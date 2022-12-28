package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.ProjectVO;


public interface ProjectMapper {
	//프로젝트 생성
	public int createProj(Map<String, Object> map);
	
	//프로젝트 이미지 이름 업데이트
	public int updateProjImg(Map<String, Object> map);
	
	//결제하고나면 payno 업데이트하기
	public int updatePayNo(ProjectVO pvo);
	
	//프로젝트 정보 불러오기
	public Map<String, Object> projInfo(int projId);
	
	//프로젝트 인건비 불러오기
	public List<Map<String, Object>> projCost(int projId);
	
	//프로젝트 맴버 불러오기
	public List<Map<String, Object>> projMember(Map<String, Object> map);
	
	//그룹별 프로젝트 멤버 불러오기
	public List<Map<String, Object>> pmemGrpList(Map<String, Object> map);
	
	//구인공고 승인 후 그 사람 정보 가져오기
	public ProjectVO afterAprvAppli(Map<String, Object> map);
	
	//멤버 추방하기
	public int kickOut(Map<String, Object> map);
	
	//프로젝트별 그룹 리스트
	public List<Map<String, Object>> grpList(int projId);
	
	//프로젝트 구인공고 불러오기
	public Map<String, Object> projJob(int projId);
	
	//프로젝트 지원자 목록 불러오기
	public List<Map<String, Object>> projAppli(int projId);
	
	//프로젝트 정보 수정
	public int projModify(Map<String, Object> map);
	
	//구인공고 개수
	public int jobInfoCnt(int projId);
	
	//내가 참여하고 있고 현재 진행 중인 프로젝트 목록
	public List<Map<String, Object>> projOnList(String memNo);
	
	//현재 진행 중이고 내가 참여하는 프로젝트 중 로고 뽑아오기
	public List<Map<String, Object>> projLogo(String memNo);
	
	//프로젝트 그룹인지 아닌지 count
	public int projCount(Map<String, Object> map);
	
	//시작날에서 하루 지난 프로젝트 상태 신규 -> 진행 자동 바꾸기
	public int changeSTTS();
	
	//종료날 지난 프로젝트 자동으로 상태 종료로 바꾸기
	public int changeSTTSE();
	
	//내가 개설한 프로젝트 중 현재 진행 중인 프로젝트 제목 리스트
	public List<ProjectVO> projMadeByMe(ProjectVO pvo);
	
	
	////////////////////////////////////////////// 대시보드 /////////////////////////////////////////////////
	
	//프로젝트 대시보드(메인)
	public Map<String, Object> projMain(Map<String, Object> map);
	
	//프로젝트 진척도(100%일감 / 전체 일감)
	public Map<String, Object> process(Map<String, Object> map);
	
	//그룹별 역할 현황
	public MainVO roleStatus(Map<String, Object> map);
	
	//그룹 있는데 전체에서 총 인원으로 역할 보여주기
	public MainVO allRoleStatus(int projId);
	
	//로드맵
	public List<Map<String, Object>> roadmap(int projId);
	
	//일감 최근 5개
	public List<Map<String, Object>> mainTask(Map<String, Object> map);
	
	//이슈 최근 5개
	public List<Map<String, Object>> mainIssue(Map<String, Object> map);
	
	//공지사항 최근 5개
	public List<Map<String, Object>> mainNotice(Map<String, Object> map);
	
	//일정 최근 4개
	public List<Map<String, Object>> mainCalendar(Map<String, Object> map); 
	
	//게시판 최근 5개
    public List<Map<String, Object>> mainBrdHelp(Map<String, Object> map);
    public List<Map<String, Object>> mainBrdFree(Map<String, Object> map);

    //문서 최근 6개
	public List<Map<String, Object>> mainDoc(Map<String, Object> map);

	//위키 최근 6개
	public List<Map<String, Object>> mainWiki(int projId);
    
    
	////////////////////////////////////////////// 마이페이지 /////////////////////////////////////////////////
	
	//진행중인 프로젝트 리스트
	public List<ProjectVO> projIngList(ProjectVO projectVO);
	
	//진행중인 프로젝트 갯수
	public ProjectVO projIngListCnt(ProjectVO projectVO);
	
	//마감 프로젝트 리스트
	public List<ProjectVO> projEndList(ProjectVO projectVO);

	//내가 참여하고 진행중인 프로젝트 명 리스트
	public List<ProjectVO> mypageProejctList(String memNo);
	
	//초대받은 프로젝트 리스트
	public List<ProjectVO> inviteProjectList(String memNo);
	
	//초대 수락
	public int inviteYes(int pmemCd);
	
	//초대 거절
	public int inviteNo(int pmemCd);
	
	//promem에는 있는데 profile에는 없을 때 해당 회원을 profile에 넣어줌
	public int syncPromemProfile(String projId);
	
	
}
