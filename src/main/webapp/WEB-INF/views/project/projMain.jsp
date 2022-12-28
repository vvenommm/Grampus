<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<script type="text/javascript">
$(function(){
//////////////////////////
<%
int projId = (int)session.getAttribute("projId");
String memGrp = (String)session.getAttribute("grp");
%>
//프로젝트 정보 검색
$(".finput").keyup(function(){
$("#documentInfo").children().remove();
$("#issueInfo").children().remove();
$("#noticeInfo").children().remove();
$("#taskInfo").children().remove();
var con = $(".finput").val();
$.ajax({
url: "http://192.168.46.26:9200/projectsearch/_search?q=proj_id:<%= projId %> AND pmem_grp:<%= memGrp %> AND "+con,
type: 'GET',
dataType: 'json',
success : function(data){
var dcode = "";
var icode = "";
var ncode = "";
var tcode = "";
$.each(data.hits.hits,function(i,v){
console.log(v._source)
if(v._source.doc_ttl != undefined){
	dcode += "<a href='/doc/docDetail/"+v._source.doc_no+"/"+v._source.pmem_cd+"' class='dropdown-item notify-item py-2' style='display: block;'>";
    dcode += "<div class='d-flex'>";
    dcode += "<div class='flex-1'>";
    dcode += "<h6 class='m-0 memberId'>"+v._source.doc_ttl+"</h6>";
    dcode += "<span class='fs-11 mb-0 text-muted memberName'>"+v._source.doc_cn+"</span>";
    dcode += "</div>";
    dcode += "</div>";
    dcode += "</a>";
}else if(v._source.issue_ttl != undefined){
	icode += "<a href='/issue/issueDetail/"+v._source.issue_no+"/"+v._source.pmem_grp+"' class='dropdown-item notify-item py-2' style='display: block;'>";
    icode += "<div class='d-flex'>";
    icode += "<div class='flex-1'>";
    icode += "<h6 class='m-0 memberId'>"+v._source.issue_ttl+"</h6>";
    icode += "<span class='fs-11 mb-0 text-muted memberName'>"+v._source.issue_cn+"</span>";
    icode += "</div>";
    icode += "</div>";
    icode += "</a>";
}else if(v._source.ntc_ttl != undefined){
	ncode += "<a href='/notice/noticeList/"+v._source.proj_id+"/"+v._source.pmem_grp+"' class='dropdown-item notify-item py-2' style='display: block;'>";
    ncode += "<div class='d-flex'>";
    ncode += "<div class='flex-1'>";
    ncode += "<h6 class='m-0 memberId'>"+v._source.ntc_ttl+"</h6>";
    ncode += "<span class='fs-11 mb-0 text-muted memberName'>"+v._source.ntc_cn+"</span>";
    ncode += "</div>";
    ncode += "</div>";
    ncode += "</a>";
}else{
	tcode += "<a href='/task/taskDetail/"+v._source.task_no+"/"+v._source.pmem_grp+"' class='dropdown-item notify-item py-2' style='display: block;'>";
    tcode += "<div class='d-flex'>";
    tcode += "<div class='flex-1'>";
    tcode += "<h6 class='m-0 memberId'>"+v._source.task_ttl+"</h6>";
    tcode += "<span class='fs-11 mb-0 text-muted memberName'>"+v._source.task_cn+"</span>";
    tcode += "</div>";
    tcode += "</div>";
    tcode += "</a>";
}
});
$("#documentInfo").append(dcode);
$("#issueInfo").append(icode);
$("#noticeInfo").append(ncode);
$("#taskInfo").append(tcode);
},
});
});
});
</script>


<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">${projVO.ttl} 
					<c:if test="${projVO.plan =='BASIC'}"><span class="badge bg-primary">BASIC</span></c:if>
					<c:if test="${projVO.plan =='PLUS'}"><span class="badge badge bg-success">PLUS</span></c:if>
					<c:if test="${projVO.plan =='PREMIUM'}"><span class="badge badge bg-warning">PREMIUM</span></c:if>
	           		<c:if test="${iamPM.pm eq 1}">
		             	<span onclick="javascript:location.href='/project/projectSetting/${projVO.id}/${projVO.grp}'" style="cursor: pointer">
		             			<i class="ri-settings-4-line align-bottom me-2"></i>
		             	</span>
	           		</c:if>
	             </h4>
	            </div>
	
	            <div class="page-title-right">
	                <ol class="breadcrumb m-0">
	                    <li class="breadcrumb-item">
	                    	<a href="javascript: location.href='/project/projMain/${projVO.id}/${projVO.grp}';">
	                    		<i class="ri-home-2-fill"></i>
	                    	</a>
	                    </li>
	                    <li class="breadcrumb-item active">${projVO.grp}</li>
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/project/projMain/${projVO.id}/${projVO.grp}'" style="cursor: pointer">대시보드</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->
                    
                    

                    
<div class="row">
       <!-- 통합검색 부분 -->                    
