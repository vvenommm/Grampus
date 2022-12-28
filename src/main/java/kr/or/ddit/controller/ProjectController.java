package kr.or.ddit.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.SubprojectService;
import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.SubprojectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/project")
@Controller
public class ProjectController {
	@Autowired
	ProjectService projectService;
	
	@Autowired
	ProfileService profileService;
	
	//이메일 인증 빈 자동 등록
	@Autowired
	private MailSendService mailService;
	
	@Autowired
	private ProMemService promemService;
	
	@Inject
	private SubprojectService subpService;
	
	@Autowired
	AlertService alertService;
	
	//프로젝트 생성페이지 이동
	@GetMapping("/newProject")
	public String newProject() {
		return "project/newProject";
	}
	
	//프로젝트 생성
	@ResponseBody
	@PostMapping("/createProject")
	public int createProject(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		int res = projectService.createProj(map);
		if(res>0) {
			int tem1 = (Integer)map.get("curr");
			
			//프로필 자동 insert
			HttpSession session = request.getSession();
			ProfileVO pvo = new ProfileVO();
			pvo.setProjId(tem1);
			pvo.setMemId((String)session.getAttribute("id"));
			log.info("      프젝 개설 후 프로필 자동 생성에 넣을 값 : " + pvo);
			this.profileService.afterNewProj(pvo);
			
			//개설된 프로젝트 aside에 출력하기 위해 세션에 저장
			log.info("개설 시 memNo : {}", session.getAttribute("memNo"));
			List<Map<String, Object>> projOnList = this.projectService.projOnList((String)session.getAttribute("memNo"));
			log.info("      projOnList : {}" , projOnList);
			session.setAttribute("projOnList", projOnList);
			
			List<Map<String, Object>> projLogo = this.projectService.projLogo((String)session.getAttribute("memNo"));
			log.info("projLogo               : " + projLogo);
			session.setAttribute("projLogo", projLogo);
			
			return tem1;
		}else {
			return 0;
		}
	}
	
