<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script src="/resources/js/jquery-3.6.0.js"></script>
<script>
$(function(){
/////////////////
/* 구인공고 상태(모집중, 마감) */
var dateVal = new Date();
var year = dateVal.getYear().toString().substring(1);
var month = dateVal.getMonth().toString();
if(month.length < 2){
	month = "0"	 + month;
}
var day = dateVal.getDay().toString();
if(day.length < 2){
	day = "0" + day;
}
var today = year + "/" + month + "/" + day;


var edyVal = "${jobVal.get('JOB_EDY2')}";
console.log(edyVal);
var eyear = edyVal.substr(0, 4);
console.log(eyear);
var emonth = edyVal.substr(5, 2);
if(emonth.length < 2){
	emonth = "0" + emonth;
}
console.log(emonth);
var eday = edyVal.substr(8, 2);
if(eday.length < 2){
	eday = "0" + eday;
}
console.log(eday);
var edate = eyear.substr(2, 2) + "/" + emonth + "/" + eday;

if(edate>=today){
	$("#jobStat").text("모집중");
	$("#jobStat").attr("class","badge rounded-pill bg-primary fs-12");
}else{
	$("#jobStat").text("마감");
	$("#jobStat").attr("class","badge rounded-pill bg-danger fs-12");
	$("#jobSubmit").attr("disabled",true);
}

//////////////////////////
/* 예상기간 구하기 */
var stDate = new Date();
var edDate = new Date("${projVal.get('PROJ_EDY')}");
var calDate = Math.ceil((edDate.getTime()-stDate.getTime())/(1000*3600*24));
if(calDate<0){
	calDate = 0;
}
$("#totalper").text(calDate + "일");

///////////////////////////
/* 목록으로 돌아가기 */	
$("#backList").on("click",function(){
	history.back();
});

/////////////////////////
/* 공고 지원하기 */
$("#jobSubmit").on("click",function(){
	
	if(${resume} == 0){
		Swal.fire({
	        text: "내 정보를 추가해주세요.",
	        icon : 'error',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        confirmButtonText: '마이페이지로 이동',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
				location.href="mypage/myPageMain?memNo=${memNo}";
	        } else  (
                result.dismiss === Swal.DismissReason.cancel
            )
	    });
		
	}else{
		$.ajax({
			url:"/applicant/appliInsert?projId=${param.projId}",
			type:"get",
			success:function(res){
					console.log(res);
				if(res.promemChk > 0){
					Swal.fire({
	                    text: '이미 참여 중인 프로젝트입니다.',
	                    imageUrl: '/resources/image/alertLogo.png',
	                    imageHeight: 25,
	                    confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
	                    buttonsStyling: false,
	                    showCloseButton: true
	              	})
					return;
				}
				if(res.res > 0){
	                Swal.fire({
	                    text: '이미 지원한 프로젝트 입니다.',
	                    imageUrl: '/resources/image/alertLogo.png',
	                    imageHeight: 25,
	                    confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
	                    buttonsStyling: false,
	                    showCloseButton: true
	              })
	
				}
					
				if(res.promemChk == 0 && res.res == 0 && res.insert == 1){
				 Swal.fire({
	                    text: '지원 완료! 내 대시보드를 전송하였습니다.',
	                    icon: 'success',
	                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
	                    buttonsStyling: false,
	                    showCloseButton: true
	             })
				}
			}
		});
	}
});
});
</script>

