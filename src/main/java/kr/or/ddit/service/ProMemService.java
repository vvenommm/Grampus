package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ProMemVO;

public interface ProMemService {
	//프로젝트 생성시 관리자 등록
	public int projAdmin(Map<String, Object> map);
	
	//프로젝트 멤버 권한 변경
	public int updateRole(ProMemVO vo);

	//내가 pm인지 아닌지 구분하려고
	public ProMemVO iAmPm(ProMemVO vo);

	//pmemCd 구하기
	public ProMemVO pmem(ProMemVO vo);
	
	//초대장 받은 후에 회원 등록하기
	public int joinProjfromInvi(ProMemVO pvo);

	//초대장 보낼 때 이미 참여 중인지 확인하기
	public int isAlreadyMem(ProMemVO pvo);
	
	//그룹 추가하면서 pm을 해당 그룹에 배정하는 insert
	public int newGrp(ProMemVO pvo);
	
	//그룹 추가해서 pm insert 하고나서 바로 쓸 select
	public ProMemVO newGrpSelect(ProMemVO pvo);

	//그룹을 추가하면서 '전체'에서 다 미정으로 바꾸기
	public int grpToUngrp(int projId);
	
	//그룹 '미정'에서 배정한 그룹으로 바꾸기
	public int ungrpToGrp(ProMemVO pvo);
	
	//그룹 미정 잇는지 아닌지
	public int isThereUngrp(int projId);
	
	//그룹 생성 후 참여 중인 멤버 그룹 배정하기
	public int newMemIntoGrp(ProMemVO pvo);
	
	//그룹에 넣었으면 그 값 다시 select
	public ProMemVO afterNewMem(ProMemVO pvo);

	//그룹에서 내보내기
	public int getOutFromGrp(ProMemVO pvo);
	
	//프로젝트 관리자 구하기
	public String getProjAdmin(int projId);
	
	//프로젝트 그룹 맴버 검색
	public List<Map<String, Object>> projGrpSearch(Map<String, Object> map);

	public int inviJoining(ProMemVO pvo);
}
