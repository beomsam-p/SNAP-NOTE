package com.lo.swipenote.controller.email;

import java.util.HashMap;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lo.swipenote.service.EmailService;
import com.lo.swipenote.util.CommonUtil;

/** 이메일 발송 관련 컨트롤러
 * @author 편범삼
 * */
@Controller
@RequestMapping(value = "/email")
public class EmailController {
	
	/** 이메일 관련 서비스
	 * */
	@Autowired
	private EmailService emailService;
	
	/**	공통 유틸 클래스
	 * */
	@Autowired
	CommonUtil commonUtil;
	
	/** 이메일 전송 
	 * @param nick					이메일에 표시할 닉네임
	 * @param email					발송할 이메일
	 * @param session				인증번호를 담을 세션 객체
	 * @return						응답바디로 실패 성공여부 반환(00:성공 / 99:실패)
	 * @throws MessagingException	메일 전송시 발생하는 예외
	 * */
	@RequestMapping(value = "/sendJoinMail")
	@ResponseBody
	public HashMap<String, String> sendmail(String nick, String email, HttpSession session) throws MessagingException {
		
		//반환 파라미터 객체
		HashMap<String, String> model = new HashMap<String, String>();
		
		//랜덤 10자리 문자열 생성
		String certificationNumber = commonUtil.randomChar10();
		
        try {
        	
        	//이메일 제목
        	String eamilTitle = "[회원가입 이메일 인증]";
        	
        	//이메일 내용
        	StringBuffer emailcontent = new StringBuffer();
        	
        	//==================================이메일 내용 설정==================================//
    		emailcontent.append("<!DOCTYPE html>");
    		emailcontent.append("<html>");
    		emailcontent.append("<head>");
    		emailcontent.append("</head>");
    		emailcontent.append("<body>");
    		emailcontent.append(
    				" <div" 																																																	+ 
    				"	style=\"font-family: 'Apple SD Gothic Neo', 'sans-serif' !important; width: 400px; height: 600px; border-top: 4px solid #02b875; margin: 100px auto; padding: 30px 0; box-sizing: border-box;\">"		+ 
    				"	<h1 style=\"margin: 0; padding: 0 5px; font-size: 28px; font-weight: 400;\">"																															+ 
    				"		<span style=\"font-size: 15px; margin: 0 0 10px 3px;\">SNAP NOTE</span><br />"																													+ 
    				"		<span style=\"color: #02b875\">메일인증</span> 안내입니다."																																				+ 
    				"	</h1>\n"																																																+ 
    				"	<p style=\"font-size: 16px; line-height: 26px; margin-top: 50px; padding: 0 5px;\">"																													+ 
    				//닉네임
    				nick																																																		+
    				"		님 안녕하세요.<br />"																																													+ 
    				"		Snap Note 이메일 인증 서비스입니다.<br />"																																							+ 
    				"		아래 <b style=\"color: #02b875\">'인증 번호'</b> 를 입력하여 회원가입을 계속 진행해 주세요.<br />"																														+ 
    				"		감사합니다."																																															+ 
    				"	</p>"																																																	+ 
    				"	<sapn style=\"color: #FFF; text-decoration: none; text-align: center;\""																																	+
    				"	href=\"javascript:void(0);\">"																																											+ 
    				"		<p"																																																	+
    				"			style=\"display: inline-block; width: 210px; height: 45px; margin: 30px 5px 40px; background: #02b875; line-height: 45px; vertical-align: middle; font-size: 16px;\">"							+ 
    				"			"																																																+
    				//인증번호
    				certificationNumber 																																														+
    				"		</p>"																																																+ 
    				"	</span>"																																																	+
    				"	<div style=\"border-top: 1px solid #DDD; padding: 5px;\"></div>"																																		+
    				" </div>"
    		);
    		emailcontent.append("</body>");
    		emailcontent.append("</html>");
    		//==================================이메일 내용 설정 끝================================//
    		
    		
    		//설정한 이메일을 발송
    		emailService.sendMail(email, eamilTitle, emailcontent.toString());
    		
    		//발송한 인증번호를 세션에 담음
    		session.setAttribute("certificationNumber", certificationNumber);
    		
    		//성공 반환
    		model.put("result", "00");
		} catch (Exception e) {
			//예외 발생시 실패 반환
			model.put("result", "99");
			
			//에러메시지
			model.put("msg", e.getLocalizedMessage());
		}
		return model;
	}
	
	/** 이메일 인증번호 체크
	 * @param certificationNumber	유저가 입력한 인증번호
	 * @param session				발송된 인증번호를 얻어올 세션
	 * @return						응답바디로 체크 성공 여부 반환(00:성공 / 99:실패)
	 * */
	@RequestMapping(value = "/chkCertificationNumber", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> chkCertificationNumber(String certificationNumber, HttpSession session) 
	{
		//리턴 파라미터 세팅
		HashMap<String, String> model = new HashMap<String, String>();
		
		try {
			//세션에 담긴 인증번호 얻기
			String sessionCertification = session.getAttribute("certificationNumber").toString();
			
			//세션에 담은 인증번호와 유저가 입력한 인증번호의 동일 여부 확인
			if(sessionCertification.equals(certificationNumber)) {
				//동일 경우 성공 반환
				model.put("result", "00");
			}else {
				//상이할 경우 실패 반환
				model.put("result", "99");
			}
		} catch (Exception e) {
			//예외 발생시 실패 반환
			model.put("result", "99");
			
			//에러메시지
			model.put("msg", e.getLocalizedMessage());
		}
		
		return model;
	}
	
	
}
