<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

${projOnList}

<div class="row">
	<div class="col-xl-7">
	    <div class="card card-height-100">
	        <div class="card-header d-flex align-items-center">
	            <h4 class="card-title flex-grow-1 mb-0">Active Projects</h4>
	            <div class="flex-shrink-0">
	                <a href="javascript:void(0);" class="btn btn-soft-info btn-sm">Export Report</a>
	            </div>
	        </div><!-- end cardheader -->
	        <div class="card-body">
	            <div class="table-responsive table-card">
	                <table class="table table-nowrap table-centered align-middle">
	                    <thead class="bg-light text-muted">
	                        <tr>
	                            <th scope="col">프로젝트명</th>
	                            <th scope="col">프로젝트 관리자</th>
	                            <th scope="col">진행률</th>
	                            <th scope="col">상태</th>
	                            <th scope="col">시작일</th>
	                            <th scope="col" style="width: 10%;">종료일</th>
	                        </tr><!-- end tr -->
	                    </thead><!-- thead -->
	
	                    <tbody>
	                    	
	                    	<c:forEach var="pro" items="${projOnList}" varStatus="stat">
	                    	
		                        <tr>
		                            <td class="fw-semibold"><a href="/project/main/${pro.proj_id}">${pro.proj_ttl}</a></td>
		                            <td>
		                                <img src="assets/images/users/avatar-1.jpg" class="avatar-xxs rounded-circle me-1" alt="">
		                                <a href="javascript: void(0);" class="text-reset">Donald Risher</a>
		                            </td>
		                            <td>
		                                <div class="d-flex align-items-center">
		                                    <div class="flex-shrink-0 me-1 text-muted fs-13">53%</div>
		                                    <div class="progress progress-sm  flex-grow-1" style="width: 68%;">
		                                        <div class="progress-bar bg-primary rounded" role="progressbar" style="width: 53%" aria-valuenow="53" aria-valuemin="0" aria-valuemax="100"></div>
		                                    </div>
		                                </div>
		                            </td>
		                            <td>
		                                <div class="avatar-group flex-nowrap">
		                                    <div class="avatar-group-item">
		                                        <a href="javascript: void(0);" class="d-inline-block">
		                                            <img src="assets/images/users/avatar-1.jpg" alt="" class="rounded-circle avatar-xxs">
		                                        </a>
		                                    </div>
		                                    <div class="avatar-group-item">
		                                        <a href="javascript: void(0);" class="d-inline-block">
		                                            <img src="assets/images/users/avatar-2.jpg" alt="" class="rounded-circle avatar-xxs">
		                                        </a>
		                                    </div>
		                                    <div class="avatar-group-item">
		                                        <a href="javascript: void(0);" class="d-inline-block">
		                                            <img src="assets/images/users/avatar-3.jpg" alt="" class="rounded-circle avatar-xxs">
		                                        </a>
		                                    </div>
		                                </div>
		                            </td>
		                            <td><span class="badge badge-soft-warning">Inprogress</span></td>
		                            <td class="text-muted">${pro.projSdy}</td>
		                        </tr><!-- end tr -->
		                        
	                        	
	                    	</c:forEach>
	                        
	                        
	                        
	                        
