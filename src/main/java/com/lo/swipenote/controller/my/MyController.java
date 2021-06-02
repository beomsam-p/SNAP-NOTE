package com.lo.swipenote.controller.my;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MemberService;
import com.lo.swipenote.service.MyHomeService;

@RequestMapping("/my")
@Controller
public class MyController extends MasterController{
	
	/** 마이홈 서비스 클래스
	 */
	@Autowired
	private MyHomeService myHomeService; 
	
	/**맴버 서비스 클래스
	 */
	@Autowired
	private MemberService memberService; 
	
	/** 마이 홈
	 * @return 마이홈
	 */
	@LoginCheck
	@RequestMapping(value = "/myHome")
	public ModelAndView searchMenuList(HttpSession session) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		MemberDto userInfo = (MemberDto) session.getAttribute("userSession");
		
		String id =  userInfo.getId();
		
		model.put("myHomeInfo", myHomeService.getMyHomeInfo(id));
		model.put("userInfo", memberService.getMemberById(id));
		
		model.put("content", "/my/MyHome.jsp");
		
		// 경로 반환
		return this.redirect("template/Template", model);
	}
	
	@LoginCheck
	@ResponseBody
	@RequestMapping(value = "/modifyProfileImg")
	public HashMap<String, Object> modifyProfileImg(HttpSession session, String url) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";
		
		try {
			if (memberInfo != null) {
				id = memberInfo.getId();
				myHomeService.modifyProfileImg(id, url);
				model.put("result","00");
			}else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
			
		} catch (Exception e) {
			model.put("result","99");	
			model.put("msg",e.getMessage());
		}
		
		return model;
	}
	
}
