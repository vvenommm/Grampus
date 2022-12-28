package kr.or.ddit.vo;

import java.util.Date;

public class JobVO {

	private int projId;
	private String jobCn;
	private Date jobWdy;
	private Date jobEdy;
	private int jobVolcnt;
	private int jobRecru;
	private String jobTech;
	private String memNo;
	private String projTtl;
	private String cnt;
	private String enddate;
	private String projCn;
	private String projBgt;
	private String projStts;
	private int dday;
	private String scon;
	
	public String getProjCn() {
		return projCn;
	}
	public void setProjCn(String projCn) {
		this.projCn = projCn;
	}
	public String getProjBgt() {
		return projBgt;
	}
	public void setProjBgt(String projBgt) {
		this.projBgt = projBgt;
	}
	public String getJobTech() {
		return jobTech;
	}
	public void setJobTech(String jobTech) {
		this.jobTech = jobTech;
	}
	public int getJobRecru() {
		return jobRecru;
	}
	public void setJobRecru(int jobRecru) {
		this.jobRecru = jobRecru;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getJobCn() {
		return jobCn;
	}
	public void setJobCn(String jobCn) {
		this.jobCn = jobCn;
	}
	public Date getJobWdy() {
		return jobWdy;
	}
	public void setJobWdy(Date jobWdy) {
		this.jobWdy = jobWdy;
	}
	public Date getJobEdy() {
		return jobEdy;
	}
	public void setJobEdy(Date jobEdy) {
		this.jobEdy = jobEdy;
	}
	public int getJobVolcnt() {
		return jobVolcnt;
	}
	public void setJobVolcnt(int jobVolcnt) {
		this.jobVolcnt = jobVolcnt;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getCnt() {
		return cnt;
	}
	public void setCnt(String cnt) {
		this.cnt = cnt;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public String getProjStts() {
		return projStts;
	}
	public void setProjStts(String projStts) {
		this.projStts = projStts;
	}
	public int getDday() {
		return dday;
	}
	public void setDday(int dday) {
		this.dday = dday;
	}
	public String getScon() {
		return scon;
	}
	public void setScon(String scon) {
		this.scon = scon;
	}
	
}
