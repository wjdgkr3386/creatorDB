package com.creatorDB.demo;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginDAO {

	

	int checkMid(LoginDTO loginDTO);
	
	int insertUserInfo(LoginDTO loginDTO);
	
	Map<String, Object> getId(String mid);
	
	Map<String, Object> checkId(LoginDTO loginDTO);
	

	int updateAuto_login(LoginDTO loginDTO);
	
}
