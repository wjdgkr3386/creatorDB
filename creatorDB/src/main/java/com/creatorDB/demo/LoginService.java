package com.creatorDB.demo;

public interface LoginService {

	int insertUserInfo(LoginDTO loginDTO) throws Exception;
	
	int updateAuto_login(LoginDTO loginDTO) throws Exception;
}
