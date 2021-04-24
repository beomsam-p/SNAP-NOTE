package com.lo.swipenote.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lo.swipenote.dto.MenuDto;
import com.lo.swipenote.mapper.MenuMapper;

@Service
public class MenuService {
	
	@Autowired
	MenuMapper menuMapper;
	
	public List<HashMap<String, Object>> searchMenuList (String id, String tabType){
		if(tabType.equals("Sentence")){
			return menuMapper.searchMenuListBySentence(id);	
		}else {
			return menuMapper.searchMenuListByWord(id);	
		}
		
		
	}
}
