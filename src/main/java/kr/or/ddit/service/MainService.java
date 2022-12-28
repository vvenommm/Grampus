package kr.or.ddit.service;


import java.util.List;

import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.RoleVO;
import kr.or.ddit.vo.TaskVO;

public interface MainService {
	//직책 불러오기
	public MainVO myRole(MemberVO memberVO);
	
	//내 전체 일감 중 완료/승인 된 일감 비율 도넛 차트로
	public TaskVO myTasks(MemberVO vo);
	
	//프로젝트 활동
	public MainVO myProj(MemberVO memberVO);
	
	//히스토리 수
	public List<MainVO> myHisList(MemberVO memberVO);
	
	//히트맵테스트
	public List<MainVO> heat(MainVO mvo);
	
	//프로젝트 리스트
	public List<ProjectVO> projList(MemberVO memberVO);
	
	//일감 리스트
	public List<TaskVO> taskList(MemberVO memberVO);
	
	//직책 리스트
	public List<RoleVO> roleList(MemberVO memberVO);
}
