package com.lo.swipenote.controller.member;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.service.MemberService;

@RequestMapping(value = "/member")
@Controller
public class LoginController extends MasterController{

	@Autowired
	private MemberService memverService;
	
	@RequestMapping(value = "/loginForm")
	public ModelAndView loginForm() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("content", "member/LoginForm.jsp");
		return this.redirect("template/Template", param);
	}
	
	@RequestMapping(value = "/joinForm")
	public ModelAndView joinForm() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("content", "member/JoinForm.jsp");
		return this.redirect("template/Template", param);
		
	}
}
