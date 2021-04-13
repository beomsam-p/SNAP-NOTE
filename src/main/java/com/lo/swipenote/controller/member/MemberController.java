package com.lo.swipenote.controller.member;

import java.util.HashMap;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.service.MemberService;
import com.lo.swipenote.util.SHA256Util;

@RequestMapping(value = "/member")
@Controller
public class MemberController extends MasterController{
	
	@Autowired
	MemberService memberService;
	
	
	@RequestMapping(value = "/loginForm")
	public ModelAndView loginForm() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("content", "member/LoginForm.jsp");
		return this.redirect("template/Template", param);
	}
	
	@RequestMapping(value = "/loginProc", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> loginProc(String email, String pwd) 
	{
		HashMap<String, Object> model = new HashMap<String, Object>();
		try {
		
			
			//인설트
			memberService.login(email, pwd);
			
			//성공코드
			model.put("result", "00");
		} catch (Exception e) {
			//실패코드
			model.put("result", "99");
		}
		
		
		return model;
	}
	
	
	@RequestMapping(value = "/joinForm")
	public ModelAndView joinForm() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("content", "member/JoinForm.jsp");
		return this.redirect("template/Template", param);
		
	}
	
	@RequestMapping(value = "/joinProc", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> joinProc(String email, String pwd, String nick) 
	{
		HashMap<String, Object> model = new HashMap<String, Object>();
		try {
			
			memberService.insertMember(email, pwd, nick);
			//성공코드
			model.put("result", "00");
		} catch (Exception e) {
			//실패코드
			model.put("result", "99");
		}
		
		
		return model;
		
	}
	
	@RequestMapping(value = "/chkDuplicate", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> chkDuplicate(String email) 
	{
		
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		try {
			//결과 얻기
			model.put("result",memberService.chkIdDuplication(email));
		} catch (Exception e) {
			//예외발생
			model.put("result","99");
			model.put("errorMsg",e.getMessage());
		}
		
		return model;
		
	}
}
