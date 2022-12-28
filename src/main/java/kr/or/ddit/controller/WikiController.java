package kr.or.ddit.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.service.MemberService;
import kr.or.ddit.service.WikiService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.WikiVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/wiki")
@Controller
public class WikiController {

	@Inject
	WikiService wikiService;
	@Inject
	MemberService memberService;
	
	//세션값 가져오기
	HttpServletRequest request;
	
	//HttpSession session = request.getSession();
	
	@GetMapping("/wikiList")
	public String wikiList(WikiVO wikiVO, ProfileVO profileVO,Model model, HttpServletRequest request,@RequestParam(value = "cont", defaultValue = "") String cont) {
		log.info("wikiVO : " + wikiVO);
		int projId = wikiVO.getProjId();
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		String memNo = (String)session.getAttribute("memNo");
		
		profileVO.setMemNo(memNo);
		profileVO.setProjId(projId);
		
		wikiVO.setScon(cont);
		List<WikiVO> wikiListVO =  this.wikiService.wikiList(wikiVO);
		ProfileVO wikiPm = this.wikiService.wikiPm(profileVO);
		String wikiScon = wikiVO.getScon();
		log.info("wikiScon : " + wikiScon);
		log.info("wikiListVO : " + wikiListVO);
		WikiVO projTtl = this.wikiService.projTtl(wikiVO);
		log.info("projTtl : " + wikiVO.getProjTtl());
	
		model.addAttribute("projTtl", projTtl);
		model.addAttribute("wikiScon", wikiScon);
		model.addAttribute("wikiListVO", wikiListVO);
		model.addAttribute("wikiPm", wikiPm);
		
		return "wiki/wikiList";
	}
	
	//등록
	@GetMapping("/wikiInsert")
	public String wikiInsert(WikiVO wikiVO,HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		session.getAttribute("projId");

		return "wiki/wikiInsert";
	}
	
	@PostMapping("/wikiInsertPost")
	public String wikiInsertPost(WikiVO wikiVO, HttpServletRequest request) {
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		int wikiInsert = this.wikiService.wikiInsert(wikiVO);
		log.info("wikiInsert : " + wikiInsert);
		
		//경로 나중에 변경 projId뒤에
		return "redirect:/wiki/wikiList?projId="+projId;
	}
	
	@PostMapping("/wikiUpdate")
	public String wikiUpdate(@Validated WikiVO wikiVO, HttpServletRequest request) {
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		log.info("wikiNo : " + wikiVO.getWikiNo());
		log.info("wikiTtl : " + wikiVO.getWikiTtl());
		log.info("wikiCn : " + wikiVO.getWikiCn());
		
		int wikiUpdate = this.wikiService.wikiUpdate(wikiVO);
		log.info("wikiUpdate : " + wikiUpdate);
		
		return "redirect:/wiki/wikiList?projId="+projId;
	}
	
	@GetMapping("/wikiDelete")
	public String wikiDelete(int wikiNo, HttpServletRequest request) {
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		int wikiDelete = this.wikiService.wikiDelete(wikiNo);
		log.info("wikiDelete : " +wikiDelete);
		//session 프로젝트 아이디 받기
		return "redirect:/wiki/wikiList?projId="+projId;
	}
	@GetMapping("/wikiwiki")
	public String WikiWiki() {
		return "wiki/wikiwiki";
	}
}
