package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class LicenseVO {

	private int liceNo;
	private String memNo;
	private String liceNm;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date liceIsdy;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date liceExdy;
	private String liceFrom;
	private String liceSm;
	public int getLiceNo() {
		return liceNo;
	}
	public void setLiceNo(int liceNo) {
		this.liceNo = liceNo;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getLiceNm() {
		return liceNm;
	}
	public void setLiceNm(String liceNm) {
		this.liceNm = liceNm;
	}
	public Date getLiceIsdy() {
		return liceIsdy;
	}
	public void setLiceIsdy(Date liceIsdy) {
		this.liceIsdy = liceIsdy;
	}
	public Date getLiceExdy() {
		return liceExdy;
	}
	public void setLiceExdy(Date liceExdy) {
		this.liceExdy = liceExdy;
	}
	public String getLiceFrom() {
		return liceFrom;
	}
	public void setLiceFrom(String liceFrom) {
		this.liceFrom = liceFrom;
	}
	public String getLiceSm() {
		return liceSm;
	}
	public void setLiceSm(String liceSm) {
		this.liceSm = liceSm;
	}
}
