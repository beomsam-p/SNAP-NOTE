package com.lo.swipenote;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**	어플리케이션 구동 클래스
 * @author 편범삼
 * */
@EnableAspectJAutoProxy
@SpringBootApplication
public class SwipenoteApplication {

	public static void main(String[] args) {
		SpringApplication.run(SwipenoteApplication.class, args);
	}

}