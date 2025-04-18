-- ----------------------------
-- 1、部门表
-- ----------------------------
create
sequence seq_sys_dept increment by 1 start
with
    200 nomaxvalue nominvalue cache
20;

create table
    sys_dept
(
    dept_id number (20) not null,
    parent_id number (20) default 0,
    ancestors varchar2 (50) default '',
    dept_name varchar2 (30) default '',
    order_num number (4) default 0,
    leader varchar2 (20) default null,
    phone varchar2 (11) default null,
    email varchar2 (50) default null,
    status      char(1) default '0',
    del_flag    char(1) default '0',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date
);

alter table sys_dept
    add constraint pk_sys_dept primary key (dept_id);

comment on table sys_dept is '部门信息表';

comment on column sys_dept.dept_id is '部门主键seq_sys_dept.nextval';

comment on column sys_dept.parent_id is '父部门id';

comment on column sys_dept.ancestors is '祖级列表';

comment on column sys_dept.dept_name is '部门名称';

comment on column sys_dept.order_num is '显示顺序';

comment on column sys_dept.leader is '负责人';

comment on column sys_dept.phone is '联系电话';

comment on column sys_dept.email is '邮箱';

comment on column sys_dept.status is '部门状态（0正常 1停用）';

comment on column sys_dept.del_flag is '删除标志（0代表存在 2代表删除）';

comment on column sys_dept.create_by is '创建者';

comment on column sys_dept.create_time is '创建时间';

comment on column sys_dept.update_by is '更新者';

comment on column sys_dept.update_time is '更新时间';

-- ----------------------------
-- 2、用户信息表
-- ----------------------------
create
sequence seq_sys_user increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_user
(
    user_id number (20) not null,
    dept_id number (20) default null,
    user_name varchar2 (30) not null,
    nick_name varchar2 (30) default '',
    user_type varchar2 (2) default '00',
    email varchar2 (50) default '',
    phonenumber varchar2 (11) default '',
    sex         char(1) default '0',
    avatar varchar2 (100) default '',
    password varchar2 (100) default '',
    status      char(1) default '0',
    del_flag    char(1) default '0',
    login_ip varchar2 (128) default '',
    login_date  date,
    create_by varchar2 (64),
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default ''
);

alter table sys_user
    add constraint pk_sys_user primary key (user_id);

comment on table sys_user is '用户信息表';

comment on column sys_user.user_id is '用户主键seq_sys_user.nextval';

comment on column sys_user.dept_id is '部门ID';

comment on column sys_user.user_name is '用户账号';

comment on column sys_user.nick_name is '用户昵称';

comment on column sys_user.user_type is '用户类型（00系统用户 01注册用户）';

comment on column sys_user.email is '用户邮箱';

comment on column sys_user.phonenumber is '手机号码';

comment on column sys_user.sex is '用户性别（0男 1女 2未知）';

comment on column sys_user.avatar is '头像路径';

comment on column sys_user.password is '密码';

comment on column sys_user.status is '账号状态（0正常 1停用）';

comment on column sys_user.del_flag is '删除标志（0代表存在 2代表删除）';

comment on column sys_user.login_ip is '最后登录IP';

comment on column sys_user.login_date is '最后登录时间';

comment on column sys_user.create_by is '创建者';

comment on column sys_user.create_time is '创建时间';

comment on column sys_user.update_by is '更新者';

comment on column sys_user.update_time is '更新时间';

comment on column sys_user.remark is '备注';

-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
create
sequence seq_sys_post increment by 1 start
with
    10 nomaxvalue nominvalue cache
20;

create table
    sys_post
(
    post_id number (20) not null,
    post_code varchar2 (64) not null,
    post_name varchar2 (50) not null,
    post_sort number (4) not null,
    status      char(1) not null,
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500)
);

alter table sys_post
    add constraint pk_sys_post primary key (post_id);

comment on table sys_post is '岗位信息表';

comment on column sys_post.post_id is '岗位主键seq_sys_post.nextval';

comment on column sys_post.post_code is '岗位编码';

comment on column sys_post.post_name is '岗位名称';

comment on column sys_post.post_sort is '显示顺序';

comment on column sys_post.status is '状态（0正常 1停用）';

comment on column sys_post.create_by is '创建者';

