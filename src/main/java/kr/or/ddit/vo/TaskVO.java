package kr.or.ddit.vo;

public class TaskVO {

	private String taskNo;
	private int projId;
	private String taskTtl;
	private String taskCn;
	private String taskSdy;
	private String taskEdy;
	private String taskPriority;
	private String taskStts;
	private int taskProgress;
	private String taskProgresss;	//임시변수
	private String taskParent;
	private int pmemCd;
	private String pmemCds;			//임시변수
	private String pmemGrp;
	private String profNm;
	private String memNo;
	private String projTtl;
	private int cnt;
	private int allTask;
	private int doneTask;
	private String profPhoto;
	
	public int getAllTask() {
		return allTask;
	}
	public void setAllTask(int allTask) {
		this.allTask = allTask;
	}
	public int getDoneTask() {
		return doneTask;
	}
	public void setDoneTask(int doneTask) {
		this.doneTask = doneTask;
	}
	public String getTaskNo() {
		return taskNo;
	}
	public void setTaskNo(String taskNo) {
		this.taskNo = taskNo;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
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
	public String getTaskProgresss() {
		return taskProgresss;
	}
	public void setTaskProgresss(String taskProgresss) {
		this.taskProgresss = taskProgresss;
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
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getPmemCds() {
		return pmemCds;
	}
	public void setPmemCds(String pmemCds) {
		this.pmemCds = pmemCds;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getProfPhoto() {
		return profPhoto;
	}
	public void setProfPhoto(String profPhoto) {
		this.profPhoto = profPhoto;
	}
	@Override
	public String toString() {
		return "TaskVO [taskNo=" + taskNo + ", projId=" + projId + ", taskTtl=" + taskTtl + ", taskCn=" + taskCn
				+ ", taskSdy=" + taskSdy + ", taskEdy=" + taskEdy + ", taskPriority=" + taskPriority + ", taskStts="
				+ taskStts + ", taskProgress=" + taskProgress + ", taskProgresss=" + taskProgresss + ", taskParent="
				+ taskParent + ", pmemCd=" + pmemCd + ", pmemCds=" + pmemCds + ", pmemGrp=" + pmemGrp + ", profNm="
				+ profNm + ", memNo=" + memNo + ", projTtl=" + projTtl + ", cnt=" + cnt + ", allTask=" + allTask
				+ ", doneTask=" + doneTask + ", profPhoto=" + profPhoto + "]";
	}
	
}
