package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class CommonController {
	
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("access Denied : " + auth);
		model.addAttribute("msg", "접근 권한이 없습니다.");
	}
	
	@GetMapping("/customLogin")
	public void loginInput(String error,String logout, Model model) {
		log.info("error: " + error);
		log.info("logout: " + logout);
		
		if(error != null) {
			model.addAttribute("error", "로그인 실패. 다시 시도하십시오");
	    }

	    if (logout != null) {
	      model.addAttribute("logout", "로그아웃 되었습니다.");
	    }
	}
	
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}

	@PostMapping("/customLogout")
	public void logoutPost() {
		log.info("post custom logout");
	}
}
