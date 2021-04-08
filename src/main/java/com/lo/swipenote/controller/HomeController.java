package com.lo.swipenote.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.mapper.MemberMapper;

@Controller
public class HomeController {
	
	
	@RequestMapping("/")
	public String homeController() {
		return "Main";
	}
}
