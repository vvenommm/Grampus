package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CostVO;

public interface CostMapper {
	//인건비 등록
	public int createCost(Map<String, Object> map);
	
	//인건비 삭제
	public int costDelete(int id);
	
	//정산내역
	public List<CostVO> costList(String memNo);
	
	//이번달 소득
	public String thisMonthCost(String memNo);
	//지난달 소득
	public String lastMonthCost(String memNo);
	
	//지지난달 소득
	public String llastMonthCost(String memNo);
}