	//프로젝트 사진 업로드
	@ResponseBody
	@PostMapping("/projImg")
	public int projImg(@RequestParam MultipartFile file, @RequestParam String projId) {
		String fileName = file.getOriginalFilename();
		String fileExtension = fileName.substring(fileName.lastIndexOf("."),fileName.length());
//		String uploadFolder = "C:\\Users\\PSR\\eclipse-workspace\\grampus\\src\\main\\webapp\\resources\\image";
		String uploadFolder = "W:\\";
		UUID uuid = UUID.randomUUID();
		String[] uuids = uuid.toString().split("-");
		String uniqueName = uuids[0];
		File saveFile = new File(uploadFolder+"\\"+uniqueName + fileExtension);
		try {
			file.transferTo(saveFile);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projPhoto", uniqueName+fileExtension);
		map.put("projId", Integer.parseInt(projId));
		int res = projectService.updateProjImg(map);
		return res;
	}
	
	//프로젝트 설정 페이지 이동
	@GetMapping("/projectSetting/{projId}/{grp}")
	public String projectSetting(Model model, @PathVariable("projId") int projId, @PathVariable("grp") String grp, HttpServletRequest request) {
		Map<String, Object> infomap = projectService.projInfo(projId);
		log.info("         infomap : " + infomap);
		List<Map<String, Object>> costlist = projectService.projCost(projId);
		
		//그룹이 있는지 없는지에 따라서 프로젝트 전체 멤버 리스트를 projMember로 select할지, pmemGrpList로 select할지
		
		
		Map<String, Object> projMemberMap = new HashMap<String, Object>();
		projMemberMap.put("projId", projId);
		projMemberMap.put("content", "");
		List<Map<String, Object>> projMember = projectService.projMember(projMemberMap);
		log.info("projMember : {}", projMember);
		List<Map<String, Object>> grpList = this.projectService.grpList(projId);
		log.info("grpList : {}", grpList);
		List<SubprojectVO> getGrpList = this.subpService.getGrpList(projId);
		log.info("    getGrpList : " + getGrpList);
		log.info("getGrpList : {}", getGrpList);
		SubprojectVO spvo = this.subpService.ungrpAlert(projId);
		log.info("    spvo 그룹 '미정'인 사람 있나요? : " + spvo.getCnt());
		model.addAttribute("ungrp", spvo.getCnt());
		
		int jobCnt = projectService.jobInfoCnt(projId);
		if(jobCnt > 0) {
			List<Map<String, Object>> applilist = projectService.projAppli(projId);
			log.info("       지원자 리스트 applilist : " + applilist);
			Map<String, Object> jobmap = projectService.projJob(projId);
			String[] tech = jobmap.get("JOB_TECH").toString().trim().split(",");
			model.addAttribute("tech", tech);
			model.addAttribute("jobCnt", jobCnt);
			model.addAttribute("projJob", jobmap);
			if(applilist != null) {
				model.addAttribute("projAppli", applilist);
			}
		}
		model.addAttribute("projInfo", infomap);
		model.addAttribute("projCost", costlist);
		model.addAttribute("projMember", projMember);
		if(grpList.size() > 1) {
			model.addAttribute("grpList", grpList);
		}else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("projId", projId);
			map.put("grp", "전체");
			
			//그룹이 없는 프로젝트의 전체 멤버 리스트
			grpList = this.projectService.pmemGrpList(map);
			model.addAttribute("projMember", grpList);
		}
		HttpSession session = request.getSession();
		
		if(getGrpList != null && getGrpList.size() > 0) {
			model.addAttribute("getGrpList", getGrpList);
			session.setAttribute("getGrpList", getGrpList);
			session.setAttribute("yesGrp", 1); //그룹이 있음
			log.info("    getGrpList : " + getGrpList.toString());
		}else {
			session.setAttribute("yesGrp", 0); //그룹이 없음
		}
		
		//로드맵 -----------------------------------------------------------------------
//		List<Map<String, Object>> roadmap = this.projectService.roadmap(projId);
//		log.info("           설정 들어갈 때 roadmap : " + roadmap);
//		if(roadmap != null && roadmap.size() > 0) {
//			model.addAttribute("roadmap", roadmap);
//		}
		return "project/projectSetting";
	}
	
