package com.lo.swipenote.controller.member;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MemberService;
import com.lo.swipenote.util.SHA256Util;

@RequestMapping(value = "/member")
@Controller
public class MemberController extends MasterController{
	
	@Autowired
	SHA256Util  sha256Util;
	
	@Autowired
	MemberService memberService;
	
	
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
	
	@RequestMapping(value = "/joinProc", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> joinProc(String email, String pwd, String nick) 
	{
		HashMap<String, Object> model = new HashMap<String, Object>();
		try {
			//단방향 암호화
			String encPwd = sha256Util.encodeSHA256(pwd);
			
			//데이터 세팅
			MemberDto memberDto = new MemberDto();
			memberDto.setId(email);
			memberDto.setEmail(email);
			memberDto.setPwd(encPwd);
			memberDto.setNickname(nick);
			
			//인설트
			memberService.insertMember(memberDto);
			
			//성공코드
			model.put("result", "00");
		} catch (Exception e) {
			//실패코드
			model.put("result", "99");
		}
		
		
		return model;
		
	}
}
