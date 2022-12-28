package kr.or.ddit.vo;

import java.util.Date;


public class AlertVO {

	private int altNo   ;
	private String memNo   ;
	private String altCn   ;
	private Date altTm   ;
	private String altSend ;
	private String altStts ;
	private String altPhoto;
	private String altSendNm;
	private int cnt;
	private String altCheck;
	private String altCnNotnull;
	private String altLink;
	public String getAltLink() {
		return altLink;
	}
	public void setAltLink(String altLink) {
		this.altLink = altLink;
	}
	public int getAltNo() {
		return altNo;
	}
	public void setAltNo(int altNo) {
		this.altNo = altNo;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getAltCn() {
		return altCn;
	}
	public void setAltCn(String altCn) {
		this.altCn = altCn;
	}
	public Date getAltTm() {
		return altTm;
	}
	public void setAltTm(Date altTm) {
		this.altTm = altTm;
	}
	public String getAltSend() {
		return altSend;
	}
	public void setAltSend(String altSend) {
		this.altSend = altSend;
	}
	public String getAltStts() {
		return altStts;
	}
	public void setAltStts(String altStts) {
		this.altStts = altStts;
	}
	@Override
	public String toString() {
		return "AlertVO [altNo=" + altNo + ", memNo=" + memNo + ", altCn=" + altCn + ", altTm=" + altTm + ", altSend="
				+ altSend + ", altStts=" + altStts + "]";
	}
	public String getAltPhoto() {
		return altPhoto;
	}
	public void setAltPhoto(String altPhoto) {
		this.altPhoto = altPhoto;
	}
	public String getAltSendNm() {
		return altSendNm;
	}
	public void setAltSendNm(String altSendNm) {
		this.altSendNm = altSendNm;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getAltCheck() {
		return altCheck;
	}
	public void setAltCheck(String altCheck) {
		this.altCheck = altCheck;
	}
	public String getAltCnNotnull() {
		return altCnNotnull;
	}
	public void setAltCnNotnull(String altCnNotnull) {
		this.altCnNotnull = altCnNotnull;
	}
	
	
}