	//프로젝트 정보 수정
	@ResponseBody
	@PostMapping("/modifyProject")
	public int modifyProject(@RequestBody Map<String, Object> map) {
		log.info("          프로젝트 수정하기 위한 값 map : " + map);
		int res = projectService.projModify(map);
		return res;
	}
	
	
	//내가 참여하고 있고 현재 진행 중인 프로젝트 목록
	@PostMapping("/subList")
	@ResponseBody
	public List<Map<String, Object>> projOnList(HttpServletRequest request){
//	public String projOnList(@RequestBody Map<String, Object> map){

		HttpSession session = request.getSession();
		String memNo = (String)session.getAttribute("memNo");
		List<Map<String, Object>> projList = this.projectService.projOnList(memNo);
		log.info("            sublist의 projOnList : " + projList);
		
//		String str = "";
//		str = "<ul class='nav nav-sm flex-column' id='ul41'><li class='nav-item'><a href='/project/projMain/41/전체' class='nav-link' data-key='t-analytics'> 대시보드 </a></li><li class='nav-item'><a href='/task/taskMain/41/전체' class='nav-link' data-key='t-crm'> 일감 </a></li><li class='nav-item'><a href='/issue/issueMain/41/전체' class='nav-link' data-key='t-ecommerce'> 이슈 </a></li><li class='nav-item'><a href='/notic/noticList/41/전체' class='nav-link' data-key='t-crypto'> 공지사항 </a></li><li class='nav-item'><a href='#sidebarBoard41' class='nav-link' data-bs-toggle='collapse' role='button' aria-expanded='false' data-key='t-crypto'> 게시판 </a><div class='collapse menu-dropdown' id='sidebarBoard41'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/board/boardList?brdHead=1&amp;projId=41&amp;projGrp=전체' class='nav-link' data-key='t-ecommerce-action'> 자유게시판 </a></li><li class='nav-item'><a href='/board/boardList?brdHead=2&amp;projId=41&amp;projGrp=전체' class='nav-link' data-key='t-basic-action'> 헬프 데스크 </a></li></ul></div></li><li class='nav-item'><a href='/doc/docMain/41/전체' class='nav-link' data-key='t-projects'> 문서 </a></li><li class='nav-item'><a href='/wiki/wikiList?projId=41&amp;projGrp=전체' class='nav-link'> <span data-key='t-nft'>위키</span></a></li></ul>";
		
//		str = "<li class='nav-item'><a href='#sidebar전체' class='nav-link' data-bs-toggle='collapse' role='button' aria-expanded='false' aria-controls='sidebarEmail' data-key='t-email'>대덕인재개발원 SNS 개발 프로젝트</a><div class='collapse menu-dropdown' id='sidebar전체'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/project/projMain/1/전체' class='nav-link' data-key='t-analytics'> 대시보드 </a></li><li class='nav-item'><a href='/task/taskMain/1/전체' class='nav-link' data-key='t-crm'> 일감 </a></li><li class='nav-item'><a href='/issue/issueMain/1/전체' class='nav-link' data-key='t-ecommerce'> 이슈 </a></li><li class='nav-item'><a href='/notic/noticList/1/전체' class='nav-link' data-key='t-crypto'> 공지사항 </a></li><li class='nav-item'><a href='#subBoard전체' class='nav-link' data-bs-toggle='collapse' role='button' data-key='t-crypto'> 게시판 </a><div class='collapse menu-dropdown' id='subBoard전체'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/board/boardList?brdHead=1&amp;projId=1&amp;projGrp=전체' class='nav-link' data-key='t-ecommerce-action'> 자유게시판 </a></li><li class='nav-item'><a href='/board/boardList?brdHead=2&amp;projId=1&amp;projGrp=전체' class='nav-link' data-key='t-basic-action'> 헬프 데스크 </a></li></ul></div></li><li class='nav-item'><a href='/doc/docMain/1/전체' class='nav-link' data-key='t-projects'> 문서 </a></li><li class='nav-item'><a href='/wiki/wikiList?projId=1&amp;projGrp=전체' class='nav-link'> <span data-key='t-nft'>위키</span></a></li></ul></div></li><li class='nav-item'><a href='#sidebar1팀' class='nav-link' data-bs-toggle='collapse' role='button' aria-expanded='false' aria-controls='sidebarEmail' data-key='t-email'>대덕인재개발원 SNS 개발 프로젝트_1팀</a><div class='collapse menu-dropdown' id='sidebar1팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/project/projMain/1/1팀' class='nav-link' data-key='t-analytics'> 대시보드 </a></li><li class='nav-item'><a href='/task/taskMain/1/1팀' class='nav-link' data-key='t-crm'> 일감 </a></li><li class='nav-item'><a href='/issue/issueMain/1/1팀' class='nav-link' data-key='t-ecommerce'> 이슈 </a></li><li class='nav-item'><a href='/notic/noticList/1/1팀' class='nav-link' data-key='t-crypto'> 공지사항 </a></li><li class='nav-item'><a href='#subBoard1팀' class='nav-link' data-bs-toggle='collapse' role='button' data-key='t-crypto'> 게시판 </a><div class='collapse menu-dropdown' id='subBoard1팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/board/boardList?brdHead=1&amp;projId=1&amp;projGrp=1팀' class='nav-link' data-key='t-ecommerce-action'> 자유게시판 </a></li><li class='nav-item'><a href='/board/boardList?brdHead=2&amp;projId=1&amp;projGrp=1팀' class='nav-link' data-key='t-basic-action'> 헬프 데스크 </a></li></ul></div></li><li class='nav-item'><a href='/doc/docMain/1/1팀' class='nav-link' data-key='t-projects'> 문서 </a></li><li class='nav-item'><a href='/wiki/wikiList?projId=1&amp;projGrp=1팀' class='nav-link'> <span data-key='t-nft'>위키</span></a></li></ul></div></li><li class='nav-item'><a href='#sidebar3팀' class='nav-link' data-bs-toggle='collapse' role='button' aria-expanded='false' aria-controls='sidebarEmail' data-key='t-email'>대덕인재개발원 SNS 개발 프로젝트_3팀</a><div class='collapse menu-dropdown' id='sidebar3팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/project/projMain/1/3팀' class='nav-link' data-key='t-analytics'> 대시보드 </a></li><li class='nav-item'><a href='/task/taskMain/1/3팀' class='nav-link' data-key='t-crm'> 일감 </a></li><li class='nav-item'><a href='/issue/issueMain/1/3팀' class='nav-link' data-key='t-ecommerce'> 이슈 </a></li><li class='nav-item'><a href='/notic/noticList/1/3팀' class='nav-link' data-key='t-crypto'> 공지사항 </a></li><li class='nav-item'><a href='#subBoard3팀' class='nav-link' data-bs-toggle='collapse' role='button' data-key='t-crypto'> 게시판 </a><div class='collapse menu-dropdown' id='subBoard3팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/board/boardList?brdHead=1&amp;projId=1&amp;projGrp=3팀' class='nav-link' data-key='t-ecommerce-action'> 자유게시판 </a></li><li class='nav-item'><a href='/board/boardList?brdHead=2&amp;projId=1&amp;projGrp=3팀' class='nav-link' data-key='t-basic-action'> 헬프 데스크 </a></li></ul></div></li><li class='nav-item'><a href='/doc/docMain/1/3팀' class='nav-link' data-key='t-projects'> 문서 </a></li><li class='nav-item'><a href='/wiki/wikiList?projId=1&amp;projGrp=3팀' class='nav-link'> <span data-key='t-nft'>위키</span></a></li></ul></div></li><li class='nav-item'><a href='#sidebar4팀' class='nav-link' data-bs-toggle='collapse' role='button' aria-expanded='false' aria-controls='sidebarEmail' data-key='t-email'>대덕인재개발원 SNS 개발 프로젝트_4팀</a><div class='collapse menu-dropdown' id='sidebar4팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/project/projMain/1/4팀' class='nav-link' data-key='t-analytics'> 대시보드 </a></li><li class='nav-item'><a href='/task/taskMain/1/4팀' class='nav-link' data-key='t-crm'> 일감 </a></li><li class='nav-item'><a href='/issue/issueMain/1/4팀' class='nav-link' data-key='t-ecommerce'> 이슈 </a></li><li class='nav-item'><a href='/notic/noticList/1/4팀' class='nav-link' data-key='t-crypto'> 공지사항 </a></li><li class='nav-item'><a href='#subBoard4팀' class='nav-link' data-bs-toggle='collapse' role='button' data-key='t-crypto'> 게시판 </a><div class='collapse menu-dropdown' id='subBoard4팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/board/boardList?brdHead=1&amp;projId=1&amp;projGrp=4팀' class='nav-link' data-key='t-ecommerce-action'> 자유게시판 </a></li><li class='nav-item'><a href='/board/boardList?brdHead=2&amp;projId=1&amp;projGrp=4팀' class='nav-link' data-key='t-basic-action'> 헬프 데스크 </a></li></ul></div></li><li class='nav-item'><a href='/doc/docMain/1/4팀' class='nav-link' data-key='t-projects'> 문서 </a></li><li class='nav-item'><a href='/wiki/wikiList?projId=1&amp;projGrp=4팀' class='nav-link'> <span data-key='t-nft'>위키</span></a></li></ul></div></li><li class='nav-item'><a href='#sidebar2팀' class='nav-link' data-bs-toggle='collapse' role='button' aria-expanded='false' aria-controls='sidebarEmail' data-key='t-email'>대덕인재개발원 SNS 개발 프로젝트_2팀</a><div class='collapse menu-dropdown' id='sidebar2팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/project/projMain/1/2팀' class='nav-link' data-key='t-analytics'> 대시보드 </a></li><li class='nav-item'><a href='/task/taskMain/1/2팀' class='nav-link' data-key='t-crm'> 일감 </a></li><li class='nav-item'><a href='/issue/issueMain/1/2팀' class='nav-link' data-key='t-ecommerce'> 이슈 </a></li><li class='nav-item'><a href='/notic/noticList/1/2팀' class='nav-link' data-key='t-crypto'> 공지사항 </a></li><li class='nav-item'><a href='#subBoard2팀' class='nav-link' data-bs-toggle='collapse' role='button' data-key='t-crypto'> 게시판 </a><div class='collapse menu-dropdown' id='subBoard2팀'><ul class='nav nav-sm flex-column'><li class='nav-item'><a href='/board/boardList?brdHead=1&amp;projId=1&amp;projGrp=2팀' class='nav-link' data-key='t-ecommerce-action'> 자유게시판 </a></li><li class='nav-item'><a href='/board/boardList?brdHead=2&amp;projId=1&amp;projGrp=2팀' class='nav-link' data-key='t-basic-action'> 헬프 데스크 </a></li></ul></div></li><li class='nav-item'><a href='/doc/docMain/1/2팀' class='nav-link' data-key='t-projects'> 문서 </a></li><li class='nav-item'><a href='/wiki/wikiList?projId=1&amp;projGrp=2팀' class='nav-link'> <span data-key='t-nft'>위키</span></a></li></ul></div></li>";
		
//		return str;
		return projList;
	}
	

