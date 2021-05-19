
package com.lo.swipenote.controller.study;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lo.swipenote.aop.LoginCheck;
import com.lo.swipenote.controller.MasterController;
import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.service.WordService;

@Controller
@RequestMapping("/study/word")
public class WordController extends MasterController{
	
	/**단어 관련 서비스 클래스
	 * */
	@Autowired
	WordService wordService;
	
	/** 단어리스트로 이동
	 * @param session	유저정보를 담은 세션
	 * @return
	 */
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
	
	/** 단어 저장 ajax
	 * @param session	유저정보를 담은 세션
	 * @param orgWord	단어
	 * @param convWord	뜻
	 * @return
	 */
	@LoginCheck
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody	
	public HashMap<String, Object> save(HttpSession session, String orgWord, String convWord){
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();

		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
		
		String id = "";

		try {
			// 유저 정보가 있을 경우 아이디 얻기
			if (memberInfo != null) {
				id = memberInfo.getId();
				String lastWordNo = wordService.insertWord(orgWord, convWord, id);
				model.put("word", wordService.getWord(lastWordNo, id));
				model.put("result", "00");
			} else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
		} catch (Exception e) {
			model.put("result", "99");
			model.put("msg", e.getMessage());
		}
		
		return model;
	}
	
	/** 암기테스트 페이지로 이동
	 * @param words	단어리스트에서 체크해온 단어들
	 * @return
	 */
	@LoginCheck
	@RequestMapping("/wordGame")
	public ModelAndView wordGame (String words) {
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();

		model.put("words", words);
		model.put("content", "/word/WordGame.jsp");
		return this.redirect("template/Template", model);
	}
	
	/**	단어게임 오답 시 오답 카운트 증가
	 * @param session	유저정보를 담은 세션
	 * @param wordNo	오답한 단어 번호
	 * @return
	 */
	@LoginCheck
	@RequestMapping(value = "/wrongCountUp", method = RequestMethod.POST)
	@ResponseBody	
	public HashMap<String, Object> wrongCountUp(HttpSession session, String wordNo){
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();

		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
		
		String id = "";

		try {
			// 유저 정보가 있을 경우 아이디 얻기
			if (memberInfo != null) {
				id = memberInfo.getId();
				wordService.updateWrongCount(wordNo, id);
				wordService.updateHitYn(wordNo, "N", id);
				model.put("result", "00");
			} else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
		} catch (Exception e) {
			model.put("result", "99");
			model.put("msg", e.getMessage());
		}
		
		return model;
	}
	
	/**단어 정답한 경우 ajax
	 * @param session
	 * @param wordNo
	 * @return
	 */
	@LoginCheck
	@RequestMapping(value = "/updateHitY", method = RequestMethod.POST)
	@ResponseBody	
	public HashMap<String, Object> updateHitY(HttpSession session, String wordNo){
		// 리턴 파라미터 선언
		HashMap<String, Object> model = new HashMap<String, Object>();

		// 세션에서 유저정보 얻기
		MemberDto memberInfo = (MemberDto) session.getAttribute("userSession");
		
		String id = "";

		try {
			// 유저 정보가 있을 경우 아이디 얻기
			if (memberInfo != null) {
				id = memberInfo.getId();
				wordService.updateHitYn(wordNo, "Y", id);
				model.put("result", "00");
			} else {
				model.put("result", "99");
				model.put("msg", "noUserInfo");
			}
		} catch (Exception e) {
			model.put("result", "99");
			model.put("msg", e.getMessage());
		}
		
		return model;
	}
	
}
