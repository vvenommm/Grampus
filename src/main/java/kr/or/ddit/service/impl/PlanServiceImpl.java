package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.PlanMapper;
import kr.or.ddit.service.PlanService;
import kr.or.ddit.vo.PlanVO;

@Service
public class PlanServiceImpl implements PlanService {
	
	@Autowired
	PlanMapper planMapper;

	//1. 플랜 조회
	@Override
	public List<Map<String, Object>> planList() {
		return this.planMapper.planList();
	}

	//2. 플랜 등록
	@Override
	public int insertPlan(PlanVO vo) {
		return this.planMapper.insertPlan(vo);
	}

	//3. 플랜 수정
	@Override
	public int editPlan(PlanVO vo) {
		return this.planMapper.editPlan(vo);
	}
	@Override
	public int updatePrice(Map<String, Integer>map) {
		return this.planMapper.updatePrice(map);
	}

	//4. 플랜 삭제
	@Override
	public int deletePlan(String planId) {
		return this.planMapper.deletePlan(planId);
	}

	//5. 플랜 1개 조회
	public Map<String, Object> planOne(int planId){
		return this.planMapper.planOne(planId);
	}
}
