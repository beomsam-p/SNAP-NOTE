package com.lo.swipenote.controller.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping(value = "/member")
@Controller
public class LoginController {

	
	@RequestMapping(value = "/loginForm")
	public String loginForm() {
		return "member/LoginForm"; 
		
	}
	
	@RequestMapping(value = "/joinForm")
	public String joinForm() {
		return "member/joinForm"; 
		
	}
}
