package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.DocFileService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/docf")
public class DocFileController {
	@Autowired
	DocFileService docFileService;
	
	@PostMapping("/delFile")
	@ResponseBody
	public int delFile(@RequestBody int dcfNo) {
		int result = this.docFileService.delFile(dcfNo);
		return result;
	}
	
	
}