comment on column sys_post.create_time is '创建时间';

comment on column sys_post.update_by is '更新者';

comment on column sys_post.update_time is '更新时间';

comment on column sys_post.remark is '备注';

-- ----------------------------
-- 4、角色信息表
-- ----------------------------
create
sequence seq_sys_role increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_role
(
    role_id number (20) not null,
    role_name varchar2 (30) not null,
    role_key varchar2 (100) not null,
    role_sort number (4) not null,
    data_scope  char(1) default '1',
    menu_check_strictly number (1) default 1,
    dept_check_strictly number (1) default 1,
    status      char(1) not null,
    del_flag    char(1) default '0',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default null
);

alter table sys_role
    add constraint pk_sys_role primary key (role_id);

comment on table sys_role is '角色信息表';

comment on column sys_role.role_id is '角色主键seq_sys_post.nextval';

comment on column sys_role.role_name is '角色名称';

comment on column sys_role.role_key is '角色权限字符串';

comment on column sys_role.role_sort is '显示顺序';

comment on column sys_role.data_scope is '数据范围（1：全部数据权限 2：自定数据权限）';

comment on column sys_role.menu_check_strictly is '菜单树选择项是否关联显示';

comment on column sys_role.dept_check_strictly is '部门树选择项是否关联显示';

comment on column sys_role.status is '角色状态（0正常 1停用）';

comment on column sys_role.del_flag is '删除标志（0代表存在 2代表删除）';

comment on column sys_role.create_by is '创建者';

comment on column sys_role.create_time is '创建时间';

comment on column sys_role.update_by is '更新者';

comment on column sys_role.update_time is '更新时间';

comment on column sys_role.remark is '备注';

-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
create
sequence seq_sys_menu increment by 1 start
with
    2000 nomaxvalue nominvalue cache
20;

create table
    sys_menu
(
    menu_id number (20) not null,
    menu_name varchar2 (50) not null,
    parent_id number (20) default 0,
    order_num number (4) default 0,
    path        varchar(200) default '',
    component   varchar(255) default null,
    query       varchar(255) default null,
    route_name  varchar(50)  default '',
    is_frame number (1) default 1,
    is_cache number (1) default 0,
    menu_type   char(1)      default '',
    visible     char(1)      default 0,
    status      char(1)      default 0,
    perms varchar2 (100) default null,
    icon varchar2 (100) default '#',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default ''
);

alter table sys_menu
    add constraint pk_sys_menu primary key (menu_id);

comment on table sys_menu is '菜单权限表';

comment on column sys_menu.menu_id is '菜单主键seq_sys_post.nextval';

comment on column sys_menu.menu_name is '菜单名称';

comment on column sys_menu.parent_id is '父菜单ID';

comment on column sys_menu.order_num is '显示顺序';

comment on column sys_menu.path is '请求地址';

comment on column sys_menu.component is '路由地址';

comment on column sys_menu.query is '路由参数';

comment on column sys_menu.route_name is '路由名称';

comment on column sys_menu.is_frame is '是否为外链（0是 1否）';

comment on column sys_menu.is_cache is '是否缓存（0缓存 1不缓存）';

comment on column sys_menu.menu_type is '菜单类型（M目录 C菜单 F按钮）';

comment on column sys_menu.visible is '菜单状态（0显示 1隐藏）';

comment on column sys_menu.status is '菜单状态（0正常 1停用）';

comment on column sys_menu.perms is '权限标识';

comment on column sys_menu.icon is '菜单图标';

comment on column sys_menu.create_by is '创建者';

comment on column sys_menu.create_time is '创建时间';

comment on column sys_menu.update_by is '更新者';

comment on column sys_menu.update_time is '更新时间';

comment on column sys_menu.remark is '备注';

-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
create table
    sys_user_role
(
    user_id number (20) not null,
    role_id number (20) not null
);

alter table sys_user_role
    add constraint pk_sys_user_role primary key (user_id, role_id);

comment on table sys_user_role is '用户和角色关联表';

comment on column sys_user_role.user_id is '用户ID';

comment on column sys_user_role.role_id is '角色ID';

-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
create table
    sys_role_menu
(
    role_id number (20) not null,
    menu_id number (20) not null
);

