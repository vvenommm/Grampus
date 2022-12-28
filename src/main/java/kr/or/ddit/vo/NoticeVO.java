package kr.or.ddit.vo;

import java.util.Date;

public class NoticeVO {

	private String ntcNo;
	private int pmemCd;
	private String ntcTtl;
	private String ntcCn;
	private Date ntcDy;
	private int ntcInq;
	//추가 컬럼
	private int projId;
	private String pmemGrp;
	private int cnt;
	private String roleNm;
	
	public String getNtcNo() {
		return ntcNo;
	}
	public void setNtcNo(String ntcNo) {
		this.ntcNo = ntcNo;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getNtcTtl() {
		return ntcTtl;
	}
	public void setNtcTtl(String ntcTtl) {
		this.ntcTtl = ntcTtl;
	}
	public String getNtcCn() {
		return ntcCn;
	}
	public void setNtcCn(String ntcCn) {
		this.ntcCn = ntcCn;
	}
	public Date getNtcDy() {
		return ntcDy;
	}
	public void setNtcDy(Date ntcDy) {
		this.ntcDy = ntcDy;
	}
	public int getNtcInq() {
		return ntcInq;
	}
	public void setNtcInq(int ntcInq) {
		this.ntcInq = ntcInq;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	@Override
	public String toString() {
		return "NoticeVO [ntcNo=" + ntcNo + ", pmemCd=" + pmemCd + ", ntcTtl=" + ntcTtl + ", ntcCn=" + ntcCn
				+ ", ntcDy=" + ntcDy + ", ntcInq=" + ntcInq + ", projId=" + projId + ", pmemGrp=" + pmemGrp + ", cnt="
				+ cnt + "]";
	}
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	
	
	
}
