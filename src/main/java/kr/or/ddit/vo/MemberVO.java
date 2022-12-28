package kr.or.ddit.vo;

public class MemberVO {

	private String memNo;
	private String memId;
	private String memPw;
	private String memNm;
	private String memPhoto;
	private String googlememNo;
	private int cnt;
	
	private String inviCd;
	private int projId;
	private String content;
	
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	public String getMemPw() {
		return memPw;
	}
	public void setMemPw(String memPw) {
		this.memPw = memPw;
	}
	public String getMemNm() {
		return memNm;
	}
	public void setMemNm(String memNm) {
		this.memNm = memNm;
	}
	public String getGooglememNo() {
		return googlememNo;
	}
	public void setGooglememNo(String googlememNo) {
		this.googlememNo = googlememNo;
	}
	public String getMemPhoto() {
		return memPhoto;
	}
	public void setMemPhoto(String memPhoto) {
		this.memPhoto = memPhoto;
	}
	public String getInviCd() {
		return inviCd;
	}
	public void setInviCd(String inviCd) {
		this.inviCd = inviCd;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	@Override
	public String toString() {
		return "MemberVO [memNo=" + memNo + ", memId=" + memId + ", memPw=" + memPw + ", memNm=" + memNm + ", memPhoto="
				+ memPhoto + ", googlememNo=" + googlememNo + ", cnt=" + cnt + ", inviCd=" + inviCd + ", projId="
				+ projId + ", content=" + content + "]";
	}
}
