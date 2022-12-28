package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.CostMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.CostService;
import kr.or.ddit.vo.CostVO;

@Service
public class CostServiceImpl implements CostService{
	@Autowired
	CostMapper costMapper;
	
	//인건비 등록
	@Override
	public int createCost(Map<String, Object> map) {
		return costMapper.createCost(map);
	};
	
	//인건비 삭제
	@Override
	public int costDelete(int id) {
		return costMapper.costDelete(id);
	};
	
	//정산내역
	@Override
	public List<CostVO> costList(String memNo){
		return costMapper.costList(memNo);
	}
	
	//이번달 소득
	@Override
	public String thisMonthCost(String memNo) {
		return costMapper.thisMonthCost(memNo);
	}
	
	
	//지난달 소득
	@Override
    public String lastMonthCost(String memNo){
    	return costMapper.lastMonthCost(memNo);
    }
		
	//지지난달 소득
	@Override
	public String llastMonthCost(String memNo){
		return costMapper.llastMonthCost(memNo);
	}
}
