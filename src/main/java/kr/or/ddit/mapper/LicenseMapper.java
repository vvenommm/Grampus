package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.LicenseVO;

public interface LicenseMapper {

	//자격증 조회 수정용
	public List<LicenseVO> licenseList(String memNo);
	
	//자격증 등록
	public int licenseInsert(LicenseVO licenseVO);
	
	//자격증 삭제
	public int licenseDelete(int liceNo);
	
	//자격증 리스트 조회용
	public List<LicenseVO> licenseList2(String memNo);
}
