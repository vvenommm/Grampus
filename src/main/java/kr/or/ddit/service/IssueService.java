package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.TaskVO;

public interface IssueService {
	
	//이슈 리스트 출력(PM용)
	public List<Map<String, Object>> issueList(Map<String, Object> map);
	
	//이슈 리스트 출력(나머지용)
	public List<Map<String, Object>> issueList2(Map<String, Object> map);
	
	//이슈 등록 시 같은 팀의 전체 일감 가져오기
	public List<TaskVO> getTaskInfo(Map<String, Object> map);
	
	//이슈 상세 정보
	public Map<String, Object> issueDetail(Map<String, Object> map);
	
	//이슈 삭제
	public int deleteIssue(String issueNo);
	
	//일감 삭제 시 관련 이슈 모두 삭제
	public int autoDelete(String taskNo);
	
	//이슈 댓글 작성자와 로그인한 사람 동일 여부 판단
	public int checkPmemcd(ProMemVO promemVO);
	
	//이슈 등록
	public int insertIssue(IssueVO issueVO);
	
	//이슈 수정
	public int updateIssue(IssueVO issueVO);
	
	//개선 개수(PM용)
	public int improveCount(Map<String, Object> map);
	
	//개선 개수(나머지용)
	public int improveCount2(Map<String, Object> map);
	
	//결함 개수(PM용)
	public int defectCount(Map<String, Object> map);
	
	//결함 개수(나머지용)
	public int defectCount2(Map<String, Object> map);
	
	//인사 개수(PM용)
	public int personalCount(Map<String, Object> map);
	
	//인사 개수(나머지용)
	public int personalCount2(Map<String, Object> map);
	
	//기타 개수(PM용)
	public int etcCount(Map<String, Object> map);
	
	//기타 개수(나머지용)
	public int etcCount2(Map<String, Object> map);
	
	//일괄편집 수정
	public int updateAll(IssueVO issueVO);
	
	//이슈 종류별 정렬(모두)
	public List<Map<String, Object>> isSortAll(Map<String, Object> map);
	
	//이슈 종류별 정렬(팀별)
	public List<Map<String, Object>> isSortGrp(Map<String, Object> map);
	
	//이슈 작성자 불러오기
	public String getWriter(int issueNo);
}
