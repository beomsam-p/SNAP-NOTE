package com.lo.swipenote.controller.member;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MemberService;
import com.lo.swipenote.util.CommonUtil;

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
	public HashMap<String, Object> loginProc(String id, String pwd, String saveId ,HttpSession session, HttpServletRequest request, HttpServletResponse response) 
	{
		HashMap<String, Object> model = new HashMap<String, Object>();
		try {
			//아이디로 맴버 정보 조회
			MemberDto memberInfo = memberService.getMemberById(id);
			
			//로그인 프로세스 진행 후 결과를 모델에 담음
			model = memberService.login(memberInfo,id, pwd, saveId, request, response);
			 
			//세션에 로그인 정보 담음
			if(model != null && model.get("result")!= null &&"00".equals(model.get("result"))) {
				session.setAttribute("userSession", memberInfo);
			}
			
			
		} catch (Exception e) {
			//실패코드
			model.put("result", "99");				//예외발생
			model.put("errorMsg", e.getMessage());	//에러 메시지
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