<div class="row">
<div class="col-12">
<div class="d-flex float-end"> 
<form class="app-search d-none d-md-block">
    <div class="position-relative">
        <input type="text" class="form-control finput" placeholder="검색" autocomplete="off" id="search-options">
        <span class="mdi mdi-magnify search-widget-icon"></span>
        <span class="mdi mdi-close-circle search-widget-icon search-widget-icon-close d-none" id="search-close-options"></span>
    </div>
    <div class="dropdown-menu dropdown-menu-lg" id="search-dropdown">
            <!-- item-->
            <div class="dropdown-header mt-2">
                <h6 class="text-overflow mb-2 text-uppercase"><i class='ri-settings-4-line'></i> 일감</h6>
            </div>
            <div class="notification-list" id="taskInfo">
            </div>
            
            <div class="dropdown-header mt-2">
                <h6 class="text-overflow mb-2 text-uppercase"><i class='ri-earthquake-line'></i> 이슈</h6>
            </div>
            <div class="notification-list" id="issueInfo">
            </div>
            
            <div class="dropdown-header mt-2">
                <h6 class="text-overflow mb-2 text-uppercase"><i class='ri-file-list-2-line'></i> 문서</h6>
            </div>
            <div class="notification-list" id="documentInfo">
            </div>
            
            <div class="dropdown-header mt-2">
                <h6 class="text-overflow mb-2 text-uppercase"><i class='ri-checkbox-line'></i> 공지</h6>
            </div>
            <div class="notification-list" id="noticeInfo">
            </div>
    </div>
</form>
</div>      
</div>         
</div>         
</div>         

<!-- ------------------------------------------------------ 진행 상태 시작 ------------------------------------------------------ -->
                    <div class="row">
                    
                    
	                    <div class="row">
                    
                    
                        <div class="col-xxl-12 mb-4">
                        
                        
                        
                        <!-- Accordions with Icons -->
						<div class="accordion custom-accordionwithicon accordion-border-box accordion-info" id="accordionWithicon">
						    <div class="accordion-item">
						        <h2 class="accordion-header" id="accordionwithiconExample1">
						            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#accor_iconExamplecollapse1" aria-expanded="true" aria-controls="accor_iconExamplecollapse1">
						                <h4 class="card-title mb-0 flex-grow-1">${projVO.ttl} 진행 상태 <a href="javascript: void(0);" class="d-inline-block" data-bs-toggle="tooltip" data-bs-placement="top" title="클릭으로 카드를 펼쳐보세요!"><i class="ri-question-line"></i></a></h4>
						            </button>
						        </h2>
						        <div id="accor_iconExamplecollapse1" class="accordion-collapse collapse" aria-labelledby="accordionwithiconExample1" data-bs-parent="#accordionWithicon">
						            <div class="accordion-body">

<%--                                     <h4 class="card-title mb-0 flex-grow-1">${projVO.ttl} 진행 상태 <a href="javascript: void(0);" class="d-inline-block" data-bs-toggle="tooltip" data-bs-placement="top" title="완료된 일감 개수 / 총 일감 개수 * 100"><i class="ri-question-line"></i></a></h4> --%>

                                    <div class="row g-0 text-center">
										<div class="row">
											<div class="col-12">
						                                      	<!-- progress bar 부분 -->
						                    	<div class="align-items-center p-2">
													<div class="row">
														<div class="col-1">
													        <div class="avatar-xs">
													            <div class="avatar-title bg-light rounded-circle text-muted">
													            	<c:forEach var="proj" items="${projLogo}">
													            		<c:if test="${proj.id eq projId}">
															                <img alt="" src="/resources/image/${proj.photo}" class="rounded avatar-sm">
													            		</c:if>
													            	</c:forEach>
													            </div>
													        </div>
														</div>
														<div class="col-9">
													        <div class="progress animated-progress custom-progress progress-label">
													            <div class="progress-bar bg-secondary" role="progressbar" style="width: ${process.process};" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100">
														            <div class="label" style="background: none;">
												            			<a href="javascript: void(0);" class="d-inline-block" data-bs-toggle="tooltip" data-bs-placement="top" title="진행률 ${process.process}" data-bs-original-title="${process.process}">
														        	    <img src="/resources/image/grampusLogo.png" style="width:25px;">
														        	    </a>
														            </div>
													            </div>
													        </div>
														</div>
														<div class="col-2">
												            <div class="text-secondary" style="border-radius: 5px;">100%</div>
														</div>
													</div>
												</div>
									
												<!-- 프로젝트 설명 부분 -->
						                    	<div class="align-items-center p-2">
													    <div class="card mb-0">
													        <div class="card-body">
																<table class="table table-nowrap borderless shadow-none">
																	<tr>
																		<td scope="col"><p class="fs-14">시작일 : ${projVO.sdy}</p></td>
																		<td scope="col" rowspan="2" class="fs-14" style="text-align: left">${projVO.cn}</td>
																		<td scope="col"><p class="fs-14">프로젝트 참여 인원 : ${projVO.party}명</p></td>
																	</tr>
																	<tr>
																		<td scope="col"><p class="fs-14">종료일 : ${projVO.edy}</p></td>
																		<td scope="col"><p class="fs-14">예산 : <i class="bx bx-won"></i>${projVO.bgt}원</p></td>
																	</tr>
																</table>
													        </div>
													    </div>
												</div>
						                     </div>
										</div>	
                                    </div>
                        
                        
                        
						            </div>
						        </div>
						    </div>
						</div>
                        
						</div>
                        
					</div>
				</div><!-- end row -->
