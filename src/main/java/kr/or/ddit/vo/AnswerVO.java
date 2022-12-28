package kr.or.ddit.vo;

import java.util.Date;

public class AnswerVO {

	private int ansNo;
	private String issueNo;
	private int pmemCd;
	private String ansCn;
	private Date ansDy;
	private String profNm;
	private String profPhoto;
	
	public int getAnsNo() {
		return ansNo;
	}
	public void setAnsNo(int ansNo) {
		this.ansNo = ansNo;
	}
	public String getIssueNo() {
		return issueNo;
	}
	public void setIssueNo(String issueNo) {
		this.issueNo = issueNo;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getAnsCn() {
		return ansCn;
	}
	public void setAnsCn(String ansCn) {
		this.ansCn = ansCn;
	}
	public Date getAnsDy() {
		return ansDy;
	}
	public void setAnsDy(Date ansDy) {
		this.ansDy = ansDy;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public String getProfPhoto() {
		return profPhoto;
	}
	public void setProfPhoto(String profPhoto) {
		this.profPhoto = profPhoto;
	}
	@Override
	public String toString() {
		return "AnswerVO [ansNo=" + ansNo + ", issueNo=" + issueNo + ", pmemCd=" + pmemCd + ", ansCn=" + ansCn
				+ ", ansDy=" + ansDy + ", profNm=" + profNm + ", profPhoto=" + profPhoto + "]";
	}
	
}
