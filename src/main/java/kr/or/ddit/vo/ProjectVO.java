package kr.or.ddit.vo;

import java.util.Date;

public class ProjectVO {

	private int projId;
	private String payNo;
	private String projStts;
	private String projTtl;
	private String projCn;
	private String projBgt;
	private Date projSdy;
	private Date projEdy;
	private int projLimit;
	private int projParty;
	private String planTtl;
	private String projPhoto;
	private String memNo; 
	private int pmemCd;
	private int cnt;
	private String pmemGrp;
	private String profPhoto;
	private String role;
	private String scon;
	private int listcnt;
	private String brdHead;
	
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getPayNo() {
		return payNo;
	}
	public void setPayNo(String payNo) {
		this.payNo = payNo;
	}
	public String getProjStts() {
		return projStts;
	}
	public void setProjStts(String projStts) {
		this.projStts = projStts;
	}
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
	public String getProjBgt() {
		return projBgt;
	}
	public void setProjBgt(String projBgt) {
		this.projBgt = projBgt;
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
	public int getProjLimit() {
		return projLimit;
	}
	public void setProjLimit(int projLimit) {
		this.projLimit = projLimit;
	}
	public int getProjParty() {
		return projParty;
	}
	public void setProjParty(int projParty) {
		this.projParty = projParty;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}

	public String getProjPhoto() {
		return projPhoto;
	}

	public void setProjPhoto(String projPhoto) {
		this.projPhoto = projPhoto;
	}

	public String getPlanTtl() {
		return planTtl;
	}

	public void setPlanTtl(String planTtl) {
		this.planTtl = planTtl;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public String getProfPhoto() {
		return profPhoto;
	}
	public void setProfPhoto(String profPhoto) {
		this.profPhoto = profPhoto;
	}
	public String getScon() {
		return scon;
	}
	public void setScon(String scon) {
		this.scon = scon;
	}
	public int getListcnt() {
		return listcnt;
	}
	public void setListcnt(int listcnt) {
		this.listcnt = listcnt;
	}
	public String getBrdHead() {
		return brdHead;
	}
	public void setBrdHead(String brdHead) {
		this.brdHead = brdHead;
	}
	@Override
	public String toString() {
		return "ProjectVO [projId=" + projId + ", payNo=" + payNo + ", projStts=" + projStts + ", projTtl=" + projTtl
				+ ", projCn=" + projCn + ", projBgt=" + projBgt + ", projSdy=" + projSdy + ", projEdy=" + projEdy
				+ ", projLimit=" + projLimit + ", projParty=" + projParty + ", planTtl=" + planTtl + ", projPhoto="
				+ projPhoto + ", memNo=" + memNo + ", pmemCd=" + pmemCd + ", cnt=" + cnt + ", pmemGrp=" + pmemGrp
				+ ", profPhoto=" + profPhoto + ", role=" + role + ", scon=" + scon + ", listcnt=" + listcnt
				+ ", brdHead=" + brdHead + "]";
	}
	
	
}
