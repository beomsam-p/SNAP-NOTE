package com.lo.swipenote.aop;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**로그인 체크 aop 커스텀 어노테이션 인터페이스
 * @author  편범삼
 * */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public  @interface LoginCheck {
}
