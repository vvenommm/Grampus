package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ResumeMapper;
import kr.or.ddit.service.ResumeService;
import kr.or.ddit.vo.ResumeVO;

@Service
public class ResumeServiceImpl implements ResumeService{
	
	@Inject
	ResumeMapper resumeMapper;

	//이력서 자격증 조회
	@Override
	public ResumeVO resumeSelect(String memNo){
		return this.resumeMapper.resumeSelect(memNo);
	}
	
	//이력서 추가
	@Override
	public int resumeInsert(ResumeVO resumeVO) {
		return this.resumeMapper.resumeInsert(resumeVO);
	}
	
	//이력서 수정
	@Override
	public int resuemUpdate(ResumeVO resumeVO) {
		return this.resumeMapper.resuemUpdate(resumeVO);
	}
	
	//이력서 있는지 없는지
	@Override
	public int doYouHaveResume(String memNo) {
		return this.resumeMapper.doYouHaveResume(memNo);
	}
}
