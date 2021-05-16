package com.lo.swipenote.controller.study;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.controller.MasterController;

@Controller
@RequestMapping("/study/word")
public class WordController extends MasterController{
	
	@RequestMapping("/list")
	public ModelAndView list () {
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		model.put("content", "/word/WordList.jsp");
		return this.redirect("template/Template", model);
	}
	
}
