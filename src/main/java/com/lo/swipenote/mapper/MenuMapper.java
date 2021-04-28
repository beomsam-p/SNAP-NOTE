package com.lo.swipenote.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.lo.swipenote.dto.MenuDto;

@Mapper
@Repository
public interface MenuMapper {
	/**아이디로 문장 메뉴 리스트 얻기
	 * @param	id	유저 아이디
	 * @return		문장 메뉴 리스트
	 */
	public List<HashMap<String, Object>>  searchSendtenceMenuListById(String id);
	
	/**아이디로 단어 메뉴 리스트 얻기
	 * @param	id	유저 아이디
	 * @return		단어 메뉴 리스트
	 */
	public List<HashMap<String, Object>>  searchWordMenuListById(String id);
	
	
	/** 매뉴 번호로 하위 문장 매뉴 얻기
	 * @param	menuNo	문장 번호
	 * @return			하위 문장 리스트
	 */
	public List<HashMap<String, Object>>  searchSentenceUnderMenuListByMenoNo(HashMap<String, String> param);
	
	
	/** 매뉴 번호로 하위 단어 매뉴 얻기
	 * @param	menuNo	문장 번호
	 * @return			하위 문장 리스트
	 */
	public List<HashMap<String, Object>>  searchWordUnderMenuListByMenoNo(HashMap<String, String> param);
}
