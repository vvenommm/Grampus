package kr.or.ddit.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.LicenseMapper;
import kr.or.ddit.service.LicenseService;
import kr.or.ddit.vo.LicenseVO;

@Service
public class LicenseServiceImpl implements LicenseService{

	@Autowired
	LicenseMapper licensMapper;
	
	//자격증 조회  수정용
	@Override
	public List<LicenseVO> licenseList(String memNo){
		return this.licensMapper.licenseList(memNo);
	}
	
	//자격증 등록
	@Override
	public int licenseInsert(LicenseVO licenseVO) {
		if(licenseVO.getLiceExdy()==null) {
			String day = "2099-12-31";
			licenseVO.setLiceExdy(java.sql.Date.valueOf(day));
		}
		return this.licensMapper.licenseInsert(licenseVO);
	}
	
	@Override
	//자격증 삭제
	public int licenseDelete(int liceNo) {
		return this.licensMapper.licenseDelete(liceNo);
	}
	
	//자격증 리스트 조회용
	@Override
	public List<LicenseVO> licenseList2(String memNo){
		return this.licensMapper.licenseList2(memNo);
	}
}
