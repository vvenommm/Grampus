package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ProMemMapper;
import kr.or.ddit.mapper.SubprojectMapper;
import kr.or.ddit.service.SubprojectService;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.SubprojectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SubprojectServiceImpl implements SubprojectService {

	@Inject
	SubprojectMapper subpMapper;
	
	@Inject
	ProMemMapper promemMapper;
	
	
	
	//그룹 잇는지 없는지 select
	@Override
	public List<SubprojectVO> getGrpList(int projId) {
		return this.subpMapper.getGrpList(projId);
	}
	
	//구인공고 승인할 때 그룹이 있는 프로젝트에서 승인한 사람 그룹 '미정'으로 들어가게
	@Override
	public int addUngrp(int projId) {
		return this.subpMapper.addUngrp(projId);
	}
	
	//구인공고 승인한 사람 그룹 미정인 사람 없을 때 그룹 없애기
	@Override
	public int delUngrp(int projId) {
		return this.subpMapper.delUngrp(projId);
	}
	
	//구인공고 승인한 사람 그룹 미정인 사람 없을 때 그룹 없애기
	@Override
	public int delUngrp2(int projId) {
		return this.subpMapper.delUngrp(projId);
	}

	//그룹 미정인 사람 있다고 알려주는 용
	public SubprojectVO ungrpAlert(int projId) {
		return this.subpMapper.ungrpAlert(projId);
	}

	//그룹 생성하면 insert
	public int addGrp(SubprojectVO spvo) {
		return this.subpMapper.addGrp(spvo);
	}
	
	//그룹명 수정
	public int newSprojTtl(SubprojectVO spvo) {
		log.info("      그룹명 바굴 spvo -> projid, 원래 그룹명, 새 그룹명 --> " + spvo);
		int result = this.subpMapper.newSprojTtl(spvo);
		
		if(result > 0) {
			//해당 그룹인 멤버들도 그룹이름 바꿔주기
			ProMemVO pvo = new ProMemVO();
			pvo.setNewPmemGrp(spvo.getNewTtl());
			pvo.setProjId(spvo.getProjId());
			pvo.setPmemGrp(spvo.getSprojTtl());
			pvo.setMemNo(spvo.getMemNo());
			result = this.promemMapper.ungrpToGrp(pvo);
		}
		return result;
	}
}
