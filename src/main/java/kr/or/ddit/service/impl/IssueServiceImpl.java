package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.AnswerMapper;
import kr.or.ddit.mapper.IssueMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.IssueService;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.TaskVO;

@Service
public class IssueServiceImpl implements IssueService{
	@Autowired
	private IssueMapper issueMapper;
	@Autowired
	private AnswerMapper answerMapper;

	//이슈 리스트 출력(PM용)
	@Override
	public List<Map<String, Object>> issueList(Map<String, Object> map) {
		return this.issueMapper.issueList(map);
	}
	
	//이슈 리스트 출력(나머지용)
	@Override
	public List<Map<String, Object>> issueList2(Map<String, Object> map){
		return this.issueMapper.issueList2(map);
	}

	//이슈 등록 시 같은 팀의 전체 일감 가져오기
	@Override
	public List<TaskVO> getTaskInfo(Map<String, Object> map) {
		return this.issueMapper.getTaskInfo(map);
	}

	//이슈 상세 정보
	@Override
	public Map<String, Object> issueDetail(Map<String, Object> map) {
		return this.issueMapper.issueDetail(map);
	}
	
	//이슈 삭제
	@Override
	public int deleteIssue(String issueNo) {
		this.answerMapper.autoDelete(issueNo);		//이슈댓글 삭제
		int result2 = this.issueMapper.deleteIssue(issueNo);	//이슈 삭제
		return result2;
	}

	//일감 삭제 시 관련 이슈 모두 삭제
	@Override
	public int autoDelete(String taskNo) {
		return this.issueMapper.autoDelete(taskNo);
	}
	
	//이슈 댓글 작성자와 로그인한 사람 동일 여부 판단
	@Override
	public int checkPmemcd(ProMemVO promemVO) {
		return this.issueMapper.checkPmemcd(promemVO);
	}
	
	//이슈 등록
	@Override
	public int insertIssue(IssueVO issueVO) {
		return this.issueMapper.insertIssue(issueVO);
	}
	
	//이슈 수정
	@Override
	public int updateIssue(IssueVO issueVO) {
		return this.issueMapper.updateIssue(issueVO);
	}
	
	//개선 개수(PM용)
	@Override
	public int improveCount(Map<String, Object> map) {
		return this.issueMapper.improveCount(map);
	}
	
	//개선 개수(나머지용)
	@Override
	public int improveCount2(Map<String, Object> map) {
		return this.issueMapper.improveCount2(map);
	}
	
	//결함 개수(PM용)
	@Override
	public int defectCount(Map<String, Object> map) {
		return this.issueMapper.defectCount(map);
	}
	
	//결함 개수(나머지용)
	@Override
	public int defectCount2(Map<String, Object> map) {
		return this.issueMapper.defectCount2(map);
	}
	
	//인사 개수(PM용)
	@Override
	public int personalCount(Map<String, Object> map) {
		return this.issueMapper.personalCount(map);
	}
	
	//인사 개수(나머지용)
	@Override
	public int personalCount2(Map<String, Object> map) {
		return this.issueMapper.personalCount2(map);
	}
	
	//기타 개수(PM용)
	@Override
	public int etcCount(Map<String, Object> map) {
		return this.issueMapper.etcCount(map);
	}
	
	//기타 개수(나머지용)
	@Override
	public int etcCount2(Map<String, Object> map) {
		return this.issueMapper.etcCount2(map);
	}
	
	//일괄편집 수정
	@Override
	public int updateAll(IssueVO issueVO) {
		return this.issueMapper.updateAll(issueVO);
	}
	//이슈 종류별 정렬(모두)
	@Override
	public List<Map<String, Object>> isSortAll(Map<String, Object> map) {
		return this.issueMapper.isSortAll(map);
	}
	
	//이슈 종류별 정렬(팀별)
	@Override
	public List<Map<String, Object>> isSortGrp(Map<String, Object> map) {
		return this.issueMapper.isSortGrp(map);
	}
	
	//이슈 작성자 불러오기
	@Override
	public String getWriter(int issueNo) {
		return this.issueMapper.getWriter(issueNo);
	};
}
