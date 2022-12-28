<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>

<script type="text/javascript">
<% String memNo =(String)session.getAttribute("memNo"); %>

function btnClick(idx){
// 	alert("i : " + idx);
	var projTtl = $("#projTtl"+idx).val();
	var projId = $("#projId"+idx).val();
	var projSdy = $("#projSdy"+idx).text();
	var projEdy = $("#projEdy"+idx).text();
	var dday = $("#dday"+idx).val();
	var projBgt = $("#projBgt"+idx).val();
	var enddate = $("#enddate"+idx).val();
	var projCn = $("#projCn"+idx).val();
	var jobCn = $("#jobCn"+idx).val();
	var jobTech = $("#jobTech"+idx).val();
	
// 	var check = jobTech.toString().split(",");
// 	alert("check : " + check);
	if(dday<0){
		$('#projStts').text('모집마감');
	}else{
		$('#projStts').text('모집중');
	}
		
	$('#projTtl').text(projTtl);
	$('#jobWdy').text(projSdy);
	$('#jobEdy').text(projEdy);
	$('#projBgt').text(projBgt);
	$('#projCn').text(projCn);
	$('#enddate').text(enddate);
	$('#jobCn').text(jobCn);
	$('#jobTech').text(jobTech);
 	$('#markDelete').attr("onclick", "javascript:location.href='/applicant/applicantDelete?projId="+projId+"&memNo=<%=memNo%>'")
	
}

//공고지원취소
function applicantCancel(idx){
	var projId = $('#projId'+idx).val();
	Swal.fire({
        text: "삭제하시겠습니까?",
        icon : 'question',
        showCancelButton: true,
        confirmButtonClass: 'btn btn-outline-primary w-xs me-2 mt-2',
        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
        buttonsStyling: false,
        showCloseButton: true
      }).then(function (result) {
        if (result.value) {
        	location.href = "/applicant/applicantDelete?projId="+projId+"&memNo=<%=memNo%>";
        } else if (
	        // Read more about handling dismissals
            result.dismiss === Swal.DismissReason.cancel
          ) {
            Swal.fire({
              text: '삭제가 취소되었습니다.',
              icon: 'error',
              confirmButtonClass: 'btn btn-outline-danger mt-2',
              buttonsStyling: false
            })
          }
    });

}

$(function(){
	
	$("#seachJob").on("click",function(){
		var cont = $("#seachCon").val();
		location.href = "/applicant/jobApplicantList?cont="+cont+"&memNo=<%=memNo%>";
	});
	
	/* 전체보기 */
	$("#showAll").on("click",function(){
		location.href = "/applicant/jobApplicantList?cont=&memNo=<%=memNo%>";
	}); 
})

 

</script>

    <!-- start page title -->
  <div class="row">
      <div class="col-12">
          <div class="page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/main/myMain'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item">내 대시보드</li>
                      <li class="breadcrumb-item active">공고 지원함</li>
                  </ol>
              </div>

          </div>
      </div>
  </div>
  <!-- end page title -->
   <div class="container-fluid">
   <c:if test="${applicantVOList[0].projTtl!=null}">
    <div class="row g-4 mb-2">
        <div class="col-sm">
            <div class="d-flex justify-content-sm-end gap-2">
           		<a class="btn btn-primary waves-effect" id="showAll">전체보기</a>
                <div class="search-box ms-2">
                    <input type="text" id="seachCon" class="form-control" placeholder="공고 제목 입력" value="${scon}">
                    <i class="ri-search-line search-icon"></i>
                </div>
          		<a class="btn btn-primary waves-effect" id="seachJob">검색</a>
            </div>
        </div>
    </div><br />
    </c:if>
    
    <c:if test="${applicantVOList[0].projTtl==null}">
	 <div class="row justify-content-center">
	    <div class="col-md-8 col-lg-6 col-xl-5">
	            <div class="card-body p-4 text-center">
	                <div class="avatar-lg mx-auto mt-2">
	                    <div class="avatar-title bg-light text-success display-3 rounded-circle">
	                        <i class="ri-inbox-unarchive-line"></i>
	                    </div>
	                </div>
	                <div class="mt-4 pt-2">
	                    <h4>지원공고 내역이 없습니다.</h4>
	                     <div class="mt-4">
                            <a href="javascript:location.href='/jobList'" class="btn btn-soft-success">공고 보러가기</a>
                        </div>
	                </div>
	            </div>
	            <!-- end card body -->
	
	    </div>
	</div>
  </c:if>

