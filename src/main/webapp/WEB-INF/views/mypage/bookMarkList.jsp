<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>
<% String memNo =(String)session.getAttribute("memNo"); %>
<script type="text/javascript">

function btnClick(idx){
// 	alert("i : " + idx);
	var projTtl = $("#projTtl"+idx).val();
	var projId = $("#projId"+idx).val();
	var jobWdy = $("#jobWdy"+idx).text();
	var jobEdy = $("#jobEdy"+idx).text();
	var projStts = $("#projStts"+idx).val();
	var projBgt = $("#projBgt"+idx).val();
	var enddate = $("#enddate"+idx).val();
	var projCn = $("#projCn"+idx).val();
	var jobCn = $("#jobCn"+idx).val();
	var jobTech = $("#jobTech"+idx).val();
	
// 	var check = jobTech.toString().split(",");
// 	alert("check : " + check);
		
	$('#projTtl').text(projTtl);
	$('#jobWdy').text(jobWdy);
	$('#jobEdy').text(jobEdy);
	$('#projStts').text(projStts);
	$('#projBgt').text(projBgt);
	$('#projCn').text(projCn);
	$('#enddate').text(enddate);
	$('#jobCn').text(jobCn);
	$('#jobTech').text(jobTech);
 	$('#markDelete').attr("onclick", "javascript:location.href='/mark/deleteBookMark?projId="+projId+"'")
	
}

//북마크 별 버튼 이벤트
function btnMarkingClick(idx){
//	alert("idx : " + idx);
	var marking = $('#marking'+idx).attr("class");
	var projId = $('#projId'+idx).val();
// 	alert("projId : " + projId);
	$('#markprojId').val(projId)
	
	//정말 해지할건지 확인 한 번더
	
	//북마크 해지
	$('#marking'+idx).attr("class","btn avatar-xs mt-n1 p-0 favourite-btn")
	$(location).attr("href", "/mark/deleteBookMark?projId="+projId);

}
$(function(){
	
	$("#seachJob").on("click",function(){
		var cont = $("#seachCon").val();
		location.href = "/bookMarkList?cont="+cont+"&memNo=<%=memNo%>";
	});
	
	/* 전체보기 */
	$("#showAll").on("click",function(){
		location.href = "/bookMarkList?cont=&memNo=<%=memNo%>";
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
                      <li class="breadcrumb-item active">공고 북마크</li>
                  </ol>
              </div>

          </div>
      </div>
  </div>
  
  <!-- end page title -->
  <div class="container-fluid">
   <c:if test="${bookMarkList[0].projTtl!=null}">
    <div class="row g-4 mb-2">
        <div class="col-sm">
            <div class="d-flex justify-content-sm-end gap-2">
           		<a class="btn btn-soft-primary waves-effect" id="showAll">전체보기</a>
                <div class="search-box ms-2">
                    <input type="text" id="seachCon" class="form-control" placeholder="공고 제목 입력" value="${scon}">
                    <i class="ri-search-line search-icon"></i>
                </div>
          		<a class="btn btn-soft-primary waves-effect" id="seachJob">검색</a>
            </div>
        </div>
    </div><br />
    </c:if>
    
       <c:if test="${bookMarkList[0].projTtl==null}">
	 <div class="row justify-content-center">
	    <div class="col-md-8 col-lg-6 col-xl-5">
	            <div class="card-body p-4 text-center">
	                <div class="avatar-lg mx-auto mt-2">
	                    <div class="avatar-title bg-light text-success display-3 rounded-circle">
	                        <i class="ri-bookmark-3-fill"></i>
	                    </div>
	                </div>
	                <div class="mt-4 pt-2">
	                    <h4>북마크내역이 없습니다.</h4>
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
    	<c:forEach var="list" items="${bookMarkList}" varStatus="stat">
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
	                            </div>
	                            <div class="d-flex gap-1 align-items-center my-n2">
									<button type="button" id="marking${stat.index}" name="21" class="btn avatar-xs mt-n1 p-0 favourite-btn active" onclick="btnMarkingClick(${stat.index});">
								    	<span class="avatar-title bg-transparent fs-15">
								       		<i class="ri-star-fill"></i>
								    	</span>
									</button>
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
                                          <p class="mb-2 text-uppercase fw-medium fs-13">등록일자</p>
                      					<h5 class="fs-15 mb-0" id="jobWdy"></h5>
                                      </div>
                                  </div>
                                  <div class="col-lg-5 col-sm-3">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">마감일자</p>
                                          <h5 class="fs-15 mb-0" id="jobEdy"></h5>
                                      </div>
                                  </div>
                              </div>
                          </div>
                          <div class="pt-3 border-top border-top-dashed mt-4">
                              <div class="row">
                                  <div class="col-lg-4 col-sm-6">
                                      <div>
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 상태</p>
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
                                          <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 기간</p>
                                          <h5 class="fs-15 mb-0" id="enddate"> 일</h5>
                                      </div>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
                  <!-- end card body -->
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
                   <!-- end card body -->
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
                <button type="button" class="btn btn-primary" id="markDelete" >삭제</button>
            </div>

        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->