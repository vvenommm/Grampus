<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script src="/resources/js/jquery-3.6.0.js"></script>
<script>
$(function(){
//////////////////
/* 구인공고 검색 */
$("#seachJob").on("click",function(){
	var cont = $("#seachCon").val();
	location.href = "/jobList?cont="+cont+"&listcnt=1";
});

//////////////////
/* 전체보기 */
$("#showAll").on("click",function(){
	location.href = "/jobList?cont=&listcnt=1";
});

/////////////////////
/* 구인공고 더보기 */
$("#moreList").on("click",function(){
	if(`${param.cont}` == null){
		location.href = "/jobList?cont=&listcnt="+`${listcnt+1}`;
	}else{
		location.href = "/jobList?cont="+`${param.cont}`+"&listcnt="+`${listcnt+1}`;
	}
});

/////////////////////
/* 북마크 추가 */
$(document).on("click","#marking",function(){
	var projVal = $(this)
	var projId = $(this).attr("name");
	$.ajax({
		url:"/mark/chkMark?projId="+projId,
		type:"get",
		success:function(res){
			if(res == 1){
				projVal.addClass("active");
			}else if(res == 2){
				projVal.removeClass("active");
			}else{
				alert("북마크 에러");
			}
		}
	});
});

///////////////////////
/* 구인공고 상세보기 */
$(document).on("click","#cellcn",function(){
	var projId = $(this).attr("name");
	location.href = "/jobDetail?projId="+projId;
});


//검색했을때 검색 내역 검색창에 저장
if("${param.cont}" != ""){
	$("#seachCon").val("${param.cont}");
}

});
</script>
<div class="page-content">
<div class="container-fluid">
<h5 style="text-align:center;">PROJECT ANNOUNCEMENT</h5>
<p class="text-muted text-center">Choose the right project for you.</p>
    <div class="row g-4 mb-2">
        <div class="col-sm">
            <div class="d-flex justify-content-sm-end gap-2">
           		<a class="btn btn-primary waves-effect" id="showAll">전체보기</a>
                <div class="search-box ms-2">
                    <input type="text" id="seachCon" class="form-control" placeholder="공고 제목 입력">
                    <i class="ri-search-line search-icon"></i>
                </div>
          		<a class="btn btn-primary waves-effect" id="seachJob">검색</a>
            </div>
        </div>
    </div>
    <br />
    <div class="row">
    	<c:forEach var="list" items="${jobList}">
	        <div class="col-xxl-3 col-sm-6 project-card">
	            <div class="card card-animate">
	                <div class="card-body">
	                	<div class="p-3 mt-n3 mx-n3 bg-primary rounded-top">
	                        <div class="d-flex align-items-center">
	                            <div class="flex-grow-1">
	                                <c:forEach items="${list.get('TECH')}" var="tval">
	                                    <span class="badge badge-outline-light">${tval}</span>
                                    </c:forEach>
	                            </div>
	                            <div class="flex-shrink-0">
	                                <div class="d-flex gap-1 align-items-center my-n2">
	                                    <c:choose>
											<c:when test="${not empty mList}">
												<c:set var="sl" value="false"/>
												<c:forEach items="${mList}" var ="mlist" varStatus="sst">
													<c:if test="${not sl}">
														<c:choose>
															<c:when test="${list.get('PROJ_ID') eq mlist}">
																<c:set var="sl" value="true" />
																<button type="button" id="marking" name="${list.get('PROJ_ID')}" class="btn fs-16 p-0 favourite-btn active">
																    <span class="avatar-title bg-transparent fs-15">
																        <i class="ri-star-fill"></i>
																    </span>
																</button>
															</c:when>
															<c:when test="${sst.last and list.get('PROJ_ID') ne mlist}">
																<button type="button" id="marking" name="${list.get('PROJ_ID')}" class="btn fs-16 p-0 favourite-btn">
															    	<span class="avatar-title bg-transparent fs-15">
															       		<i class="ri-star-fill"></i>
															    	</span>
																</button>
															</c:when>
														</c:choose>
													</c:if>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<button type="button" id="marking" name="${list.get('PROJ_ID')}" class="btn fs-16 p-0 favourite-btn">
												    <span class="avatar-title bg-transparent fs-15">
												        <i class="ri-star-fill"></i>
												    </span>
												</button>
											</c:otherwise>
										</c:choose>
	                                </div>
	                            </div>
	                        </div>
                       	</div>
	                    <div class="py-3" id="cellcn" name="${list.get('PROJ_ID')}">
	                        <h5 class="mb-3 fs-15"><a class="text-dark">${list.get('PROJ_TTL')}</a></h5>
	                        <div class="row gy-3">
	                            <div class="col-6">
	                                <div>
	                                    <p class="text-muted mb-1">모집인원</p>
	                                    <h5 class="fs-14">${list.get('JOB_RECRU')}명</h5>
	                                </div>
	                            </div>
	                            <div class="col-6">
	                                <div>
	                                    <p class="text-muted mb-1">지원자수</p>
	                                    <h5 class="fs-14">${list.get('JOB_VOLCNT')}명</h5>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                    <div>
	                        <div class="d-flex mb-2">
	                            <div class="flex-grow-1">
	                                <div>마감까지</div>
	                            </div>
	                            <div class="flex-shrink-0">
	                                <div>${list.get("pers")}%</div>
	                            </div>
	                        </div>
	                        <div class="progress progress-sm animated-progress">
	                            <div class="progress-bar bg-primary" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: ${list.get('pers')}%;"></div><!-- /.progress-bar -->
	                        </div><!-- /.progress -->
	                    </div>
	                </div>
	                <!-- end card body -->
	            </div>
	            <!-- end card -->
	        </div>
	        <!-- end col -->
        </c:forEach>
		<div class="row g-4 mb-2">
			<div class="col-12 text-center">
				<a class="btn btn-ghost-primary waves-effect waves-light"
					id="moreList"><i class="ri-add-line align-bottom me-1"></i> 더보기</a>
			</div>
		</div>
    </div>
    <!-- end row -->
</div>
</div>