package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.CostService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.vo.CostVO;
import kr.or.ddit.vo.MemberVO;

@RequestMapping("/cost")
@Controller
public class CostController {
	@Autowired
	CostService costService;
	@Autowired
	MemberService memService;
	
	//인건비 등록
	@ResponseBody
	@PostMapping("/createCost")
	public int createCost(@RequestBody ArrayList<Map<String, Object>> list, int id) {
		int res = 0;
		for(Map<String, Object> map : list) {
			map.put("id", id);
			res += costService.createCost(map);
		}
		return res;
	}
	
	//인건비 수정
	@ResponseBody
	@PostMapping("/costDelete")
	public int costDelete(@RequestBody ArrayList<Map<String, Object>> list, int id) {
		costService.costDelete(id);
		int res = 0;
		for(Map<String, Object> map : list) {
			map.put("id", id);
			res += costService.createCost(map);
		}
		return res;
	}
	//정산내역
	@GetMapping("/costList")
	public String costList(String memNo, Model model) {
		List<CostVO> costVOList = costService.costList(memNo);
		String lastCost = costService.lastMonthCost(memNo);
		String llastCost = costService.llastMonthCost(memNo);
		String thisCost = costService.thisMonthCost(memNo);
		MemberVO memberVO =  this.memService.memDetail(memNo);
		model.addAttribute("costVOList", costVOList);
		model.addAttribute("thisCost", thisCost);
		model.addAttribute("lastCost", lastCost);
		model.addAttribute("llastCost", llastCost);
		model.addAttribute("memberVO", memberVO);
		return "mypage/costList";
	}
	
}
