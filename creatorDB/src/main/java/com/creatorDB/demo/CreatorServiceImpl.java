package com.creatorDB.demo;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional
@Service
public class CreatorServiceImpl implements CreatorService{

	@Autowired
	CreatorDAO creatorDAO;

	
	public int insertCreator(CreatorDTO creatorDTO) {
		int cnt=0;
		
		if(creatorDAO.isCreator(creatorDTO)>0) return -13; //이미 있음
		cnt = creatorDAO.insertCreator(creatorDTO);
		
		return cnt;
	}
	
	public int updateChannel(CreatorDTO creatorDTO) {
		int cnt=0;
		
		cnt = creatorDAO.updateChannel(creatorDTO);
		
		return cnt;
	}
	
	
	
	
	
}
