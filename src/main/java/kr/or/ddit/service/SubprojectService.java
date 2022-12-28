package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.SubprojectVO;

public interface SubprojectService {

	//그룹 잇는지 없는지 select
	public List<SubprojectVO> getGrpList(int projId);
	
	//구인공고 승인할 때 그룹이 있는 프로젝트에서 승인한 사람 그룹 '미정'으로 들어가게
	public int addUngrp(int projId);
	
	//구인공고 승인한 사람 그룹 미정인 사람 없을 때 그룹 없애기
	public int delUngrp(int projId);
	
	//구인공고 승인한 사람 그룹 미정인 사람 없을 때 그룹 없애기
	public int delUngrp2(int projId);
	
	//그룹 미정인 사람 있다고 알려주는 용
	public SubprojectVO ungrpAlert(int projId);

	//그룹 생성하면 insert
	public int addGrp(SubprojectVO spvo);
	
	//그룹명 수정
	public int newSprojTtl(SubprojectVO spvo);
}
