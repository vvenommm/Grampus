package kr.or.ddit.vo;

public class WikiVO {

	private int wikiNo;
	private int projId;
	private String wikiTtl;
	private String wikiCn;
	private int cnt;
	private String sprojTitle;
	private String scon;
	
	private String projTtl;
	private String planTtl;
	
	
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public int getWikiNo() {
		return wikiNo;
	}
	public void setWikiNo(int wikiNo) {
		this.wikiNo = wikiNo;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getWikiTtl() {
		return wikiTtl;
	}
	public void setWikiTtl(String wikiTtl) {
		this.wikiTtl = wikiTtl;
	}
	public String getWikiCn() {
		return wikiCn;
	}
	public void setWikiCn(String wikiCn) {
		this.wikiCn = wikiCn;
	}
	public String getSprojTitle() {
		return sprojTitle;
	}
	public void setSprojTitle(String sprojTitle) {
		this.sprojTitle = sprojTitle;
	}
	public String getScon() {
		return scon;
	}
	public void setScon(String scon) {
		this.scon = scon;
	}
	@Override
	public String toString() {
		return "WikiVO [wikiNo=" + wikiNo + ", projId=" + projId + ", wikiTtl=" + wikiTtl + ", wikiCn=" + wikiCn
				+ ", cnt=" + cnt + ", sprojTitle=" + sprojTitle + ", scon=" + scon + "]";
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getPlanTtl() {
		return planTtl;
	}
	public void setPlanTtl(String planTtl) {
		this.planTtl = planTtl;
	}
	
}