<div class="container-fluid">
    <div class="row">
    	<c:forEach var="list" items="${applicantVOList}" varStatus="stat">
	        <!-- 보내줄 값들 숨겨놓고 변수에 저장시키기 
	       	 제목, 등록일자, 마감일자, 프로젝트 상태, 프로젝트 예산, 예상기간, 프로젝트 내용, 구인공고 내용, 기술분야-->
	       	 <input id="projTtl${stat.index}" type="hidden" value="${list.projTtl}" />
	       	 <input  id="projId${stat.index}" type="hidden" value="${list.projId}" />
	       	 <p id="jobWdy${stat.index}" style="display:none;"><fmt:formatDate pattern="yyyy.MM.dd" value="${list.jobWdy}"/></p>
	       	 <p id="jobEdy${stat.index}" style="display:none;"><fmt:formatDate pattern="yyyy.MM.dd" value="${list.jobEdy}"/></p>
	       	 <input id="projStts${stat.index}" type="hidden" value="${list.projStts}" />
	       	 <input id="projBgt${stat.index}" type="hidden" value="${list.projBgt}" />
	       	 <input id="enddate${stat.index}" type="hidden" value="${list.enddate}" />
	       	 <input id="projCn${stat.index}" type="hidden" value="${list.projCn}" />
	       	 <input id="jobCn${stat.index}" type="hidden" value="${list.jobCn}" />
	       	 <input id="jobTech${stat.index}" type="hidden" value="${list.jobTech}" />
	       	 <!-- ----------------- -->
	        <div class="col-xxl-3 col-sm-6 project-card">
	            <div class="card">
	                <div class="card-body">
	                	<c:if test="${list.dday<0}"><div class="p-3 mt-n3 mx-n3 bg-soft-danger rounded-top"></c:if>
		                <c:if test="${list.dday>0}"><div class="p-3 mt-n3 mx-n3 bg-soft-primary rounded-top"></c:if>
	                        <div class="d-flex align-items-center">
	                            <div class="flex-grow-1">
	                                <p class="text-muted mb-1">마감일 : <fmt:formatDate pattern="yyyy.MM.dd" value="${list.jobEdy}"/>&emsp;
	                                	<c:if test="${list.dday>0}"><span id="jobStat" class="badge rounded-pill bg-primary fs-12">모집중</span>&nbsp;<span class="badge rounded-pill badge-soft-light" style="color:black;">D-${list.dday}</span></c:if>
	                                	<c:if test="${list.dday<0}"><span id="jobStat" class="badge rounded-pill bg-danger fs-12">모집마감</span></c:if>
	                            		<a onclick="applicantCancel(${stat.index});"  style="position:absolute; right: 20px;"><i class="ri-delete-bin-5-line" style="color:red; cursor: pointer;"></i></a>
	                            	</p>
	                            </div>
	                            <div class="flex-shrink-0">
	                            </div>
	                        </div>
                       	</div>
	                    <div class="py-3" name="${list.projId}">
	                        <h5 class="mb-3 fs-15"><a href="#" class="text-dark" data-bs-toggle="modal" data-bs-target="#myModal" onclick="btnClick(${stat.index});">${list.projTtl}</a></h5>
	                        <div class="row gy-3">
	                            <div class="col-6">
	                                <div>
	                                    <p class="text-muted mb-1">모집인원</p>
	                                    <h5 class="fs-14">${list.jobRecru}명</h5>
	                                </div>
	                            </div>
	                            <div class="col-6">
	                                <div>
	                                    <p class="text-muted mb-1">지원자수</p>
	                                    <h5 class="fs-14">${list.jobVolcnt}명</h5>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	                <!-- end card body -->
	            </div>
	            <!-- end card -->
	        </div>
	        <!-- end col -->
        </c:forEach>
      </div>
</div>

<!-- 북마크 상세보기 -->
<!-- Default Modals -->
<div id="myModal" class="modal fade" tabindex="-1" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <div class="card">
                  <div class="card-body">
                      <div class="text-muted">
                      	<h4 class="fw-bold" id="projTtl"><span id="jobStat" class="badge rounded-pill bg-danger fs-12">마감</span>&nbsp;&nbsp;&nbsp;</h4>
                          <div class="pt-3 border-top border-top-dashed mt-4">
                              <div class="row">
                                  <div class="col-lg-5 col-sm-3">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 시작일</p>
                      					<h5 class="fs-15 mb-0" id="jobWdy"></h5>
                                      </div>
                                  </div>
                                  <div class="col-lg-5 col-sm-3">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 마감일</p>
                                          <h5 class="fs-15 mb-0" id="jobEdy"></h5>
                                      </div>
                                  </div>
                              </div>
                          </div>
                          <div class="pt-3 border-top border-top-dashed mt-4">
                              <div class="row">
                                  <div class="col-lg-4 col-sm-6">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">모집 상태</p>
                      					<h5 class="fs-15 mb-0" id="projStts"></h5>
                                      </div>
                                  </div>
                                  <div class="col-lg-4 col-sm-6">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 예산</p>
                                          <h5 class="fs-15 mb-0" id="projBgt"> 원</h5>
                                      </div>
                                  </div>
                                  <div class="col-lg-4 col-sm-6">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">예상기간</p>
                                          <h5 class="fs-15 mb-0" id="enddate"> 일</h5>
                                      </div>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
                  <!--end card body -->
              </div>
              <div class="card">
                   <div class="card-body">
                       <div class="text-muted">
                           <div>
                               <div class="row">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 내용</p>
                      					<h5 class="fs-15 mb-0" id="projCn"></h5>
                                      </div>
                               </div>
                           </div>
                           <div class="pt-3 border-top border-top-dashed mt-4">
                               <div class="row">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 공고 내용</p>
                      					<h5 class="fs-15 mb-0" id="jobCn"></h5>
                                      </div>
                               </div>
                           </div>
                       </div>
                   </div>
                  <!--  end card body -->
               </div>
               <div class="card">
                  <div class="card-body">
                      <h5 class="card-title mb-4">기술분야</h5>
                      <div class="d-flex flex-wrap gap-2 fs-16">
<%--                       		<c:forEach var="tech" items="${jobTech}">  --%>
	                          <div class="badge fw-medium badge-soft-secondary" id="jobTech"></div>
<%--                       		</c:forEach> --%>
                      </div>
                  </div>
                  <!-- end card body -->
              </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="markDelete" >지원취소</button>
            </div>

        </div><!--/.modal-content  -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->