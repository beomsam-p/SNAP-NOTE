package com.lo.swipenote.config;

import java.io.IOException;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import lombok.RequiredArgsConstructor;

/** 마이바티스 설정 클래스
 * @author 편범삼
 * */
@RequiredArgsConstructor
@Configuration
public class MyBatisConfig {
	
	/** 어플리케이션 컨텍스트 클래스
	 * */
	@Autowired
	ApplicationContext applicationContext;

	/** sql 세션빈 생성 및 마이바티스 매퍼/설정파일 위치 세팅
	 * @param	dataSource	데이터 소스 객체
	 * @return				sql 세션 객체
	 * @throws	Exception	
	 * */
	@Bean
	public  SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
		
		//sql 세션 팩토리 설정
		final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		
		//sql 세션 팩토리를 dataSource로 세팅
		sessionFactory.setDataSource(dataSource);
	
		//패스 매칭 리졸버 생성
		PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
		
		//마이바티스 매퍼 위치 매핑
		sessionFactory.setMapperLocations(resolver.getResources("classpath:mapper/*/*.xml"));
		
		//마이바티스 설정파일 위치 세팅
		sessionFactory.setConfigLocation(applicationContext.getResource("classpath:mapper/mybatis-config.xml"));
		
		//데이터 메핑시 카멜케이스 사용
		sessionFactory.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);
		
		//반환
		return sessionFactory.getObject();
	}
}