alter table sys_role_menu
    add constraint pk_sys_role_menu primary key (role_id, menu_id);

comment on table sys_role_menu is '角色和菜单关联表';

comment on column sys_role_menu.role_id is '角色ID';

comment on column sys_role_menu.menu_id is '菜单ID';

-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
create table
    sys_role_dept
(
    role_id number (20) not null,
    dept_id number (20) not null
);

alter table sys_role_dept
    add constraint pk_sys_role_dept primary key (role_id, dept_id);

comment on table sys_role_dept is '角色和部门关联表';

comment on column sys_role_dept.role_id is '角色ID';

comment on column sys_role_dept.dept_id is '部门ID';

-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
create table
    sys_user_post
(
    user_id number (20) not null,
    post_id number (20) not null
);

alter table sys_user_post
    add constraint pk_sys_user_post primary key (user_id, post_id);

comment on table sys_user_post is '用户与岗位关联表';

comment on column sys_user_post.user_id is '用户ID';

comment on column sys_user_post.post_id is '岗位ID';

-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
create
sequence seq_sys_oper_log increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_oper_log
(
    oper_id number (20) not null,
    title varchar2 (50) default '',
    business_type number (2) default 0,
    method varchar2 (200) default '',
    request_method varchar(10) default '',
    operator_type number (1) default 0,
    oper_name varchar2 (50) default '',
    dept_name varchar2 (50) default '',
    oper_url varchar2 (255) default '',
    oper_ip varchar2 (128) default '',
    oper_location varchar2 (255) default '',
    oper_param varchar2 (2000) default '',
    json_result varchar2 (2000) default '',
    status number (1) default 0,
    error_msg varchar2 (2000) default '',
    cost_time number (20) default 0,
    oper_time      date
);

alter table sys_oper_log
    add constraint pk_sys_oper_log primary key (oper_id);

create index idx_sys_oper_log_bt on sys_oper_log (business_type);

create index idx_sys_oper_log_s on sys_oper_log (status);

create index idx_sys_oper_log_ot on sys_oper_log (oper_time);

comment on table sys_oper_log is '操作日志记录';

comment on column sys_oper_log.oper_id is '日志主键seq_sys_oper_log.nextval';

comment on column sys_oper_log.title is '模块标题';

comment on column sys_oper_log.business_type is '业务类型（0其它 1新增 2修改 3删除）';

comment on column sys_oper_log.method is '方法名称';

comment on column sys_oper_log.request_method is '请求方式';

comment on column sys_oper_log.operator_type is '操作类别（0其它 1后台用户 2手机端用户）';

comment on column sys_oper_log.oper_name is '操作人员';

comment on column sys_oper_log.dept_name is '部门名称';

comment on column sys_oper_log.oper_url is '请求URL';

comment on column sys_oper_log.oper_ip is '主机地址';

comment on column sys_oper_log.oper_location is '操作地点';

comment on column sys_oper_log.oper_param is '请求参数';

comment on column sys_oper_log.json_result is '返回参数';

comment on column sys_oper_log.status is '操作状态（0正常 1异常）';

comment on column sys_oper_log.error_msg is '错误消息';

comment on column sys_oper_log.cost_time is '消耗时间';

comment on column sys_oper_log.oper_time is '操作时间';

-- ----------------------------
-- 11、字典类型表
-- ----------------------------
create
sequence seq_sys_dict_type increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_dict_type
(
    dict_id number (20) not null,
    dict_name varchar2 (100) default '',
    dict_type varchar2 (100) default '',
    status      char(1) default '0',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default null
);

alter table sys_dict_type
    add constraint pk_sys_dict_type primary key (dict_id);

create unique index sys_dict_type_index1 on sys_dict_type (dict_type);

comment on table sys_dict_type is '字典类型表';

comment on column sys_dict_type.dict_id is '字典主键seq_sys_dict_type.nextval';

comment on column sys_dict_type.dict_name is '字典名称';

comment on column sys_dict_type.dict_type is '字典类型';

comment on column sys_dict_type.status is '状态（0正常 1停用）';

comment on column sys_dict_type.create_by is '创建者';

comment on column sys_dict_type.create_time is '创建时间';

comment on column sys_dict_type.update_by is '更新者';

comment on column sys_dict_type.update_time is '更新时间';

