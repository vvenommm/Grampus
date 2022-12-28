package kr.or.ddit.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.service.BoardService;
import kr.or.ddit.service.FAQService;
import kr.or.ddit.service.QNAService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FAQVO;
import kr.or.ddit.vo.QNAVO;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@Controller
public class CenterController {
	
	@Inject
	FAQService faqService;
	
	@Inject
	QNAService qnaService;
	
	//FAQ목록, QNA목록 조회
	@GetMapping("/faqList")
	public String faqList(String faqNo, Model model,
			@RequestParam(value = "cont", defaultValue = "") String cont, 
			@RequestParam(value = "listcnt", defaultValue = "1") String listcnt) throws ParseException {
		
		List<FAQVO> faqVOList = new ArrayList<FAQVO>();
		faqVOList = this.faqService.faqList();
		model.addAttribute("faqVOList", faqVOList);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listcnt", Integer.parseInt(listcnt)*5);
		map.put("scon", cont);
		String scon = (String) map.get("scon");
		model.addAttribute("scon", scon);
		
		List<QNAVO> qnaVOList = new ArrayList<QNAVO>();
		qnaVOList = this.qnaService.qnaList(map);
		
		model.addAttribute("qnaVOList", qnaVOList);
		model.addAttribute("listcnt",Integer.parseInt(listcnt));
		return "faqList";
	}
	
	
	//FAQ상세 조회
	@GetMapping("/faqDetail")
	public String faqDetail(String faqNo, Model model) {
		log.info("faqNo : " + faqNo);
		
		FAQVO faqVO = this.faqService.faqDetail(faqNo);
		
		model.addAttribute("faqVO", faqVO);
		
		return "redirect:/faqList";
	}
	
	//FAQ 작성하기
	@GetMapping("/faqWrite")
	public String faqWrite(@ModelAttribute FAQVO faqVO) {
		log.info("faqVO : " + faqVO.toString());
		
		return "faqWrite";
	}
	
	@PostMapping("/faqWritePost")
	public String faqWritePost(@Validated FAQVO faqVO) {
		
		int faqInsert = this.faqService.faqInsert(faqVO);
		
		log.info("faqVO : " + faqVO.getFaqCn());
		log.info("faqInsert : " + faqInsert);
		
		return "redirect:/faqList";
	}
	
	//QNA상세 조회
	@GetMapping("/qnaDetail")
	public String qnaDetail(String qnaNo, Model model) {
		log.info("qnaNo : " + qnaNo);
		
		QNAVO qnaVO = this.qnaService.qnaDetail(qnaNo);
		
		model.addAttribute("qnaVO", qnaVO);
		
		return "qnaDetail";
		
	}

	//QNA 작성하기
	@GetMapping("/qnaWrite")
	public String qnaWrite(@ModelAttribute QNAVO qnaVO) {
		log.info("qnaVO : " + qnaVO);
		
		return "qnaWrite";
	}
	
	@PostMapping("/qnaWritePost")
	public String qnaWritePost(@Validated QNAVO qnaVO) {
		
		log.info("qnaVO : " + qnaVO);
		int qnaInsert = this.qnaService.qnaInsert(qnaVO);
		
		log.info("qnaInsert : " + qnaInsert);
		
		return "redirect:/faqList";
	}
	
	//QNA 수정하기
	@PostMapping("/qnaUpdate")
	public String qnaUpdate(QNAVO qnaVO) {
		log.info("memNo : " + qnaVO.getMemNo());
		log.info("qnaNo : " + qnaVO.getQnaNo());
		log.info("qnaCn : " + qnaVO.getQnaCn());
		
		int qnaUpdate = this.qnaService.qnaUpdate(qnaVO);
		log.info("qnaUpdate : " + qnaUpdate);
		
		return "redirect:/faqList";
	}
	
	//QNA 삭제하기
	@PostMapping("/qnaDelete")
	public String qnaDelete(String qnaNo) {
		int qnaDelete = this.qnaService.qnaDelete(qnaNo);
		
		log.info("qnaDelete : " + qnaDelete);
		
		return "redirect:/faqList";
	}
	
	//QNA 댓글 등록
	@PostMapping("/qnaReply")
	public String qnaReply(QNAVO qnaVO) {
		log.info("qnaReply : " + qnaVO.toString());
		
		int qnaReply = this.qnaService.qnaReply(qnaVO);
		log.info("qnaReply : " + qnaReply);
		
		return "redirect:/faqList"; //해당 번호로 이동하는 것 구현하기
		
	}
	
	//QNA 댓글 수정
	@PostMapping("/qnaReplyUpdate")
	public String qnaReplyUpdate(QNAVO qnaVO) {
		log.info("qnaReplyUpdate : " + qnaVO.getQnaReply());
		
		int qnaReplyUpdate = this.qnaService.qnaReply(qnaVO);
		log.info("qnaReplyUpdate : " + qnaReplyUpdate);
		
		return "redirect:/faqList"; //해당 번호로 이동하는 것 구현하기
		
	}
	
	//QNA 댓글 삭제
	@PostMapping("/qnaReplyDelete")
	public String qnaReplyDelete(QNAVO qnaVO) {
		log.info("qnaReplyDelete : " + qnaVO.getQnaReply());
		
		int qnaReplyDelete = this.qnaService.qnaReplyDelete(qnaVO);
		log.info("qnaReplyDelete : " + qnaReplyDelete);
		
		return "redirect:/faqList"; //해당 번호로 이동하는 것 구현하기
		
	}
	
}
