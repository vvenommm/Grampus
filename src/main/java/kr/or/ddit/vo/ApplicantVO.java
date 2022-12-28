package kr.or.ddit.vo;

import java.sql.Date;

public class ApplicantVO extends JobVO{

	private int projId;
	private String memNo;
	private String appYn;
	private String projTtl;
	private String projCn;
	private Date projSdy;
	private Date projEdy;
	private String bgt; //예산
	private int dday;
	private int projGigan;
	
	
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getProjCn() {
		return projCn;
	}
	public void setProjCn(String projCn) {
		this.projCn = projCn;
	}
	public Date getProjSdy() {
		return projSdy;
	}
	public void setProjSdy(Date projSdy) {
		this.projSdy = projSdy;
	}
	public Date getProjEdy() {
		return projEdy;
	}
	public void setProjEdy(Date projEdy) {
		this.projEdy = projEdy;
	}
	public String getBgt() {
		return bgt;
	}
	public void setBgt(String bgt) {
		this.bgt = bgt;
	}
	public int getDday() {
		return dday;
	}
	public void setDday(int dday) {
		this.dday = dday;
	}
	public int getProjGigan() {
		return projGigan;
	}
	public void setProjGigan(int projGigan) {
		this.projGigan = projGigan;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getAppYn() {
		return appYn;
	}
	public void setAppYn(String appYn) {
		this.appYn = appYn;
	}
	
}
