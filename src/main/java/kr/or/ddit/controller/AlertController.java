package kr.or.ddit.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import kr.or.ddit.service.InvitationService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.vo.AlertVO;
import kr.or.ddit.vo.InvitationVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@RequestMapping("/alert")
@Controller
public class AlertController {

	@Inject
	AlertService alertService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	InvitationService invitationService;
	
	//알림함 리스트 조회, 발신자별 리스트조회
	@GetMapping("/alertList")
	public String alertList(AlertVO alertVO, Model model) {
		List<AlertVO> alertVOList =  this.alertService.alertList(alertVO);
		model.addAttribute("alertVOList", alertVOList);
		
//		if(alertVO.getAltSend()!=null) {
//			List<AlertVO> alertSendVOList = this.alertService.alertSendList(alertVO);
//			model.addAttribute("alertSendVOList", alertSendVOList);
//			int cnt = this.alertService.updateSendStts(alertVO);
//			log.info("발신자별 알림 업뎃 cnt : " + cnt);
//		}
		
		return "mypage/alertList";
	}

	@GetMapping("/alertSendList")
	public String alertSendList(AlertVO alertVO, Model model) {
		log.info("alertVO : " + alertVO.toString());
		List<AlertVO> alertSendVOList = this.alertService.alertSendList(alertVO);
		model.addAttribute("alertSendVOList", alertSendVOList);
		int cnt = this.alertService.updateSendStts(alertVO);
		log.info("발신자별 알림 업뎃 cnt : " + cnt);
		
		return "mypage/alertSendList";
	}
	
	@ResponseBody
	@PostMapping("/alertDelete")
	public int alertDelete(@RequestParam int altNo) {
		int alertDelete = this.alertService.alertDelete(altNo);
		
		return alertDelete;
	}
	
	@ResponseBody
	@PostMapping("/alertCount")
	public int alertCount(@RequestParam String memNo) {
		int res = this.alertService.alertCount(memNo);
		return res;
	}
	
	@ResponseBody
	@PostMapping("/alertSelect")
	public List<Map<String, Object>> alertSelect(@RequestBody Map<String, Object> map) {
		List<Map<String, Object>> list = this.alertService.alertSelect(map);
		return list;
	}
	
	@ResponseBody
	@PostMapping("/alertCheck")
	public int alertCheck(@RequestParam int altNo) {
		int res = this.alertService.alertCheck(altNo);
		return res;
	}
	
	@ResponseBody
	@RequestMapping("/invitation")
	public int invitation(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		
		log.info("       알림함 초대장 (받는 사람 memNo, 초대프로젝트 ttl, ranKey, 프젝Id, 그룹" + map);
		/*
		 * data = { "memNo" : alertMemNo,
					"ttl" : ttl,
					"ranKey" : ranKey,
					"projId" : projId,
					"pmemGrp" : groups1[i]
					};
		 */
		String ranKey = (String)map.get("ranKey");
		String cn = String.format("<p id='ttl' data-ttl='%s'>[GRAMPUS] 초대장</p><p><%s>에서 초대장을 보냈습니다.</p>"
				+ "<p>프로젝트 상세 내용은 이메일로 확인해주세요.</p>"
				+ "<p id='invCd' data-invCd='%s'>인증 코드 : %s (유효기간 : 3일)</p>"
				+ "<button type='button' id='okBtn' class='btn btn-primary okBtn' data-projId='%d'>수락</button> "
				+ "<button type='button' id='noBtn' class='btn btn-danger noBtn' data-pmemGrp='%s'>거절</button>"
				,(String)map.get("ttl"), (String)map.get("ttl"), ranKey, ranKey, (int)map.get("projId"), (String)map.get("pmemGrp"));
		
		HttpSession session = request.getSession();
		String altSend = (String)session.getAttribute("memNo"); //보내는 사람
		
		AlertVO avo = new AlertVO();
		avo.setAltSend(altSend); //보내는 사람
		avo.setMemNo((String)map.get("memNo")); //받는 사람
		avo.setAltCn(cn); //내용
		avo.setAltLink("/alert/alertSendList?memNo="+(String)map.get("memNo")+"&altSend="+altSend);
		log.info("      avo 값 : " + avo);
		int result = this.alertService.invitation(avo);
		return result;
	}
	
}
