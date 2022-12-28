package kr.or.ddit.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ProMemMapper;
import kr.or.ddit.mapper.ProfileMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.vo.ProMemVO;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class ProMemServiceImpl implements ProMemService{
	@Autowired
	ProMemMapper proMemMapper;
	@Inject
	ProfileMapper profMapper;
	
	//프로젝트 생성시 관리자 등록
	@Override
	public int projAdmin(Map<String, Object> map) {
		
		
		//트랜잭션으로 묶이는 부분
		try {
			return proMemMapper.projAdmin(map);
		} catch (PersistenceException | SQLException e) {
			// TODO Auto-generated catch block
			log.error(e.getMessage(), e);
			return 0;
		}
	}

	//프로젝트 멤버 권한 변경
	@Override
	public int updateRole(ProMemVO vo) {
		return proMemMapper.updateRole(vo);
	}

	//내가 pm인지 아닌지 구분하려고
	@Override
	public ProMemVO iAmPm(ProMemVO vo){
		return this.proMemMapper.iAmPm(vo);
	}

	//pmemCd 구하기
	@Override
	public ProMemVO pmem(ProMemVO vo) {
		return this.proMemMapper.pmem(vo);
	}

	//초대장 받은 후에 회원 등록하기
	@Override
	public int joinProjfromInvi(ProMemVO pvo) {
		return this.proMemMapper.joinProjfromInvi(pvo);
	}
	
	//초대장 보낼 때 이미 참여 중인지 확인하기
	@Override
	public int isAlreadyMem(ProMemVO pvo) {
		return this.proMemMapper.isAlreadyMem(pvo);
	}
	
	//그룹 추가하면서 pm을 해당 그룹에 배정하는 insert
	@Override
	public int newGrp(ProMemVO pvo) {
		return this.proMemMapper.newGrp(pvo);
	}
	
	//그룹 추가해서 pm insert 하고나서 바로 쓸 select
	@Override
	public ProMemVO newGrpSelect(ProMemVO pvo) {
		return this.proMemMapper.newGrpSelect(pvo);
	}
	
	//그룹을 추가하면서 '전체'에서 다 미정으로 바꾸기
	public int grpToUngrp(int projId) {
		return this.proMemMapper.grpToUngrp(projId);
	}
	
	//그룹 '미정'에서 배정한 그룹으로 바꾸기
	public int ungrpToGrp(ProMemVO pvo) {
		return this.proMemMapper.ungrpToGrp(pvo);
	}
	
	//그룹 미정 잇는지 아닌지
	public int isThereUngrp(int projId) {
		return this.proMemMapper.isThereUngrp(projId);
	}
	
	//그룹 생성 후 참여 중인 멤버 그룹 배정하기
	@Override
	public int newMemIntoGrp(ProMemVO pvo) {
		return this.proMemMapper.newMemIntoGrp(pvo);
	}
	
	//그룹에 넣었으면 그 값 다시 select
	@Override
	public ProMemVO afterNewMem(ProMemVO pvo) {
		return this.proMemMapper.afterNewMem(pvo);
	}

	//그룹에서 내보내기
	@Override
	public int getOutFromGrp(ProMemVO pvo) {
		return this.proMemMapper.getOutFromGrp(pvo);
	}

	//프로젝트 관리자 구하기
	@Override
	public String getProjAdmin(int projId) {
		return this.proMemMapper.getProjAdmin(projId);
	};
	
	//프로젝트 그룹 맴버 검색
	@Override
	public List<Map<String, Object>> projGrpSearch(Map<String, Object> map){
		return this.proMemMapper.projGrpSearch(map);
	};
	
	@Override
	public int inviJoining(ProMemVO pvo) {
		int res = this.proMemMapper.inviJoining(pvo);
		if(res > 0) {
			this.profMapper.inviJoining(pvo);
		}
		return res;
	}
}
