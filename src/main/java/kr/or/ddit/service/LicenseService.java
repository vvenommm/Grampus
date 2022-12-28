package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.LicenseVO;

public interface LicenseService {

	public List<LicenseVO> licenseList(String memNo);

	public int licenseInsert(LicenseVO licenseVO);

	public int licenseDelete(int liceNo);

	public List<LicenseVO> licenseList2(String memNo);

}
