#!/bin/sh

set -ue

SCRIPT_DIR=$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)
PROJECT_PATH=$(realpath "${SCRIPT_DIR}")

JAVA_BIN="java"

JAR_FILE_NAME="ruoyi-admin.jar"
JAR_PATH="${PROJECT_PATH}/${JAR_FILE_NAME}"

CONFIG_DIR_NAME="config"
CONFIG_DIR_PATH="${PROJECT_PATH}/${CONFIG_DIR_NAME}"

JVM_ARGS="-Djava.security.egd=file:/dev/./urandom Xms512m -Xmx2048m"
APP_ARGS="--spring.config.location=file:${CONFIG_DIR_PATH}/"

HEALTH_CHECK_URL="http://127.0.0.1:8080/health/check"
HEALTH_CHECK_INTERVAL_SECONDS=2
HEALTH_CHECK_TOTAL_ATTEMPTS=120

BACKUP_DIR_PATH="${PROJECT_PATH}/backup"
ROLLBACK_DIR_PATH="${PROJECT_PATH}/rollback"
RUN_LOG_FILE="${PROJECT_PATH}/run.log"
PID_FILE="${PROJECT_PATH}/app.pid"
PID_CHECK_INTERVAL_SECONDS=1
PID_CHECK_TOTAL_ATTEMPTS=10

cd "${PROJECT_PATH}"
echo "Current work dir: ${PROJECT_PATH}"

is_running() {
  cd "${PROJECT_PATH}"

  if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}")
    if [ -n "${PID}" ] && ps -p "${PID}" >/dev/null; then
      return 0
    else
      rm -rf "${PID_FILE}"
    fi
  fi
  return 1
}

check_health() {
  echo "Checking server health"
  ATTEMPT=1
  while [ $ATTEMPT -le $HEALTH_CHECK_TOTAL_ATTEMPTS ]; do
    RESPONSE=$(curl -s -m 5 -o /dev/null -w "%{http_code}" "$HEALTH_CHECK_URL" || true)

    if [ "$RESPONSE" -eq "204" ]; then
        echo "Health check passed"
        return 0
    fi

    ATTEMPT=$((ATTEMPT + 1))
    sleep $HEALTH_CHECK_INTERVAL_SECONDS
  done

  echo "Health check failed!"
  return 1
}

check_pid() {
  JVM_PID=$(jps -l | grep "${JAR_FILE_NAME}" | awk -F' ' '{print $1}' | grep -q "^$1$")
  if [ -z "${JVM_PID}" ]; then
    echo "Error: Current watching PID $1 may not correct."
    JAR_PID="$(pgrep -f "${JAR_FILE_NAME}" || true)"
    if [ -n "${JAR_PID}" ]; then
      echo "Current JAR ${JAR_FILE_NAME} may running at PID ${JAR_PID}"
    else
      echo "Current JVM processes:"
      jps -l
    fi
    return 1
  else
    return 0
  fi
}

not_running_process_check() {
  JAR_PID="$(pgrep -f "${JAR_FILE_NAME}" || true)"
  if [ -n "${JAR_PID}" ]; then
    echo "Server PID file not found, but it may running at PID ${JAR_PID}"
    echo "Current JVM processes:"
    jps -l
    return 1
  else
    echo "Server not started yet"
    return 0
  fi
}

start() {
  cd "${PROJECT_PATH}"

  if is_running; then
    PID=$(cat "${PID_FILE}")
    if check_pid "${PID}"; then
      echo "Server (pid ${PID}) already started"
      return 0
    else
      echo "Please check manually and modify PID file ${PID_FILE}"
      echo "Stop starting server"
      exit 1
    fi
  fi

  if [ ! -f "${JAR_PATH}" ]; then
    echo "Can't find file ${JAR_PATH}"
    exit 1
  fi

  echo "Starting server"
  nohup $JAVA_BIN "${JVM_ARGS}" -jar "${JAR_PATH}" "${APP_ARGS}" > "${RUN_LOG_FILE}" 2>&1 &

  echo $! >"${PID_FILE}"

  sleep 1

  ATTEMPT=0
  while ! is_running; do
    if [ "${ATTEMPT}" -ge "${PID_CHECK_TOTAL_ATTEMPTS}" ]; then
      echo "Server launch failed!"
      exit 1
    fi
    echo "Waiting for server launching ..."
    sleep $PID_CHECK_INTERVAL_SECONDS
    ATTEMPT=$((ATTEMPT + 1))
  done

  PID=$(cat "${PID_FILE}")
  echo "Server (pid ${PID}) started"

  check_health

  return $?
}

stop() {
  cd "${PROJECT_PATH}"

  if ! is_running; then
    not_running_process_check
    return $?
  fi

  if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}")

    if ! check_pid "${PID}"; then
      echo "Stop killing server"
      exit 1
    fi

    echo "Killing server (pid ${PID})"
    kill -15 "${PID}"

    sleep 2

    ATTEMPT=0
    while is_running; do
      if [ "${ATTEMPT}" -ge "${PID_CHECK_TOTAL_ATTEMPTS}" ]; then
        kill -9 "${PID}"
        sleep 2
        if is_running; then
          echo "Server kill failed!"
          exit 1
        fi
      else
        echo "Waiting for server killing ..."
        sleep $PID_CHECK_INTERVAL_SECONDS
        ATTEMPT=$((ATTEMPT + 1))
      fi
    done

    rm -rf "${PID_FILE}"

    echo "Server stopped"
  fi
}

status() {
  if is_running; then
    PID=$(cat "${PID_FILE}")
    if check_pid "${PID}"; then
      echo "Server is running (pid ${PID})"
    fi
    check_health
    return $?
  else
    not_running_process_check
    return $?
  fi
}

