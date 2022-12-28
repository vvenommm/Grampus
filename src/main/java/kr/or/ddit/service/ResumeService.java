package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.ResumeVO;

public interface ResumeService {

	public ResumeVO resumeSelect(String memNo);

	public int resumeInsert(ResumeVO resumeVO);

	public int resuemUpdate(ResumeVO resumeVO);
	
	//이력서 있는지 없는지
	public int doYouHaveResume(String memNo);

}