<div class="page-content">
	<div class="row">
      <div class="col-12">
          <div class= "page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/jobList'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item">GRAMPUS</li>
                      <li class="breadcrumb-item active">JOBS</li>
                  </ol>
              </div>
          </div>
      </div>
  </div>
	<div class="row">
	    <div class="col-lg-12">
	        <div class="tab-content text-muted">
	            <div class="tab-pane fade show active" id="project-overview" role="tabpanel">
	                <div class="row">
	                    <div class="col-lg-12">
	                        <div class="card">
	                            <div class="card-body">
	                                <div class="text-muted">
	                                	<h4 class="fw-bold"><span id="jobStat"></span>&nbsp;&nbsp;&nbsp;${projVal.get('PROJ_TTL')}</h4>
	                                    <div class="pt-3 border-top border-top-dashed mt-4">
	                                        <div class="row">
	                                            <div class="col-lg-3 col-sm-6">
	                                                <div>
	                                                    <p class="mb-2 text-uppercase fw-medium fs-13">등록일자</p>
	                                					<h5 class="fs-15 mb-0"><fmt:formatDate pattern="yyyy.MM.dd" value="${jobVal.get('JOB_WDY')}"/></h5>
	                                                </div>
	                                            </div>
	                                            <div class="col-lg-3 col-sm-6">
	                                                <div>
	                                                    <p class="mb-2 text-uppercase fw-medium fs-13">마감일자</p>
	                                                    <h5 class="fs-15 mb-0"><fmt:formatDate pattern="yyyy.MM.dd" value="${jobVal.get('JOB_EDY')}"/></h5>
	                                                </div>
	                                            </div>
	                                            <div class="col-lg-3 col-sm-6">
	                                            	<div>
	                                                    <p class="mb-2 text-uppercase fw-medium fs-13">모집인원</p>
	                                                    <h5 class="fs-15 mb-0">${jobVal.get('JOB_RECRU')}명</h5>
	                                                </div>
	                                            </div>
	                                            <div class="col-lg-3 col-sm-6">
	                                            	<div>
	                                                    <p class="mb-2 text-uppercase fw-medium fs-13">지원자수</p>
	                                                    <h5 class="fs-15 mb-0">${jobVal.get('JOB_VOLCNT')}명</h5>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	                                    <div class="pt-3 border-top border-top-dashed mt-4">
	                                        <div class="row">
	                                            <div class="col-lg-3 col-sm-6">
	                                                <div>
                                                  		<p class="mb-2 text-uppercase fw-medium fs-13">초급</p>
                                                  		<c:set var="flag1" value="false" />
                                        				<c:forEach var="clist" items="${costVal}" varStatus="stat">
                                        					<c:if test="${not flag1}">
	                                        					<c:choose>
				                                					<c:when test="${clist.get('COST_LV') eq '초급'}">
																		<c:set var="flag1" value="true" />		                                					
																		<h5 class="fs-15 mb-0">&#8361;${clist.get("COST_PAY")}</h5>
				                                					</c:when>
				                                					<c:when test="${stat.last}">
																		<h5 class="fs-15 mb-0">내역 없음</h5>		                                					
				                                					</c:when>
			                                					</c:choose>
		                                					</c:if>
			                                            </c:forEach>
	                                                </div>
	                                            </div>
	                                            <div class="col-lg-3 col-sm-6">
	                                                <div>
                                                  		<p class="mb-2 text-uppercase fw-medium fs-13">중급</p>
                                        				<c:set var="flag2" value="false" />
                                        				<c:forEach var="clist" items="${costVal}" varStatus="stat">
                                        					<c:if test="${not flag2}">
	                                        					<c:choose>
				                                					<c:when test="${clist.get('COST_LV') eq '중급'}">
																		<c:set var="flag2" value="true" />		                                					
																		<h5 class="fs-15 mb-0">&#8361;${clist.get("COST_PAY")}</h5>
				                                					</c:when>
				                                					<c:when test="${stat.last}">
																		<h5 class="fs-15 mb-0">내역 없음</h5>		                                					
				                                					</c:when>
			                                					</c:choose>
		                                					</c:if>
			                                            </c:forEach>
	                                                </div>
	                                            </div>
	                                            <div class="col-lg-3 col-sm-6">
	                                                <div>
                                                  		<p class="mb-2 text-uppercase fw-medium fs-13">고급</p>
                                        				<c:set var="flag3" value="false" />
                                        				<c:forEach var="clist" items="${costVal}" varStatus="stat">
                                        					<c:if test="${not flag3}">
	                                        					<c:choose>
				                                					<c:when test="${clist.get('COST_LV') eq '고급'}">
																		<c:set var="flag3" value="true" />		                                					
																		<h5 class="fs-15 mb-0">&#8361;${clist.get("COST_PAY")}</h5>
				                                					</c:when>
				                                					<c:when test="${stat.last}">
																		<h5 class="fs-15 mb-0">내역 없음</h5>		                                					
				                                					</c:when>
			                                					</c:choose>
		                                					</c:if>
			                                            </c:forEach>
	                                                </div>
	                                            </div>
	                                            <div class="col-lg-3 col-sm-6">
	                                                <div>
	                                                    <p class="mb-2 text-uppercase fw-medium fs-13">기술분야</p>
						                                <c:forEach items="${jobTech}" var="jVal">
						                                    <span class="badge badge-soft-primary badge-border">${jVal}</span>
					                                    </c:forEach>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                            <!-- end card body -->
	                        </div>
	                        <!-- end card -->
	                        <div class="card">
	                            <div class="card-body">
	                                <div class="text-muted">
	                                    <div>
	                                        <div class="row">
                                                <div>
                                                    <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 내용</p>
                                					<h5 class="fs-15 mb-0">${projVal.get("PROJ_CN")}</h5>
                                                </div>
	                                        </div>
	                                    </div>
	                                    <div class="pt-3 border-top border-top-dashed mt-4">
	                                        <div class="row">
                                                <div>
                                                    <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 공고 내용</p>
                                					<h5 class="fs-15 mb-0">${jobVal.get("JOB_CN")}</h5>
                                                </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                            <!-- end card body -->
	                        </div>
	                        <!-- end card -->
                            <div class="row g-4 mb-3">
						        <div class="col-sm">
						        	<c:if test="${!empty id}">
						        		<p class="text-muted" style="text-align:center;" >단, 공고 지원 시 내 대시보드가 포트폴리오로 제출됩니다.</p>
						        	</c:if>
						            <div class="d-flex justify-content-sm-center gap-2">
						            	<c:if test="${!empty id}">
						               		<button type="button" id="jobSubmit" class="btn btn-outline-primary waves-effect">공고지원</button>
						            	</c:if>
						            </div>
						        </div>
					        </div>
		
	                        <!-- end card -->
	                    </div>
	                    <!-- ene col -->
	                </div>
	                <!-- end row -->
	            </div>
	            <!-- end tab pane -->
	        </div>
	    </div>
	    <!-- end col -->
	</div>
	<!-- end row -->
</div>