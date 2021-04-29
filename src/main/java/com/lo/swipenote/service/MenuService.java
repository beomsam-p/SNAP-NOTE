package com.lo.swipenote.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.mapper.MenuMapper;

/** 문장 및 단어 메뉴 관련 서비스 클래스
 * @author 편범삼
 * */
@Service
public class MenuService {
	/** 메뉴 관련 매퍼 클래스
	 * */
	@Autowired
	MenuMapper menuMapper;
	
	/** 메뉴 리스트 얻기  (탭 타입에 따라 문장 / 단어 리스트 반환)
	 * @param id		유저아이디
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @return
	 * */
	public List<HashMap<String, Object>> searchMenuList (String id, String tabType){
		if(tabType.equals("Sentence")){
			return menuMapper.searchSendtenceMenuListById(id);	
		}else {
			return menuMapper.searchWordMenuListById(id);	
		}
	}
	
	/** 현재 메뉴 번호로 하위 메뉴 얻기 (탭 타입에 따라 문장 / 단어 리스트 반환)
	 * @param menuNo
	 * @param tabType
	 * @return
	 */
	public List<HashMap<String, Object>> searchUnderMenuListByNo (String menuNo, String tabType, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("menuNo",menuNo);
		param.put("id",id);
		
		if(tabType.equals("Sentence")){
			return menuMapper.searchSentenceUnderMenuListByMenoNo(param);	
		}else {
			return menuMapper.searchWordUnderMenuListByMenoNo(param);	
		}
	}
	
	public HashMap<String, Object> getMenuPath(String menuNo, String tabType, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("menuNo",menuNo);
		param.put("id",id);
		if(tabType.equals("Sentence")){
			return menuMapper.getMenuPath(param);	
		}else {
			//todo 단어용 메퍼 만들어야함
			return menuMapper.getMenuPath(param);
		}
	}
}
