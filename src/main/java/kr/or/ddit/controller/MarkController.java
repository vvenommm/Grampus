package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.MarkService;

@RequestMapping("/mark")
@Controller
public class MarkController {
	@Autowired
	MarkService markService;
	
	//북마크 등록해제
	@ResponseBody
	@GetMapping("/chkMark")
	public int insertMark(@RequestParam String projId, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String id  = (String)session.getAttribute("id");
//		String id = "java@ddit.or.kr";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("memId", id);
		int chk = markService.markCheck(map);
		int res = 0;
		if(chk>0) {
			int slt1 = markService.deleteMark(map);
			if(slt1>0) {
				res = 2;
			}
		}else {
			int slt2 = markService.insertMark(map);
			if(slt2>0) {
				res = 1;
			}
		}
		return res;
	}
	
	//마이페이지 북마크 삭제
	@GetMapping("/deleteBookMark")
	public String deleteBookMark(int projId, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String memNo  = (String)session.getAttribute("memNo");
		
		this.markService.deleteBookMark(projId);
		
		return "redirect:/bookMarkList?memNo="+memNo;
	}
	
}
