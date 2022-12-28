package kr.or.ddit.vo;

import java.util.Date;

public class QNAVO {

	private String qnaNo;
	private String memNo;
	private String qnaTtl;
	private String qnaCn;
	private Date qnaDy;
	private String qnaPw;
	private String qnaReply;
	private String qnaNim;
	
	private String adminId;
	private int rownum;
	
	public String getQnaNo() {
		return qnaNo;
	}
	public void setQnaNo(String qnaNo) {
		this.qnaNo = qnaNo;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getQnaTtl() {
		return qnaTtl;
	}
	public void setQnaTtl(String qnaTtl) {
		this.qnaTtl = qnaTtl;
	}
	public String getQnaCn() {
		return qnaCn;
	}
	public void setQnaCn(String qnaCn) {
		this.qnaCn = qnaCn;
	}
	public Date getQnaDy() {
		return qnaDy;
	}
	public void setQnaDy(Date qnaDy) {
		this.qnaDy = qnaDy;
	}
	public String getQnaPw() {
		return qnaPw;
	}
	public void setQnaPw(String qnaPw) {
		this.qnaPw = qnaPw;
	}
	public String getQnaReply() {
		return qnaReply;
	}
	public void setQnaReply(String qnaReply) {
		this.qnaReply = qnaReply;
	}
	public String getAdminId() {
		return adminId;
	}
	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}
	public String getQnaNim() {
		return qnaNim;
	}
	public void setQnaNim(String qnaNim) {
		this.qnaNim = qnaNim;
	}
	@Override
	public String toString() {
		return "QNAVO [qnaNo=" + qnaNo + ", memNo=" + memNo + ", qnaTtl=" + qnaTtl + ", qnaCn=" + qnaCn + ", qnaDy="
				+ qnaDy + ", qnaPw=" + qnaPw + ", qnaReply=" + qnaReply + ", qnaNim=" + qnaNim + ", adminId=" + adminId
				+ "]";
	}
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	
}
