package kr.or.ddit.vo;

public class MainVO {
	private String roleId;
	private String roleNm;
	private String memNo;
	private String memNm;
	private int projId;
	private int cnt;
	private String pmemRsvp;
	//직책
	private int pm;
	private int pl;
	private int ta;
	private int aa;
	private int ua;
	private int da;
	//프로젝트
	private int ingproject;
	private int endproject;
	//히스토리
	private int hiscnt;
	private String myhisdate;
	private String hisdatemy;
	
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getMemNm() {
		return memNm;
	}
	public void setMemNm(String memNm) {
		this.memNm = memNm;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public int getPm() {
		return pm;
	}
	public void setPm(int pm) {
		this.pm = pm;
	}
	public int getPl() {
		return pl;
	}
	public void setPl(int pl) {
		this.pl = pl;
	}
	public int getTa() {
		return ta;
	}
	public void setTa(int ta) {
		this.ta = ta;
	}
	public int getAa() {
		return aa;
	}
	public void setAa(int aa) {
		this.aa = aa;
	}
	public int getUa() {
		return ua;
	}
	public void setUa(int ua) {
		this.ua = ua;
	}
	public int getDa() {
		return da;
	}
	public void setDa(int da) {
		this.da = da;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getPmemRsvp() {
		return pmemRsvp;
	}
	public void setPmemRsvp(String pmemRsvp) {
		this.pmemRsvp = pmemRsvp;
	}
	public int getIngproject() {
		return ingproject;
	}
	public void setIngproject(int ingproject) {
		this.ingproject = ingproject;
	}
	public int getEndproject() {
		return endproject;
	}
	public void setEndproject(int endproject) {
		this.endproject = endproject;
	}
	public int getHiscnt() {
		return hiscnt;
	}
	public void setHiscnt(int hiscnt) {
		this.hiscnt = hiscnt;
	}
	public String getMyhisdate() {
		return myhisdate;
	}
	public void setMyhisdate(String myhisdate) {
		this.myhisdate = myhisdate;
	}
	public String getHisdatemy() {
		return hisdatemy;
	}
	public void setHisdatemy(String hisdatemy) {
		this.hisdatemy = hisdatemy;
	}
	@Override
	public String toString() {
		return "MainVO [roleId=" + roleId + ", roleNm=" + roleNm + ", memNo=" + memNo + ", memNm=" + memNm + ", projId="
				+ projId + ", cnt=" + cnt + ", pmemRsvp=" + pmemRsvp + ", pm=" + pm + ", pl=" + pl + ", ta=" + ta
				+ ", aa=" + aa + ", ua=" + ua + ", da=" + da + ", ingproject=" + ingproject + ", endproject="
				+ endproject + ", hiscnt=" + hiscnt + ", myhisdate=" + myhisdate + ", hisdatemy=" + hisdatemy + "]";
	}
	
	
}
