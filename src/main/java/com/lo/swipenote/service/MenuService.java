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
	 * @param menuNo	매뉴번호
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
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
	
	/** 매뉴에 따른 경로 반환
	 * @param menuNo	매뉴번호
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @param id		아이디
	 * @return
	 */
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
	
	/**매뉴 추가
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @param parentNo	추가할 위치
	 * @param title		폴더 제목
	 * @param descript	폴더 설명
	 * @param id		아이디
	 * @return			성공여부 1:성공 / 0: 실패
	 */
	public int registMenu( String tabType, String parentNo, String title, String descript, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("parentNo", parentNo);
		param.put("id", id);
		param.put("title", title);
		param.put("descript", descript);
		if(tabType.equals("Sentence")){
			return menuMapper.registMenu(param);	
		}else {
			//todo 단어용 메퍼 만들어야함
			return menuMapper.registMenu(param);
		}
	}
	
	
	/**매뉴 추가
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @param parentNo	추가할 위치
	 * @param id		아이디
	 * @return			성공여부 1:성공 / 0: 실패
	 */
	public int removeMenu( String tabType, String menuNo, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("menuNo", menuNo);
		param.put("id", id);
		if(tabType.equals("Sentence")){
			return menuMapper.removeMenu(param);	
		}else {
			//todo 단어용 메퍼 만들어야함
			return menuMapper.removeMenu(param);
		}
	}
	

	
	
	/**	메뉴 수정
	 * @param tabType	매뉴탭 타입  (Sentence / Word)
	 * @param crrentNo	현재 글번호
	 * @param moveNo	이동하고자 하는 글번호(하위로 들어감)
	 * @param title		제목
	 * @param descript  설명
	 * @param id		아이디
	 * @return			성공여부 1:성공 / 0: 실패
	 */
	public int modifyMenu (String tabType, String crrentNo, String moveNo, String title, String descript, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("crrentNo", crrentNo);
		param.put("moveNo", moveNo);
		param.put("title", title);
		param.put("descript", descript);
		param.put("id", id);
		if(tabType.equals("Sentence")){
			return menuMapper.modifyMenu(param);	
		}else {
			//todo 단어용 메퍼 만들어야함
			return menuMapper.modifyMenu(param);
		}
	}
}
