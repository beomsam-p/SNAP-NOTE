package com.lo.swipenote.aop;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MemberService;

@Aspect
@Component
public class LoginCheckConfig {
	
	@Autowired
	MemberService memberService;
	
	//로거
	Logger log =  LoggerFactory.getLogger(this.getClass());
		
	/**
	 * 고객의 로그인을 체크한다.
	 * @author jun
	 * @param pjp
	 * @return
	 * @throws Throwable
	 * */
	@Before("@annotation(com.lo.swipenote.aop.LoginCheck)")
		public void memberLoginCheck(JoinPoint jp) throws Throwable {
		log.debug("AOP - Member Login Check Started");
    
		HttpSession session = ((ServletRequestAttributes)(RequestContextHolder.currentRequestAttributes())).getRequest().getSession();
		
		MemberDto memberInfo = (MemberDto)session.getAttribute("userSession");
    
		if (memberInfo == null) {
			throw new HttpStatusCodeException(HttpStatus.UNAUTHORIZED, "NO_LOGIN") {
				private static final long serialVersionUID = 1L;
			};
		}
	}
}