<!-- 	                        <tr> -->
<!-- 	                            <td class="fw-semibold">Redesign - Landing Page</td> -->
<!-- 	                            <td> -->
<!-- 	                                <img src="assets/images/users/avatar-2.jpg" class="avatar-xxs rounded-circle me-1" alt=""> -->
<!-- 	                                <a href="javascript: void(0);" class="text-reset">Prezy William</a> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="d-flex align-items-center"> -->
<!-- 	                                    <div class="flex-shrink-0 text-muted me-1">0%</div> -->
<!-- 	                                    <div class="progress progress-sm flex-grow-1" style="width: 68%;"> -->
<!-- 	                                        <div class="progress-bar bg-primary rounded" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="avatar-group"> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-5.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-6.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td><span class="badge badge-soft-danger">Pending</span></td> -->
<!-- 	                            <td class="text-muted">13 Nov 2021</td> -->
<!-- 	                        </tr>end tr -->
<!-- 	                        <tr> -->
<!-- 	                            <td class="fw-semibold">Multipurpose Landing Template</td> -->
<!-- 	                            <td> -->
<!-- 	                                <img src="assets/images/users/avatar-3.jpg" class="avatar-xxs rounded-circle me-1" alt=""> -->
<!-- 	                                <a href="javascript: void(0);" class="text-reset">Boonie Hoynas</a> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="d-flex align-items-center"> -->
<!-- 	                                    <div class="flex-shrink-0 text-muted me-1">100%</div> -->
<!-- 	                                    <div class="progress progress-sm flex-grow-1" style="width: 68%;"> -->
<!-- 	                                        <div class="progress-bar bg-primary rounded" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="avatar-group"> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-7.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-8.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td><span class="badge badge-soft-success">Completed</span></td> -->
<!-- 	                            <td class="text-muted">26 Nov 2021</td> -->
<!-- 	                        </tr>end tr -->
<!-- 	                        <tr> -->
<!-- 	                            <td class="fw-semibold">Chat Application</td> -->
<!-- 	                            <td> -->
<!-- 	                                <img src="assets/images/users/avatar-5.jpg" class="avatar-xxs rounded-circle me-1" alt=""> -->
<!-- 	                                <a href="javascript: void(0);" class="text-reset">Pauline Moll</a> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="d-flex align-items-center"> -->
<!-- 	                                    <div class="flex-shrink-0 text-muted me-1">64%</div> -->
<!-- 	                                    <div class="progress flex-grow-1 progress-sm" style="width: 68%;"> -->
<!-- 	                                        <div class="progress-bar bg-primary rounded" role="progressbar" style="width: 64%" aria-valuenow="64" aria-valuemin="0" aria-valuemax="100"></div> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="avatar-group"> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-2.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td><span class="badge badge-soft-warning">Progress</span></td> -->
<!-- 	                            <td class="text-muted">15 Dec 2021</td> -->
<!-- 	                        </tr>end tr -->
<!-- 	                        <tr> -->
<!-- 	                            <td class="fw-semibold">Create Wireframe</td> -->
<!-- 	                            <td> -->
<!-- 	                                <img src="assets/images/users/avatar-6.jpg" class="avatar-xxs rounded-circle me-1" alt=""> -->
<!-- 	                                <a href="javascript: void(0);" class="text-reset">James Bangs</a> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="d-flex align-items-center"> -->
<!-- 	                                    <div class="flex-shrink-0 text-muted me-1">77%</div> -->
<!-- 	                                    <div class="progress flex-grow-1 progress-sm" style="width: 68%;"> -->
<!-- 	                                        <div class="progress-bar bg-primary rounded" role="progressbar" style="width: 77%" aria-valuenow="77" aria-valuemin="0" aria-valuemax="100"></div> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td> -->
<!-- 	                                <div class="avatar-group"> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-1.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-6.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                    <div class="avatar-group-item"> -->
<!-- 	                                        <a href="javascript: void(0);" class="d-inline-block"> -->
<!-- 	                                            <img src="assets/images/users/avatar-4.jpg" alt="" class="rounded-circle avatar-xxs"> -->
<!-- 	                                        </a> -->
<!-- 	                                    </div> -->
<!-- 	                                </div> -->
<!-- 	                            </td> -->
<!-- 	                            <td><span class="badge badge-soft-warning">Progress</span></td> -->
<!-- 	                            <td class="text-muted">21 Dec 2021</td> -->
<!-- 	                        </tr> -->
	                        <!-- end tr -->
	                    </tbody><!-- end tbody -->
	                </table><!-- end table -->
	            </div>
	
	            <div class="align-items-center mt-xl-3 mt-4 justify-content-between d-flex">
	                <div class="flex-shrink-0">
	                    <div class="text-muted">Showing <span class="fw-semibold">5</span> of <span class="fw-semibold">25</span> Results </div>
	                </div>
	                <ul class="pagination pagination-separated pagination-sm mb-0">
	                    <li class="page-item disabled">
	                        <a href="#" class="page-link">←</a>
	                    </li>
	                    <li class="page-item">
	                        <a href="#" class="page-link">1</a>
	                    </li>
	                    <li class="page-item active">
	                        <a href="#" class="page-link">2</a>
	                    </li>
	                    <li class="page-item">
	                        <a href="#" class="page-link">3</a>
	                    </li>
	                    <li class="page-item">
	                        <a href="#" class="page-link">→</a>
	                    </li>
	                </ul>
	            </div>
	
	        </div><!-- end card body -->
	    </div><!-- end card -->
	</div><!-- end col -->
	
	
	</div><!-- end row -->



</body>
</html>