package com.lo.swipenote.controller;

import java.util.HashMap;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.servlet.ModelAndView;

/** 컨트롤러 공통 기능을 정의한 객체
 * @author 편범삼
 */
public class MasterController {

	/** 로그인 체크  익셉션 핸들러
	 * @return	로그인 페이지로 이동 및 경고 모달 노출
	 * */
	@ExceptionHandler(HttpStatusCodeException.class)
	public ModelAndView loginCheckExceptionHanlder() {
		//ModelAndView 
		ModelAndView mv = new ModelAndView();
		
		//로그인으로 리다이렉트
		mv.setViewName("redirect:/");
		
		//파라미터로 nologin 전달
		mv.addObject("exception", "nologin");
		return mv;
	}
	
	
	/** 리다이렉트 메소드
	 * @param viewName	이동할 뷰 경로
	 * @param param		jsp로 전달할 파라미터
	 * @return			경로와 파라미터를 담은 ModelAndView 객체
	 */
	public ModelAndView redirect(String viewName, HashMap<String, Object> param) {
		//ModelAndView 
		ModelAndView mv = new ModelAndView();
		
		//이동할 뷰네임
		mv.setViewName(viewName);
		
		//이동시 들고갈 파라미터 
		mv.addAllObjects(param);
		
		return mv;
	}
	
}
