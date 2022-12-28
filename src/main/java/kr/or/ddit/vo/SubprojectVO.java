package kr.or.ddit.vo;

public class SubprojectVO {

	private String sprojTtl;
	private int projId;
	private int cnt;
	private String newTtl;
	private String memNo;
	
	public String getSprojTtl() {
		return sprojTtl;
	}
	public void setSprojTtl(String sprojTtl) {
		this.sprojTtl = sprojTtl;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getNewTtl() {
		return newTtl;
	}
	public void setNewTtl(String newTtl) {
		this.newTtl = newTtl;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	@Override
	public String toString() {
		return "SubprojectVO [sprojTtl=" + sprojTtl + ", projId=" + projId + ", cnt=" + cnt + ", newTtl=" + newTtl
				+ ", memNo=" + memNo + "]";
	}
	
	
	
}
