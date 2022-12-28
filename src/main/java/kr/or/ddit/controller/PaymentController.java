package kr.or.ddit.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.PaymentService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.vo.PaymentVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PaymentController {

	@Autowired
	PaymentService paymentService;
	
	@Autowired
	ProjectService projectService;
	
	//1. 결제
	@ResponseBody
	@PostMapping("/paying")
	public int pay(@RequestBody Map<String, Object> map, Model model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String memNo = (String) session.getAttribute("memNo");
		
		log.info("                      pay/paying의 map : " + map);

		//pay 쿼리에 전달할 paymentVO
		PaymentVO payVo = new PaymentVO();
		payVo.setMemNo(memNo);
		payVo.setPlanId((int)map.get("planId"));
		
		//결제되면 payment테이블 insert
		int result = this.paymentService.pay(payVo);
		log.info("                      pay/paying의 payVo : " + payVo);
		log.info("                  결제 insert한 결과 result : " + result);
		
		ProjectVO pvo = new ProjectVO();
		pvo.setPayNo(payVo.getPayNo());
		pvo.setPlanTtl((String)map.get("planTtl"));
		pvo.setProjId((int)map.get("projId"));
		result += this.projectService.updatePayNo(pvo);
		log.info("                      payno 프로젝트에 없데이트할 값 pvo : " + pvo);
		log.info("                  결제번호 update한 결과 result : " + result);
		
		return result;
	}
	
	//2. 결제 완료 후 페이지
	@GetMapping("/paymentResult")
	public String paymentResult(Model model, int projId) {
		
		PaymentVO paymentVOHistory = this.paymentService.paymentHistory(projId);
		log.info("paymentVOHistory : " + paymentVOHistory);
		model.addAttribute("paymentVOHistory", paymentVOHistory);
		
		return "paymentResult";
	}
	
	//프로젝트별 결제 리스트 
	@GetMapping("/paymentHistory")
	public String paymentHistory(Model model,int projId) {
		
		PaymentVO paymentVOHistory = this.paymentService.paymentHistory(projId);
		log.info("paymentVOHistory : " + paymentVOHistory);
		model.addAttribute("paymentVOHistory", paymentVOHistory);
		
		return "payment/paymentHistory";
	}
	
	//플랜변경
//	@PostMapping("/planUpdate")
//	public String planUpdate(PaymentVO paymentVO) {
//		//insert된 payment를 가져와야됌
//		
//		int planUpdateResult = this.paymentService.planUpdate(paymentVO);
//		log.info("planUpdateResult : " + planUpdateResult);
//		
//		return "redirect:/plan/plan";
//	}
}
