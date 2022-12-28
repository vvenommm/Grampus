package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.InvitationService;
import kr.or.ddit.vo.InvitationVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/invite")
@Controller
public class InvitationController {

	@Autowired
	InvitationService invitationService;
	
	@Autowired
	MailSendService mailService;
	
	@ResponseBody
	@RequestMapping("/inviChk")
	public InvitationVO inviChk(@RequestBody InvitationVO ivo) {
		log.info("     초대장 이미 보냈었나 확인할 값 " + ivo);
		//invEmail, projId, invCd, pmemGrp
		ivo = this.invitationService.inviChk(ivo);
		return ivo;
	}

//	@ResponseBody
//	@RequestMapping("/invitation")
//	public InvitationVO invitation(@RequestBody InvitationVO ivo) {
//		log.info("     (이미 회원이고) 초대장 처음 보낼 떄 " + ivo);
//		/*
//		 * data = { "invEmail" : emails1[i],
//					"invCd" : ranKey, -> 이건 여기 메소드에서
//					"projId" : projId,
//					"pmemGrp" : groups1[i]
//					};
//		 */
//		boolean flag = true;
//		String ranKey;
//		//랜덤 키 중복 검사
//		while(flag) {
//			ranKey = this.mailService.getKey(10);
//			ivo.setInvCd(ranKey);
//			log.info("      invCdChk에 보낼 ivo : " + ivo);
//			InvitationVO v = this.invitationService.inviCdChk(ivo);
//			log.info("      invCdChk의 결과값 ivo : " + ivo);
//			log.info("      invCdChk의 결과로 while 끝내는 InvitationVO : " + v);
//			if(v == null) { //rankey 중복 아니라 보내도 되니 while 끝내기
//				flag = false;
//			}
//		}
//
//		//초대장 insert
//		this.invitationService.inviSend(ivo);
//		return ivo;
//	}

	@ResponseBody
	@RequestMapping("/invitation")
	public int invitation(@RequestBody Map<String, Object> info, HttpServletRequest request, InvitationVO ivo, MemberVO mvo) {
		//세션에서 가져올 값 : projId 
		log.info("          뭐가 넘어왔나요? : " + info);
		ivo.setProjCn((String)info.get("projCn"));
		ivo.setTtl((String)info.get("ttl"));
		
		List<Object> emailArr1 = (List<Object>)info.get("emailArr1");
		List<Object> emailArr2 = (List<Object>)info.get("emailArr2");
		List<Object> groupsArr1 = (List<Object>)info.get("groupsArr1");
		List<Object> groupsArr2 = (List<Object>)info.get("groupsArr2");
		
		log.info("     emailArr1 : {}", emailArr1);
		log.info("     emailArr2 : {}", emailArr2);
		log.info("     groupsArr1 : {}", groupsArr1);
		log.info("     groupsArr2 : {}", groupsArr2);
		
		HttpSession session = request.getSession();
		mvo = (MemberVO)session.getAttribute("loginVO");
		ivo.setProjId((int)session.getAttribute("projId"));
		ivo.setMemNo((String)session.getAttribute("memNo"));
		ivo.setMemNm(mvo.getMemNm());
		
		Map<String, Object> inviList = new HashMap<String, Object>();
		if(info.get("emailArr1") != null && info.get("groupsArr1") != null) {
			for(int i = 0; i < emailArr1.size(); i++) {
				ivo.setInvEmail((String)emailArr1.get(i));
				ivo.setPmemGrp((String)groupsArr1.get(i));
				log.info(" 누굴 초대하나요? ivo : {}", ivo);
				
				this.invitationService.invitation(ivo);
			}
		}
		
		if(info.get("emailArr2") != null && info.get("groupsArr2") != null) {
			for(int i = 0; i < emailArr2.size(); i++) {
				ivo.setInvEmail((String)emailArr2.get(i));
				ivo.setPmemGrp((String)groupsArr2.get(i));
				log.info(" 누굴 초대하나요? ivo : {}", ivo);

				this.invitationService.invitation(ivo);
			}
		}
		
		
		return 1;
	}
	
	@ResponseBody
	@RequestMapping("/inviUpdate")
	public InvitationVO inviUpdate(@RequestBody InvitationVO ivo) {
		log.info("     초대장 이미 보냈으니 rankey만 update " + ivo);
		//invEmail, projId, pmemGrp
		
		boolean flag = true;
		String ranKey;
		//랜덤 키 중복 검사
		while(flag) {
			ranKey = this.mailService.getKey(10);
			ivo.setInvCd(ranKey);
			log.info("      invCdChk에 보낼 ivo : " + ivo);
			InvitationVO v = this.invitationService.inviCdChk(ivo);
			log.info("      invCdChk의 결과값 ivo : " + ivo);
			log.info("      invCdChk의 결과로 while 끝내는 InvitationVO : " + v);
			if(v == null) { //rankey 중복 아니라 보내도 되니 while 끝내기
				flag = false;
			}
		}
		
		this.invitationService.invCdUp(ivo);
		
		return ivo;
	}
	
	@ResponseBody
	@RequestMapping("/sendEmail")
	public int sendEmail(@RequestBody InvitationVO ivo, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		map.put("projId", projId);

		MemberVO mvo = (MemberVO)session.getAttribute("loginVO");
		String name = mvo.getMemNm();
		map.put("name", name);
		
		
		map.put("email", ivo.getInvEmail());
		map.put("ttl", ivo.getTtl());
		map.put("projCn", ivo.getProjCn());
//		map.put("ranKey", ivo.getRanKey());
		map.put("pmemGrp", ivo.getPmemGrp());
		
//		this.mailService.invitationForm(map);
		
		return 1;
	}
	
	
	
}
