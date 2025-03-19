package com.creatorDB.demo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

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
	@Autowired
	LoginDAO loginDAO;
	
	@RequestMapping( value="/main.do")
	public ModelAndView main(
			HttpSession session
	) {
		ModelAndView mav = new ModelAndView();
		String mid = (String) session.getAttribute("mid");
		String access_token = (String) session.getAttribute("access_token");
		if(mid != null) {
			mav.addObject("mid", mid);
		}
		if(access_token != null) {
			mav.addObject("access_token", access_token);
		}
		
		mav.setViewName("main.jsp");
		return mav;
	}
	
	@RequestMapping( value="/searchCreatorInfoProc.do")
	public Map<String, Object> searchCreatorInfoProc(
			CreatorDTO creatorDTO
	) {		
		Map<String, Object> map = new HashMap<String, Object>();		
		List<Map<String, Object>> creatorList = creatorDAO.searchCreator(creatorDTO);
		
		int resultCount = 0;
		if(creatorList!=null) {
			resultCount = creatorList.size();
			Util.timeElapses(creatorList);
		}
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
	
	@RequestMapping( value="/getChannelProc.do")
	public Map<String, Object> getChannelProc(
			CreatorDTO creatorDTO
	) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> m = creatorDAO.getChannel(creatorDTO);
		int size = 0;
		
		if(m!=null) {
			size = m.size();
			map = m;
		}
		
		map.put("size", size);
		return map;
	}

	@RequestMapping( value="/updateChannelProc.do")
	public int updateChannelProc(
			CreatorDTO creatorDTO
	) {
		int cnt=0;
		try {
			cnt = creatorService.updateChannel(creatorDTO);
		}catch(Exception e) {
			System.out.println(e);
		}
		
		return cnt;
	}
	
	
	
	
	
	
	
	
	
	
	

	
	@RequestMapping( value="/test.do")
	public ModelAndView test(
	) {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("test.jsp");
		return mav;
	}
	
	@RequestMapping( value="/test2.do")
	public ModelAndView test2(
	) {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("test2.jsp");
		return mav;
	}
	
	@RequestMapping( value="/error.do")
	public ModelAndView error(
	) {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("error.jsp");
		return mav;
	}
}
