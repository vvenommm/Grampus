package kr.or.ddit.vo;

import java.util.Date;

public class DocFileVO {

	private int dcfNo;
	private int docNo;
	private String dcfNm;
	private long dcfSz;
	private String dcfSavepath;
	private Date dcfUlddy;
	private String dcfSe;
	
	public int getDcfNo() {
		return dcfNo;
	}
	public void setDcfNo(int dcfNo) {
		this.dcfNo = dcfNo;
	}
	public int getDocNo() {
		return docNo;
	}
	public void setDocNo(int docNo) {
		this.docNo = docNo;
	}
	public String getDcfNm() {
		return dcfNm;
	}
	public void setDcfNm(String dcfNm) {
		this.dcfNm = dcfNm;
	}
	public long getDcfSz() {
		return dcfSz;
	}
	public void setDcfSz(long dcfSz) {
		this.dcfSz = dcfSz;
	}
	public String getDcfSavepath() {
		return dcfSavepath;
	}
	public void setDcfSavepath(String dcfSavepath) {
		this.dcfSavepath = dcfSavepath;
	}
	public Date getDcfUlddy() {
		return dcfUlddy;
	}
	public void setDcfUlddy(Date dcfUlddy) {
		this.dcfUlddy = dcfUlddy;
	}
	public String getDcfSe() {
		return dcfSe;
	}
	public void setDcfSe(String dcfSe) {
		this.dcfSe = dcfSe;
	}
	@Override
	public String toString() {
		return "DocFileVO [dcfNo=" + dcfNo + ", docNo=" + docNo + ", dcfNm=" + dcfNm + ", dcfSz=" + dcfSz
				+ ", dcfSavepath=" + dcfSavepath + ", dcfUlddy=" + dcfUlddy + ", dcfSe=" + dcfSe + "]";
	}
	
}
