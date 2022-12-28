package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.InvitationService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.service.ProjectService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/error")
@Controller
public class ErrorController {
		
	@RequestMapping(value = "/error400", method = { RequestMethod.GET, RequestMethod.POST })
	public String error400(Model model) {
		
		// forwarding
		return "error400";
	}
	
	@RequestMapping(value = "/error404", method = { RequestMethod.GET, RequestMethod.POST })
	public String error404(Model model) {
		
		// forwarding
		return "error404";
	}
	
	@RequestMapping(value = "/error500", method = { RequestMethod.GET, RequestMethod.POST })
	public String error500(Model model) {
		
		// forwarding
		return "error500";
	}
}
