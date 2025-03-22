package com.creatorDB.demo;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginDAO {

	

	int checkMid(LoginDTO loginDTO);
	
	int insertUserInfo(LoginDTO loginDTO);
	
	Map<String, Object> getId(String mid);

	Map<String, Object> checkId(LoginDTO loginDTO);

	List<Map<String, Object>> idFind(LoginDTO loginDTO);

	String passwordFind(LoginDTO loginDTO);
	
	
}
