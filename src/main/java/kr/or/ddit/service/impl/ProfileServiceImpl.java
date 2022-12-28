package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ProfileMapper;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.ProfileVO;

@Service
public class ProfileServiceImpl implements ProfileService{
	
	@Autowired
	ProfileMapper profileMapper;

	//프로필 리스트 조회
	@Override
	public List<ProfileVO> profileList(String memNo){
		return this.profileMapper.profileList(memNo);
	}
	
	//프로필 수정
	@Override
	public int profileUpdate(ProfileVO profileVO) {
		return this.profileMapper.profileUpdate(profileVO);
	}
	
	//구인공고 신청하면 프로필 자동 등록
	@Override
	public int jobAprvInsert(Map<String, Object> map) {
		return this.profileMapper.jobAprvInsert(map);
	}
	
	//구인공고 취소하면 프로필 삭제
	public int jobCancel(ApplicantVO applicantVO) {
		return this.profileMapper.jobCancel(applicantVO);
	}
	
	//프로젝트에서 쫓겨나면 프로필 삭제하기
	@Override
	public int kickOutProf(Map<String, Object> map) {
		return this.profileMapper.kickOutProf(map);
	}

	@Override
	//프로젝트 개설 후 자동 프로필 생성
	public int afterNewProj (ProfileVO pvo) {
		return this.profileMapper.afterNewProj(pvo);
	}
	
	@Override
	public int inviJoining(ProMemVO pvo) {
		return this.profileMapper.inviJoining(pvo);
	}
	
}