<!-- ------------------------------------------------------ 진행 상태 끄읕 ------------------------------------------------------ -->



                    <div class="row">
                    
                        <!-- //////////////////////////////////////////////////// 일감 //////////////////////////////////////////////////// -->
                        <div class="row">
                        <div class="col-xxl-6">
                            <div class="card card-height-100 border" style="min-height: 438px;">
                                <div class="card-header d-flex align-items-center">
                                    <h4 class="card-title flex-grow-1 mb-0">일감 (TASK)</h4>
                                    <div class="flex-shrink-0">
                                        <a href="javascript:location.href='/task/taskMain/${projId}/${grp}';" class="btn btn-soft-info btn-sm">일감 더보기</a>
                                    </div>
                                </div><!-- end cardheader -->
                                <div class="card-body">
                                    <div class="table-responsive table-card">
                                        <table class="table table-hover table-nowrap borderless table-centered align-middle">
                                            <thead class="bg-light text-muted">
                                                <tr>
                                                    <th scope="col" style="width:10%;">일감번호(#)</th> 
                                                    <th scope="col" style="width:10%;">우선순위</th>
                                                    <th scope="col" style="width:30%; text-align: center;">제목</th>
                                                    <th scope="col" style="width:10%;">담당자</th>
                                                    <th scope="col" style="width:20%; text-align: center;">진척도</th>
                                                    <th scope="col" style="width:10%;">상태</th>
                                                    <th scope="col" style="width: 10%; text-align: center;">마감일</th>
                                                </tr><!-- end tr -->
                                            </thead><!-- thead -->
                                            <tbody>
                                            <c:choose>
                                            	<c:when test="${!empty taskList}">
                                            	<c:forEach var="task" items="${taskList}">
	                                                <tr>
	                                                    <td class="fw-semibold" style="text-align: center;">${task.TASK_NO}</td>
                                                    	<c:choose>
												            <c:when test="${task.TASK_PRIORITY =='긴급'}">
												            	<td style="text-align: center;"><span class="badge badge-soft-danger">${task.TASK_PRIORITY}</span></td>
												            </c:when>
												            <c:otherwise>
												            	<td style="text-align: center;"><span class="badge badge-soft-success">${task.TASK_PRIORITY}</span></td>
												            </c:otherwise>
											            </c:choose>
	                                                    <td>
	                                                    	<a href="/task/taskDetail/${task.TASK_NO}/${task.PMEM_GRP}">${task.TASK_TTL}</a>
	                                                    </td>
	                                                    <td>
	                                                        <div class="avatar-group flex-nowrap">
	                                                            <div class="avatar-group-item">
	                                                                <a href="javascript: void(0);" class="d-inline-block" data-bs-toggle="tooltip" data-bs-placement="top" title="${task.PROF_NM} (${task.ROLE_ID})">
	                                                                    <img alt="" src="/resources/image/${task.PROF_PHOTO}" class="rounded-circle avatar-xxs">
	                                                                </a>
	                                                            </div>
	                                                        </div>
	                                                    </td>
	                                                    <td>
	                                                        <div class="d-flex align-items-center">
	                                                            <div class="flex-shrink-0 me-1 text-muted fs-13">${task.TASK_PROGRESS}%</div>
	                                                            <div class="progress progress-sm  flex-grow-1" style="width: 68%;">
	                                                                <div class="progress-bar bg-info rounded" role="progressbar" style="width: ${task.TASK_PROGRESS}%" aria-valuenow="${task.TASK_PROGRESS}" aria-valuemin="0" aria-valuemax="100"></div>
	                                                            </div>
	                                                        </div>
	                                                    </td>
	                                                    <c:choose>
											            	<c:when test="${task.TASK_STTS == '완료' or task.TASK_STTS == '승인'}">
													            <td><span class="badge badge-soft-success">${task.TASK_STTS}</span></td>
											            	</c:when>
											            	<c:when test="${task.taskStts == '반려'}">
													            <td><span class="badge badge-soft-danger">${task.TASK_STTS}</span></td>
											            	</c:when>
											            	<c:otherwise>
													            <td><span class="badge badge-soft-warning">${task.TASK_STTS}</span></td>
											            	</c:otherwise>
											            </c:choose>
	                                                    <td class="text-muted">${task.TASK_EDY}</td>
	                                                </tr><!-- end tr -->
                                            	</c:forEach>
                                            	</c:when>
                                            	<c:otherwise>
                                           			<tr>
                                           				<td colspan="7" class="text-muted" style="text-align: center;">등록된 일감이 없습니다.</td>
                                           			</tr>
                                            	</c:otherwise>
                                            </c:choose>
                                            </tbody><!-- end tbody -->
                                        </table><!-- end table --> 
                                    </div>
                                </div><!-- end card body -->
                            </div><!-- end card -->
                        </div><!-- end col -->

                        
                        
                        
                        <!-- //////////////////////////////////////////////////// 이슈 //////////////////////////////////////////////////// -->
                        <div class="col-xxl-6">
                            <div class="card card-height-100 border">
                                <div class="card-header d-flex align-items-center">
                                    <h4 class="card-title flex-grow-1 mb-0">이슈 (ISSUE)</h4>
                                    <div class="flex-shrink-0">
                                        <a href="javascript:location.href='/issue/issueMain/${projId}/${grp}';" class="btn btn-soft-info btn-sm">이슈 더보기</a>
                                    </div>
                                </div><!-- end cardheader -->
                                <div class="card-body">
                                    <div class="table-responsive table-card">
                                        <table class="table table-hover table-nowrap table-centered align-middle">
                                            <thead class="bg-light text-muted">
                                                <tr>
                                                    <th scope="col" style="width:10%;">이슈번호(#)</th> 
                                                    <th scope="col" style="width:10%;">종류</th>
                                                    <th scope="col" style="width:30%; text-align: center;">제목</th>
                                                    <th scope="col" style="width:20%;">작성자</th>
                                                    <th scope="col" style="width:15%;">상태</th>
                                                    <th scope="col" style="width:15%; text-align: center;">발생일</th>
                                                </tr><!-- end tr -->
                                            </thead><!-- thead -->

                                            <tbody>
                                            
                                           	<c:choose>
                                           		<c:when test="${!empty issueList}">
                                            	<c:forEach var="issue" items="${issueList}">
	                                                <tr>
	                                                    <td class="fw-semibold" style="text-align: center;">${issue.ISSUE_NO}</td>
	                                                    <c:choose>
												            <c:when test="${issue.ISSUE_TYPE =='결함'}">
												            	<td><span class="badge badge-soft-danger">${issue.ISSUE_TYPE}</span></td>
												            </c:when>
												            <c:when test="${issue.ISSUE_TYPE =='개선'}">
												            	<td><span class="badge badge-soft-warning">${issue.ISSUE_TYPE}</span></td>
												            </c:when>
												            <c:when test="${issue.ISSUE_TYPE =='인사'}">
												            	<td><span class="badge badge-soft-success">${issue.ISSUE_TYPE}</span></td>
												            </c:when>
												            <c:otherwise>
												            	<td><span class="badge badge-soft-info">${issue.ISSUE_TYPE}</span></td>
												            </c:otherwise>
											            </c:choose>
	                                                    <td>
	                                                    	<a href="/issue/issueDetail/${issue.ISSUE_NO}/${issue.PMEM_GRP}">${issue.ISSUE_TTL}</a>
	                                                    </td>
	                                                    <td>
	                                                        <div class="avatar-group flex-nowrap">
	                                                            <div class="avatar-group-item">
	                                                                <a href="javascript: void(0);" class="d-inline-block" data-bs-toggle="tooltip" data-bs-placement="top" title="${issue.PROF_NM} (${issue.ROLE_ID})">
	                                                                    <img alt="" src="/resources/image/${issue.PROF_PHOTO}" class="rounded-circle avatar-xxs">
	                                                                </a>
	                                                            </div>
	                                                        </div>
	                                                    </td>
											            <td><span class="badge badge-soft-success">${issue.ISSUE_STTS}</span></td>
	                                                    <td class="text-muted">${issue.ISSUE_DY}</td>
	                                                </tr><!-- end tr -->
                                            	</c:forEach>
                                           		</c:when>
                                           		<c:otherwise>
                                           			<tr>
                                           				<td colspan="6" class="text-muted" style="text-align: center;">등록된 이슈가 없습니다.</td>
                                           			</tr>
                                           		</c:otherwise>
                                           	</c:choose>
                                            </tbody><!-- end tbody -->
                                        </table><!-- end table --> 
                                    </div>
                                </div><!-- end card body -->
                            </div><!-- end card -->
                        </div><!-- end col -->
                    </div>






<!-- ------------------------------------------------------ 깃허브 시작 ------------------------------------------------------ -->

					<div class="row">
						<div class="col-xxl-4">
                            <div class="card border" style="min-height: 454px;">
					            <div class="card-header align-items-center d-flex">
					                <h4 class="card-title mb-0 flex-grow-1">깃허브 <i class="bx bxl-github"></i></h4>
					<c:if test="${iamPM.pm eq 1}">
		                <button type="button" id="gitInfo" class="btn btn-outline-info waves-effect waves-light" data-bs-toggle="modal" data-bs-target="#gitInfoModal">저장소 정보</button>
	           		</c:if>
					                
<!-- --------------------------- 깃허브 정보 담은 모달 ----------------------------- -->
<div class="modal fade" id="gitInfoModal" tabindex="-1" aria-labelledby="gitInfoModal" style="display: none;" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">저장소 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                   <div class="row g-3">
                       <div class="col-xxl-12">
                           <div>
                               <label for="firstName" class="form-label">토큰</label>
                               <input type="text" class="form-control" id="userToken" value="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" placeholder="토큰값" />
                           </div>
                       </div>
                       <!--end col-->
                       <div class="col-xxl-6">
                           <div>
                               <label for="userId" class="form-label">아이디</label>
                               <input type="text" class="form-control" id="userId" value="gbl1234" placeholder="아이디" />
                           </div>
                       </div>
                       <!--end col-->
                       <div class="col-xxl-6">
                           <div>
                               <label for="userRepo" class="form-label">저장소이름</label>
                               <input type="text" class="form-control" id="userRepo" value="gptest" placeholder="저장소 이름" />
                           </div>
                       </div>
                       <!--end col-->
                       <div class="col-lg-12">
                           <div class="hstack gap-2 justify-content-end">
                               <button type="button" id="getContents" class="btn btn-outline-success waves-effect waves-light" data-bs-dismiss="modal">확인</button>
                               <button type="button" class="btn btn-outline-danger waves-effect waves-light" data-bs-dismiss="modal">닫기</button>
                               <button type="reset" id="writeReset" class="btn btn-outline-primary waves-effect waves-light">작성값 비우기</button>
                           </div>
                       </div>
                       <!--end col-->
                   </div>
                   <!--end row-->
            </div>
        </div>
    </div>
</div>					            
					            </div><!-- end card header -->
					            <div class="card-body">
					                <div class="table-responsive table-card">
					                    <table class="table table-borderless table-hover table-nowrap align-middle mb-0">
					                        <thead class="table-light">
					                            <tr class="text-muted">
					                                <th scope="col" style="width: 25%;">형식</th>
					                                <th scope="col" style="width: 45%;">이름</th>
					                                <th scope="col" style="width: 30%;">크기 (Byte)</th>
					                            </tr>
					                        </thead>
					                        <tbody id="repolist">
					                        </tbody><!-- end tbody -->
					                    </table><!-- end table -->
					                </div><!-- end table responsive -->
					            </div><!-- end card body -->
                            </div><!-- end card -->
                        </div>

<!-- ------------------------------------------------------ 깃허브 끄읕 ------------------------------------------------------ -->




<!-- ------------------------------------------------------ 공지 사항 시작 ------------------------------------------------------ -->

<!-- 					<div class="row"> -->
						<div class="col-xxl-4">
                            <div class="card border" style="min-height: 454px;">
                                <div class="card-header align-items-center d-flex">
                                    <h5 class="card-title mb-0 flex-grow-1">공지사항</h5>
                                    <div class="flex-shrink-0">
                                        <a href="javascript:location.href='/notice/noticeList/${projId}/${grp}';" class="btn btn-soft-info btn-sm">공지사항 더보기</a>
                                    </div>
                                </div><!-- end card header -->
										<c:if test="${!empty noticeList}">
                                <div class="card-body">
									<div class="row">
										</c:if>
										<c:if test="${empty noticeList}">
                                <div class="card-body pt-5">
									<div class="row">
											<p class="text-muted text-center">등록된 공지사항이 없습니다.</p>
										</c:if>
										<c:forEach var="noticeList" items="${noticeList}" varStatus="stat">
											<input id="ntcNo" type="hidden" name="ntcNo" />
										    <div class="col-xxl-6 col-sm-6 project-card">
										        <div class="card card-height-100 border goToNotice" style="cursor: pointer">
										            <div class="card-body">
										                <div class="d-flex flex-column h-100">
										                    <div class="d-flex">
										                        <div class="flex-grow-1">
										                            <div class="text-muted">
										                            	<i class="ri-calendar-event-fill me-1 align-bottom"></i>
										                            	<fmt:formatDate value="${noticeList.NTC_DY}" pattern="yyyy.MM.dd" />
										                        	</div>
										                        </div>
										                        <div class="flex-shrink-0">
										                            <div class="d-flex gap-1 align-items-center">
										                                <div class="text-muted">
										                                	<i class="ri-pushpin-fill"></i>
										                                </div>
										                            </div>
										                        </div>
										                    </div>
										                    <div class="d-flex mb-2 mt-2">
										                        <div style="width:100%;">
										                           <!-- 공지사항 제목 -->
																	<h6 class="card-title mb-3 text-uppercase" id="ntcTtl" name="ntcTtl">
																		${noticeList.NTC_TTL}
																	</h6>
																	<!-- 공지사항 내용 -->
																	<p1 id="ntcCn" name="ntcCn" lass="text-muted text-truncate-two-lines mb-3">${noticeList.NTC_CN}</p1>
																	
										                        </div>
										                    </div>
										                </div>
										            </div>
										        </div>
										        <!-- end card -->
										    </div>
										    <!-- end col -->
									    </c:forEach>
									</div>
									<!-- end row -->
                                
                                
                                </div><!-- end card body -->
                            </div><!-- end card -->
                        </div>

<!-- ------------------------------------------------------ 공지 사항 끄읕 ------------------------------------------------------ -->



<!-- ------------------------------------------------------ 일정 시작 ------------------------------------------------------ -->

						<div class="col-xxl-4">
                            <div class="card border" style="min-height: 454px;">
                                <div class="card-header align-items-center d-flex">
                                    <h5 class="card-title mb-0 flex-grow-1">일정</h5>
                                    <div class="flex-shrink-0">
                                        <a href="javascript:location.href='/calendar/myCalendar/${projId}/${grp}';" class="btn btn-soft-info btn-sm">일정 더보기</a>
                                    </div>
                                </div><!-- end card header -->
                                       <c:if test="${!empty mainCalendar}">
                                <div class="card-body">
										</c:if>
                                       <c:if test="${empty mainCalendar}">
                                <div class="card-body pt-5">
											<p class="text-muted text-center">등록된 일정이 없습니다.</p>
										</c:if>
                                    <ul class="list-group list-group-flush border-dashed">
	                                    <c:choose>
	                                    	<c:when test="${!empty mainCalendar}">
	                                    		<c:forEach var="cal" items="${mainCalendar}">
			                                        <li class="list-group-item ps-0 mb-2">
			                                            <div class="row align-items-center g-3">
			                                                <div class="col-auto m-2">
			                                                    <div class="avatar-sm p-1 py-2 h-auto bg-light rounded-3">
			                                                        <div class="text-center">
			                                                            <h5 class="mb-0">${cal.STTDATE}</h5>
			                                                            <div class="text-muted">${cal.STTDAY}</div>
			                                                        </div>
			                                                    </div>
			                                                </div>
			                                                <div class="col m-2"> 
			                                                	<c:if test="${cal.STTTIME eq '00:00'}">
				                                                    <h5 class="text-muted mt-0 mb-1 fs-14">종일</h5>
			                                                	</c:if>
			                                                	<c:if test="${cal.STTTIME ne '00:00'}">
				                                                    <h5 class="text-muted mt-0 mb-1 fs-14">${cal.STTTIME} - ${cal.ENDTIME}</h5>
			                                                	</c:if>
			                                                    <a href="/calendar/myCalendar/${projId}/${grp}" class="text-reset fs-15 mb-0">${cal.CAL_CN}</a>
			                                                </div>
			                                            </div>
			                                            <!-- end row -->
			                                        </li><!-- end -->
	                                    		</c:forEach>
	                                    	</c:when>
	                                    	<c:otherwise> 
	                                    	</c:otherwise>
	                                    </c:choose>
                                    </ul><!-- end -->
                                </div><!-- end card body -->
                            </div><!-- end card -->
                        </div>
<!-- 					</div> -->
				</div><!-- end row -->

<!-- ------------------------------------------------------ 일정 끄읕 ------------------------------------------------------ -->



                    
                   <!-- //////////////////////////////////////////////////// 게시판 //////////////////////////////////////////////////// -->
                    <div class="row">
                    	<div class="col-xxl-6">
							<div class="card border" style="min-height: 220px;">
								<div class="card-body">
									<!-- Nav tabs -->
									<ul class="nav nav-pills nav-customs nav-danger mb-3" role="tablist">
										<li class="nav-item">
											<a class="nav-link active" data-bs-toggle="tab" href="#border-navs-help" role="tab" aria-selected="true">헬프데스크</a>
										</li>
										<li class="nav-item">
											<a class="nav-link" data-bs-toggle="tab" href="#border-navs-free" role="tab" aria-selected="false">자유게시판</a>
										</li>
									</ul><!-- Tab panes -->
									
									<div class="tab-content text-muted">
										<div class="tab-pane active" id="border-navs-help" role="tabpanel">
											<div class="text-end">
		                                        <a href="javascript:location.href='/board/boardList?brdHead=2&projId=${projId}&pmemGrp=${grp}';" class="btn btn-soft-info btn-sm">헬프 더보기</a>
		                                    </div>
		                                    <c:if test="${empty helpList}">
												<p class="text-muted text-center">등록된 헬프데스크가 없습니다.</p>
											</c:if>
											<c:forEach var="helpList" items="${helpList}">
											<div class="d-flex">
												<div class="flex-shrink-0">
													<i class="ri-checkbox-circle-fill text-primary"></i>
												</div>
												<div class="flex-grow-1 ms-2">
													${helpList.BRD_TTL}
												</div>
											</div>
											</c:forEach>
										</div>
										<div class="tab-pane" id="border-navs-free" role="tabpanel">
											<div class="text-end">
		                                        <a href="javascript:location.href='/board/boardList?brdHead=1&projId=${projId}&pmemGrp=${grp}';" class="btn btn-soft-info btn-sm">자유 더보기</a>
		                                    </div>
											<c:if test="${empty freeList}">
												<p class="text-muted text-center">등록된 자유게시글이 없습니다.</p>
											</c:if>
											<c:forEach var="freeList" items="${freeList}">
											<div class="d-flex">
												<div class="flex-shrink-0">
													<i class="ri-checkbox-circle-fill text-primary"></i>
												</div>
												<div class="flex-grow-1 ms-2">
													${freeList.BRD_TTL}
												</div>
											</div>
											</c:forEach>
										</div>
									</div>
								</div><!-- end card-body -->
							</div>
						</div>
						
						
						
						
						<div class="col-xxl-6">
							<div class="card border" style="min-height: 220px;">
								<div class="card-body">
									<!-- Nav tabs -->
									<ul class="nav nav-pills nav-customs nav-danger mb-3" role="tablist2">
										<li class="nav-item">
											<a class="nav-link active" data-bs-toggle="tab" href="#border-navs-doc" role="tab" aria-selected="true">문서</a>
										</li>
										<li class="nav-item">
											<a class="nav-link" data-bs-toggle="tab" href="#border-navs-wiki" role="tab" aria-selected="false">위키</a>
										</li>
									</ul><!-- Tab panes -->
									
									<div class="tab-content text-muted">
										<div class="tab-pane active" id="border-navs-doc" role="tabpanel">
											<div class="text-end">
		                                        <a href="javascript:location.href='/doc/docMain/${projId}/${grp}'" class="btn btn-soft-info btn-sm">문서 더보기</a>
		                                    </div>
		                                    <c:if test="${empty mainDoc}">
												<p class="text-muted text-center">등록된 문서가 없습니다.</p>
											</c:if>
											<c:forEach var="doc" items="${mainDoc}">
											<div class="d-flex">
												<div class="flex-shrink-0">
													<i class="ri-checkbox-circle-fill text-primary"></i>
												</div>
												<div class="flex-grow-1 ms-2">
													<a href="/doc/docDetail/${doc.DOC_NO}/${doc.PMEM_CD}">${doc.DOC_TTL}</a>
												</div>
											</div>
											</c:forEach>
										</div>
										<div class="tab-pane" id="border-navs-wiki" role="tabpanel">
											<div class="text-end">
		                                        <a href="javascript:location.href='/wiki/wikiList?projId=${projId}'" class="btn btn-soft-info btn-sm">위키 더보기</a>
		                                    </div>
											<c:if test="${empty mainWiki}">
												<p class="text-muted text-center">등록된 위키 없습니다.</p>
											</c:if>
											<c:forEach var="wiki" items="${mainWiki}">
											<div class="d-flex">
												<div class="flex-shrink-0">
													<i class="ri-checkbox-circle-fill text-primary"></i>
												</div>
												<div class="flex-grow-1 ms-2">
													${wiki.WIKI_TTL}
												</div>
											</div>
											</c:forEach>
										</div>
									</div>
								</div><!-- end card-body -->
							</div>
						</div>
                    </div>
                    










<style>
tr:hover{
	background-color: 
}
</style>
<script>
// $(function(){
	
// 	$("#repolist").children().remove();
// 	var uToken = $("#userToken").val();
// 	var uId = $("#userId").val();
// 	var uRepo = $("#userRepo").val();
// 	var auth = btoa(unescape(encodeURIComponent(uToken)));
// 	$.ajax({
// 	      type: "GET",
// 	      headers: {
// 	        Authorization: "Basic " + auth,
// 	      },
// 	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents/",
// 	      dataType: "json",
// 	      success: function (response) {
// 	    	  console.log(response)
// 	    	  var code = "";
// 	    	  $.each(response,function(i,v){
// 	    		  if(v.type == "dir"){
// 	    			  code += "<tr id='"+v.sha+"'>";
// 	    			  code += "<td><i class='bx bxs-folder'></i></td>";
// 	                  code += "<td id='getCon'><a href='#'>"+v.name+"</a></td>";
// 	                  code += "<td>"+v.size+"</td>";
// 	                  code += "</tr>";
// 	    		  }
// 	    	  });
// 	    	  $.each(response,function(i,v){
// 	    		  if(v.type == "file"){
// 	    			  code += "<tr id='"+v.sha+"'>";
// 	    			  code += "<td><i class='bx bx-file'></i></td>";
// 	                  code += "<td><a href='"+v.download_url+"'>"+v.name+"</a></td>";
// 	                  code += "<td>"+v.size+"</td>";
// 	                  code += "</tr>";
// 	    		  }
// 	    	  });
// 	    	  $("#repolist").append(code);
// 	      }
// 	});
// });		
	
// 	var context2 = document.getElementById('role').getContext('2d');

// 	const data2 = {
// 			labels: ['PM', 'PL', 'TA', 'AA', 'UA', 'DA'],
// 			datasets : [{
// 				label : '직책',
// 				data : [${role.pl}, ${role.ta}, ${role.aa}, ${role.ua}, ${role.da}],
// 				backgroundColor : [ 
// 	                'rgba(255, 99, 132, 0.5)',
// 	                'rgba(54, 162, 235, 0.5)',
// 	                'rgba(255, 206, 86, 0.5)',
// 	                'rgba(75, 192, 192, 0.5)',
// 	                'rgba(153, 102, 255, 0.5)',
// 	                'rgba(255, 159, 64, 0.5)'
// 				]
// 			}]
// 	}

// 	const config2 = {
// 		    type: 'bar',
// 		    data: data2,
// 		    options: {}
// 		  };
		  
// 	var myChart = new Chart(
// 			document.getElementById('role'),
// 		    config2
// 	);
    
// });




///////////////////////////////////////////// 깃허브 /////////////////////////////////////////////

//////////////////////
/* 저장소 파일목록 불러오기 */
$("#getContents").on("click",function(){
	$("#repolist").children().remove();
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	$.ajax({
	      type: "GET",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents/",
	      dataType: "json",
	      success: function (response) {
	    	  console.log(response)
	    	  var codef = "";
	    	  var coded = "";
	    	  $.each(response,function(i,v){
	    		  if(v.type == "dir"){
	    			  coded += "<tr id='"+v.sha+"'>";
	    			  coded += "<td><i class='bx bxs-folder'></i></td>";
	    			  coded += "<td id='getCon'><a href='#'>"+v.name+"</a></td>";
	    			  coded += "<td>"+v.size+"</td>";
	    			  coded += "</tr>";
	    		  }else{
	    			  codef += "<tr id='"+v.sha+"'>";
	    			  codef += "<td><i class='bx bx-file'></i></td>";
	    			  codef += "<td><a href='"+v.html_url+"' target='_blank'>"+v.name+"</a></td>";
	    			  codef += "<td>"+v.size+"</td>";
	    			  codef += "</tr>";
	    		  }
	    	  });
	    	  $("#repolist").append(coded);
	    	  $("#repolist").append(codef);
	    	  
	      }
	});
});

////////////////////
/* 저장소 디렉토리 이동 */
var dirCount = 0;
var tName = "";
$(document).on("click","#getCon",function(){
	if($(this).find("a").text() == ".."){ 
		dirCount = dirCount-1;
	}else{
		dirCount = dirCount+1;
	}
	tName += "/"+$(this).find("a").text();
	$("#repolist").children().remove();
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	$.ajax({
	      type: "GET",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents"+tName,
	      dataType: "json",
	      success: function (response) {
	    	  console.log(response)
	    	  if(dirCount > 0){
	    		  var code = "<tr><td><i class='ri-arrow-go-back-fill'></i></td><td id='getCon' colspan='4'><a href='#'>..</a></td></tr>";
	    	  }else{
	    		  var coded = "";
	    		  var codef = "";
	    		  tName = "";
	    	  }
	    	  $.each(response,function(i,v){
	    		  if(v.type == "dir"){
	    			  coded += "<tr id='"+v.sha+"'>";
	    			  coded += "<td><i class='bx bxs-folder'></i></td>";
	    			  coded += "<td id='getCon'><a href='#'>"+v.name+"</a></td>";
	    			  coded += "<td>"+v.size+"</td>";
	    			  coded += "</tr>";
	    		  }
	    	  });
	    	  $.each(response,function(i,v){
	    		  if(v.type == "file"){
	    			  codef += "<tr id='"+v.sha+"'>";
	    			  codef += "<td><i class='bx bx-file'></i></td>";
	    			  codef += "<td><a href='"+v.html_url+"' target='_blank'>"+v.name+"</a></td>";
	    			  codef += "<td>"+v.size+"</td>";
	    			  codef += "</tr>";
	    		  }
	    	  });
	    	  $("#repolist").append(code);
	    	  $("#repolist").append(coded);
	    	  $("#repolist").append(codef);
	      }
	});
});

///////////////////////
/* 저장소에 파일 업로드 */
$("#commitCon").on("click",function(){
	var uPath = $("#userPath").val().replace(/\s/gi, "");
	var uFile = $("#userFile")[0].files[0];
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	var file = new FileReader();
	file.readAsText(uFile);
	file.onload = function(){
		var tFile = file.result;
		var eFile = btoa(unescape(encodeURIComponent(tFile)))
		var gdt = {message:"UPLOAD "+uFile.name,committer:{name:"세션이름",email:'세션아이디'},content:eFile}
		$.ajax({
		      type: "PUT",
		      headers: {
		        Authorization: "Basic " + auth,
		      },
		      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents"+uPath+"/"+uFile.name,
		      data:JSON.stringify(gdt),
		      dataType: "json",
		      contentType:"application/json; charset=utf-8",
		      success: function (response) {
				  console.log(response)
				  alert("업로드 완료");
				  $("#userFile").val("");
		      }
		});
	}
});

///////////////////////
/* 저장소 파일 삭제 */
$(document).on("click","#delContents",function(){
	var ftr = $(this).closest("tr");
	var fSha = $(this).closest("tr").attr("id");
	var fName = $(this).closest("tr").find("td").eq(1).find("a").text();
	console.log(fSha)
	console.log(fName)
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	var gdt = {message:"DELETE "+fName,committer:{name:"세션이름",email:'세션아이디'},sha:fSha}
	$.ajax({
	      type: "DELETE",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents/"+fName,
	      data:JSON.stringify(gdt),
	      dataType: "json",
	      contentType:"application/json; charset=utf-8",
	      success: function (response) {
			  console.log(response)
			  ftr.remove();
			  alert("삭제 완료")
	      }
	});
});


////////////////////////
/* 커밋내역 출력 */
$("#crecon").on("click",function(){
	$("#comlist").children().remove();
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	$.ajax({
	      type: "GET",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/commits",
	      dataType: "json",
	      success: function (response) {
			  console.log(response)
			  var code = "";
	    	  $.each(response,function(i,v){
	    		  code += "<tr>";
                  code += "<td>"+v.commit.author.name+"</td>";
                  code += "<td>"+v.commit.author.email+"</td>";
                  code += "<td>"+v.commit.author.date+"</td>";
                  code += "<td>"+v.commit.message+"</td>";
                  code += "</tr>";
	    	  });
	    	  $("#comlist").append(code);
	      }
	});
});

/////////////////////
/* 저장소 정보 값 비우기 */
$("#writeReset").on("click",function(){
	$("#userToken").val("");
	$("#userId").val("");
	$("#userRepo").val("");
});

/////////////////////
/* 공지사항 카드 누르면 공지사항 페이지로 이동 */
$('.goToNotice').on('click', function(){
	location.href='/notice/noticeList/${projId}/${grp}';
});

</script>