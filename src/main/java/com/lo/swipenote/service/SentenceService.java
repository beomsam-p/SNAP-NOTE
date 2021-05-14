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
	
	/** 문장 저장
	 * @param sentence	문장
	 * @param menuNo	폴더번호
	 * @param id		유저 아이디
	 * @return
	 */
	public int saveSentence(String sentence, String menuNo, String title, String descript, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("sentence", sentence);
		param.put("menuNo", menuNo);
		param.put("title", title);
		param.put("descript", descript);
		param.put("id", id);
		return sentenceMapper.saveSentence(param);
	}

	/**문장수정
	 * @param sentence		문장
	 * @param menuNo		폴더번호
	 * @param title			제목
	 * @param descript		설명
	 * @param sentenceNo	문장번호
	 * @param id			유저아이디
	 * @return
	 */
	public int modifySentence(String sentence, String menuNo, String title, String descript, String sentenceNo, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("sentence", sentence);
		param.put("menuNo", menuNo);
		param.put("title", title);
		param.put("descript", descript);
		param.put("sentenceNo", sentenceNo);
		param.put("id", id);
		return sentenceMapper.modifySentence(param);
	}
	
	/** 문장 수정
	 * @param sentenceNo	문장 번호
	 * @param id			유저 아이디
	 * @return
	 */
	public int deleteSentence(String sentenceNo, String id){
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("sentenceNo", sentenceNo);
		param.put("id", id);
		return sentenceMapper.deleteSentence(param);
	}
	
	
}