backup() {
  cd "${PROJECT_PATH}"

  BACKUP_TAG="$1"
  echo "Backup tag: ${BACKUP_TAG}"

  BACKUP_TAG_PATH="${BACKUP_DIR_PATH}/${BACKUP_TAG}"
  echo "Backup to: ${BACKUP_TAG_PATH}"
  if [ -d "${BACKUP_TAG_PATH}" ]; then
    if [ -z "$(ls -A "${BACKUP_TAG_PATH}")" ]; then
      echo "Reuse exist but empty backup dir"
    else
      echo "Backup tag already exists"
      exit 1
    fi
  else
    mkdir -p "${BACKUP_TAG_PATH}"
  fi

  echo "Backup configs: ${CONFIG_DIR_PATH}"
  if [ -d "${CONFIG_DIR_PATH}" ]; then
    cp -rfp "${CONFIG_DIR_PATH}" "${BACKUP_TAG_PATH}/"
  else
    echo "Can't find dir ${CONFIG_DIR_PATH}"
  fi

  echo "Backup jar: ${JAR_PATH}"
  if [ -f "${JAR_PATH}" ]; then
    cp -fp "${JAR_PATH}" "${BACKUP_TAG_PATH}/"
  else
    echo "Can't find file ${JAR_PATH}"
  fi

  if [ -z "$(ls -A "${BACKUP_TAG_PATH}")" ]; then
    echo "No backup files"
    rm -rf "${BACKUP_TAG_PATH}"
    return 0
  fi

  echo "Packaging backup files ..."
  BACKUP_PKG_PATH="${BACKUP_DIR_PATH}/${BACKUP_TAG}.tar.gz"

  cd "${BACKUP_DIR_PATH}"
  tar -zcf "${BACKUP_PKG_PATH}" "${BACKUP_TAG}"
  cd "${PROJECT_PATH}"

  echo "Cleaning temp files"
  rm -rf "${BACKUP_TAG_PATH}"

  if [ -f "${BACKUP_PKG_PATH}" ]; then
    echo "Backup success: ${BACKUP_PKG_PATH}"
  else
    echo "Backup failed: backup package not found"
  fi
}

rollback() {
  cd "${PROJECT_PATH}"

  BACKUP_TAG="$1"
  echo "Backup tag to rollback: ${BACKUP_TAG}"

  ROLLBACK_PKG_PATH="${BACKUP_DIR_PATH}/${BACKUP_TAG}.tar.gz"
  if [ -f "${ROLLBACK_PKG_PATH}" ]; then
    echo "Loading backup package"
    cd "${BACKUP_DIR_PATH}"
    tar -xzf "${ROLLBACK_PKG_PATH}"
    cd "${PROJECT_PATH}"

    BACKUP_TAG_PATH="${BACKUP_DIR_PATH}/${BACKUP_TAG}"
    if [ -z "$(ls -A "${BACKUP_TAG_PATH}")" ]; then
      echo "No rollback files"
      rm -rf "${BACKUP_TAG_PATH}"
      return 0
    fi

    if [ -d "${ROLLBACK_DIR_PATH}" ]; then
      rm -rf "${ROLLBACK_DIR_PATH}"
    fi
    mkdir -p "${ROLLBACK_DIR_PATH}"

    ROLLBACK_CONFIG_PATH="${BACKUP_TAG_PATH}/${CONFIG_DIR_NAME}"
    echo "Rollback config files: ${ROLLBACK_CONFIG_PATH}"
    if [ -d "${ROLLBACK_CONFIG_PATH}" ]; then
      mv "${CONFIG_DIR_PATH}" "${ROLLBACK_DIR_PATH}/"
      mv "${ROLLBACK_CONFIG_PATH}" "${CONFIG_DIR_PATH}"
    else
      echo "No configs to rollback"
    fi

    ROLLBACK_JAR_PATH="${BACKUP_TAG_PATH}/${JAR_FILE_NAME}"
    echo "Rollback jar file: ${ROLLBACK_JAR_PATH}"
    if [ -f "${ROLLBACK_JAR_PATH}" ]; then
      mv "${JAR_PATH}" "${ROLLBACK_DIR_PATH}/"
      mv "${ROLLBACK_JAR_PATH}" "${JAR_PATH}"
    else
      echo "No jar file to rollback"
    fi

    echo "Cleaning temp files"
    rm -rf "${BACKUP_TAG_PATH}"

    echo "Rollback success: ${BACKUP_TAG}"
    echo "Please restart server"
  else
    echo "Can't find rollback package ${BACKUP_TAG}!"
    exit 1
  fi
}

print_help() {
  echo "Usage: $0 [COMMAND] [OPTION...]"
  echo "Commands:"
  echo "  start           Start server"
  echo "  stop            Stop server"
  echo "  restart         Restart server"
  echo "  status          Print server status"
  echo "  backup [TAG]    Backup server as tag"
  echo "  rollback [TAG]  Rollback server from tag"
}

if [ -z "${1+x}" ]; then
  print_help "$0"
  exit 1
fi

case "$1" in
start)
  start
  ;;
stop)
  stop
  ;;
status)
  status
  ;;
restart)
  stop
  start
  ;;
backup)
  if [ -z "${2+x}" ]; then
    echo "Empty backup tag!"
    exit 1
  else
    backup "$2"
  fi
  ;;
rollback)
  if [ -z "${2+x}" ]; then
    echo "Empty backup tag to rollback!"
    exit 1
  else
    rollback "$2"
  fi
  ;;
*)
  echo "Unknown command: $1"
  print_help "$0"
  exit 1
  ;;
esac

exit 0
