package com.lo.swipenote.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.dto.MemberDto;
import com.lo.swipenote.mapper.MemberMapper;
@Service
public class MemberService {
	@Autowired
	public MemberMapper mapper;

	
	public MemberDto getMember(MemberDto memberDto) {
		return mapper.getMember(memberDto);
	};
	
	public void insertMember(MemberDto memberDto) {
		mapper.insertMember(memberDto);
	}
	
	public void deleteMember(MemberDto memberDto) {
		mapper.deleteMember(memberDto);
	}
}
