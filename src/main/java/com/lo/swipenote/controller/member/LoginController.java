package com.lo.swipenote.controller.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MemberService;

@RequestMapping(value = "/member")
@Controller
public class LoginController {

	@Autowired
	private MemberService memverService;
	
	@RequestMapping(value = "/loginForm")
	public String loginForm() {
		MemberDto memberDto = new MemberDto();
		memberDto.setMembNo(2);
		
		memberDto = memverService.getMember(memberDto);
		System.out.println(memberDto); 
		
		return "member/LoginForm"; 
		
	}
	
	@RequestMapping(value = "/joinForm")
	public String joinForm() {
		return "member/joinForm"; 
		
	}
}
