package kr.or.ddit.vo;

import java.util.Date;

public class ProMemVO {

	private int pmemCd;
	private int projId;
	private String memNo;
	private String roleId;
	private Date pmemIdy;
	private Date pmemOdy;
	private String pmemRsvp;
	private String pmemId;
	private String memId;
	private String roleNm;
	private String pmemGrp;
	private String newPmemGrp;
	private int cnt;
	private int pm;
	private String invCd;
	private String memNm;
	private String profNm;
	private String profPhoto;
	private String pmemIdy2;
	private String pmemOdy2;
	
	
	
	
	public int getPm() {
		return pm;
	}
	public void setPm(int pm) {
		this.pm = pm;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public Date getPmemIdy() {
		return pmemIdy;
	}
	public void setPmemIdy(Date pmemIdy) {
		this.pmemIdy = pmemIdy;
	}
	public Date getPmemOdy() {
		return pmemOdy;
	}
	public void setPmemOdy(Date pmemOdy) {
		this.pmemOdy = pmemOdy;
	}
	public String getPmemRsvp() {
		return pmemRsvp;
	}
	public void setPmemRsvp(String pmemRsvp) {
		this.pmemRsvp = pmemRsvp;
	}
	public String getPmemId() {
		return pmemId;
	}
	public void setPmemId(String pmemId) {
		this.pmemId = pmemId;
	}
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public String getInvCd() {
		return invCd;
	}
	public void setInvCd(String invCd) {
		this.invCd = invCd;
	}
	public String getMemNm() {
		return memNm;
	}
	public void setMemNm(String memNm) {
		this.memNm = memNm;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public String getProfPhoto() {
		return profPhoto;
	}
	public void setProfPhoto(String profPhoto) {
		this.profPhoto = profPhoto;
	}
	public String getPmemIdy2() {
		return pmemIdy2;
	}
	public void setPmemIdy2(String pmemIdy2) {
		this.pmemIdy2 = pmemIdy2;
	}
	public String getPmemOdy2() {
		return pmemOdy2;
	}
	public void setPmemOdy2(String pmemOdy2) {
		this.pmemOdy2 = pmemOdy2;
	}
	public String getNewPmemGrp() {
		return newPmemGrp;
	}
	public void setNewPmemGrp(String newPmemGrp) {
		this.newPmemGrp = newPmemGrp;
	}
	@Override
	public String toString() {
		return "ProMemVO [pmemCd=" + pmemCd + ", projId=" + projId + ", memNo=" + memNo + ", roleId=" + roleId
				+ ", pmemIdy=" + pmemIdy + ", pmemOdy=" + pmemOdy + ", pmemRsvp=" + pmemRsvp + ", pmemId=" + pmemId
				+ ", memId=" + memId + ", roleNm=" + roleNm + ", pmemGrp=" + pmemGrp + ", newPmemGrp=" + newPmemGrp
				+ ", cnt=" + cnt + ", pm=" + pm + ", invCd=" + invCd + ", memNm=" + memNm + ", profNm=" + profNm
				+ ", profPhoto=" + profPhoto + ", pmemIdy2=" + pmemIdy2 + ", pmemOdy2=" + pmemOdy2 + "]";
	}
	

	
}
