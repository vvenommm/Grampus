package kr.or.ddit.vo;

import java.util.Date;

public class CalendarVO {

	private String calNo;
	private int pmemCd;
	private Date calSdy;
	private Date calEdy;
	private String calCn;
	private String calGroup;
	private int projId;
	
	public String getCalNo() {
		return calNo;
	}
	public void setCalNo(String calNo) {
		this.calNo = calNo;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public Date getCalSdy() {
		return calSdy;
	}
	public void setCalSdy(Date calSdy) {
		this.calSdy = calSdy;
	}
	public Date getCalEdy() {
		return calEdy;
	}
	public void setCalEdy(Date calEdy) {
		this.calEdy = calEdy;
	}
	public String getCalCn() {
		return calCn;
	}
	public void setCalCn(String calCn) {
		this.calCn = calCn;
	}
	public String getCalGroup() {
		return calGroup;
	}
	public void setCalGroup(String calGroup) {
		this.calGroup = calGroup;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	@Override
	public String toString() {
		return "CalendarVO [calNo=" + calNo + ", pmemCd=" + pmemCd + ", calSdy=" + calSdy + ", calEdy=" + calEdy
				+ ", calCn=" + calCn + ", calGroup=" + calGroup + ", projId=" + projId + "]";
	}
	
}
