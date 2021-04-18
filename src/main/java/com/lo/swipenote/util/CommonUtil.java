package com.lo.swipenote.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

/** 공통 유틸
 * @author 편범삼
 * */
@Component
public class CommonUtil {

	/** 랜덤 10자리 문자열 생성
	 * @return	문자열 
	 * */
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
	
	/** 쿠키 생성
	 * @param name		쿠키 이름
	 * @param value		쿠키 값
	 * @param response	쿠키를 담을 응답객체
	 * */
	public void setCookie(String name, String value, HttpServletResponse response) {
		//쿠키 생성
		Cookie setCookie = new Cookie(name, value); // 쿠키 이름을 name으로 생성
		//쿠키 유지시간 설정
		setCookie.setMaxAge(60*60*24*30);
		//쿠키 경로 설정
		setCookie.setPath("/");
		//쿠키 추가
		response.addCookie(setCookie);
	}
	
	/** 쿠키 얻기
	 * @param name		쿠키 이름
	 * @param request	쿠키를 얻어올 요청 객체
	 * @return
	 */
	public String getCookieValue(String name, HttpServletRequest request) {
		//반환할 쿠키 값 변수 초기화
		String cookeVal = "";
		
		 // 쿠키값 가져오기
	    Cookie[] cookies = request.getCookies() ;
	    
	    //얻어온 쿠키가 있을 때 
	    if(cookies != null){
	    	//모든 쿠키를 얻어서 찾고자하는 쿠키 이름과 비교
	        for(Cookie c : cookies){
	        	if(name.equals(c.getName())) {
	        		 // 쿠키값을 가져온다
		            cookeVal = c.getValue() ;
	        	}
	        }
	    }
	    
	    //쿠키 값 반환
		return cookeVal;
	}
	
	/** 쿠키 삭제
	 * @param name		쿠키이름
	 * @param response	쿠키를 삭제하기 위한 응답 객체
	 */
	public void deleteCookie(String name, HttpServletResponse response) {
		// 삭제하고자 하는 쿠키 이름으로 쿠키 생성
		Cookie setCookie = new Cookie(name, ""); 
		
		//쿠키 경로 설정
		setCookie.setPath("/");

		//쿠키 유지 시간을 0으로 세팅
		setCookie.setMaxAge(0);
		
		//쿠키 담기(유지시간이 0이므로 바로 없어짐)
		response.addCookie(setCookie);
	}
}