comment on column sys_dict_type.remark is '备注';

-- ----------------------------
-- 12、字典数据表
-- ----------------------------
create
sequence seq_sys_dict_data increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_dict_data
(
    dict_code number (20) not null,
    dict_sort number (4) default 0,
    dict_label varchar2 (100) default '',
    dict_value varchar2 (100) default '',
    dict_type varchar2 (100) default '',
    css_class varchar2 (100) default null,
    list_class varchar2 (100) default null,
    is_default  char(1) default 'N',
    status      char(1) default '0',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default null
);

alter table sys_dict_data
    add constraint pk_sys_dict_data primary key (dict_code);

comment on table sys_dict_data is '字典数据表';

comment on column sys_dict_data.dict_code is '字典主键seq_sys_dict_data.nextval';

comment on column sys_dict_data.dict_sort is '字典排序';

comment on column sys_dict_data.dict_label is '字典标签';

comment on column sys_dict_data.dict_value is '字典键值';

comment on column sys_dict_data.dict_type is '字典类型';

comment on column sys_dict_data.css_class is '样式属性（其他样式扩展）';

comment on column sys_dict_data.list_class is '表格回显样式';

comment on column sys_dict_data.is_default is '是否默认（Y是 N否）';

comment on column sys_dict_data.status is '状态（0正常 1停用）';

comment on column sys_dict_data.create_by is '创建者';

comment on column sys_dict_data.create_time is '创建时间';

comment on column sys_dict_data.update_by is '更新者';

comment on column sys_dict_data.update_time is '更新时间';

comment on column sys_dict_data.remark is '备注';

-- ----------------------------
-- 13、参数配置表
-- ----------------------------
create
sequence seq_sys_config increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_config
(
    config_id number (20) not null,
    config_name varchar2 (100) default '',
    config_key varchar2 (100) default '',
    config_value varchar2 (100) default '',
    config_type char(1) default 'N',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default null
);

alter table sys_config
    add constraint pk_sys_config primary key (config_id);

comment on table sys_config is '参数配置表';

comment on column sys_config.config_id is '参数主键seq_sys_config.nextval';

comment on column sys_config.config_name is '参数名称';

comment on column sys_config.config_key is '参数键名';

comment on column sys_config.config_value is '参数键值';

comment on column sys_config.config_type is '系统内置（Y是 N否）';

comment on column sys_config.create_by is '创建者';

comment on column sys_config.create_time is '创建时间';

comment on column sys_config.update_by is '更新者';

comment on column sys_config.update_time is '更新时间';

comment on column sys_config.remark is '备注';

-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
create
sequence seq_sys_logininfor increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_logininfor
(
    info_id number (20) not null,
    user_name varchar2 (50) default '',
    ipaddr varchar2 (128) default '',
    login_location varchar2 (255) default '',
    browser varchar2 (50) default '',
    os varchar2 (50) default '',
    status     char(1) default '0',
    msg varchar2 (255) default '',
    login_time date
);

alter table sys_logininfor
    add constraint pk_sys_logininfor primary key (info_id);

create index idx_sys_logininfor_s on sys_logininfor (status);

create index idx_sys_logininfor_lt on sys_logininfor (login_time);

comment on table sys_logininfor is '系统访问记录';

comment on column sys_logininfor.info_id is '访问主键seq_seq_sys_logininfor.nextval';

comment on column sys_logininfor.user_name is '登录账号';

comment on column sys_logininfor.ipaddr is '登录IP地址';

comment on column sys_logininfor.login_location is '登录地点';

comment on column sys_logininfor.browser is '浏览器类型';

comment on column sys_logininfor.os is '操作系统';

comment on column sys_logininfor.status is '登录状态（0成功 1失败）';

comment on column sys_logininfor.msg is '提示消息';

comment on column sys_logininfor.login_time is '访问时间';

-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
create
sequence seq_sys_job increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_job
(
    job_id number (20) not null,
    job_name varchar2 (64) default '',
    job_group varchar2 (64) default '',
    invoke_target varchar2 (500) not null,
    cron_expression varchar2 (255) default '',
    misfire_policy varchar2 (20) default '3',
    concurrent  char(1) default '1',
    status      char(1) default '0',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (500) default ''
);

