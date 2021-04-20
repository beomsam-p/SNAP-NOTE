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

/** 회원관련 컨트롤러
 * @author 편범삼
 * */
@RequestMapping(value = "/member")
@Controller
public class MemberController extends MasterController{
	
	/** 맴버관련 비즈니스 로직 처리 서비스
	 * */
	@Autowired
	MemberService memberService;
	
	/** 로그인 페이지로 이동
	 * @return	로그인 페이지 뷰경로
	 * */
	@RequestMapping(value = "/loginForm")
	public ModelAndView loginForm() {
		//리턴 파라미터 설정
		HashMap<String, Object> param = new HashMap<String, Object>();
		//좌메뉴 감추기
		param.put("LEFTMENU", "hide");
		
		//뷰경로 설정
		param.put("content", "member/LoginForm.jsp");
		
		
		//뷰경로를 담고 템플릿으로 이동
		return this.redirect("template/Template", param);
	}
	
	/** 로그인  프로세스
	 * @param id		입력 아이디
	 * @param pwd		입력 비밀번호
	 * @param saveId	아이디 저장 
	 * @param session	유저정보를 담을 세션
	 * @param request	쿠키 생성을 위한 요청 객체
	 * @param response	쿠키 생서을 위한 응답 객체
	 * @return			로그인 성공여부 반환(00:성공 / 99:실패)
	 * */
	@RequestMapping(value = "/loginProc", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> loginProc(String id, String pwd, String saveId ,HttpSession session, HttpServletRequest request, HttpServletResponse response) 
	{
		//리턴 파라미터 세팅
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
			//실패 코드
			model.put("result", "99");				
			//에러 메시지
			model.put("errorMsg", e.getMessage());	
		}
		
		return model;
	}
	
	/** 회원가입 페이지 이동
	 * @return	회원가입 페이지 뷰경로
	 * */
	@RequestMapping(value = "/joinForm")
	public ModelAndView joinForm() {
		//리턴 파라미터 설정
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		//좌메뉴 감추기
		param.put("LEFTMENU", "hide");
		
		//뷰경로 설정
		param.put("content", "member/JoinForm.jsp");
		
		//뷰경로 반환
		return this.redirect("template/Template", param);
		
	}
	
	/** 회원가입 프로세스
	 * @param email	입력 이메일(아이디)
	 * @param pwd	입력 비밀번호
	 * @param nick	입력 닉네임
	 * @return		성공 여부 반환(00:성공 / 99:실패)
	 * */
	@RequestMapping(value = "/joinProc", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> joinProc(String email, String pwd, String nick) 
	{
		//파라미터 세팅
		HashMap<String, Object> model = new HashMap<String, Object>();
		try {
			//유저 등록
			memberService.insertMember(email, pwd, nick);
			
			//성공코드
			model.put("result", "00");
		} catch (Exception e) {
			//실패코드
			model.put("result", "99");
		}
		
		return model;
		
	}
	
	/** 아이디 중복 확인
	 * @param	email	유저 입력 이메일(id)
	 * @return	중복여부 반환	(성공:1  / 입력실패:0 / 예외발생:99) 
	 * */
	
	@RequestMapping(value = "/chkDuplicate", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> chkDuplicate(String email) 
	{
		
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		try {
			//결과 얻기
			model.put("result",memberService.chkIdDuplication(email));
		} catch (Exception e) {
			//예외코드
			model.put("result","99");
			//에러메시지
			model.put("errorMsg",e.getMessage());
		}
		
		return model;
		
	}
}
