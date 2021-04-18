package com.lo.swipenote.controller;

import java.util.HashMap;

import org.springframework.web.servlet.ModelAndView;

/** 컨트롤러 공통 기능을 정의한 객체
 * @author 편범삼
 */
public class MasterController {

	/** 리다이렉트 메소드
	 * @param viewName	이동할 뷰 경로
	 * @param param		jsp로 전달할 파라미터
	 * @return			경로와 파라미터를 담은 ModelAndView 객체
	 */
	public ModelAndView redirect(String viewName, HashMap<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(viewName);
		mv.addAllObjects(param);
		return mv;
	}
}
