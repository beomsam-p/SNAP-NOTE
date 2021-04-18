package com.lo.swipenote.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/** view 경로 및 정적 리소스파일 위치 설정 클래스
 * @author 편범삼
 * */
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer{
	
	/** view 파일 위치 설정
	 * @param registry	뷰리졸버 등록 객체
	 * */
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		registry.jsp("/WEB-INF/views/",".jsp");
	}
	

	/** 정적 리소스  위치 설정
	 * @param registry	정적리소스 위치 등록 객체
	 * */
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/static/**")
		.addResourceLocations("classpath:/static/")
		.setCachePeriod(20);
		WebMvcConfigurer.super.addResourceHandlers(registry);
	}
}
