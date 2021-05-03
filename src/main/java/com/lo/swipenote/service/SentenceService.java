package com.lo.swipenote.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.mapper.SentenceMapper;

/** 문장관련 서비스 클래스
 * @author pbs
 */
@Service
public class SentenceService {
	
	/** 문장관련 메퍼 
	 * */
	@Autowired
	SentenceMapper sentenceMapper;
	
	/** 문장번호로 문장 얻어오기
	 * @param sentenceNo	문장번호
	 * @param id			아이디
	 * @return				문장 정보
	 */
	public HashMap<String, Object> getSentence(String sentenceNo, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("sentenceNo", sentenceNo);
		param.put("id", id);
		return sentenceMapper.getSentence(param);
	}
	
}

