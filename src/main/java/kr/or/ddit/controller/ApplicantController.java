package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.ApplicantService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.SubprojectService;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.SubprojectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/applicant")
@Controller
public class ApplicantController {
	@Autowired
	ApplicantService applicantService;
	@Autowired
	ProfileService profileService;
	@Inject
	SubprojectService subpService;
	@Inject
	ProjectService projectService;
	@Inject
	ProMemService proMemService;
	@Inject
	AlertService alertService;
	
	//지원자 등록 - jobDetail.jsp
	@ResponseBody
	@GetMapping("/appliInsert")
	public Map<String, Object> appliInset(@RequestParam String projId, HttpServletRequest request) {
		//id 세션값으로
		HttpSession session = request.getSession();
		String id  = (String)session.getAttribute("id");
//		String id = "java@ddit.or.kr";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		
		log.info("   공고 프젝id : {} / 지원한 사람id : {} " , projId, id);

		Map<String, Object> prof = new HashMap<String, Object>();
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		prof.put("projId", projId);
		prof.put("memNo", vo.getMemNo());
		prof.put("profNm", vo.getMemNm());
		map.put("memNo", vo.getMemNo());
		log.info("   쿼리에 보내는 맵 : {} " , map.toString());
		
		int res = 0;
		int slt = 0;
		
		//이미 프로젝트 회원인지?
		int promemChk = this.applicantService.promemChk(map);
		log.info("         promemChk : " + promemChk);
		map.put("promemChk", promemChk);
		
		if(promemChk == 0) {//프로젝트 회원이 아님 (0이면 통과)

			res = applicantService.appliChk(map); //이미 지원한 사람인지 확인하기
			
			if(res == 0) { //프로젝트 중복 지원이 아님. 첫 지원임
				int result = applicantService.appliInset(map); //지원자 테이블에 추가
				log.info("         appliInset : " + result);
				result = applicantService.appliCntUp(Integer.parseInt(projId)); //지원자 수 증가
				log.info("         appliCntUp : " + result);
				result = profileService.jobAprvInsert(prof); //프로필 테이블에 추가
				log.info("         jobAprvInsert : " + result);
				
				slt = 1;
				map.put("insert", slt);
				
				//구인공고 지원시 프로젝트 관리자에게 알림
				String receiver = this.proMemService.getProjAdmin(Integer.parseInt(projId));
				Map<String, Object> projInfo = this.projectService.projInfo(Integer.parseInt(projId));
				Map<String, Object> alertmap = new HashMap<String, Object>();
				alertmap.put("memNo", receiver);
				alertmap.put("altCn", projInfo.get("PROJ_TTL")+" 새로운 지원자가 있습니다");
				alertmap.put("altSend", vo.getMemNo());
				alertmap.put("altLink", "/project/projectSetting/"+projId+"/전체");
				this.alertService.alertInsert(alertmap);
			}
			map.put("promemChk", promemChk);
			map.put("res", res);
		}
		
		return map;
	}
	
	//지원자 업데이트 - projectSetting.jsp
	@ResponseBody
	@PostMapping("/appliUpdate")
	public int appliUpdate(@RequestBody Map<String, Object> map, HttpServletRequest request, Model model) {
		int res = 0;

		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		if(map.get("stat").equals("Y")) {
			applicantService.appliUpdate(map); //지원자 테이블에서 승인Y로
			
			//그룹 있으면 '미정'으로, 없으면 '전체'로
//			List<SubprojectVO> spvo = this.subpService.getGrpList((int)map.get("projId"));
//			int all = 0;
//			int ungrp = 0;
//			if(spvo != null && spvo.size() > 0) { //그룹이 있음
//				for(SubprojectVO vo : spvo) {
//					if(vo.getSprojTtl() == "미정") {
//						ungrp += 1;
//					}
//					if(vo.getSprojTtl() == "전체") {
//						all += 1;
//					}
//				}
//				
//				if(ungrp == 0) {
//					this.subpService.addUngrp((int)map.get("projId")); //subproject 테이블에 '미정' 그룹 추가하기
//				}
//				map.put("grp", "미정");
//				
//			}else { //그룹이 없음
//				map.put("grp", "전체");
//			}
			
			map.put("grp", "미정");
			map.put("stat", "J");
			res = applicantService.promemInsert(map); //promem 테이블에 상태 J로 삽입
			
			//구인공고 승인 시 대상자에게 알림
			String sender = this.proMemService.getProjAdmin(Integer.parseInt(String.valueOf(map.get("projId"))));
			Map<String, Object> projInfo = this.projectService.projInfo(Integer.parseInt(String.valueOf(map.get("projId"))));
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", map.get("memNo"));
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" 에 참여하게 되었습니다");
			alertmap.put("altSend", sender);
			alertmap.put("altLink", "/project/projectSetting/"+Integer.parseInt(String.valueOf(map.get("projId")))+"/전체");
			this.alertService.alertInsert(alertmap);
		}else { //"N"로 업데이트
			res = applicantService.appliUpdate(map);
		}
		
		
		return res;
	}
	
	//지원공고 리스트
	@GetMapping("/jobApplicantList")
	public String jobApplicantList(ApplicantVO applicantVO, Model model,@RequestParam(value = "cont", defaultValue = "") String cont) {
		applicantVO.setScon(cont);
		List<ApplicantVO> applicantVOList = applicantService.jobApplicantList(applicantVO);
		String scon = applicantVO.getScon();
		model.addAttribute("scon", scon);
		model.addAttribute("applicantVOList", applicantVOList);
		return "mypage/applicantList";
	}
	
	//지원공고 취소
	@GetMapping("/applicantDelete")
	public String applicantDelete(ApplicantVO applicantVO) {
		String memNo = applicantVO.getMemNo();
		int result = applicantService.applicantDelete(applicantVO);
		log.info("applicantVO : " + applicantVO.toString());
		log.info("result : " + result);
		
		//프로필도 삭제
		this.profileService.jobCancel(applicantVO);
		
		return "redirect:/applicant/jobApplicantList?memNo="+memNo;
	}
	


}