alter table sys_job
    add constraint pk_sys_job primary key (job_id, job_name, job_group);

comment on table sys_job is '定时任务调度表';

comment on column sys_job.job_id is '任务主键seq_sys_job.nextval';

comment on column sys_job.job_name is '任务名称';

comment on column sys_job.job_group is '任务组名';

comment on column sys_job.invoke_target is '调用目标字符串';

comment on column sys_job.cron_expression is 'cron执行表达式';

comment on column sys_job.misfire_policy is '计划执行错误策略（1立即执行 2执行一次 3放弃执行）';

comment on column sys_job.concurrent is '是否并发执行（0允许 1禁止）';

comment on column sys_job.status is '状态（0正常 1暂停）';

comment on column sys_job.create_by is '创建者';

comment on column sys_job.create_time is '创建时间';

comment on column sys_job.update_by is '更新者';

comment on column sys_job.update_time is '更新时间';

comment on column sys_job.remark is '备注信息';

-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
create
sequence seq_sys_job_log increment by 1 start
with
    1 nomaxvalue nominvalue cache
20;

create table
    sys_job_log
(
    job_log_id number (20) not null,
    job_name varchar2 (64) not null,
    job_group varchar2 (64) not null,
    invoke_target varchar2 (500) not null,
    job_message varchar2 (500),
    status      char(1) default '0',
    exception_info varchar2 (2000) default '',
    create_time date
);

alter table sys_job_log
    add constraint pk_sys_job_log primary key (job_log_id);

comment on table sys_job_log is '定时任务调度日志表';

comment on column sys_job_log.job_log_id is '日志主键seq_sys_job_log.nextval';

comment on column sys_job_log.job_name is '任务名称';

comment on column sys_job_log.job_group is '任务组名';

comment on column sys_job_log.invoke_target is '调用目标字符串';

comment on column sys_job_log.job_message is '日志信息';

comment on column sys_job_log.status is '执行状态（0正常 1失败）';

comment on column sys_job_log.exception_info is '异常信息';

comment on column sys_job_log.create_time is '创建时间';

-- ----------------------------
-- 17、通知公告表
-- ----------------------------
create
sequence seq_sys_notice increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    sys_notice
(
    notice_id number (20) not null,
    notice_title varchar2 (50) not null,
    notice_type char(1) not null,
    notice_content clob default null,
    status      char(1) default '0',
    create_by varchar2 (64) default '',
    create_time date,
    update_by varchar2 (64) default '',
    update_time date,
    remark varchar2 (255) default null
);

alter table sys_notice
    add constraint pk_sys_notice primary key (notice_id);

comment on table sys_notice is '通知公告表';

comment on column sys_notice.notice_id is '公告主键seq_sys_notice.nextval';

comment on column sys_notice.notice_title is '公告标题';

comment on column sys_notice.notice_type is '公告类型（1通知 2公告）';

comment on column sys_notice.notice_content is '公告内容';

comment on column sys_notice.status is '公告状态（0正常 1关闭）';

comment on column sys_notice.create_by is '创建者';

comment on column sys_notice.create_time is '创建时间';

comment on column sys_notice.update_by is '更新者';

comment on column sys_notice.update_time is '更新时间';

comment on column sys_notice.remark is '备注';

-- ----------------------------
-- 18、代码生成业务表
-- ----------------------------
create
sequence seq_gen_table increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    gen_table
(
    table_id number (20) not null,
    table_name varchar2 (200) default '',
    table_comment varchar2 (500) default '',
    sub_table_name    varchar(64) default null,
    sub_table_fk_name varchar(64) default null,
    class_name varchar2 (100) default '',
    tpl_category varchar2 (200) default 'crud',
    tpl_web_type varchar2 (30) default '',
    package_name varchar2 (100),
    module_name varchar2 (30),
    business_name varchar2 (30),
    function_name varchar2 (50),
    function_author varchar2 (50),
    gen_type          char(1)     default '0',
    gen_path varchar2 (200) default '/',
    options varchar2 (1000),
    create_by varchar2 (64) default '',
    create_time       date,
    update_by varchar2 (64) default '',
    update_time       date,
    remark varchar2 (500) default null
);

alter table gen_table
    add constraint pk_gen_table primary key (table_id);

