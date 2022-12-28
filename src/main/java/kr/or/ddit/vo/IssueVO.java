package kr.or.ddit.vo;

public class IssueVO {

	private String issueNo;
	private String taskNo;
	private String issueType;
	private String issueTtl;
	private String issueCn;
	private String issueStts;
	private int pmemCd;
	private String issueDy;
	private String memNo;
	private String pmemCds;
	private String[] memNoArr;
	
	public String getIssueNo() {
		return issueNo;
	}
	public void setIssueNo(String issueNo) {
		this.issueNo = issueNo;
	}
	public String getTaskNo() {
		return taskNo;
	}
	public void setTaskNo(String taskNo) {
		this.taskNo = taskNo;
	}
	public String getIssueType() {
		return issueType;
	}
	public void setIssueType(String issueType) {
		this.issueType = issueType;
	}
	public String getIssueTtl() {
		return issueTtl;
	}
	public void setIssueTtl(String issueTtl) {
		this.issueTtl = issueTtl;
	}
	public String getIssueCn() {
		return issueCn;
	}
	public void setIssueCn(String issueCn) {
		this.issueCn = issueCn;
	}
	public String getIssueStts() {
		return issueStts;
	}
	public void setIssueStts(String issueStts) {
		this.issueStts = issueStts;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getIssueDy() {
		return issueDy;
	}
	public void setIssueDy(String issueDy) {
		this.issueDy = issueDy;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getPmemCds() {
		return pmemCds;
	}
	public void setPmemCds(String pmemCds) {
		this.pmemCds = pmemCds;
	}
	public String[] getMemNoArr() {
		return memNoArr;
	}
	public void setMemNoArr(String[] memNoArr) {
		this.memNoArr = memNoArr;
	}
	@Override
	public String toString() {
		return "IssueVO [issueNo=" + issueNo + ", taskNo=" + taskNo + ", issueType=" + issueType + ", issueTtl="
				+ issueTtl + ", issueCn=" + issueCn + ", issueStts=" + issueStts + ", pmemCd=" + pmemCd + ", issueDy="
				+ issueDy + ", memNo=" + memNo + ", pmemCds=" + pmemCds + "]";
	}
	
}
