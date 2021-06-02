package com.lo.swipenote.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/** 마이홈관련 매퍼(DAO) 클래스
 * @author 편범삼
 * */
@Mapper
@Repository
public interface MyHomeMapper {

	/**	마이페이지 통계정보
	 * @param id	유저 아이디
	 * @return	통계정보
	 */
	public HashMap<String, String> getMyHomeInfo(String id);
	
	/** 마이페이지 프로필 사진 ㅅ줭
	 * @param param	아이디, 새로등록된 프로필 URL
	 */
	public void modifyProfileImg(HashMap<String, String> param);
}


