package com.lo.swipenote.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.lo.swipenote.dto.MemberDto;

/** 맴버관련 매퍼(DAO) 클래스
 * @author 편범삼
 * */
@Mapper
@Repository
public interface MemberMapper {
	
	//맴버 리스트
	public List<MemberDto> searchMemberList();
	
	//아이디를 통한 맴버정보 단건 조회
	public MemberDto getMemberById(String id);
	
	//맴버 등록
	public void insertMember(MemberDto memberDto);
	
	//맴버 정보 수정
	public void updateMember(MemberDto memberDto);
	
	//맴버 탈퇴
	public void deleteMember(MemberDto memberDto);
	
	//맴버 중복 조회
	public int chkIdDuplication(String id);
	
}


