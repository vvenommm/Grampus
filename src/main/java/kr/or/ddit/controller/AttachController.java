package kr.or.ddit.controller;


import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.inject.Inject;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.AttachService;
import kr.or.ddit.vo.AttachVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@RequestMapping("/attach")
@Controller
public class AttachController {
	
	@Inject
	AttachService attachService;
	
	//첨부파일 삭제하기
	@PostMapping("/attachDelete")
	public String attachDelete(AttachVO attachVO, int battNo) throws UnsupportedEncodingException {
		log.info("첨부파일 삭제 : " + attachVO.toString());

		log.info("battNo : " + battNo); 
		int attachDelete = this.attachService.attachDelete(battNo);
		
		log.info("attachDelete : " + attachDelete);
		
		return "redirect:/board/boardDetail?brdNo="+ attachVO.getBrdNo() + "&projId=" + attachVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(attachVO.getPmemGrp(), "UTF-8");
	}

}
