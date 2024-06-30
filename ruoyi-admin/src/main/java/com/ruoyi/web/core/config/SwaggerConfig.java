package com.ruoyi.web.core.config;

import com.ruoyi.common.config.RuoYiConfig;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
    private static final String SECURITY_SCHEME_NAME = "BearerAuth";

    /**
     * 系统基础配置
     */
    @Autowired
    private RuoYiConfig ruoyiConfig;

    /**
     * 创建API
     */
    @Bean
    public OpenAPI createOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("标题：若依管理系统_接口文档")
                        .description("描述：用于管理集团旗下公司的人员信息,具体包括XXX,XXX模块...")
                        .contact(new Contact().name(ruoyiConfig.getName()))
                        .version("版本号:" + ruoyiConfig.getVersion()))
                .addSecurityItem(new SecurityRequirement().addList(SECURITY_SCHEME_NAME))
                .components(
                        new Components().addSecuritySchemes(
                                SECURITY_SCHEME_NAME,
                                new SecurityScheme()
                                        .name(SECURITY_SCHEME_NAME)
                                        .type(SecurityScheme.Type.HTTP)
                                        .in(SecurityScheme.In.HEADER)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                        )
                );
    }

    /**
     * 配置默认分组
     */
    @Bean
    public GroupedOpenApi defaultApi() {
        return GroupedOpenApi.builder()
                .group("default")
                .pathsToMatch("/**")
                .pathsToExclude("/test/**")
                .build();
    }

    /**
     * 配置测试分组
     */
    @Bean
    public GroupedOpenApi testApi() {
        return GroupedOpenApi.builder()
                .group("test")
                .pathsToMatch("/test/**")
                .build();
    }
}
