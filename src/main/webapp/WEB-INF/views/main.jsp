<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/loadingoverlay.min.js"></script>

<!-- Swiper -->
<div class="swiper mousewheel-control-swiper rounded"
	style="height: 800px; margin-top: 0;">
	<div class="swiper-wrapper" id="main">
		<div class="swiper-slide">
			<div class="img">
				<div class="content">
					<h1 style="color:white; font-size:70%;">GRAMPUS</h1>
					<h3 style="color:white;">Project Management System</h3>
				</div>
				<div class="img-cover"></div>
			</div>
		</div>
		<div class="swiper-slide">
			<div class="target" id="news">
			<br />
				<jsp:include page="../views/newsList.jsp"></jsp:include>
			</div>
		</div>
		<div class="swiper-slide">
			<div class="target" id="job">
			<br />
				<jsp:include page="../views/jobList.jsp"></jsp:include>
			</div>
		</div>
		<div class="swiper-slide">
			<div class="target" id="plan">
				<div class="page-content">
				<br />
					<!-- ------------------------------------ 플랜 변경 시작  ------------------------------------- -->
					<!-- 결제 번호, 플랜명, 프로젝트 아이디 받아야함 -->
					<form id="frm" action="payment/planUpdate">
						<input type="hidden" name="payNo" id="updatePayNo" /> <input
							type="hidden" name="planTtl" id="updatePlanTtl" /> <input
							type="hidden" name="projId" id="updateProjId" /> <input
							type="submit" style="display: none" />
					</form>
					<!-- ------------------------------------ 플랜 변경 끝 --------------------------------------- -->
					<h5 style="text-align:center;">PLAN</h5>
					<p class="text-muted text-center">Choose the plan that's right for you.</p>
					<br />
					<div class="row justify-content-center">
						<div class="col-xl-9">
							<div class="row">

								<c:forEach var="plan" items="${planList}" varStatus="stat">
									<div class="col-lg-4">
										<div class="card pricing-box ribbon-box right">
											<div class="card-body p-4 m-2">
												<c:if test="${plan.ttl eq 'PLUS'}">
													<div class="ribbon-two ribbon-two-danger">
														<span>Popular</span>
													</div>
												</c:if>
												<div>
													<div class="d-flex align-items-center">
														<div class="flex-grow-1">
															<h5 class="mb-1 fw-bold">${plan.ttl}</h5>
															<c:choose>
																<c:when test="${plan.ttl eq 'BASIC'}">
																	<p class="text-muted mb-0">프로젝트 개설 시 기본 적용 플랜</p>
																</c:when>
																<c:when test="${plan.ttl eq 'PLUS'}">
																	<p class="text-muted mb-0">기본 플랜 + 두 가지 기능을 더!</p>
																</c:when>
																<c:otherwise>
																	<p class="text-muted mb-0">모든 기능을 사용해보세요!</p>
																</c:otherwise>
															</c:choose>
														</div>
														<div class="avatar-sm">
															<div
																class="avatar-title bg-light rounded-circle text-primary">
																<c:choose>
																	<c:when test="${plan.ttl eq 'BASIC'}">
																		<img alt="BASIC" src="/resources/image/basic.png"
																			style="width: 30px;">
																	</c:when>
																	<c:when test="${plan.ttl eq 'PLUS'}">
																		<img alt="PLUS" src="/resources/image/plus.png"
																			style="width: 30px;">
																	</c:when>
																	<c:otherwise>
																		<img alt="PREMIUM" src="/resources/image/premium.png"
																			style="width: 30px;">
																	</c:otherwise>
																</c:choose>
															</div>
														</div>
													</div>
													<div class="pt-4" id="divPrice${plan.id}">
														<h2 id="price${plan.id}" data-num="${plan.priceNum}">${plan.price}<span
																class="fs-14 text-muted"> 원</span>
														</h2>
													</div>

													<div class='pt-4' id="priceDiv${plan.id}"
														style="display: none;" class="priceDiv">
														<div class="row g-6 mb-2">
															<div class="col-lg-15">
																<div class="d-flex justify-content-sm-center gap-2">
																	<div>
																		<input type="text" value="${plan.priceNum}"
																			id="priceInput${plan.id}"
																			class='form-control form-control-user' />
																	</div>
																	<a id="priceBtn${plan.id}"
																		class="btn btn-soft-primary waves-effect waves-light upPrice"
																		onclick="updatePrice(${plan.id})">확인</a>
																</div>
															</div>
														</div>
													</div>

												</div>
												<hr class="my-4 text-muted">
												<div>
													<ul class="list-unstyled text-muted vstack gap-3">
														<li>
															<div class="d-flex">
																<div class="flex-shrink-0 text-primary me-1">
																	<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																</div>
																<div class="flex-grow-1">
																	<b>프로젝트 대시보드</b>
																</div>
															</div>
														</li>
														<li>
															<div class="d-flex">
																<div class="flex-shrink-0 text-primary me-1">
																	<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																</div>
																<div class="flex-grow-1">
																	<b>프로젝트 로드맵</b>
																</div>
															</div>
														</li>
														<li>
															<div class="d-flex">
																<div class="flex-shrink-0 text-primary me-1">
																	<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																</div>
																<div class="flex-grow-1">
																	<b>프로젝트 멤버 일정 관리</b>
																</div>
															</div>
														</li>
														<li>
															<div class="d-flex">
																<div class="flex-shrink-0 text-primary me-1">
																	<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																</div>
																<div class="flex-grow-1">
																	<b>칸반</b>
																</div>
															</div>
														</li>
														<li>
															<div class="d-flex">
																<c:choose>
																	<c:when test="${plan.ttl eq 'BASIC'}">
																		<div class="flex-shrink-0 text-danger me-1">
																			<i class="ri-close-circle-fill fs-15 align-middle"></i>
																		</div>
																	</c:when>
																	<c:otherwise>
																		<div class="flex-shrink-0 text-primary me-1">
																			<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																		</div>
																	</c:otherwise>
																</c:choose>
																<div class="flex-grow-1">
																	<b>프로젝트 인원 무제한</b>
																</div>
															</div>
														</li>
														<li>
															<div class="d-flex">
																<c:choose>
																	<c:when test="${plan.ttl eq 'BASIC'}">
																		<div class="flex-shrink-0 text-danger me-1">
																			<i class="ri-close-circle-fill fs-15 align-middle"></i>
																		</div>
																	</c:when>
																	<c:otherwise>
																		<div class="flex-shrink-0 text-primary me-1">
																			<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																		</div>
																	</c:otherwise>
																</c:choose>
																<div class="flex-grow-1">
																	<b>프로젝트 공고 등록</b>
																</div>
															</div>
														</li>
														<li>
															<div class="d-flex">
																<c:choose>
																	<c:when test="${plan.ttl eq 'PREMIUM'}">
																		<div class="flex-shrink-0 text-primary me-1">
																			<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
																		</div>
																	</c:when>
																	<c:otherwise>
																		<div class="flex-shrink-0 text-danger me-1">
																			<i class="ri-close-circle-fill fs-15 align-middle"></i>
																		</div>
																	</c:otherwise>
																</c:choose>
																<div class="flex-grow-1">
																	<b>프로젝트 기한 무제한</b>
																</div>
															</div>
														</li>
													</ul>
													<div class="mt-4">
														<c:choose>
															<c:when test="${plan.ttl eq 'BASIC'}">
																<c:if test="${empty id}">
																	<a onclick="notMember()"
																		class="btn btn-primary w-100 waves-effect waves-light">Grampus
																		시작하기</a>
																</c:if>
																<c:if test="${!empty id and id ne 'admin'}">
																	<a href="javascript:payment(${plan.id});"
																		class="btn btn-primary w-100 waves-effect waves-light">결제</a>
																</c:if>
															</c:when>
															<c:otherwise>
																<c:if test="${empty id}">
																	<a onclick="notMember()"
																		class="btn btn-primary w-100 waves-effect waves-light">결제</a>
																</c:if>
																<c:if test="${!empty id and id ne 'admin'}">
																	<a href="javascript:payment(${plan.id});"
																		class="btn btn-primary w-100 waves-effect waves-light">결제</a>
																</c:if>
															</c:otherwise>
														</c:choose>
														<c:if test="${id eq 'admin'}">
															<div class="mt-4 text-center" id="upDel${plan.id}">
																<button type="button"
																	class="btn btn-soft-primary waves-effect waves-light"
																	onclick="editPlan(${plan.id})">수정</button>
																<button onclick="delPlan(${plan.id})"
																	class="btn btn-soft-danger waves-effect waves-light">삭제</button>
															</div>
														</c:if>
													</div>
												</div>
											</div>
										</div>
									</div>
									<!--end col-->
								</c:forEach>

							</div>
							<!--end row-->
						</div>
						<!--end col-->
					</div>
					<!--end row-->
				</div>
			</div>
		</div>
	</div>
	<div class="swiper-pagination"></div>
</div>


<script>
$(window).on('scroll', function() {
    $('.target').each(function() {
        if($(window).scrollTop() >= $(this).offset().top) {
            var id = $(this).attr('id');
            $('#nav nav a').removeClass('active');
            $('#nav nav a[href=#'+ id +']').addClass('active');
        }
    });
});



</script>

<style>
.img{
   position: relative;
   background-image: url(/resources/image/범고래인트로.webp);                                                               
   height: 93vh;
   background-size: cover;
 }

 .img-cover{
    position: absolute;
    height: 100%;
    width: 100%;       
    background-color: rgba(0, 0, 0, 0);                                      
    z-index:1;
 }

 .img .content{
    position: absolute;
    top:25%;
    left:50%;
    transform: translate(-50%, -50%);                                                                   
    font-size:5rem;
    font-color:white;
    z-index: 2;
    text-align: center;
 }

#main div.target {
	width: 90%;
	margin-left: auto;
	margin-right: auto;
}
</style>