package kr.or.ddit.service.impl;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MainMapper;
import kr.or.ddit.service.MainService;
import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.RoleVO;
import kr.or.ddit.vo.TaskVO;

@Service
public class MainServiceImpl implements MainService{
	@Autowired
	MainMapper mainMapper;
	
	//직책 불러오기
	@Override
	public MainVO myRole(MemberVO memberVO){
		return this.mainMapper.myRole(memberVO);
	}
	
	@Override
	//내 전체 일감 중 완료/승인 된 일감 비율 도넛 차트로
	public TaskVO myTasks(MemberVO vo) {
		return this.mainMapper.myTasks(vo);
	}
	
	@Override
	//프로젝트 활동
	public MainVO myProj(MemberVO memberVO) {
		return this.mainMapper.myProj(memberVO);
	}
	
	@Override
	//히스토리 수
	public List<MainVO> myHisList(MemberVO memberVO) {
		return this.mainMapper.myHisList(memberVO);
	}
	
	@Override
	//히트맵테스트
	public List<MainVO> heat(MainVO mvo){
		return this.mainMapper.heat(mvo);
	}
	
	@Override
	//프로젝트 리스트
	public List<ProjectVO> projList(MemberVO memberVO){
		return this.mainMapper.projList(memberVO);
	}
	
	@Override
	//일감 리스트
	public List<TaskVO> taskList(MemberVO memberVO){
		return this.mainMapper.taskList(memberVO);
	}
	
	@Override
	//일감 리스트
	public List<RoleVO> roleList(MemberVO memberVO){
		return this.mainMapper.roleList(memberVO);
	}
}
