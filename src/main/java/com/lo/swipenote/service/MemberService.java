package com.lo.swipenote.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.mapper.MemberMapper;
import com.lo.swipenote.util.SHA256Util;
@Service
public class MemberService {
	@Autowired
	public MemberMapper mapper;

	@Autowired
	SHA256Util  sha256Util;
	
	public MemberDto getMemberById(String id) {
		return mapper.getMemberById(id);
	};
	
	public HashMap<String, Object> login(String email, String pwd) {
		
		
		
		//단방향 암호화
		String encPwd = sha256Util.encodeSHA256(pwd);
		
		
		MemberDto me = getMemberById(email);
		
		if(me.getPwd().equals(encPwd)) {
			
		}
		
		return me 가입 유효성검사(비번패턴, 글자수 다 확인) / 로그인프로세스확인;
	};
	
	public int chkIdDuplication(String id) {
		return mapper.chkIdDuplication(id);
	}
	
	public void insertMember(String email, String pwd, String nick) {
		//단방향 암호화
		String encPwd = sha256Util.encodeSHA256(pwd);
		
		//데이터 세팅
		MemberDto memberDto = new MemberDto();
		memberDto.setId(email);
		memberDto.setEmail(email);
		memberDto.setPwd(encPwd);
		memberDto.setNickname(nick);
		
		mapper.insertMember(memberDto);
	}
	
	public void updateMember(MemberDto memberDto) {
		mapper.updateMember(memberDto);
	}
	
	public void deleteMember(MemberDto memberDto) {
		mapper.deleteMember(memberDto);
	}
	
	
	
}
