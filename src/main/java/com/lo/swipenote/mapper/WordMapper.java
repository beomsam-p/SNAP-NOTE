package com.lo.swipenote.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/** 단어 메퍼 클래스
 * @author pbs
 */
@Repository
@Mapper
public interface WordMapper {

	/** 단어리스트
	 * @param 	param	아이디를 담고있음
	 * @return
	 * */
	public List<HashMap<String, Object>>  searchWordList(HashMap<String, Object> param);
	
}
