package kr.or.ddit.vo;

import java.util.Date;


public class AttachVO {

	private int battNo;
	private String brdNo;
	private String battNm;
	private int battSz;
	private Date battUlddy;
	private String battSavepath;

	//필요한 컬럼 추가
	private int projId;
	private String pmemGrp;
	
	public int getBattNo() {
		return battNo;
	}
	public void setBattNo(int battNo) {
		this.battNo = battNo;
	}
	public String getBrdNo() {
		return brdNo;
	}
	public void setBrdNo(String brdNo) {
		this.brdNo = brdNo;
	}
	public String getBattNm() {
		return battNm;
	}
	public void setBattNm(String battNm) {
		this.battNm = battNm;
	}
	public int getBattSz() {
		return battSz;
	}
	public void setBattSz(int battSz) {
		this.battSz = battSz;
	}
	public Date getBattUlddy() {
		return battUlddy;
	}
	public void setBattUlddy(Date battUlddy) {
		this.battUlddy = battUlddy;
	}
	public String getBattSavepath() {
		return battSavepath;
	}
	public void setBattSavepath(String battSavepath) {
		this.battSavepath = battSavepath;
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
	@Override
	public String toString() {
		return "AttachVO [battNo=" + battNo + ", brdNo=" + brdNo + ", battNm=" + battNm + ", battSz=" + battSz
				+ ", battUlddy=" + battUlddy + ", battSavepath=" + battSavepath + ", projId=" + projId + ", pmemGrp="
				+ pmemGrp + "]";
	}
	
}
