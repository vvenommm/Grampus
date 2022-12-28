package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.ResumeVO;

public interface ResumeMapper {

	//이력서  조회
	public ResumeVO resumeSelect(String memNo);
	
	//이력서 추가
	public int resumeInsert(ResumeVO resumeVO);
	
	//이력서 수정
	public int resuemUpdate(ResumeVO resumeVO);
	
	//이력서 있는지 없는지
	public int doYouHaveResume(String memNo);
}
