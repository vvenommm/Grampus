package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.InvitationService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.SubprojectService;
import kr.or.ddit.vo.InvitationVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.SubprojectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/promem")
@Controller
public class ProMemController {
	@Autowired
	ProMemService proMemService;
	
	@Autowired
	ProfileService profService;
	
	@Autowired
	InvitationService inviService;
	
	@Autowired
	ProjectService projectService;
	
	@Autowired
	AlertService alertService;
	
	@Autowired
	SubprojectService subpService;
	
	//프로젝트 생성시 관리자 등록
	@ResponseBody
	@PostMapping("/projAdmin")
	public int projAdmin(@RequestBody Map<String, Object> map) {
		int res = proMemService.projAdmin(map);
		return res;
	}
	
	//프로젝트 멤버 권한 변경
	@ResponseBody
	@RequestMapping("/updateRole")
	public int updateRole(@RequestBody ProMemVO vo) {
		//맴버 직책 부여 알림
		String roleName = "";
		if(vo.getRoleId().equals("R02")) {
			roleName += "PL";
		}else if(vo.getRoleId().equals("R03")) {
			roleName += "TA";
		}else if(vo.getRoleId().equals("R04")) {
			roleName += "AA";
		}else if(vo.getRoleId().equals("R05")) {
			roleName += "UA";
		}else if(vo.getRoleId().equals("R06")) {
			roleName += "DA";
		}
		String sender = this.proMemService.getProjAdmin(vo.getProjId());
		Map<String, Object> projInfo = this.projectService.projInfo(vo.getProjId());
		Map<String, Object> alertmap = new HashMap<String, Object>();
		alertmap.put("memNo", vo.getMemNo());
		alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+vo.getPmemGrp()+" 그룹에서 "+roleName+" 직책을 부여 받았습니다");
		alertmap.put("altSend", sender);
		alertmap.put("altLink", "/project/projMain/"+vo.getProjId()+"/"+vo.getPmemGrp());
		this.alertService.alertInsert(alertmap);
		
