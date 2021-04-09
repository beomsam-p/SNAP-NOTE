package com.lo.swipenote.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController extends MasterController{
	
	
	@RequestMapping("/")
	public ModelAndView homeController() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("content", "Login.jsp");
		return this.redirect("template/Template", param);
	}
}
