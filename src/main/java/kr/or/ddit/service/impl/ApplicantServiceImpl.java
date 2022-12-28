package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ApplicantMapper;
import kr.or.ddit.service.ApplicantService;
import kr.or.ddit.vo.ApplicantVO;

@Service
public class ApplicantServiceImpl implements ApplicantService {
	@Autowired
	ApplicantMapper applicantMapper;
	
	//지원자 등록
	@Override
	public int appliInset(Map<String, Object> map) {
		return applicantMapper.appliInset(map);
	};
	
	//지원자수 증가
	@Override
	public int appliCntUp(int projId) {
		return applicantMapper.appliCntUp(projId);
	};
	
	//이미 프로젝트 멤버일 때 구인공고 지원 불가
	@Override
	public int promemChk(Map<String, Object> map) {
		return this.applicantMapper.promemChk(map);
	}
	
	//지원 여부 확인
	@Override
	public int appliChk(Map<String, Object> map) {
		return applicantMapper.appliChk(map);
	};
	
	//지원자 업데이트
	@Override
	public int appliUpdate(Map<String, Object> map) {
		return applicantMapper.appliUpdate(map);
	};
	
	//지원자 승인시 프로젝트 맴버 등록
	@Override
	public int promemInsert(Map<String, Object> map) {
		return applicantMapper.promemInsert(map);
	};	
	
	//공고 지원 리스트
	@Override
	public List<ApplicantVO> jobApplicantList(ApplicantVO applicantVO){
		return applicantMapper.jobApplicantList(applicantVO);
	}
	//공고 지원 취소
	@Override
	public int applicantDelete(ApplicantVO applicantVO) {
		return applicantMapper.applicantDelete(applicantVO);
	}
}
