package com.creatorDB.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class CreatorController {

	@Autowired
	CreatorService creatorService;
	@Autowired
	CreatorDAO creatorDAO;
	
	@RequestMapping( value="/main.do")
	public ModelAndView main(
	) {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("main.jsp");
		return mav;
	}
	
	@RequestMapping( value="/searchCreatorInfoProc.do")
	public Map<String, Object> searchCreatorInfoProc(
			CreatorDTO creatorDTO
	) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> creatorList = creatorDAO.searchCreator(creatorDTO);
		int resultCount = creatorList.size();
		
		map.put("creatorList", creatorList);
		map.put("resultCount", resultCount);
		
		return map;
	}
	
	@RequestMapping( value="/insertCreatorInfoProc.do")
	public int insertCreatorInfoProc(
			CreatorDTO creatorDTO
	) {
		int cnt=0;
		try {
			cnt = creatorService.insertCreator(creatorDTO);
		}catch(Exception e) {
			System.out.println(e);
		}
		
		return cnt;
	} 
	
	
	
	
}
