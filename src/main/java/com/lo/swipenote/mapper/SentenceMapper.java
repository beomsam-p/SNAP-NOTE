package com.lo.swipenote.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/** 문장관련 메퍼 인터페이스
 * @author pbs
 */
@Repository
@Mapper
public interface SentenceMapper {

	/** 매뉴 번호로 하위 문서 얻기
	 * @param	param	메뉴번호 및 아이디를 담은 맵 객체
	 * @return			하위 문장 리스트
	 */
	public List<HashMap<String, Object>>  searchSentenceListUnderFolder(HashMap<String, String> param);
	
	/** 문장 페이지 얻기
	 * @param param	문장번호 및 아이디를 담은 맵 객체 
	 * @return
	 */
	public HashMap<String, Object> getSentence(HashMap<String, String> param);
	
	/** 문장저장
	 * @param param	문장 및 폴더번호를 담은 맵 객체
	 * @return
	 */
	public int  saveSentence(HashMap<String, String> param);
	
	/** 문장 수정
	 * @param param	문장 및 폴더번호를 담은 맵 객체
	 * @return
	 */
	public int  modifySentence(HashMap<String, String> param);
}
