package com.lo.swipenote.controller;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.dto.MemberDto;

/** 최초 진입점 
 * @author 편범삼
 * */
@Controller
public class HomeController extends MasterController{
	
	/** 메인으로 이동 
	 * @return	메인 뷰 경로
	 * */
	@RequestMapping("/")
	public ModelAndView homeController(HttpSession session) {
		//파라미터 세팅
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
		
		if(memberInfo==null) {
			//뷰 경로 설정
			param.put("content", "Main.jsp");
		}else {
			return this.direct("/study/study");				
		}
		
		//뷰 경로 설정
		param.put("content", "Main.jsp");
		
		//탬플릿으로 이동
		return this.redirect("template/Template", param);
	}
}