		return this.proMemService.updateRole(vo);
	}

	
	
	//초대장 보낼 때 이미 참여 중인 회원인지?
	@ResponseBody
	@RequestMapping("/isAlreadyMem")
	public int isAlreadyMem(@RequestBody ProMemVO pvo) {
		log.info("     초대장 보낼 때 이미 참여 중인지? projId, memId필요 : " + pvo);
		int result = this.proMemService.isAlreadyMem(pvo);
		return result;
	}
	
	//초대장 보낼 때 바로 promem에 insert
	@ResponseBody
	@RequestMapping("/joinProjfromInvi")
	public int joinProjfromInvi(@RequestBody ProMemVO pvo) {
		log.info("      초대장 보내고 promem에 넣을 vo : " + pvo);
		int result = this.proMemService.joinProjfromInvi(pvo);
		log.info("         promem에 insert 됐나? : " + result);
		return result;
	}
	
	
	//초대장 수락/거절 시 promem 테이블에 insert
	@ResponseBody
	@RequestMapping("/RSVP")
	public InvitationVO rsvp(@RequestBody ProMemVO pvo, HttpServletRequest request) {
		log.info("      초대장 알림함에서 응답한 vo : " + pvo);
		
		InvitationVO ivo = new InvitationVO();
		ivo.setMemNo(pvo.getMemNo());
		ivo.setProjId(pvo.getProjId());
		ivo.setPmemGrp(pvo.getPmemGrp());
		ivo.setInvCd(pvo.getInvCd());
		
		InvitationVO expiredIVO = this.inviService.isitExpired(ivo);
		if(expiredIVO == null) {
			ivo.setExpire(0);
			return ivo;
		}else {
			ivo.setExpire(1);
		
			//promem에 insert
			int result = this.proMemService.joinProjfromInvi(pvo);
			
			if(result > 0 && pvo.getPmemRsvp().equals("Y")) { //성공 시
				//수락한거니까 프로필 추가
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("memNo", pvo.getMemNo());
				map.put("projId", pvo.getProjId());
				map.put("profNm", pvo.getMemNm());
				
				result = this.profService.jobAprvInsert(map);
				
				
				//초대수락하면 관리자에게 알림
				Map<String, Object> projInfo = this.projectService.projInfo(pvo.getProjId());
				String receiver = this.proMemService.getProjAdmin(pvo.getProjId());
				Map<String, Object> alertmap = new HashMap<String, Object>();
				alertmap.put("memNo", receiver);
				alertmap.put("altCn", pvo.getMemNm()+" 님이 "+projInfo.get("PROJ_TTL")+" 프로젝트 초대를 수락했습니다");
				alertmap.put("altSend", pvo.getMemNo());
				alertmap.put("altLink", "/project/projectSetting/"+pvo.getProjId()+"/전체");
				this.alertService.alertInsert(alertmap);
			}
			
			//invitation 테이블에서 삭제
			result = this.inviService.inviDel(ivo);
			
			//참여한 프로젝트도 세션에 저장돼서 aside에 나오게
			// 현재 진행 중이고 내가 참여하는 프로젝트 중 로고 뽑아오기
			HttpSession session = request.getSession();
			MemberVO mvo = (MemberVO)session.getAttribute("loginVO");
			List<Map<String, Object>> projLogo = this.projectService.projLogo(mvo.getMemNo());
			if (projLogo != null && projLogo.size() > 0) {
				for (int i = 0; i < projLogo.size(); i++) {
					log.info("             현재 진행 중이고 내가 참여하는 프로젝트 중 로고 뽑아오기 projLogo" + projLogo.get(i));
				}
	
				session.setAttribute("projLogo", projLogo);
			}
			return ivo;
		}
	}
	

	//그룹 추가하면서 pm을 해당 그룹에 배정하는 insert
	@ResponseBody
	@RequestMapping("newGrp")
	public ProMemVO newGrp(@RequestBody ProMemVO pvo, HttpServletRequest request, Model model) {
		log.info("      그룹 추가할 때 promem에 넣을 vo(pm 정보) : " + pvo);
		HttpSession session = request.getSession();
		MemberVO mvo = (MemberVO)session.getAttribute("loginVO");
		pvo.setMemNo(mvo.getMemNo());

		int result = this.proMemService.newGrp(pvo);
		if(result > 0) {
			pvo = this.proMemService.newGrpSelect(pvo);
			log.info("      새로 생긴 그룹의 멤버 가져오기 : " + pvo);
			
			//subproj 테이블에 그룹 추가하기
			SubprojectVO spvo = new SubprojectVO();
			spvo.setProjId(pvo.getProjId());

			List<SubprojectVO> getGrpList = (List<SubprojectVO>)session.getAttribute("getGrpList");
			if(getGrpList == null) {
				//미정은 그룹이 없는데 처음 만들었을 때에만! 기존에 그룹 있는데 추가한 경우에는 미정 없음
				spvo.setSprojTtl("미정");
				this.subpService.addGrp(spvo);
				
				spvo.setSprojTtl("전체");
				this.subpService.addGrp(spvo);
				
				//그룹이 '전체'였던 멤버들 '미정'으로 바꾸기
				this.proMemService.grpToUngrp(pvo.getProjId());
			}

			//추가한 그룹명 insert
			spvo.setSprojTtl(pvo.getPmemGrp());
			this.subpService.addGrp(spvo);
			
			//그룹 리스트 다시 뽑아서 보내기
			getGrpList = this.subpService.getGrpList(pvo.getProjId());
			session.setAttribute("getGrpList", getGrpList);
			session.setAttribute("yesGrp", 1);
		}
		
		return pvo;
	}
	
	
	//그룹 생성 후 참여 중인 멤버 그룹 배정하기
	@ResponseBody
	@RequestMapping("newMemIntoGrp")
	public ProMemVO newMemIntoGrp(@RequestBody ProMemVO pvo, HttpServletRequest request) {
		log.info("      참여 멤버 그룹 배정 - jsp에서 넘긴 vo : " + pvo);
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		pvo.setProjId(projId);
		log.info("      참여 멤버 그룹 배정 - jsp에서 넘긴 vo : " + pvo);
		
		int result = this.proMemService.newMemIntoGrp(pvo); //promem에 isnert
		if(result > 0) {
			pvo = this.proMemService.afterNewMem(pvo);
			pvo.setCnt(result);
		}
	
		return pvo;
	}
	
	//그룹에서 내보내기
	@ResponseBody
	@RequestMapping("getOutFromGrp")
	public int getOutFromGrp(@RequestBody ProMemVO pvo, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		pvo.setProjId(projId);
		
		int result = this.proMemService.getOutFromGrp(pvo);
		
		//그룹에서 탈퇴 시 알림
		String sender = this.proMemService.getProjAdmin(projId);
		Map<String, Object> projInfo = this.projectService.projInfo(projId);
		Map<String, Object> alertmap = new HashMap<String, Object>();
		alertmap.put("memNo", pvo.getMemNo());
		alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+pvo.getPmemGrp()+" 그룹에서 탈퇴했습니다");
		alertmap.put("altSend", sender);
		alertmap.put("altLink", "");
		this.alertService.alertInsert(alertmap);
				
		return result;
	}
	
	//프로젝트 그룹 맴버 검색
	@ResponseBody
	@PostMapping("/projGrpSearch")
	public List<Map<String, Object>> projGrpSearch(@RequestBody Map<String, Object> map){
		List<Map<String, Object>> list = this.proMemService.projGrpSearch(map);
		return list;
	}
	
	//그룹 없는 멤버 미정에서 그룹 배정하기
	@ResponseBody
	@RequestMapping("ungrpToGrp")
	public int ungrpToGrp(@RequestBody ProMemVO pvo, HttpServletRequest request) {
		//pvo : 새그룹명(newPmemGrp), pmemNo //// rojId(여기서 넣기), 기존그룹명pmemGrp = 미정(여기서 넣기)
		log.info("        pvo : " + pvo);
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		pvo.setPmemGrp("미정");
		pvo.setProjId(projId);
		
		int result = this.proMemService.ungrpToGrp(pvo);
		
		//미정 이제 없으면 subproj에서 미정 없애기
		int cnt = this.proMemService.isThereUngrp(projId);
		if(cnt == 0) {
			this.subpService.delUngrp(projId);
			this.subpService.delUngrp2(projId);
		}
		
		return result;
	}
	
}
