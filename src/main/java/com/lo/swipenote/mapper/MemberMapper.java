package com.lo.swipenote.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.lo.swipenote.dto.MemberDto;

@Mapper
@Repository
public interface MemberMapper {
	
	public List getMemberList();
	
	public MemberDto getMember(MemberDto memberDto);
	
	public void insertMember(MemberDto memberDto);
	
	public void updateMember(MemberDto memberDto);
	
	public void deleteMember(MemberDto memberDto);
}


