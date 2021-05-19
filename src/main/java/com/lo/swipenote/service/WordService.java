package com.lo.swipenote.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.mapper.WordMapper;

/** 단어서비스 클래스
 * @author 편범삼
 * */
@Service
public class WordService {

	@Autowired
	WordMapper wordMapper;
	
	/** 단어리스트
	 * @param 	param	아이디를 담고있음
	 * @return
	 * */
	public List<HashMap<String, Object>> searchWordList(String id){
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("id", id);
		return wordMapper.searchWordList(param);
	}
	
	/** 단어단건
	 * @param 	param	아이디를 담고있음
	 * @return
	 * */
	public HashMap<String, Object> getWord(String wordNo,String id){
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("wordNo", wordNo);
		param.put("id", id);
		return wordMapper.getWord(param);
	}
	
	
	/** 단어 입력
	 * @param orgWord	원 단어
	 * @param convWord	번역 단어
	 * @param id		유저 아이디
	 * @return
	 */
	public String insertWord(String orgWord, String convWord, String id) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("orgWord", orgWord);
		param.put("convWord", convWord);
		param.put("id", id);
		wordMapper.insertWord(param);
		return param.get("id").toString();
	}
	
	
	/** 단어 오답 카운트 증가
	 * @param wordNo	오답 단어 번호
	 * @param id		유저 아이디
	 */
	public void updateWrongCount(String wordNo, String id) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("wordNo", wordNo);
		param.put("id", id);
		wordMapper.updateWrongCount(param);
	}
	
	/** 단어 적중여부 수정
	 * @param wordNo	대상 단어번호
	 * @param hitYn		적중여부
	 * @param id		유저 아이디
	 */
	public void updateHitYn(String wordNo, String hitYn, String id) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("wordNo", wordNo);
		param.put("hitYn", hitYn);
		param.put("id", id);
		wordMapper.updateHitYn(param);
	}
	
	
}