comment on table gen_table is '代码生成业务表';

comment on column gen_table.table_id is '编号';

comment on column gen_table.table_name is '表名称';

comment on column gen_table.table_comment is '表描述';

comment on column gen_table.sub_table_name is '关联子表的表名';

comment on column gen_table.sub_table_fk_name is '子表关联的外键名';

comment on column gen_table.class_name is '实体类名称';

comment on column gen_table.tpl_category is '使用的模板（crud单表操作 tree树表操作）';

comment on column gen_table.tpl_web_type is '前端模板类型（element-ui模版 element-plus模版）';

comment on column gen_table.package_name is '生成包路径';

comment on column gen_table.module_name is '生成模块名';

comment on column gen_table.business_name is '生成业务名';

comment on column gen_table.function_name is '生成功能名';

comment on column gen_table.function_author is '生成功能作者';

comment on column gen_table.gen_type is '生成代码方式（0zip压缩包 1自定义路径）';

comment on column gen_table.gen_path is '生成路径（不填默认项目路径）';

comment on column gen_table.options is '其它生成选项';

comment on column gen_table.create_by is '创建者';

comment on column gen_table.create_time is '创建时间';

comment on column gen_table.update_by is '更新者';

comment on column gen_table.update_time is '更新时间';

comment on column gen_table.remark is '备注';

-- ----------------------------
-- 19、代码生成业务表字段
-- ----------------------------
create
sequence seq_gen_table_column increment by 1 start
with
    100 nomaxvalue nominvalue cache
20;

create table
    gen_table_column
(
    column_id number (20) not null,
    table_id number (20),
    column_name varchar2 (200),
    column_comment varchar2 (500),
    column_type varchar2 (100),
    java_type varchar2 (500),
    java_field varchar2 (200),
    is_pk        char(1),
    is_increment char(1),
    is_required  char(1),
    is_insert    char(1),
    is_edit      char(1),
    is_list      char(1),
    is_query     char(1),
    query_type   varchar(200) default 'EQ',
    html_type    varchar(200),
    dict_type    varchar(200) default '',
    sort number (4),
    create_by    varchar(64)  default '',
    create_time  date,
    update_by    varchar(64)  default '',
    update_time  date
);

alter table gen_table_column
    add constraint pk_gen_table_column primary key (column_id);

comment on table gen_table_column is '代码生成业务表字段';

comment on column gen_table_column.column_id is '编号';

comment on column gen_table_column.table_id is '归属表编号';

comment on column gen_table_column.column_name is '列名称';

comment on column gen_table_column.column_comment is '列描述';

comment on column gen_table_column.column_type is '列类型';

comment on column gen_table_column.java_type is 'JAVA类型';

comment on column gen_table_column.java_field is 'JAVA字段名';

comment on column gen_table_column.is_pk is '是否主键（1是）';

comment on column gen_table_column.is_increment is '是否自增（1是）';

comment on column gen_table_column.is_required is '是否必填（1是）';

comment on column gen_table_column.is_insert is '是否为插入字段（1是）';

comment on column gen_table_column.is_edit is '是否编辑字段（1是）';

comment on column gen_table_column.is_list is '是否列表字段（1是）';

comment on column gen_table_column.is_query is '是否查询字段（1是）';

comment on column gen_table_column.query_type is '查询方式（等于、不等于、大于、小于、范围）';

comment on column gen_table_column.html_type is '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）';

comment on column gen_table_column.dict_type is '字典类型';

comment on column gen_table_column.sort is '排序';

comment on column gen_table_column.create_by is '创建者';

comment on column gen_table_column.create_time is '创建时间';

comment on column gen_table_column.update_by is '更新者';

comment on column gen_table_column.update_time is '更新时间';

-- ----------------------------
-- 函数 ，代替mysql的find_in_set
-- 例如： select * from sys_dept where FIND_IN_SET (101,ancestors) <> 0
-- mysql可接受0或其它number做为where 条件，oracle只接受表达式做为where 条件
-- ----------------------------
create
or
replace function find_in_set (arg1 in varchar2, arg2 in varchar) return number is Result number;

begin
select instr(',' || arg2 || ',', ',' || arg1 || ',')
into Result
from dual;

return
    (Result);

end find_in_set;