	//그룹 리스트 불러오기
	@ResponseBody
	@RequestMapping("grpList")
	public List<Map<String, Object>> grpList(int projId, Model model){
		List<Map<String, Object>> grpList = this.projectService.grpList(projId);
		model.addAttribute("grpList", grpList);
		
		return grpList;
	}
	
	//프로젝트 멤버 탭 누르면 멤버 불러오기
	@ResponseBody
	@RequestMapping("memberList")
	public List<Map<String, Object>> memberList(HttpServletRequest request, @RequestParam(value="content", required = false) String content, Map<String, Object> grpMap, Model model){
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		String grp = (String)session.getAttribute("grp");
		
		//1. 그룹이 있는 프로젝트인지 아닌지
		List<Map<String, Object>> grpList = this.projectService.grpList(projId);
		int all = 0;
		int ungrp = 0;
		for(int i=0; i<grpList.size(); i++) {
			if(grpList.get(i).get("PMEM_GRP") == "전체") {
				all += 1;
			}
			if(grpList.get(i).get("PMEM_GRP") == "미정") {
				ungrp += 1;
			}
		}
		
		//2. 그룹 여부에 따라 멤버 리스트 가져오기
		List<Map<String, Object>> memberList = null;
		if((all == 1 && grpList.size() == 1) || (all == 1 && ungrp == 1 && grpList.size() == 2)) {
			//그룹이 없음
			grpMap.put("projId", projId);
			grpMap.put("grp", grp);
			
			//전체 멤버 리스트 가져오기
			memberList = this.projectService.pmemGrpList(grpMap);
		}else {
			//그룹이 있음
			grpMap.put("projId", projId);
			grpMap.put("content", "");

			//전체 멤버 리스트 가져오기
			memberList = this.projectService.projMember(grpMap);
		}
		log.info("   프로젝트 멤버 탭 누르면 멤버 불러오기     memberList : {}", memberList);
		
		model.addAttribute("grpList", grpList);
		log.info("   프로젝트 멤버 탭 누르면 멤버 불러오기     grpList : {}", grpList);
		return memberList;
	}
	
