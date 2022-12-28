package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.ProfileVO;

public interface ProfileService {

	//프로필 리스트 조회
	public List<ProfileVO> profileList(String memNo);

	public int profileUpdate(ProfileVO profileVO);
	
	//구인공고 승인 되면 프로필 자동 등록
	public int jobAprvInsert(Map<String, Object> map);
	
	//구인공고 취소하면 프로필 삭제
	public int jobCancel(ApplicantVO applicantVO);

	//프로젝트에서 쫓겨나면 프로필 삭제하기
	public int kickOutProf(Map<String, Object> map);

	//프로젝트 개설 후 자동 프로필 생성
	public int afterNewProj (ProfileVO pvo);
	
	public int inviJoining(ProMemVO pvo);
}
