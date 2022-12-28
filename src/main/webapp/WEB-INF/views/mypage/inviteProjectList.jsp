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

    <div class="container-fluid">

        <!-- start page title -->
       <div class="row">
           <div class="col-12">
               <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                   <a href="javascript:location.href='/main/myMain'"><i class="bx bx-left-arrow-circle"></i></a>
                   <div class="page-title-right">
                       <ol class="breadcrumb m-0">
                           <li class="breadcrumb-item">내 대시보드</li>
                           <li class="breadcrumb-item active">초대 프로젝트</li>
                       </ol>
                   </div>

               </div>
           </div>
       </div>
       <!-- end page title -->
       

    
       <div class="row">
           <div class="col-lg-12">
               <div>
                   <div class="team-list grid-view-filter row">
                   <!-- 초대받은 리스트가 없을 때  -->
                   <c:if test="${projectVOList[0].projTtl==null}">
                   	<div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6 col-xl-5">
                            <div class="card-body p-4 text-center">
                                <div class="avatar-lg mx-auto mt-2">
                                    <div class="avatar-title bg-light text-danger display-3 rounded-circle">
                                        <i class="ri-mail-fill"></i>
                                    </div>
                                </div>
                                <div class="mt-4 pt-2">
                                    <h4>초대 받은 내역이 없습니다.</h4>
                                </div>
                            </div>
                            <!-- end card body -->

                    </div>
                </div>
                   </c:if>
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
                                               <div class="avatar-lg">
                                               </div>
                                               <div class="team-content">
                                                   <h5 class="fs-17 mb-1">${projectList.projTtl}</h5>
                                                   <p><span class="badge badge-outline-dark">${projectList.pmemGrp}</span></p>
                                                   <div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content"
														style="height: 40px; overflow: hidden scroll;">${projectList.projCn}</div>
                                               </div>
                                           </div>
                                       </div>
                                       <div class="col-lg-4 col" style="margin-bottom:10px;">
                                           <div class="row text-muted text-center">
                                               <div class="col-6 border-end border-end-dashed">
                                                   <h5 class="mb-1">시작일</h5>
                                                   <p class="text-muted mb-0"><fmt:formatDate pattern="yyyy년 MM월 dd일" value="${projectList.projSdy}"/></p>
                                               </div>
                                               <div class="col-6">
                                                   <h5 class="mb-1">마감일</h5>
                                                   <p class="text-muted mb-0"><fmt:formatDate pattern="yyyy년 MM월 dd일" value="${projectList.projEdy}"/></p>
                                               </div>
                                           </div>
                                       </div>
                                       <div class="col-lg-2 col">
                                           <div class="row">
                                               <a href="/project/inviteYes?pmemCd=${projectList.pmemCd}&memNo=<%=memNo%>" class="btn btn-outline-primary waves-effect waves-light" style="width:50%;">수락</a>
                                               <a href="/project/inviteNo?pmemCd=${projectList.pmemCd}&memNo=<%=memNo%>"  class="btn btn-outline-danger waves-effect waves-light" style="width:50%;">거절</a>
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