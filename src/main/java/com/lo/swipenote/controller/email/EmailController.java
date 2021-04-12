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

@Controller
@RequestMapping(value = "/email")
public class EmailController {
	@Autowired
	private EmailService emailService;
	
	
	@Autowired
	CommonUtil commonUtil;
	
	@RequestMapping(value = "/sendJoinMail")
	@ResponseBody
	public HashMap<String, String> sendmail(String nick, String email, HttpSession session) throws MessagingException {
		
		
		HashMap<String, String> model = new HashMap<String, String>();
		
		String certificationNumber = commonUtil.randomChar10();
		
        try {
        	StringBuffer emailcontent = new StringBuffer();
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
    				nick																																																		+
    				"		님 안녕하세요.<br />"																																													+ 
    				"		Snap Note에 가입해 주셔서 진심으로 감사드립니다.<br />"																																							+ 
    				"		아래 <b style=\"color: #02b875\">'인증 번호'</b> 를 입력하여 회원가입을 완료해 주세요.<br />"																														+ 
    				"		감사합니다."																																															+ 
    				"	</p>"																																																	+ 
    				"	<sapn style=\"color: #FFF; text-decoration: none; text-align: center;\""																																	+
    				"	href=\"javascript:void(0);\">"																																											+ 
    				"		<p"																																																	+
    				"			style=\"display: inline-block; width: 210px; height: 45px; margin: 30px 5px 40px; background: #02b875; line-height: 45px; vertical-align: middle; font-size: 16px;\">"							+ 
    				"			"																																																+
    				certificationNumber 																																														+
    				"		</p>"																																																+ 
    				"	</span>"																																																	+
    				"	<div style=\"border-top: 1px solid #DDD; padding: 5px;\"></div>"																																		+
    				" </div>"
    		);
    		emailcontent.append("</body>");
    		emailcontent.append("</html>");
    		emailService.sendMail(email, "[회원가입 이메일 인증]", emailcontent.toString());
    		
    		session.setAttribute("certificationNumber", certificationNumber);
    		
    		model.put("result", "00");
		} catch (Exception e) {
			
			model.put("result", "99");
			model.put("msg", e.getLocalizedMessage());
		}
		
		
		return model;
	}
	
	
	@RequestMapping(value = "/chkCertificationNumber", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> chkCertificationNumber(String certificationNumber, HttpSession session) 
	{
		HashMap<String, String> model = new HashMap<String, String>();
		
		try {
			String sessionCertification = session.getAttribute("certificationNumber").toString();
			if(sessionCertification.equals(certificationNumber)) {
				session.removeAttribute("certificationNumber");
				model.put("result", "00");
			}else {
				session.removeAttribute("certificationNumber");
				model.put("result", "99");
			}
		} catch (Exception e) {
			session.removeAttribute("certificationNumber");
			model.put("result", "99");
		}
		
		
		return model;
	}
	
	
}
