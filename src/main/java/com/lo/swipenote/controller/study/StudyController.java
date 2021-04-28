package com.lo.swipenote.controller.study;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MenuService;

/**
 * 공부페이지 컨트롤러
 * 
 * @author 편범삼
 */
@RequestMapping("/study")
@Controller
public class StudyController extends MasterController {

	@Autowired
	MenuService menuService;

	/**
	 * 공부 페이지으로 이동
	 * 
	 * @return 공부 페이지 경로
	 */
	@LoginCheck
	@RequestMapping(value = "/category", method = RequestMethod.GET)
	public ModelAndView studyform(HttpSession session, @RequestParam( defaultValue = "Sentence") String tabType) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();

	
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";

		try {
			// 유저 정보가 있을 경우 아이디 얻기
			if (memberInfo != null) {
				id = memberInfo.getId();

				List<HashMap<String, Object>>  menuList = menuService.searchMenuList(id, tabType);
				
				model.put("list", menuList);
				model.put("result", "00");
				
			} else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
		} catch (Exception e) {
			model.put("result", "99");
			model.put("msg", e.getMessage());
		}

		// 뷰 경로
		model.put("content", "study/Cetegory.jsp");
		model.put("tabType",tabType);
		// 경로 반환
		return this.redirect("template/Template", model);
	}
	
	/** 공부 페이지으로 이동
	 * @return 공부 페이지 경로
	 */
	@LoginCheck
	@RequestMapping(value = "/categoryModify")
	public ModelAndView categoryModify(HttpSession session, @RequestParam( defaultValue = "Sentence") String tabType) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";

		try {
			// 유저 정보가 있을 경우 아이디 얻기
			if (memberInfo != null) {
				id = memberInfo.getId();

				List<HashMap<String, Object>>  menuList = menuService.searchMenuList(id, tabType);
				
				model.put("list", menuList);
				model.put("result", "00");
				
			} else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
		} catch (Exception e) {
			model.put("result", "99");
			model.put("msg", e.getMessage());
		}

		// 뷰 경로
		model.put("tabType",tabType);
		model.put("content", "/study/CetegoryModify.jsp");
		// 경로 반환
		return this.redirect("template/Template", model);
	}
	
	
	/** 공부 페이지으로 이동
	 * @return 공부 페이지 경로
	 */
	@LoginCheck
	@ResponseBody
	@RequestMapping(value = "/selectPosition")
	public HashMap<String, Object> selectPosition(HttpSession session, String tabType, String menuNo) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";
		
		//try {
			if (memberInfo != null) {
				id = memberInfo.getId();
				model.put("result","00");
				model.put("list", menuService.searchUnderMenuListByNo(menuNo, tabType, id));		
			}else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
			
		//} catch (Exception e) {
		//	model.put("result","99");	
		//	model.put("msg",e.getMessage());
		//}
		
		return model;
	}
	
	
	
	
	/** 공부 페이지으로 이동
	 * @return 공부 페이지 경로
	 */
	@LoginCheck
	@RequestMapping(value = "/study")
	public ModelAndView searchMenuList(HttpSession session) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
	
		model.put("content", "/study/Study.jsp");
		// 경로 반환
		return this.redirect("template/Template", model);
	}
	

}
