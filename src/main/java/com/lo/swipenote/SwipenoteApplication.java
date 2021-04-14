package com.lo.swipenote;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@EnableAspectJAutoProxy
@SpringBootApplication
public class SwipenoteApplication {

	public static void main(String[] args) {
		SpringApplication.run(SwipenoteApplication.class, args);
	}

}