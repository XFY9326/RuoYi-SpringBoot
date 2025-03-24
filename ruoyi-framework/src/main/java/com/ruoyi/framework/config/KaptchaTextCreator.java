package com.ruoyi.framework.config;

import com.google.code.kaptcha.text.impl.DefaultTextCreator;
import org.apache.commons.lang3.RandomUtils;

/**
 * 验证码文本生成器
 *
 * @author ruoyi
 */
public class KaptchaTextCreator extends DefaultTextCreator {
    private static final String[] NUMBER_CHAR_ARRAY = "0,1,2,3,4,5,6,7,8,9,10".split(",");

    @Override
    public String getText() {
        int result;
        int x = RandomUtils.secure().randomInt(0, 10);
        int y = RandomUtils.secure().randomInt(0, 10);
        StringBuilder suChinese = new StringBuilder();
        int randomOperator = RandomUtils.secure().randomInt(0, 3);
        if (randomOperator == 0) {
            result = x * y;
            suChinese.append(NUMBER_CHAR_ARRAY[x]);
            suChinese.append("*");
            suChinese.append(NUMBER_CHAR_ARRAY[y]);
        } else if (randomOperator == 1) {
            if ((x != 0) && y % x == 0) {
                result = y / x;
                suChinese.append(NUMBER_CHAR_ARRAY[y]);
                suChinese.append("/");
                suChinese.append(NUMBER_CHAR_ARRAY[x]);
            } else {
                result = x + y;
                suChinese.append(NUMBER_CHAR_ARRAY[x]);
                suChinese.append("+");
                suChinese.append(NUMBER_CHAR_ARRAY[y]);
            }
        } else {
            if (x >= y) {
                result = x - y;
                suChinese.append(NUMBER_CHAR_ARRAY[x]);
                suChinese.append("-");
                suChinese.append(NUMBER_CHAR_ARRAY[y]);
            } else {
                result = y - x;
                suChinese.append(NUMBER_CHAR_ARRAY[y]);
                suChinese.append("-");
                suChinese.append(NUMBER_CHAR_ARRAY[x]);
            }
        }
        suChinese.append("=?@").append(result);
        return suChinese.toString();
    }
}