	//전체 프로젝트 멤버 불러오기
	@ResponseBody
	@PostMapping("pmemAllList")
	public List<Map<String, Object>> pmemAllList(HttpServletRequest request, @RequestParam(value="content", required = false) String content){
		
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		if(content != null) {
			map.put("content", content);
		}else {
			map.put("content", "");
		}
		
		return this.projectService.projMember(map);
	}
	
	//그룹별 프로젝트 멤버 불러오기
	@ResponseBody
	@PostMapping("pmemGrpList")
	public List<Map<String, Object>> pmemGrpList(@RequestBody Map<String, Object> map, HttpServletRequest request){
		
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		log.info("      pmemGrpList의 map : " + map);
		map.put("projId", projId);
		
		log.info("         그룹별 멤버 불러오려고 보내는 매개변수 값 map : " + map);
		
		List<SubprojectVO> getGrpList = this.subpService.getGrpList(projId);
		session.setAttribute("getGrpList", getGrpList);
		
		return this.projectService.pmemGrpList(map);
	}
	
	
	//초대장 발송
	@ResponseBody
	@PostMapping("/invitation")
	public int invitation(@RequestBody Map<String, Object> map){
		//{"email" : emails1[i], "name" : name, "ttl" : ttl,
		// "projId" : projId, "pmemGrp" : groups1[i], "projCn" : projCn}
		log.info("     초대하기 map : " + map);
		
		ProMemVO pvo = new ProMemVO();
		pvo.setProjId((int)map.get("projId"));
		pvo.setMemId((String)map.get("email"));
		log.info("     회원인지 확인할 pvo : " + pvo);

		int result = this.promemService.isAlreadyMem(pvo);
		log.info("     회원인가? result : " + result);
		
		if(result == 0) {//회원이 아님
//			this.mailService.invitationForm(map);
		}
		
		return result;
	}
	
