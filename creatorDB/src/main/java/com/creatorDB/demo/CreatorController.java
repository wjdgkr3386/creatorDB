package com.creatorDB.demo;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class CreatorController {

	@RequestMapping( value="/main.do")
	public ModelAndView main(
	) {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("main.jsp");
		return mav;
	}
}
