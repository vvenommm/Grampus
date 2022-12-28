package kr.or.ddit.vo;

import java.util.Date;

public class ResumeVO {

	private String memNo;
	private String rsmJob;
	private String rsmCareer;
	private Date rsmMdy;
	private String memPhoto;
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getRsmJob() {
		return rsmJob;
	}
	public void setRsmJob(String rsmJob) {
		this.rsmJob = rsmJob;
	}
	public String getRsmCareer() {
		return rsmCareer;
	}
	public void setRsmCareer(String rsmCareer) {
		this.rsmCareer = rsmCareer;
	}
	public Date getRsmMdy() {
		return rsmMdy;
	}
	public void setRsmMdy(Date rsmMdy) {
		this.rsmMdy = rsmMdy;
	}
	public String getMemPhoto() {
		return memPhoto;
	}
	public void setMemPhoto(String memPhoto) {
		this.memPhoto = memPhoto;
	}
	@Override
	public String toString() {
		return "ResumeVO [memNo=" + memNo + ", rsmJob=" + rsmJob + ", rsmCareer=" + rsmCareer + ", rsmMdy=" + rsmMdy
				+ ", memPhoto=" + memPhoto + "]";
	}
	
	
	
}