	//멤버 추방
	@ResponseBody
	@PostMapping("kickOut")
	public int kickOut(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		map.put("projId", projId);
		log.info("       추방할 회원 파라미터 : " + map);
		
		//맴버 추방시 알림
		String receiver = this.promemService.getProjAdmin(projId);
		Map<String, Object> projmap = this.projectService.projInfo(projId);
		Map<String, Object> alertmap = new HashMap<String, Object>();
		alertmap.put("memNo", map.get("memNo"));
		alertmap.put("altCn", projmap.get("PROJ_TTL")+" 프로젝트에서 탈퇴하였습니다");
		alertmap.put("altSend", receiver);
		alertmap.put("altLink", "");
		log.info("     추방 시 알림 : {}", alertmap);
		this.alertService.alertInsert(alertmap);
		
		return this.projectService.kickOut(map);
	}
	
	
	//////////////////////////////////////////////대시보드 /////////////////////////////////////////////////
	

	//프로젝트 대시보드(프로젝트 메인)
	@RequestMapping("/projMain/{projId}/{grp}")
	public ModelAndView main(@PathVariable("projId") int projId, @PathVariable("grp") String grp, ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", grp);
		log.info("           projId : " + projId);
		
		//개설된 프로젝트 aside에 출력하기 위해 세션에 저장
		List<Map<String, Object>> projLogo = this.projectService.projLogo((String)session.getAttribute("memNo"));
		log.info("projLogo               : " + projLogo);
		session.setAttribute("projLogo", projLogo);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("grp", grp);
		map.put("memNo", session.getAttribute("memNo"));
		log.info("   대시보드 값 가져오는 파라미터 map : " + map);
		
		ProMemVO vo = new ProMemVO();
		vo.setProjId(projId);
		vo.setMemNo((String)session.getAttribute("memNo"));
		
		ProMemVO amIPM = this.promemService.iAmPm(vo);
		int pm = 0;
		if(amIPM != null) pm = amIPM.getPm();
		
		log.info("           난 pm인가? : " + pm);
		vo.setPm(pm);
		session.setAttribute("iamPM", vo);
		log.info("           난 pm인가?vo : " + vo);

		//프로젝트 기본 정보(개설 시 입력한 정보들)
		Map<String, Object> projVO = this.projectService.projMain(map);
		session.setAttribute("projVO", projVO);
		log.info("           projVO : " + projVO);
		if(projVO != null) {
			mav.addObject("projVO", projVO);
			mav.addObject("grp", grp);
		}
		
		
		//프로젝트 진척도 -----------------------------------------------------------------------
		Map<String, Object> process = this.projectService.process(map);
		log.info("           process : " + process);
		if(process != null && process.size() > 0) {
			mav.addObject("process", process);
		}

		
		//역할 파이 차트 -----------------------------------------------------------------------
		//그룹 있는 프로젝트에서 전체를 들어가는 건지 아닌지
//		Map<String, Object> grpMap = new HashMap<String, Object>();
//		grpMap.put("projId", projId);
//		grpMap.put("memNo", (String)session.getAttribute("memNo"));
//		log.info("        grpmap : " + grpMap);
//		List<Map<String, Object>> projOnList = new ArrayList<Map<String,Object>>();
//		projOnList = this.projectService.projOnList(grpMap);
//		log.info("        projOnList : " + projOnList);
//		
//		grpMap.remove("memNo");
//		grpMap.put("pmemGrp", grp);
//
//		MainVO mvo = new MainVO();
//		if(grp.equals("전체") && Integer.parseInt(String.valueOf(projOnList.get(0).get("group"))) == 1) {
//			mvo = this.projectService.allRoleStatus(projId);
//			log.info("       그룹 있는데 전체적으로 보는 mvo : " + mvo);
//		}else {
//			mvo = this.projectService.roleStatus(grpMap);
//			log.info("       롤롤롤 mvo : " + mvo);
//		}
//		if(mvo != null) {
//			mav.addObject("role", mvo);
//		}
		
		
		//로드맵 -----------------------------------------------------------------------
		List<Map<String, Object>> roadmap = this.projectService.roadmap(projId);
		log.info("           roadmap : " + roadmap);
		if(roadmap != null && roadmap.size() > 0) {
			mav.addObject("roadmap", roadmap);
		}

		
		//일감 최근 5개 -----------------------------------------------------------------------
		log.info("           map : " + map);
		
		map.remove("memNo");
		List<Map<String, Object>> taskList = this.projectService.mainTask(map);
		
		if(taskList != null && taskList.size() > 0) {
			log.info("      가져온 taskList : " + taskList.get(0));
			mav.addObject("taskList", taskList);
		}
		
		
		//이슈 최근 5개 -----------------------------------------------------------------------
		List<Map<String, Object>> issueList = this.projectService.mainIssue(map);
		
		if(issueList != null && issueList.size() > 0) {
			log.info("      가져온 issueList : " + issueList.get(0));
			mav.addObject("issueList", issueList);
		}
		
		
		//공지사항 최근 5개 -----------------------------------------------------------------------
		List<Map<String, Object>> noticeList = this.projectService.mainNotice(map);
		log.info("      가져온 noticeList : " + noticeList);
		
		if(noticeList != null && noticeList.size() > 0) {
			mav.addObject("noticeList", noticeList);
		}
		
		
		//일정 최근 4개 -----------------------------------------------------------------------
		List<Map<String, Object>> mainCalendar = this.projectService.mainCalendar(map);
		
		log.info("      가져온 mainCalendar : " + mainCalendar);
		
		if(mainCalendar != null && mainCalendar.size() > 0) {
			mav.addObject("mainCalendar", mainCalendar);
		}
		
		
		//게시글 최근 5개 -----------------------------------------------------------------------
		//헬프
		List<Map<String, Object>> helpList = this.projectService.mainBrdHelp(map);
		log.info("      가져온 helpList : " + helpList);
		
		if(helpList != null && helpList.size() > 0) {
			mav.addObject("helpList", helpList);
		}
		//자유
		List<Map<String, Object>> freeList = this.projectService.mainBrdFree(map);
		log.info("      가져온 freeList : " + freeList);
		
		if(freeList != null && freeList.size() > 0) {
			mav.addObject("freeList", freeList);
		}
		
		
		//문서 최근 6개 -----------------------------------------------------------------------
		List<Map<String, Object>> mainDoc = this.projectService.mainDoc(map);
		
		log.info("      가져온 mainDoc : " + mainDoc);
		
		if(mainDoc != null && mainDoc.size() > 0) {
			mav.addObject("mainDoc", mainDoc);
		}
		
		//위키 최근 6개 -----------------------------------------------------------------------
		List<Map<String, Object>> mainWiki = this.projectService.mainWiki(projId);
		
		log.info("      가져온 mainWiki : " + mainWiki);
		
		if(mainWiki != null && mainWiki.size() > 0) {
			mav.addObject("mainWiki", mainWiki);
		}
		
		
		
		
		
		mav.setViewName("project/projMain");
		return mav;
	}
	
