package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.TaskMapper;
import kr.or.ddit.service.HistoryService;
import kr.or.ddit.service.IssueService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.vo.HistoryVO;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TaskServiceImpl implements TaskService{
	@Autowired
	TaskMapper taskMapper;
	
	@Autowired
	HistoryService hisService;
	
	@Autowired
	IssueService issueMapper;
	
	//일감 리스트 출력
	@Override
	public List<TaskVO> taskList(Map<String, Object> map) {
		return this.taskMapper.taskList(map);
	}
	
	//일감 리스트 출력(나머지용)
	@Override
	public List<TaskVO> taskList2(Map<String, Object> map) {
		return this.taskMapper.taskList2(map);
	}

	//같은 그룹 멤버(담당자) 출력하기(새 일감 등록 시)
	@Override
	public List<Map<String, Object>> sameGrpMem(Map<String, Object> map) {
		return this.taskMapper.sameGrpMem(map);
	}
	
	//같은 그룹 멤버(담당자) 출력하기(일감 수정 시)
	@Override
	public List<Map<String, Object>> sameGrpMemUp(Map<String, Object> map) {
		return this.taskMapper.sameGrpMemUp(map);
	}

	//새 일감 등록
	@Override
	public int insertTask(Map<String, Object> map) {
		HistoryVO vo = new HistoryVO();
		vo.setProjId((int)map.get("projId"));
		vo.setMemNo((String)map.get("memNo"));
		vo.setPmemGrp((String)map.get("pmemGrp"));
		vo.setHisCn((String)map.get("taskCn"));

		int result = this.taskMapper.insertTask(map);
		log.info("           taskService!!! map : " + map.toString());
		vo.setHisKey(String.format("%d" , (int)map.get("taskNo")));
		log.info("           taskService!!! vo : " + vo.toString());
		this.hisService.taskIn(vo);
		
		return result;
		
	}

	//일감 상세 정보
	@Override
	public TaskVO taskDetail(TaskVO taskVO) {
		return this.taskMapper.taskDetail(taskVO);
	}

	//하위 일감 검색
	@Override
	public List<TaskVO> taskChild(Map<String, Object> map) {
		return this.taskMapper.taskChild(map);
	}

	//상위 일감 검색
	@Override
	public List<TaskVO> taskParent(TaskVO taskVO) {
		return this.taskMapper.taskParent(taskVO);
	}
		
	//일감 삭제
	@Override
	public int deleteTask(String taskNo) {
		//관련 이슈도 삭제
		this.issueMapper.autoDelete(taskNo);
		int result = this.taskMapper.deleteTask(taskNo);
		return result;
	}

	//삭제된 일감을 상위일감으로 가진 일감의 상위일감 null로 변경
	@Override
	public int updateTaskParent(String taskNo) {
		return this.taskMapper.updateTaskParent(taskNo);
	}
	
	//승인 반려를 위한 권한 체크
	@Override
	public List<ProMemVO> checkRole(ProMemVO promemVO) {
		return this.taskMapper.checkRole(promemVO);
	}

	//승인 및 반려 처리
	public int updateStts(TaskVO taskVO) {
		return this.taskMapper.updateStts(taskVO);
	}
	
	//일감 수정
	@Override
	public int updateTask(Map<String, Object> map) {
		HistoryVO vo = new HistoryVO();
		
		log.info("      일감 수정 map : " + map);
		
		vo.setProjId((int)map.get("projId"));
		vo.setMemNo((String)map.get("memNo"));
		vo.setPmemGrp((String)map.get("pmemGrp"));
		vo.setHisKey(map.get("taskNo"));
		vo.setHisCn((String)map.get("taskCn"));
		
		this.hisService.taskUp(vo);
		log.info("      일감 수정 vo : " + vo);
		
		return this.taskMapper.updateTask(map);
	}

	//전체 일감 개수(PM용)
	@Override
	public int countTask(TaskVO taskVO) {
		return this.taskMapper.countTask(taskVO);
	}
	
	//전체 일감 개수(나머지용)
	@Override
	public int countTask2(TaskVO taskVO) {
		return this.taskMapper.countTask2(taskVO);
	}
	
	//신규 중 일감 개수(PM용)
	@Override
	public int countTaskNew(TaskVO taskVO) {
		return this.taskMapper.countTaskNew(taskVO);
	}
	
	//신규 중 일감 개수(나머지용)
	@Override
	public int countTaskNew2(TaskVO taskVO) {
		return this.taskMapper.countTaskNew2(taskVO);
	}

	//진행 중 일감 개수(PM용)
	@Override
	public int countTaskIng(TaskVO taskVO) {
		return this.taskMapper.countTaskIng(taskVO);
	}
	
	//진행 중 일감 개수(나머지용)
	@Override
	public int countTaskIng2(TaskVO taskVO) {
		return this.taskMapper.countTaskIng2(taskVO);
	}
	
	
	//완료 일감 개수(PM용)
	@Override
	public int countTaskDone(TaskVO taskVO) {
		return this.taskMapper.countTaskDone(taskVO);
	}
	
	//완료 일감 개수(나머지용)
	@Override
	public int countTaskDone2(TaskVO taskVO) {
		return this.taskMapper.countTaskDone2(taskVO);
	}
	
	//승인 일감 개수(PM용)
	@Override
	public int countTaskApprove(TaskVO taskVO) {
		return this.taskMapper.countTaskApprove(taskVO);
	}
	
	//승인 일감 개수(나머지용)
	@Override
	public int countTaskApprove2(TaskVO taskVO) {
		return this.taskMapper.countTaskApprove2(taskVO);
	}
	
	//반려 일감 개수(PM용)
	@Override
	public int countTaskReject(TaskVO taskVO) {
		return this.taskMapper.countTaskReject(taskVO);
	}
	
	//반려 일감 개수(나머지용)
	@Override
	public int countTaskReject2(TaskVO taskVO) {
		return this.taskMapper.countTaskReject2(taskVO);
	}
	
	//전월 대비 증가율(전체 일감, PM용)
	@Override
	public Map<String, Integer> allPercent(Map<String, Object> map) {
		return this.taskMapper.allPercent(map);
	}
	
	//전월 대비 증가율(전체 일감, 나머지용)
	@Override 
	public Map<String, Integer> allPercent2(Map<String, Object> map) {
		return this.taskMapper.allPercent2(map);
	}
	
	//전월 대비 증가율(진행 일감, PM용)
	@Override
	public Map<String, Integer> ingPercent(Map<String, Object> map) {
		return this.taskMapper.ingPercent(map);
	}
	
	//전월 대비 증가율(진행 일감, 나머지용)
	@Override 
	public Map<String, Integer> ingPercent2(Map<String, Object> map) {
		return this.taskMapper.ingPercent2(map);
	}
	
	//전월 대비 증가율(완료 일감, PM용)
	@Override 
	public Map<String, Integer> donePercent(Map<String, Object> map) {
		return this.taskMapper.donePercent(map);
	}
	
	//전월 대비 증가율(완료 일감, 나머지용)
	@Override 
	public Map<String, Integer> donePercent2(Map<String, Object> map) {
		return this.taskMapper.donePercent2(map);
	}
	
	//전월 대비 증가율(승인 일감, PM용)
	@Override 
	public Map<String, Integer> approvePercent(Map<String, Object> map) {
		return this.taskMapper.approvePercent(map);
	}
	
	//전월 대비 증가율(승인 일감, 나머지용)
	@Override 
	public Map<String, Integer> approvePercent2(Map<String, Object> map) {
		return this.taskMapper.approvePercent2(map);
	}
	
	//전월 대비 증가율(반려 일감, PM용)
	@Override 
	public Map<String, Integer> rejectPercent(Map<String, Object> map) {
		return this.taskMapper.rejectPercent(map);
	}
	
	//전월 대비 증가율(반려 일감, 나머지용)
	@Override 
	public Map<String, Integer> rejectPercent2(Map<String, Object> map) {
		return this.taskMapper.rejectPercent2(map);
	}
	
	//일감 관련 이슈 출력
	@Override
	public List<IssueVO> onetaskIssue(String taskNo) {
		return this.taskMapper.onetaskIssue(taskNo);
	}
	
	//일괄편집 모달에서 담당자 출력
	@Override
	public List<Map<String, Object>> modalPmemCd(Map<String, Object> map) {
		return this.taskMapper.modalPmemCd(map);
	}
	
	//일괄편집 수정
	@Override
	public int updateAll(TaskVO taskVO) {
		return this.taskMapper.updateAll(taskVO);
	}

	//프로젝트 멤버 코드 가져오기
	@Override
	public int getPmemCd(Map<String, Object> map) {
		return this.taskMapper.getPmemCd(map);
	}
	
	//일감 메인페이지 카드별 검색
	@Override
	public List<TaskVO> cardSort(Map<String, Object> map) {
		return this.taskMapper.cardSort(map);
	}
	
	
	///////////////////////////////////////////////////칸반///////////////////////////////////////////////////
	
	//일감 상태 수정
	@Override
	public int updateKanbanStts(TaskVO taskVO) {
		return this.taskMapper.updateKanbanStts(taskVO);
	}
	
	//일감의 진척도 가져오기
	@Override
	public int selectProgress(String taskNo) {
		return this.taskMapper.selectProgress(taskNo);
	}
	
	//상위일감 번호 삭제
	public int updateParent(Map<String, Object> map) {
		return this.taskMapper.updateParent(map);
	}
	
	///////////////////////////////////////////////////간트///////////////////////////////////////////////////
	
	//바 이동 시 날짜 수정
	@Override
	public int updateDateGantt(TaskVO taskVO) {
		return this.taskMapper.updateDateGantt(taskVO);
	}
	
	//수정창을 통한 수정
	@Override
	public int updateAllGantt(TaskVO taskVO) {
		return this.taskMapper.updateAllGantt(taskVO);
	}
	
	
	//////////////마이페이지 ////////////////
	//내 일감 리스트조회
	@Override
	public List<TaskVO> mypageTaskList(TaskVO taskVO){

		System.out.println("왔다1, taskVO : " + taskVO.toString());
		return this.taskMapper.mypageTaskList(taskVO);
	}
	
	//오늘까지 일감 죄회
	@Override
	public List<TaskVO> todayTaskList(TaskVO taskVO){
		return this.taskMapper.todayTaskList(taskVO);
	}
	
	//지난 일감 조회
	@Override
	public List<TaskVO> endTaskList(TaskVO taskVO){
		return this.taskMapper.endTaskList(taskVO);
	}
		
	//주간 일감 조회
	@Override
	public List<TaskVO> weekTaskList(String memNo){
		return this.taskMapper.weekTaskList(memNo);
	}
	
	//상위 하위 일감 검색
	@Override
	public List<Map<String, Object>> updownSearch(Map<String, Object> map){
		return this.taskMapper.updownSearch(map);
	};
	
	
	////////////////////////////////////////////////////////////
	//PL누군지 찾기
	@Override
	public String selectPL(Map<String, Object> map) {
		return this.taskMapper.selectPL(map);
	};
	
	
	
	
	//페이징용 쿼리
	public int totalPages(Map<String, Object> map) {
		return this.taskMapper.totalPages(map);
	}
	
	//페이징용 쿼리 - '모두'
	public int totalPagesAll(int projId) {
		return this.taskMapper.totalPagesAll(projId);
	}
}
