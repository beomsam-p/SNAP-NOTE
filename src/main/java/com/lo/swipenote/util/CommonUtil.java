package com.lo.swipenote.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;


@Component
public class CommonUtil {

	public String randomChar10() {
		char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
				  'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

		String str = "";
		
		int idx = 0;
		for (int i = 0; i < 10; i++) {
			idx = (int) (charSet.length * Math.random());
			str += charSet[idx];
		}
		
		return str;
	}
	
	public void setCookie(String name, String value, HttpServletResponse response) {
		Cookie setCookie = new Cookie(name, value); // 쿠키 이름을 name으로 생성
		setCookie.setMaxAge(60*60*24*30);
		setCookie.setPath("/");
		response.addCookie(setCookie);
	}
	
	public String getCookieValue(String name, HttpServletRequest request) {
		String cookeVal = "";
		 // 쿠키값 가져오기
	    Cookie[] cookies = request.getCookies() ;
	    if(cookies != null){
	        for(Cookie c : cookies){
	        	if(name.equals(c.getName())) {
	        		 // 쿠키값을 가져온다
		            cookeVal = c.getValue() ;
	        	}
	        }
	    }
		return cookeVal;
	}
	
	public void deleteCookie(String name, HttpServletResponse response) {
		Cookie setCookie = new Cookie(name, ""); // 쿠키 이름을 name으로 생성
		setCookie.setPath("/");
		setCookie.setMaxAge(0);
		response.addCookie(setCookie);
	}
}
