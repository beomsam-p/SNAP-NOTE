package com.lo.swipenote.controller.my;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;

@RequestMapping("/my")
@Controller
public class MyController extends MasterController{
	
	/** 마이 홈
	 * @return 마이홈
	 */
	@LoginCheck
	@RequestMapping(value = "/myHome")
	public ModelAndView searchMenuList(HttpSession session) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
	
		model.put("content", "/my/MyHome.jsp");
		// 경로 반환
		return this.redirect("template/Template", model);
	}
	
}
