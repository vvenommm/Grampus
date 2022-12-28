package kr.or.ddit.vo;

public class PlanVO {
	
	private String planId;
	private String planTtl;
	private int planPrice;
	public String getPlanId() {
		return planId;
	}
	public void setPlanId(String planId) {
		this.planId = planId;
	}
	public String getPlanTtl() {
		return planTtl;
	}
	public void setPlanTtl(String planTtl) {
		this.planTtl = planTtl;
	}
	public int getPlanPrice() {
		return planPrice;
	}
	public void setPlanPrice(int planPrice) {
		this.planPrice = planPrice;
	}
	@Override
	public String toString() {
		return "PlanVO [planId=" + planId + ", planTtl=" + planTtl + ", planPrice=" + planPrice + ", planExdate=" + "]";
	}
	
}
