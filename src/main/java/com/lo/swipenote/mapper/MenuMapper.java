package com.lo.swipenote.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.lo.swipenote.dto.MenuDto;

@Mapper
@Repository
public interface MenuMapper {
	
	public List<MenuDto> searchMenuList(String id);
	
}
