package kr.or.ddit.vo;

import java.util.Date;

public class ReplyVO{

	private String rplNo;
	private String brdNo;
	private String rplCn;
	private Date rplDy;
	
	private String profNm;
	private String profPhoto;
	private int projId;
	private String memId;
	private int cnt;
	private String pmemCd;
	private String memNo;
	private String pmemGrp;
	
	public String getRplNo() {
		return rplNo;
	}
	public void setRplNo(String rplNo) {
		this.rplNo = rplNo;
	}
	public String getBrdNo() {
		return brdNo;
	}
	public void setBrdNo(String brdNo) {
		this.brdNo = brdNo;
	}
	public String getRplCn() {
		return rplCn;
	}
	public void setRplCn(String rplCn) {
		this.rplCn = rplCn;
	}
	public Date getRplDy() {
		return rplDy;
	}
	public void setRplDy(Date rplDy) {
		this.rplDy = rplDy;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(String pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	@Override
	public String toString() {
		return "ReplyVO [rplNo=" + rplNo + ", brdNo=" + brdNo + ", rplCn=" + rplCn + ", rplDy=" + rplDy + ", profNm="
				+ profNm + ", projId=" + projId + ", memId=" + memId + ", cnt=" + cnt + ", pmemCd=" + pmemCd
				+ ", memNo=" + memNo + ", pmemGrp=" + pmemGrp + "]";
	}
	public String getProfPhoto() {
		return profPhoto;
	}
	public void setProfPhoto(String profPhoto) {
		this.profPhoto = profPhoto;
	}
	
	
}
