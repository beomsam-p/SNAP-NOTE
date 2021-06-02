package com.lo.swipenote.service;


import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.lo.swipenote.mapper.MyHomeMapper;
@Service
public class MyHomeService {
	
	@Autowired
	public MyHomeMapper mapper;

	/** 마이홈 통계
	 * @param id	유저아이디
	 * @return
	 */
	public HashMap<String, String> getMyHomeInfo(String id){
		return mapper.getMyHomeInfo(id);
	} 
	
	public void modifyProfileImg(String id, String profileUrl) {
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("id", id);
		param.put("profileUrl", profileUrl);
		mapper.modifyProfileImg(param);
	}
}
