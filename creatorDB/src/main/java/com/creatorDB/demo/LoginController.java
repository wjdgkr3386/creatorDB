package com.creatorDB.demo;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class LoginController {

	@Autowired
	LoginService loginService;
	@Autowired
	LoginDAO loginDAO;

	
	@RequestMapping( value="/login.do")
	public ModelAndView login(
			HttpSession session
	) {
		ModelAndView mav = new ModelAndView();
		String mid = (String) session.getAttribute("mid");
		session.removeAttribute("mid");
        session.removeAttribute("access_token");
        session.invalidate();
		
		if(mid!=null) {
			Map<String, Object> map = loginDAO.getId(mid);
			String mid1 = (String) map.get("MID");
			String pwd = (String) map.get("PWD");
			mav.addObject("mid", mid1);
			mav.addObject("pwd", pwd);
		}
		mav.setViewName("login.jsp");
		return mav;
	}
	
	@RequestMapping( value="/loginProc.do")
	public int loginProc(
			LoginDTO loginDTO,
			HttpSession session,
			HttpServletResponse response
	) {
		Map<String, Object> map = loginDAO.checkId(loginDTO);
		int cnt = 0;
		if(map!=null)
			cnt = map.size();
		
		if(cnt>0) {
			try {
				map = loginDAO.checkId(loginDTO);
			}catch(Exception e) {
				System.out.println(e);
			}
			String mid = (String) map.get("MID");
			session.setAttribute( "mid", mid );
		}

		return cnt;
	}
	
	@RequestMapping( value="/signup.do")
	public ModelAndView signup(
	) {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("signup.jsp");
		return mav;
	}
	
	@RequestMapping( value="/signUpProc.do")
	public int signUpProc(
			LoginDTO loginDTO
	) {
		int cnt = 0;
		
		try {
			cnt = loginService.insertUserInfo(loginDTO);
		}catch(Exception e) {
			System.out.println(e);
		}
		return cnt;
	}
	
    @RequestMapping(value = "/logout.do")
    public void logout(HttpSession session, HttpServletResponse response) throws IOException {
        session.removeAttribute("mid");
        session.removeAttribute("access_token");
        session.invalidate();
        response.sendRedirect("/main.do");
    }
  
	@RequestMapping( value="/findAccount.do")
	public ModelAndView findAccount(
	) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("findAccount.jsp");
		return mav;
	}
	
	@RequestMapping( value="/idFindProc.do")
	public Map<String, Object> idFindProc(
			LoginDTO loginDTO
	) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> idList = loginDAO.idFind(loginDTO);
		map.put("idList", idList);
		
		return map;
	}
	
	@RequestMapping( value="/passwordFindProc.do")
	public Map<String, Object> passwordFindProc(
			LoginDTO loginDTO
	) {
		Map<String, Object> map = new HashMap<String, Object>();
		String password = loginDAO.passwordFind(loginDTO);
		map.put("password", password);
		
		return map;
	}
	
	
	
	
}
