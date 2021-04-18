package com.lo.swipenote.service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/** 이메일 관련 서비스 
 * @author 편범삼
 * */
@Service
public class EmailService {
	
	/** 이메일 전송 객체
	 * */
	@Autowired
    private JavaMailSender javaMailSender;

	/** 이메일 전송 
	 * @param toEmail				전송할 이메일 주소
	 * @param subject				제목
	 * @param message				내용
	 * @throws MessagingException	이메일 발송 관련 예외
	 */
    public void sendMail(String toEmail, String subject, String message) throws MessagingException {
    	//mime 스타일 메시지 객체 얻기
    	MimeMessage mimeMessage = javaMailSender.createMimeMessage();
    	
    	//메시지 헬퍼에 인코딩 및 메시지객체 세팅
    	MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");
    	
    	//헬퍼에 전송관련 정보 세팅
    	helper.setFrom("SnapNotePublic");	//보내는사람
    	helper.setTo(toEmail);			 	//받는사람
    	helper.setSubject(subject);		 	//메일제목
    	helper.setText(message, true);		//ture넣을경우 html

    	//이메일 발송
        javaMailSender.send(mimeMessage);
    }
}