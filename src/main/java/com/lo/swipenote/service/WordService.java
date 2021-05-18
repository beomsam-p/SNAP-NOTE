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
	public List<HashMap<String, Object>>  searchWordList(String id){
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("id", id);
		return wordMapper.searchWordList(param);
	}
}
