package com.lo.swipenote.log;

import java.util.Arrays;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@Aspect
public class LogConfig {
	//로거
	Logger log =  LoggerFactory.getLogger(this.getClass());

	/** 로그 AOP 메소드
	 * @param pjp	
	 * @return	
	 * @throws Throwable
	 */
	@Around("within(com.lo.swipenote..*))")
	public Object logging(ProceedingJoinPoint pjp) throws Throwable { // 2
	
		String params = getRequestParams();
		
		long startAt = System.currentTimeMillis();
		
		log.info("-----------> REQUEST : {}({}) = {}", pjp.getSignature().getDeclaringTypeName(),
		    pjp.getSignature().getName(), params);
		
		Object result = pjp.proceed();
		
		long endAt = System.currentTimeMillis();
		
		log.info("-----------> RESPONSE : {}({}) = {} ({}ms)", pjp.getSignature().getDeclaringTypeName(),
        pjp.getSignature().getName(), result, endAt - startAt);
	
	    return result;
	  }
	
	/** 파라미터를 문자열로 만들어주는 메소드
	 * @param paramMap	파라미터가 담긴 map 객체
	 * @return			파라미터 문자열
	 */
	private String paramMapToString(Map<String, String[]> paramMap) {
		return paramMap.entrySet().stream().map(entry -> String.format("%s -> (%s)",entry.getKey(),Arrays.toString(entry.getValue()))).collect(Collectors.joining(", "));
	}
	
	/**리퀘스트 파라미터를 보여주는 메소드
	 * @return	파라미터 String
	 */
	private String getRequestParams() {
		String params = "empty";
	
	    RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes(); // 3
	
	    if (requestAttributes != null) {
	    	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest(); 
	
	    	Map<String, String[]> paramMap = request.getParameterMap();

	    	if (!paramMap.isEmpty()) {
	    		params = " [" + paramMapToString(paramMap) + "]";
	    	}
	    }
	    return params;
	
	}
}
