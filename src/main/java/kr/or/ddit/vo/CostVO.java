package kr.or.ddit.vo;

import java.sql.Date;

public class CostVO {

	private String costLv;
	private int projId;
	private int costPcnt;
	private long costPay;
	private String roleId;
	private String projBgt;
	private int cnt;
	private String grade;
	private String projTtl;
	private String mycost;
	private String pmemGrp;
	private String sum;
	private Date projSdy;
	private Date projEdy;
	private int projGigan;
	private String memNm;
	private String month;
	private String monthSum;
	private String pcp;
	private int thisMonth; //이번달
	private int lastMonth; //지난달
	private int llastMonth; //지지난달
	
	
	public int getThisMonth() {
		return thisMonth;
	}
	public void setThisMonth(int thisMonth) {
		this.thisMonth = thisMonth;
	}
	public int getLastMonth() {
		return lastMonth;
	}
	public void setLastMonth(int lastMonth) {
		this.lastMonth = lastMonth;
	}
	public int getLlastMonth() {
		return llastMonth;
	}
	public void setLlastMonth(int llastMonth) {
		this.llastMonth = llastMonth;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getProjBgt() {
		return projBgt;
	}
	public void setProjBgt(String projBgt) {
		this.projBgt = projBgt;
	}
	public String getCostLv() {
		return costLv;
	}
	public void setCostLv(String costLv) {
		this.costLv = costLv;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public int getCostPcnt() {
		return costPcnt;
	}
	public void setCostPcnt(int costPcnt) {
		this.costPcnt = costPcnt;
	}
	public long getCostPay() {
		return costPay;
	}
	public void setCostPay(long costPay) {
		this.costPay = costPay;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getMycost() {
		return mycost;
	}
	public void setMycost(String mycost) {
		this.mycost = mycost;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public String getSum() {
		return sum;
	}
	public void setSum(String sum) {
		this.sum = sum;
	}
	public int getProjGigan() {
		return projGigan;
	}
	public void setProjGigan(int projGigan) {
		this.projGigan = projGigan;
	}
	public String getMemNm() {
		return memNm;
	}
	public void setMemNm(String memNm) {
		this.memNm = memNm;
	}
	public Date getProjEdy() {
		return projEdy;
	}
	public void setProjEdy(Date projEdy) {
		this.projEdy = projEdy;
	}
	public Date getProjSdy() {
		return projSdy;
	}
	public void setProjSdy(Date projSdy) {
		this.projSdy = projSdy;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getMonthSum() {
		return monthSum;
	}
	public void setMonthSum(String monthSum) {
		this.monthSum = monthSum;
	}
	public String getPcp() {
		return pcp;
	}
	public void setPcp(String pcp) {
		this.pcp = pcp;
	}
}
