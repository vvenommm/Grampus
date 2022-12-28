package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.JobMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.JobService;
import kr.or.ddit.vo.JobVO;

@Service
public class JobServiceImpl implements JobService{
	@Autowired
	JobMapper jobMapper;
	
	//구인공고 목록
	@Override
	public List<Map<String, Object>> jobList(Map<String, Object> map){
		return jobMapper.jobList(map);
	};
	
	//북마크 목록
	@Override
	public List<String> markList(String id){
		return jobMapper.markList(id);
	};
	
	//프로젝트 정보
	@Override
	public Map<String, Object> projVal(int projId){
		return jobMapper.projVal(projId);
	};
	
	//구인공고 정보
	@Override
	public Map<String, Object> jobVal(int projId){
		return jobMapper.jobVal(projId);
	};
	
	//인건비 정보
	@Override
	public List<Map<String, Object>> costVal(int projId){
		return jobMapper.costVal(projId);
	};
	
	//구인공고 등록
	@Override
	public int jobRegist(Map<String, Object> map) {
		return jobMapper.jobRegist(map);
	};
	
	//구인공고 수정
	@Override
	public int jobModify(Map<String, Object> map) {
		return jobMapper.jobModify(map);
	};
	
	//구인공고 삭제
	@Override
	public int jobDelete(int projId) {
		return jobMapper.jobDelete(projId);
	};
	
	//구인공고 지원자 삭제
	public int appliDelete(int projId) {
		return jobMapper.appliDelete(projId);
	};	
	
	//마이페이지 북마크 리스트
	@Override
	public List<JobVO> bookMarkList(JobVO jobVO){
		return this.jobMapper.bookMarkList(jobVO);
	}
	
	//공고 북마크 상세보기
	@Override
	public JobVO bookMarkDetail(JobVO jobVO) {
		return this.jobMapper.bookMarkDetail(jobVO);
	}
}
