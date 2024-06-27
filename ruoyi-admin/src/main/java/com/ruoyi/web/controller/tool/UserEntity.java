package com.ruoyi.web.controller.tool;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(title = "UserEntity", description = "用户实体")
public class UserEntity {
    @Schema(title = "用户ID")
    private Integer userId;

    @Schema(title = "用户名称")
    private String username;

    @Schema(title = "用户密码")
    private String password;

    @Schema(title = "用户手机")
    private String mobile;


    public UserEntity() {

    }

    public UserEntity(Integer userId, String username, String password, String mobile) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.mobile = mobile;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }
}
