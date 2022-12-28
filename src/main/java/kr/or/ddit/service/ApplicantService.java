package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApplicantVO;

public interface ApplicantService {
	//지원자 등록
	public int appliInset(Map<String, Object> map);
	
	//지원자수 증가
	public int appliCntUp(int projId);
	
	//이미 프로젝트 멤버일 때 구인공고 지원 불가
	public int promemChk(Map<String, Object> map);
	
	//지원 여부 확인
	public int appliChk(Map<String, Object> map);
	
	//지원자 업데이트
	public int appliUpdate(Map<String, Object> map);
	
	//지원자 승인시 프로젝트 맴버 등록
	public int promemInsert(Map<String, Object> map);

	public List<ApplicantVO> jobApplicantList(ApplicantVO applicantVO);

	public int applicantDelete(ApplicantVO applicantVO);	
}
