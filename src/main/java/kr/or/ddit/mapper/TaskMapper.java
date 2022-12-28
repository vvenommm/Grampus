package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.TaskVO;

public interface TaskMapper {

	//일감 리스트 출력(PM용)
	public List<TaskVO> taskList(Map<String, Object> map);
	
	//일감 리스트 출력(나머지용)
	public List<TaskVO> taskList2(Map<String, Object> map);
	
	//같은 그룹 멤버(담당자) 출력하기(새 일감 등록 시)
	public List<Map<String, Object>> sameGrpMem(Map<String, Object> map);
	
	//같은 그룹 멤버(담당자) 출력하기(일감 수정 시)
	public List<Map<String, Object>> sameGrpMemUp(Map<String, Object> map);
	
	//새 일감 등록
	public int insertTask(Map<String, Object> map);
	
	//일감 상세 정보
	public TaskVO taskDetail(TaskVO taskVO);
	
	//하위 일감 검색
	public List<TaskVO> taskChild(Map<String, Object> map);
	
	//상위 일감 검색
	public List<TaskVO> taskParent(TaskVO taskVO);
	
	//일감 삭제
	public int deleteTask(String taskNo);
	
	//삭제된 일감을 상위일감으로 가진 일감의 상위일감 null로 변경
	public int updateTaskParent(String taskNo);
	
	//승인 반려를 위한 권한 체크
	public List<ProMemVO> checkRole(ProMemVO promemVO);
	
	//승인 및 반려 처리
	public int updateStts(TaskVO taskVO);
	
	//일감 수정
	public int updateTask(Map<String, Object> map);
	
	//전체 일감 개수(PM용)
	public int countTask(TaskVO taskVO);
	
	//전체 일감 개수(나머지용)
	public int countTask2(TaskVO taskVO);
	
	//신규 중 일감 개수(PM용)
	public int countTaskNew(TaskVO taskVO);
	
	//신규 중 일감 개수(나머지용)
	public int countTaskNew2(TaskVO taskVO);
	
	//진행 중 일감 개수(PM용)
	public int countTaskIng(TaskVO taskVO);
	
	//진행 중 일감 개수(PM용)-
	public int countTaskIng2(TaskVO taskVO);
	
	//완료 일감 개수(PM용)
	public int countTaskDone(TaskVO taskVO);
	
	//완료 일감 개수(나머지용)
	public int countTaskDone2(TaskVO taskVO);
	
	//승인 일감 개수(PM용)
	public int countTaskApprove(TaskVO taskVO);
	
	//승인 일감 개수(나머지용)
	public int countTaskApprove2(TaskVO taskVO);
	
	//반려 일감 개수(PM용)
	public int countTaskReject(TaskVO taskVO);
	
	//반려 일감 개수(나머지용)
	public int countTaskReject2(TaskVO taskVO);
	
	//전월 대비 증가율(전체 일감, PM용)
	public Map<String, Integer> allPercent(Map<String, Object> map);
	
	//전월 대비 증가율(전체 일감, 나머지용)
	public Map<String, Integer> allPercent2(Map<String, Object> map);
	
	//전월 대비 증가율(진행 일감, PM용)
	public Map<String, Integer> ingPercent(Map<String, Object> map);
	
	//전월 대비 증가율(진행 일감, 나머지용)
	public Map<String, Integer> ingPercent2(Map<String, Object> map);
	
	//전월 대비 증가율(완료 일감, PM용)
	public Map<String, Integer> donePercent(Map<String, Object> map);
	
	//전월 대비 증가율(완료 일감, 나머지용)
	public Map<String, Integer> donePercent2(Map<String, Object> map);
	
	//전월 대비 증가율(승인 일감, PM용)
	public Map<String, Integer> approvePercent(Map<String, Object> map);
	
	//전월 대비 증가율(승인 일감, 나머지용)
	public Map<String, Integer> approvePercent2(Map<String, Object> map);
	
	//전월 대비 증가율(반려 일감, PM용)
	public Map<String, Integer> rejectPercent(Map<String, Object> map);
	
	//전월 대비 증가율(반려 일감, 나머지용)
	public Map<String, Integer> rejectPercent2(Map<String, Object> map);
	
	//일감 관련 이슈 출력
	public List<IssueVO> onetaskIssue(String taskNo);
	
	//일괄편집 모달에서 담당자 출력
	public List<Map<String, Object>> modalPmemCd(Map<String, Object> map);
	
	//일괄편집 수정
	public int updateAll(TaskVO taskVO);
	
	//프로젝트 멤버 코드 가져오기
	public int getPmemCd(Map<String, Object> map);
	
	//일감 메인페이지 카드별 검색
	public List<TaskVO> cardSort(Map<String, Object> map);
	
	///////////////////////////////////////////////////칸반///////////////////////////////////////////////////
	
	//일감 상태 수정
	public int updateKanbanStts(TaskVO taskVO);
	
	//일감의 진척도 가져오기
	public int selectProgress(String taskNo);
	
	
	///////////////////////////////////////////////////간트///////////////////////////////////////////////////
	
	//바 이동 시 날짜 수정
	public int updateDateGantt(TaskVO taskVO);
	
	//수정창을 통한 수정
	public int updateAllGantt(TaskVO taskVO);
	
	//상위일감 번호 삭제
	public int updateParent(Map<String, Object> map);
	
	
	//////////////마이페이지 ////////////////
	//내 일감 리스트조회
	public List<TaskVO> mypageTaskList(TaskVO taskVO);
	
	//오늘까지 일감 죄회
	public List<TaskVO> todayTaskList(TaskVO taskVO);
	
	//지난 일감 조회
	public List<TaskVO> endTaskList(TaskVO taskVO);
	
	//주간 일감 조회
	public List<TaskVO> weekTaskList(String memNo);
	
	//상위 하위 일감 검색
	public List<Map<String, Object>> updownSearch(Map<String, Object> map);
	
	//PL누군지 찾기
	public String selectPL(Map<String, Object> map);
	
	
	
	//페이징용 쿼리 - '그룹별'
	public int totalPages(Map<String, Object> map);

	//페이징용 쿼리 - '모두'
	public int totalPagesAll(int projId);
}
