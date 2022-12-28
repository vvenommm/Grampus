package kr.or.ddit.vo;

import java.util.Date;

public class InvitationVO {

	private int invNo;
	private String invEmail;
	private String invCd;
	private int projId;
	private String pmemGrp;
	private Date invDay;
	
	private int expire;
	private String memNo;
	private String memNm;
	private String ttl;
	private String projCn;
	
	public int getInvNo() {
		return invNo;
	}
	public void setInvNo(int invNo) {
		this.invNo = invNo;
	}
	public String getInvEmail() {
		return invEmail;
	}
	public void setInvEmail(String invEmail) {
		this.invEmail = invEmail;
	}
	public String getInvCd() {
		return invCd;
	}
	public void setInvCd(String invCd) {
		this.invCd = invCd;
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
	public Date getInvDay() {
		return invDay;
	}
	public void setInvDay(Date invDay) {
		this.invDay = invDay;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public int getExpire() {
		return expire;
	}
	public void setExpire(int expire) {
		this.expire = expire;
	}
	public String getTtl() {
		return ttl;
	}
	public void setTtl(String ttl) {
		this.ttl = ttl;
	}
	public String getProjCn() {
		return projCn;
	}
	public void setProjCn(String projCn) {
		this.projCn = projCn;
	}
	public String getMemNm() {
		return memNm;
	}
	public void setMemNm(String memNm) {
		this.memNm = memNm;
	}
	@Override
	public String toString() {
		return "InvitationVO [invNo=" + invNo + ", invEmail=" + invEmail + ", invCd=" + invCd + ", projId=" + projId
				+ ", pmemGrp=" + pmemGrp + ", invDay=" + invDay + ", expire=" + expire + ", memNo=" + memNo + ", memNm="
				+ memNm + ", ttl=" + ttl + ", projCn=" + projCn + "]";
	}
}
