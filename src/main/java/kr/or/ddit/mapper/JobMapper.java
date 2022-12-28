package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.JobVO;

public interface JobMapper {
	//구인공고 목록
	public List<Map<String, Object>> jobList(Map<String, Object> map);
	
	//북마크 목록
	public List<String> markList(String id);
	
	//프로젝트 정보
	public Map<String, Object> projVal(int projId);
	
	//구인공고 정보
	public Map<String, Object> jobVal(int projId);
	
	//인건비 정보
	public List<Map<String, Object>> costVal(int projId);
	
	//구인공고 등록
	public int jobRegist(Map<String, Object> map);
	
	//구인공고 수정
	public int jobModify(Map<String, Object> map);
	
	//구인공고 삭제
	public int jobDelete(int projId);
	
	//구인공고 지원자 삭제
	public int appliDelete(int projId);
	
	//마이페이지 북마크 리스트
	public List<JobVO> bookMarkList(JobVO jobVO);
	
	//공고 북마크 상세보기
	public JobVO bookMarkDetail(JobVO jobVO);
}
