package kr.or.ddit.vo;

import java.util.Date;

public class PaymentVO {

	private String payNo;
	private String memNo;
	private String prodId;
	private String payMethod;
	private Date paySdy;
	private Date payEdy;
	private String payDeadline;
	private String payStts;
	private int projId;
	private int planId;
	private String planTtl;
	private int planPrice;
	private String memNm;
	private int cnt;
	
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getPayNo() {
		return payNo;
	}
	public void setPayNo(String payNo) {
		this.payNo = payNo;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getProdId() {
		return prodId;
	}
	public void setProdId(String prodId) {
		this.prodId = prodId;
	}
	public String getPayMethod() {
		return payMethod;
	}
	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}
	public Date getPaySdy() {
		return paySdy;
	}
	public void setPaySdy(Date paySdy) {
		this.paySdy = paySdy;
	}
	public Date getPayEdy() {
		return payEdy;
	}
	public void setPayEdy(Date payEdy) {
		this.payEdy = payEdy;
	}
	public String getPayDeadline() {
		return payDeadline;
	}
	public void setPayDeadline(String payDeadline) {
		this.payDeadline = payDeadline;
	}
	public String getPayStts() {
		return payStts;
	}
	public void setPayStts(String payStts) {
		this.payStts = payStts;
	}
	@Override
	public String toString() {
		return "PaymentVO [payNo=" + payNo + ", memNo=" + memNo + ", prodId=" + prodId + ", payMethod=" + payMethod
				+ ", paySdy=" + paySdy + ", payEdy=" + payEdy + ", payDeadline=" + payDeadline + ", payStts=" + payStts
				+ ", projId=" + projId + ", planId=" + planId + ", planTtl=" + planTtl + "]";
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public int getPlanId() {
		return planId;
	}
	public void setPlanId(int planId) {
		this.planId = planId;
	}
	public String getPlanTtl() {
		return planTtl;
	}
	public void setPlanTtl(String planTtl) {
		this.planTtl = planTtl;
	}
	public String getMemNm() {
		return memNm;
	}
	public void setMemNm(String memNm) {
		this.memNm = memNm;
	}
	public int getPlanPrice() {
		return planPrice;
	}
	public void setPlanPrice(int planPrice) {
		this.planPrice = planPrice;
	}
}
