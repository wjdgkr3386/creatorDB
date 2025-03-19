package com.creatorDB.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional
@Service
public class LoginServiceImpl implements LoginService{

	@Autowired
	LoginDAO loginDAO;

	public int insertUserInfo(LoginDTO loginDTO) {
		int cnt = 0;
		if(loginDAO.checkMid(loginDTO)>0) return -13;
		cnt = loginDAO.insertUserInfo(loginDTO);
		return cnt;
	}

	public int updateAuto_login(LoginDTO loginDTO) {
		int cnt = 0;
		
		loginDAO.updateAuto_login(loginDTO);
		
		return cnt;
	}
	
	
	
}
