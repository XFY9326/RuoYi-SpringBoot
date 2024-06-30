package com.ruoyi.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.servlet.MultipartProperties;
import org.springframework.stereotype.Component;

@Component
public class MultipartConfig {
    private static MultipartProperties multipartProperties;

    @Autowired
    public void setMultipartProperties(MultipartProperties multipartProperties) {
        MultipartConfig.multipartProperties = multipartProperties;
    }

    public static long getMaxFileSize() {
        return multipartProperties.getMaxFileSize().toBytes();
    }
}
