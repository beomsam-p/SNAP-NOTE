package com.lo.swipenote.controller;

import java.util.HashMap;

import org.springframework.web.servlet.ModelAndView;

public class MasterController {

	public ModelAndView redirect(String viewName, HashMap<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(viewName);
		mv.addAllObjects(param);
		return mv;
	}
}
