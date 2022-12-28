package kr.or.ddit.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ProjectMapper;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectServiceImpl implements ProjectService{
	@Autowired
	ProjectMapper projectMapper;
	
	@Autowired
	ProfileService profileService;
	
	//프로젝트 생성
	@Override
	public int createProj(Map<String, Object> map) {
		return projectMapper.createProj(map);
	};
	
	//프로젝트 이미지 이름 업데이트
	@Override
	public int updateProjImg(Map<String, Object> map) {
		return projectMapper.updateProjImg(map);
	};
	
	//결제하고나면 payno 업데이트하기
	public int updatePayNo(ProjectVO pvo) {
		return this.projectMapper.updatePayNo(pvo);
	}

	//프로젝트 정보 불러오기
	@Override
	public Map<String, Object> projInfo(int projId){
		return projectMapper.projInfo(projId);
	};
	
	//프로젝트 인건비 불러오기
	@Override
	public List<Map<String, Object>> projCost(int projId){
		return projectMapper.projCost(projId);
	};
	
	//프로젝트 맴버 불러오기
	@Override
	public List<Map<String, Object>> projMember(Map<String, Object> map){
		List<Map<String, Object>> List = projectMapper.projMember(map);
		List<Map<String, Object>> promemList = new ArrayList<Map<String,Object>>();
		int i = 0;
		for(Map<String, Object> map2 : List) {
			String photo = (String)map2.get("PROF_PHOTO");
			if(photo == null) {
				map2.put("PROF_PHOTO", "grampusLogo.png");
			}
			promemList.add(i, map2);
			i++;
		}
		
		return promemList;
	};
	
	//그룹별 프로젝트 멤버 불러오기
	@Override
	public List<Map<String, Object>> pmemGrpList(Map<String, Object> map){
		return this.projectMapper.pmemGrpList(map);
	}
	
	//구인공고 승인 후 그 사람 정보 가져오기
	public ProjectVO afterAprvAppli(Map<String, Object> map) {
		return this.projectMapper.afterAprvAppli(map);
	}
	
	//멤버 추방하기
	@Override
	public int kickOut(Map<String, Object> map) {
		
		int result = this.projectMapper.kickOut(map);
		if(result > 0) {
			this.profileService.kickOutProf(map);
		}
		return result;
	}
	
	//프로젝트별 그룹 리스트
	@Override
	public List<Map<String, Object>> grpList(int projId){
		return this.projectMapper.grpList(projId);
	}
	
	//프로젝트 구인공고 불러오기
	@Override
	public Map<String, Object> projJob(int projId){
		return projectMapper.projJob(projId);
	};
	
	//프로젝트 지원자 목록 불러오기
	@Override
	public List<Map<String, Object>> projAppli(int projId){
		return projectMapper.projAppli(projId);
	};	
	
	//프로젝트 정보 수정
	@Override
	public int projModify(Map<String, Object> map) {
		return projectMapper.projModify(map);
	};	
	
	//구인공고 개수
	@Override
	public int jobInfoCnt(int projId) {
		return projectMapper.jobInfoCnt(projId);
	};
	
	//내가 참여하고 있고 현재 진행 중인 프로젝트 목록
	@Override
	public List<Map<String, Object>> projOnList(String memNo){
		
		List<Map<String, Object>> projOnList = new ArrayList<Map<String,Object>>();
		projOnList = this.projectMapper.projOnList(memNo);
		log.info("         projList" + projOnList);
		Map<String, Object> map2 = new HashMap<String, Object>();
		List<Map<String, Object>> projList = new ArrayList<Map<String,Object>>();
		
//		for(Map<String, Object> proj : projOnList) {
//			map2.put("memNo", proj.get("memNo"));
//			map2.put("projId", proj.get("id"));
//			int cnt = this.projCount(map2);
//			log.info("         cnt" + cnt);
//
//			if(cnt > 1) {
//				proj.put("group", proj.get("id"));
//				projList.add(proj);
//			}else {
//				proj.put("group", 0);
//				projList.add(proj);
//			}
//		}
		
//		return projList;
		return projOnList;
	}
	
	//프로젝트 그룹인지 아닌지 count
	public List<Map<String, Object>> projLogo(String memNo) {
		return this.projectMapper.projLogo(memNo);
	}
	
	//프로젝트 그룹인지 아닌지 count
	public int projCount(Map<String, Object> map) {
		return this.projectMapper.projCount(map);
	}
	
	//시작날에서 하루 지난 프로젝트 상태 신규 -> 진행 자동 바꾸기
	public int changeSTTS() {
		return this.projectMapper.changeSTTS();
	}
	
	//종료날 지난 프로젝트 자동으로 상태 종료로 바꾸기
	public int changeSTTSE() {
		return this.projectMapper.changeSTTSE();
	}
	
	//내가 개설한 프로젝트 중 현재 진행 중인 프로젝트 제목 리스트
	public List<ProjectVO> projMadeByMe(ProjectVO pvo) {
		return this.projectMapper.projMadeByMe(pvo);
	}
	
	
	////////////////////////////////////////////// 대시보드 /////////////////////////////////////////////////
	
	
	//프로젝트 대시보드(메인)
	@Override
	public Map<String, Object> projMain(Map<String, Object> map){
		return this.projectMapper.projMain(map);
	}
	
	//프로젝트 진척도(100%일감 / 전체 일감)
	public Map<String, Object> process(Map<String, Object> map){
		log.info("           진척도map : " + map);
		
		Map<String, Object> process = this.projectMapper.process(map);
		log.info("           진척도process : " + process);
		int done = Integer.parseInt(String.valueOf(process.get("DONE")));
		int alltask = Integer.parseInt(String.valueOf(process.get("ALLTASK")));

		double procPer = ((double)done/alltask) * 100;
		
		if(alltask > 0) {
			process.put("process", String.format("%1.0f%s", procPer, "%"));
		}else {
			process.put("process", "0%");
		}
		return process;
	}
	
	//그룹별 역할 현황
	public MainVO roleStatus(Map<String, Object> map) {
		return this.projectMapper.roleStatus(map);
	}
	
	//그룹 있는데 전체에서 총 인원으로 역할 보여주기
	public MainVO allRoleStatus(int projId) {
		return this.projectMapper.allRoleStatus(projId);
	}
	
	//로드맵
	public List<Map<String, Object>> roadmap(int projId){
		return this.projectMapper.roadmap(projId);
	}
	
	//일감 최근 5개
	@Override
	public List<Map<String, Object>> mainTask(Map<String, Object> map){
		return this.projectMapper.mainTask(map);
	}
	
	//이슈 최근 5개
	@Override
	public List<Map<String, Object>> mainIssue(Map<String, Object> map){
		return this.projectMapper.mainIssue(map);
	}
	
	//공지사항 최근 5개
	@Override
	public List<Map<String, Object>> mainNotice(Map<String, Object> map){
		return this.projectMapper.mainNotice(map);
	}
	
	//일정 최근 4개
	public List<Map<String, Object>> mainCalendar(Map<String, Object> map){
		return this.projectMapper.mainCalendar(map);
	}
	
	//게시판 최근 5개
	public List<Map<String, Object>> mainBrdHelp(Map<String, Object> map){
		return this.projectMapper.mainBrdHelp(map);
	}
	public List<Map<String, Object>> mainBrdFree(Map<String, Object> map){
		return this.projectMapper.mainBrdFree(map);
	}
	
    //문서 최근 5개
	public List<Map<String, Object>> mainDoc(Map<String, Object> map){
		return this.projectMapper.mainDoc(map);
	}
	
	//위키 최근 6개
	public List<Map<String, Object>> mainWiki(int projId){
		return this.projectMapper.mainWiki(projId);
	}
	
	////////////////////////////////////////////// 마이페이지 /////////////////////////////////////////////////
	
	//진행중인 프로젝트 리스트
	@Override
	public List<ProjectVO> projIngList(ProjectVO projectVO){
		return this.projectMapper.projIngList(projectVO);
	}
	
	//진행중인 프로젝트 갯수
	@Override
	public ProjectVO projIngListCnt(ProjectVO projectVO) {
		return this.projectMapper.projIngListCnt(projectVO);
	}
	
	//마감 프로젝트 리스트
	@Override
	public List<ProjectVO> projEndList(ProjectVO projectVO){
		return this.projectMapper.projEndList(projectVO);
	}
	
	//내가 참여하고 진행중인 프로젝트 명 리스트
	@Override
	public List<ProjectVO> mypageProejctList(String memNo){
		return this.projectMapper.mypageProejctList(memNo);
	}
	
	//초대받은 프로젝트 리스트
	@Override
	public List<ProjectVO> inviteProjectList(String memNo){
		return this.projectMapper.inviteProjectList(memNo);
	}
	
	//초대 수락
	@Override
	public int inviteYes(int pmemCd) {
		return this.projectMapper.inviteYes(pmemCd);
	}
	
	//초대 거절
	@Override
	public int inviteNo(int pmemCd) {
		return this.projectMapper.inviteNo(pmemCd);
	}
	
	//promem에는 있는데 profile에는 없을 때 해당 회원을 profile에 넣어줌
	@Override
	public int syncPromemProfile(String projId) {
		return this.projectMapper.syncPromemProfile(projId);
	}
}