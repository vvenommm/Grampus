package kr.or.ddit.vo;

import java.util.Date;

public class HistoryVO {
 
	private int projId;
	private String projTtl;
	private String pmemGrp;
	private String memNo;
	private String profNm;

	
	////////// history 원조 멤버 변수 /////////
	private int hisNo;
	private int pmemCd;
	private String hisType;
	private Date hisDate;
	private String hisSe;
	private String hisCn;
	private Object hisKey;
	
	
	////////// task /////////
	private String taskNo;
	private String taskTtl;
	private String taskCn;
	private String taskSdy;
	private String taskEdy;
	private String taskPriority;
	private String taskStts;
	private int taskProgress;
	private String taskParent;
	
	
	////////// issue /////////
	private String issueNo;
	private String issueType;
	private String issueTtl;
	private String issueCn;
	private String issueStts;
	private String issueDy;
	
	
	////////// board /////////
	private String brdNo;
	private String brdHead;
	private String brdTtl;
	private String brdCn;
	private Date brdDy;
	private int brdInq;

	
	////////// Reply /////////
	private String rplNo;
	private String rplCn;
	private Date rplDy;
	
	//////////////////////////////////////////////////////////

	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public int getHisNo() {
		return hisNo;
	}
	public void setHisNo(int hisNo) {
		this.hisNo = hisNo;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getHisType() {
		return hisType;
	}
	public void setHisType(String hisType) {
		this.hisType = hisType;
	}
	public Date getHisDate() {
		return hisDate;
	}
	public void setHisDate(Date hisDate) {
		this.hisDate = hisDate;
	}
	public String getHisSe() {
		return hisSe;
	}
	public void setHisSe(String hisSe) {
		this.hisSe = hisSe;
	}
	public String getHisCn() {
		return hisCn;
	}
	public void setHisCn(String hisCn) {
		this.hisCn = hisCn;
	}
	public Object getHisKey() {
		return hisKey;
	}
	public void setHisKey(Object hisKey) {
		this.hisKey = hisKey;
	}
	public String getTaskNo() {
		return taskNo;
	}
	public void setTaskNo(String taskNo) {
		this.taskNo = taskNo;
	}
	public String getTaskTtl() {
		return taskTtl;
	}
	public void setTaskTtl(String taskTtl) {
		this.taskTtl = taskTtl;
	}
	public String getTaskCn() {
		return taskCn;
	}
	public void setTaskCn(String taskCn) {
		this.taskCn = taskCn;
	}
	public String getTaskSdy() {
		return taskSdy;
	}
	public void setTaskSdy(String taskSdy) {
		this.taskSdy = taskSdy;
	}
	public String getTaskEdy() {
		return taskEdy;
	}
	public void setTaskEdy(String taskEdy) {
		this.taskEdy = taskEdy;
	}
	public String getTaskPriority() {
		return taskPriority;
	}
	public void setTaskPriority(String taskPriority) {
		this.taskPriority = taskPriority;
	}
	public String getTaskStts() {
		return taskStts;
	}
	public void setTaskStts(String taskStts) {
		this.taskStts = taskStts;
	}
	public int getTaskProgress() {
		return taskProgress;
	}
	public void setTaskProgress(int taskProgress) {
		this.taskProgress = taskProgress;
	}
	public String getTaskParent() {
		return taskParent;
	}
	public void setTaskParent(String taskParent) {
		this.taskParent = taskParent;
	}
	public String getIssueNo() {
		return issueNo;
	}
	public void setIssueNo(String issueNo) {
		this.issueNo = issueNo;
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
	public String getIssueDy() {
		return issueDy;
	}
	public void setIssueDy(String issueDy) {
		this.issueDy = issueDy;
	}
	public String getBrdNo() {
		return brdNo;
	}
	public void setBrdNo(String brdNo) {
		this.brdNo = brdNo;
	}
	public String getBrdHead() {
		return brdHead;
	}
	public void setBrdHead(String brdHead) {
		this.brdHead = brdHead;
	}
	public String getBrdTtl() {
		return brdTtl;
	}
	public void setBrdTtl(String brdTtl) {
		this.brdTtl = brdTtl;
	}
	public String getBrdCn() {
		return brdCn;
	}
	public void setBrdCn(String brdCn) {
		this.brdCn = brdCn;
	}
	public Date getBrdDy() {
		return brdDy;
	}
	public void setBrdDy(Date brdDy) {
		this.brdDy = brdDy;
	}
	public int getBrdInq() {
		return brdInq;
	}
	public void setBrdInq(int brdInq) {
		this.brdInq = brdInq;
	}
	public String getRplNo() {
		return rplNo;
	}
	public void setRplNo(String rplNo) {
		this.rplNo = rplNo;
	}
	public String getRplCn() {
		return rplCn;
	}
	public void setRplCn(String rplCn) {
		this.rplCn = rplCn;
	}
	public Date getRplDy() {
		return rplDy;
	}
	public void setRplDy(Date rplDy) {
		this.rplDy = rplDy;
	}
	@Override
	public String toString() {
		return "HistoryVO [projId=" + projId + ", projTtl=" + projTtl + ", pmemGrp=" + pmemGrp + ", memNo=" + memNo
				+ ", profNm=" + profNm + ", hisNo=" + hisNo + ", pmemCd=" + pmemCd + ", hisType=" + hisType
				+ ", hisDate=" + hisDate + ", hisSe=" + hisSe + ", hisCn=" + hisCn + ", hisKey=" + hisKey + ", taskNo="
				+ taskNo + ", taskTtl=" + taskTtl + ", taskCn=" + taskCn + ", taskSdy=" + taskSdy + ", taskEdy="
				+ taskEdy + ", taskPriority=" + taskPriority + ", taskStts=" + taskStts + ", taskProgress="
				+ taskProgress + ", taskParent=" + taskParent + ", issueNo=" + issueNo + ", issueType=" + issueType
				+ ", issueTtl=" + issueTtl + ", issueCn=" + issueCn + ", issueStts=" + issueStts + ", issueDy="
				+ issueDy + ", brdNo=" + brdNo + ", brdHead=" + brdHead + ", brdTtl=" + brdTtl + ", brdCn=" + brdCn
				+ ", brdDy=" + brdDy + ", brdInq=" + brdInq + ", rplNo=" + rplNo + ", rplCn=" + rplCn + ", rplDy="
				+ rplDy + "]";
	}
}
