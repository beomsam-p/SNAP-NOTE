
package com.lo.swipenote.controller.study;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.WordService;

@Controller
@RequestMapping("/study/word")
public class WordController extends MasterController{
	
	@Autowired
	WordService wordService;
	
	
	@LoginCheck
	@RequestMapping("/list")
	public ModelAndView list (HttpSession session) {
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();

		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
		
		String id = "";

		try {
			// 유저 정보가 있을 경우 아이디 얻기
			if (memberInfo != null) {
				id = memberInfo.getId();

				List<HashMap<String, Object>>  wordList = wordService.searchWordList(id);
				
				model.put("wordList", wordList);
				model.put("result", "00");
				
			} else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
		} catch (Exception e) {
			model.put("result", "99");
			model.put("msg", e.getMessage());
		}
		
		
		model.put("content", "/word/WordList.jsp");
		return this.redirect("template/Template", model);
	}
	
}