	//진행중인 프로젝트 리스트 조회
	@GetMapping("/projingList")
	public String projingList(ProjectVO projectVO, Model model 
				,@RequestParam(value = "cont", defaultValue = "") String cont,@RequestParam(value = "listcnt", defaultValue = "1") String listcnt) {
		projectVO.setScon(cont);
		projectVO.setListcnt(Integer.parseInt(listcnt)*8);
		List<ProjectVO> projectVOList = this.projectService.projIngList(projectVO);
		String scon = projectVO.getScon();
		model.addAttribute("scon", scon);
		model.addAttribute("projectVOList", projectVOList);
		model.addAttribute("listcnt",Integer.parseInt(listcnt));
		
		return "mypage/projingList";
	}
	
	//a마감 프로젝트 리스트 조회
	@GetMapping("/projEndList")
	public String projEndList(ProjectVO projectVO, Model model ,@RequestParam(value = "cont", defaultValue = "") String cont) {
		projectVO.setScon(cont);
		List<ProjectVO> projectVOList = this.projectService.projEndList(projectVO);
		String scon = projectVO.getScon();
		model.addAttribute("scon", scon);
		model.addAttribute("projectVOList", projectVOList);
		
		return "mypage/projEndList";
	}
	
	//초대받은 프로젝트 리스트 조회
	@GetMapping("/inviteProjectList")
	public String inviteProjectList(String memNo, Model model) {
		List<ProjectVO> projectVOList = this.projectService.inviteProjectList(memNo);
		model.addAttribute("projectVOList", projectVOList);
		
		
		return "mypage/inviteProjectList";
	}
	
	//초대 수락
	@GetMapping("/inviteYes")
	public String inviteYes(int pmemCd, String memNo) {
		this.projectService.inviteYes(pmemCd);
		
		return "redirect:/project/inviteProjectList?memNo="+memNo;
	}
	
	//초대 거절
	@GetMapping("/inviteNo")
	public String inviteNo(int pmemCd, String memNo) {
		this.projectService.inviteNo(pmemCd);
		
		return "redirect:/project/inviteProjectList?memNo="+memNo;
	}
	
	//promem에는 있는데 profile에는 없을 때 해당 회원을 profile에 넣어줍니다
	@ResponseBody
	@PostMapping("/syncPromemProfile")
	public int syncPromemProfile(@RequestBody Map<String,String> map) {
		log.info("map : " + map);
		log.info("projId : " + map.get("projId"));
		
		String projId = map.get("projId");
		
		int result = this.projectService.syncPromemProfile(projId);
		
		return result;
	}
}

