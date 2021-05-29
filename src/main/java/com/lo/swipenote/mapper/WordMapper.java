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
	
	/** 단어 단건 얻기
	 * @param 	param	아이디와 단어정보를 담고있음
	 * @return
	 * */
	public HashMap<String, Object> getWord(HashMap<String, Object> param);
	
	/** 단어 입력
	 * @param 	param	아이디와 단어정보를 담고있음
	 * @return
	 * */
	public void insertWord(HashMap<String, Object> param);
	
	/** 실패횟수 업데이트
	 * @param 	param	단어번호를 담고있음
	 * @return
	 * */
	public void updateWrongCount(HashMap<String, Object> param);
	
	
	/** 단어 적중 여부 수정
	 * @param param		아이디, 단어번호, 적중여부가 있음
	 */
	public void updateHitYn(HashMap<String, Object> param);
	

	/** 단어 삭제
	 * @param param		아이디, 단어번호가 있음
	 */
	public void deletWord(HashMap<String, Object> param);
	
}
