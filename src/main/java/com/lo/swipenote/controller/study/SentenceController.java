package com.lo.swipenote.controller.study;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.MenuService;
import com.lo.swipenote.service.SentenceService;

/** 문장관련 컨트롤러
 * @author 편범삼
 * */
@RequestMapping("/study/sentence")
@Controller
public class SentenceController extends MasterController {


	@Autowired
	MenuService menuService;
	
	@Autowired
	SentenceService sentenceService;

	/** 파일 및 사진 찍기 선택 페이지
	 * @return 문장 등록으로 경로
	 */
	@LoginCheck
	@RequestMapping(value = "/{menuNo}")
	public ModelAndView searchMenuList(@PathVariable("menuNo") String menuNo, String sentenceNo, String type, HttpSession session) {
	
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";
		try {
			if(!"0".equals(sentenceNo)){
				if (memberInfo != null) {
					id = memberInfo.getId();
					HashMap<String, Object> sentenceMap = sentenceService.getSentence(sentenceNo, id);
					model.put("sentence", sentenceMap.get("CONTENT").toString().replaceAll("\"", "'"));
					model.put("title", sentenceMap.get("TITLE").toString());
					model.put("descript", sentenceMap.get("DESCRIPT").toString());
				}else {
					model.put("result", "99");
					model.put("msg", "noUserInfo");
				}
			}
		} catch (Exception e) {
			model.put("result","99");	
			model.put("msg",e.getMessage());
		}
		model.put("content", "/study/Sentence.jsp");
		model.put("sentenceNo", sentenceNo);
		model.put("menuNo", menuNo);
		model.put("type", type);
		// 경로 반환
		return this.redirect("template/Template", model);
	}
	
	
	/** 문장 문서 얻기
	 * @param session	유저정보를 받아올 세션
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @param menuNo	매뉴 번호
	 * @return
	 */
	@LoginCheck
	@ResponseBody
	@RequestMapping(value = "/searchSentence")
	public HashMap<String, Object> searchSentence(HttpSession session, String tabType, String menuNo) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";
		
		try {
			if (memberInfo != null) {
				id = memberInfo.getId();
				model.put("result","00");
				model.put("list", menuService.searchSentenceListUnderFolder(menuNo, tabType, id));		
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
	
	/** 문장 문서 얻기
	 * @param session	유저정보를 받아올 세션
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @param menuNo	매뉴 번호
	 * @return
	 */
	@LoginCheck
	@ResponseBody
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public HashMap<String, Object> save(HttpSession session, String sentence, String menuNo, String title, String descript, String sentenceNo) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";
		
		try {
			if (memberInfo != null) {
				id = memberInfo.getId();
				model.put("result","00");
				if("0".equals(sentenceNo)) {
					sentenceService.saveSentence(sentence, menuNo, title, descript, id);	
				}else {
					sentenceService.modifySentence(sentence, menuNo,  title, descript, sentenceNo, id);
				}
					
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
	
	
	@LoginCheck
	@ResponseBody
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public HashMap<String, Object> delete(HttpSession session, String sentenceNo) {

		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
	
		// 유저 아이디 초기화
		String id = "";
		
		try {
			if (memberInfo != null) {
				id = memberInfo.getId();
				model.put("result","00");
				sentenceService.deleteSentence(sentenceNo, id);
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
