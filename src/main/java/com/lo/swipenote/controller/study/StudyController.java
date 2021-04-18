package com.lo.swipenote.controller.study;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;

/** 공부페이지 컨트롤러
 * @author 편범삼
 * */
@RequestMapping("/study")
@Controller
public class StudyController extends MasterController{

	/** 공부 페이지으로 이동
	 * @return	공부 페이지 경로
	 * */
	@LoginCheck
	@RequestMapping(value = "/study",method = RequestMethod.GET)
	public ModelAndView studyform() {
		
		//리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		//뷰 경로
		model.put("content", "study/Study.jsp");
		
		//경로 반환
		return this.redirect("template/Template", model);
	}
	
}

