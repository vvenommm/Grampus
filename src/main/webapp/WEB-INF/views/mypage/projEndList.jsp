<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>
<% String memNo =(String)session.getAttribute("memNo"); %>
<style>
	.profile-offcanvas .team-cover::before, .team-box .team-cover::before {
		background: white;
	}
</style>

<script type="text/javascript">
 $(function(){
		$("#seach").on("click",function(){
			var cont = $("#seachCon").val();
			location.href = "/project/projEndList?cont="+cont+"&memNo=<%=memNo%>";
		});

		/* 전체보기 */
		$("#showAll").on("click",function(){
			location.href = "/project/projEndList?cont=&memNo=<%=memNo%>";
		}); 
 });
</script>

    <div class="container-fluid">

        <!-- start page title -->
       <div class="row">
           <div class="col-12">
               <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                   <a href="javascript:location.href='/main/myMain'"><i class="bx bx-left-arrow-circle"></i></a>

                   <div class="page-title-right">
                       <ol class="breadcrumb m-0">
                           <li class="breadcrumb-item">내 대시보드</li>
                           <li class="breadcrumb-item active">마감 프로젝트</li>
                       </ol>
                   </div>

               </div>
           </div>
       </div>
       <!-- end page title -->
    
       <div class="row">
       <c:if test="${projectVOList[0].projTtl!=null}">
         <div class="col-sm">
		   <div class="d-flex justify-content-sm-end gap-2">
		       		<a class="btn btn-soft-primary waves-effect" id="showAll">전체보기</a>
		            <div class="search-box ms-2">
		                <input type="text" id="seachCon" class="form-control" placeholder="프로젝트 명을 입력하세요" value="${scon}">
		                <i class="ri-search-line search-icon"></i>
		            </div>
		      		<a class="btn btn-soft-primary waves-effect" id="seach">검색</a>
		        </div>
		    	<br />
		    </div>
		    </c:if>
		    <c:if test="${projectVOList[0].projTtl==null}">
                   	<div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6 col-xl-5">
                            <div class="card-body p-4 text-center">
                                <div class="avatar-lg mx-auto mt-2">
                                    <div class="avatar-title bg-light text-danger display-3 rounded-circle">
                                        <i class="ri-folder-zip-line"></i>
                                    </div>
                                </div>
                                <div class="mt-4 pt-2">
                                    <h4>마감된 프로젝트가 없습니다.</h4>
                                </div>
                            </div>
                            <!-- end card body -->

                    </div>
                </div>
                   </c:if>
           <div class="col-lg-12">
               <div>
                   <div class="team-list grid-view-filter row">
                   <!-- 여기서부터 프로젝트 리스트 반복문 -->
                   <c:forEach var="projectList" items="${projectVOList}" varStatus="stat">
                       <div class="col">
                           <div class="card team-box">
                               <div class="team-cover">
                                   <img src="/resources/image/${projectList.projPhoto}" alt="" class="img-fluid">
                               </div>
                               <div class="card-body p-4">
                                   <div class="row align-items-center team-row" style="height:400px;">
                                       <div class="col team-settings">
                                       </div>
                                       <div class="col-lg-4 col">
                                           <div class="team-profile-img">
                                               <div class="avatar-lg img-thumbnail rounded-circle flex-shrink-0">
                                                   <img src="/resources/image/${projectList.profPhoto}" alt="" class="img-fluid d-block rounded-circle"  style="width:100%; height:100%;">
                                               </div>
                                               <div class="team-content">
                                                   <h5 class="fs-17 mb-1">${projectList.projTtl}</h5>
                                                   <p><span class="badge badge-outline-dark">${projectList.pmemGrp}</span></p>
                                                   <div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content"
														style="height: 40px; overflow: hidden scroll;">${projectList.projCn}</div>
                                               </div>
                                           </div>
                                       </div>
                                       <div class="col-lg-4 col">
                                           <div class="row text-muted text-center">
                                               <div class="col-6 border-end border-end-dashed">
                                                   <h5 class="mb-1">시작일</h5>
                                                   <p class="text-muted mb-0"><fmt:formatDate pattern="yyyy.MM.dd" value="${projectList.projSdy}"/></p>
                                               </div>
                                               <div class="col-6">
                                                   <h5 class="mb-1">마감일</h5>
                                                   <p class="text-muted mb-0"><fmt:formatDate pattern="yyyy.MM.dd" value="${projectList.projEdy}"/></p>
                                               </div>
                                           </div>
                                       </div>
                                       <div class="col-lg-2 col">
                                           <div class="text-end">
                                               <a href="pages-profile.html" class="btn btn-light view-btn">프로젝트 홈으로</a>
                                           </div>
                                       </div>
                                   </div>
                               </div>
                           </div>
                           <!--end card-->
                       </div>
                       </c:forEach>
                       <!-- 여기까지 반복 -->
                       <!--end col-->
                   </div>
                   <!--end row-->

</div></div></div></div>