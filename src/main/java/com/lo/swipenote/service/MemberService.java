package com.lo.swipenote.service;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.mapper.MemberMapper;
import com.lo.swipenote.util.CommonUtil;
import com.lo.swipenote.util.SHA256Util;
@Service
public class MemberService {
	@Autowired
	public MemberMapper mapper;

	@Autowired
	SHA256Util  sha256Util;
	
	@Autowired
	CommonUtil commonUtil;
	
	public MemberDto getMemberById(String id) {
		return mapper.getMemberById(id);
	};
	
	public HashMap<String, Object> login(MemberDto memberInfo, String id, String pwd , String saveId, HttpServletRequest request, HttpServletResponse response) {
		
		HashMap<String, Object> model = new HashMap<String, Object>();
		
		//조회된 맴버 있는지 확인
		if(memberInfo == null) {
			//존재하지 않는 아이디
			model.put("result", "98");
			model.put("errorMsg", "아이디가 존재하지 않습니다.");
		}else {
			//단방향 암호화
			String encPwd = sha256Util.encodeSHA256(pwd);
			
			//조회된 맴버 있을 경우
			//비밀번호 일치 확인
			if(!memberInfo.getPwd().equals(encPwd)) {
				//비밀번호 미일치
				model.put("result", "99");
				model.put("errorMsg", "비밀번호가 일치하지 않습니다.");
			}else {
				//아이디 저장 체크박스 클릭 시 쿠키 생성 / 아닐 경우 삭제
				if("".equals(saveId) || saveId == null) {
					commonUtil.deleteCookie("saveId", response);
				}else {
					commonUtil.setCookie("saveId", id, response);
				}
				//비밀번호 일치(로그인 성공)
				model.put("result", "00");
			}
		}
		return model;
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
