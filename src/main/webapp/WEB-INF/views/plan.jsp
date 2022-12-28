<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript"
	src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">

//회원이 아닐 때 시작하기 버튼 누르면 로그인 하라고 이동시키기
function notMember(){
	Swal.fire({
        text: "로그인 하시겠습니까?",
        imageUrl: '/resources/image/alertLogo.png',
        imageHeight: 25,
        showCancelButton: true,
        confirmButtonClass: 'btn btn-outline-primary w-xs me-2 mt-2',
        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
        buttonsStyling: false,
        showCloseButton: true
      }).then(function (result) {
        if (result.value) {
        	location.href="/login";
        }
    });
}

//수정 버튼 누르면 요소 숨기고 드러내기
function editPlan(id){
	
	document.getElementById('price' + id).value = "";
	var div1 = document.getElementById('divPrice' + id);
	var div2 = document.getElementById('priceDiv' + id);
	
	div1.setAttribute('style', 'display:none');
	div2.setAttribute('style', 'display:block');
	$("#upDel" + id).css("display", "none"); 
	
}

//플랜 가격 수정하기
function updatePrice(id){
	var priceInput = document.getElementById('priceInput' + id);
	var priceBtn = document.getElementById('priceBtn' + id);
	
	var price = priceInput.value;
	
	var data = {"planPrice" : price, "planId" : id};
	
	$.ajax({
		url : "/updatePrice",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		success : function(res){
			JSON.stringify(res);
			console.log(res);
			
			if(res.id != '0'){
				price = res.price;

				var div1 = document.getElementById('divPrice' + id);
				var div2 = document.getElementById('priceDiv' + id);
				
				document.getElementById('price' + id).innerHTML = price + '<span class="fs-14 text-muted"> 원</span>';
				
				div1.setAttribute('style', 'display:block');
				div2.setAttribute('style', 'display:none');
			}
		}
	});
	$("#upDel" + id).css("display", "block"); 
}

var planid = "";


//닫기 누르면 선택 그룹창 초기화
function close(){
	var typeName = document.getElementById('typeName');
	typeName.innerHTML = "선택";
}

function noProj(){
	Swal.fire(
		{
		    title: "개설한 프로젝트가 없습니다.",
		    text: '프로젝트 개설 후에 이용해주세요.',
		    icon: 'error',
		    confirmButtonClass: 'btn btn-outline-primary w-xs mt-2',
		    buttonsStyling: false,
		    showCloseButton: true
		}
	)
	
}

var planId = 0;
var planTtl = "";
var typeName = "";
//결제 누르면 플랜 아이디 전역 변수에 저장하기
function passPlanId(id, ttl){
	planId = id;
	planTtl = ttl;
	
	var selectedPlan = document.getElementById('selectedPlan');
	selectedPlan.innerHTML = ttl;
}

//결제 누르면 뜨는 모달 창에서 프로젝트 개설 누르면 개설 페이지로 이동
function addProj(){
	location.href="/project/newProject";
}

var projId = 0;
//모달에서 프로젝트 제목 선택하면 프로젝트 아이디랑 제목 매개변수로 전달받음
function selectTtl(id, ttl){
	projId = id;
	var projTtl = ttl;
	
	var btn = document.getElementById('typeName');
	btn.innerHTML = ttl;
}

//모달에서 결제버튼 누르면 실행
function pay(){
	
	payment();
}

//결제 API
function payment() {
	var price = document.getElementById('price' + planId).dataset.num;
	
	//가맹점 주문번호 랜덤발생
	rnd = Math.random();
	
    IMP.init('imp62720121');//아임포트 관리자 콘솔에서 확인한 '가맹점 식별코드' 입력
    IMP.request_pay({// param
        pg: "html5_inicis", //pg사명 or pg사명.CID (잘못 입력할 경우, 기본 PG사가 띄워짐)
        pay_method: "card", //지불 방법
        merchant_uid: rnd, //가맹점 주문번호 (아임포트를 사용하는 가맹점에서 중복되지 않은 임의의 문자열을 입력)
        name: 'Grampus', //결제창에 노출될 상품명
        amount: price, //금액
        buyer_email : "testiamport@naver.com", 
        buyer_name : "홍길동",
        buyer_tel : "01012341234"
    }, function (rsp) { // callback
        if (rsp.success) {
        	
        	var data = {"planId" : planId, "planTtl" : planTtl, "projId" : projId};
        	
			$.ajax({
				url : "/paying",
				contentType : "application/json;charset=utf-8",
				data : JSON.stringify(data),
				type : "post",
				success : function(res){
					console.log(res);
					
					if(res == 2){
						
						Swal.fire({
							title: "결제 성공",
		   	                text: '플랜을 적용하였습니다.',
		   	                icon: 'success',
					        showCancelButton: true,
					        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
					        confirmButtonText: '프로젝트로 이동',
					        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
					        buttonsStyling: false,
					        showCloseButton: true
					      }).then(function (result) {
					        if (result.value) {
								location.href="project/projMain/" + projId + "/전체";
					        } else  (
				                result.dismiss === Swal.DismissReason.cancel
				            )
					    });
						
			           	$('#exampleModalgrid').modal('hide');
					}else{
						Swal.fire(
			   	            {
			   	                title: "오류 발생.",
			   	                text: 'Grampus에 문의해주세요.',
			   	                icon: 'error',
			   	                confirmButtonClass: 'btn btn-outline-danger w-xs mt-2',
			   	                buttonsStyling: false,
			   	                showCloseButton: true
			   	            }
			           	 )
					}
				}
			});
        } else {
            Swal.fire(
   	            {
   	                title: "결제 실패하였습니다.",
   	                text: '자세한 사항은 Grampus에 문의해주세요.',
   	                icon: 'error',
   	                confirmButtonClass: 'btn btn-outline-danger w-xs mt-2',
   	                buttonsStyling: false,
   	                showCloseButton: true
   	            }
           	 )
        }
    });
}

</script>

<div class="page-content">
	<!-- ------------------------------------ 플랜 변경 시작  ------------------------------------- -->
	<!-- 결제 번호, 플랜명, 프로젝트 아이디 받아야함 -->
	<form id="frm" action="payment/planUpdate">
		<input type="hidden" name="payNo" id="updatePayNo" /> <input
			type="hidden" name="planTtl" id="updatePlanTtl" /> <input
			type="hidden" name="projId" id="updateProjId" /> <input
			type="submit" style="display: none" />
	</form>
	<!-- ------------------------------------ 플랜 변경 끝 --------------------------------------- -->





	<!-- ------------------------------------ 플랜 소개글 시작 ------------------------------------ -->
	<h5 style="text-align: center;">PLAN</h5>
	<div class="row justify-content-center mt-2">
		<div class="col-lg-5">
			<div class="text-center mb-2 pb-2">
				<p class="text-muted">Choose the plan that's right for you.</p>
				<!--              <p class="text-muted mb-4 fs-15">Simple pricing. No hidden fees. Advanced features for you business.</p> -->
			</div>
		</div>
		<!--end col-->
	</div>
	<!--end row-->
	<!-- ------------------------------------ 플랜 소개글 끄읕 ------------------------------------ -->


	<!-- ------------------------------------ 플랜 메뉴 리스트 시작 ------------------------------------ -->
	<div class="row justify-content-center">
		<div class="col-xl-9">
			<div class="row">

				<c:forEach var="plan" items="${planList}" varStatus="stat">
					<div class="col-lg-4">
						<div class="card pricing-box ribbon-box right border">
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
										<c:choose>
											<c:when test="${plan.ttl eq 'BASIC'}">
												<h2 id="price${plan.id}" data-num="${plan.priceNum}">
													FREE<span class="fs-14 text-muted"> 무료</span>
												</h2>
											</c:when>
											<c:otherwise>
												<h2 id="price${plan.id}" data-num="${plan.priceNum}">
													<i class="bx bx-won"></i>${plan.price}<span
														class="fs-14 text-muted"> 원</span>
												</h2>
											</c:otherwise>
										</c:choose>
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
													<b>칸반 보드 & 간트 차트</b>
												</div>
											</div>
										</li>
										<li>
											<div class="d-flex">
												<div class="flex-shrink-0 text-primary me-1">
													<i class="ri-checkbox-circle-fill fs-15 align-middle"></i>
												</div>
												<div class="flex-grow-1">
													<b>프로젝트 멤버 그룹화(grouping)</b>
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
													<b>프로젝트 기한 무제한</b>
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
													<b>프로젝트 인원 무제한</b>
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
													<button
														class="btn btn-primary w-100 waves-effect waves-light"
														disabled="disabled">기본</button>
												</c:if>
											</c:when>
											<c:otherwise>
												<c:if test="${empty id}">
													<a onclick="notMember()"
														class="btn btn-primary w-100 waves-effect waves-light">Grampus
														시작하기</a>
												</c:if>
												<c:if test="${!empty id and id ne 'admin'}">
													<c:if test="${!empty projMadeByMe}">
														<a class="btn btn-primary w-100 waves-effect waves-light"
															data-bs-toggle="modal" data-bs-target="#exampleModalgrid"
															data-planId="${plan.id}"
															onclick="passPlanId(${plan.id}, '${plan.ttl}')">결제</a>
													</c:if>
													<c:if test="${empty projMadeByMe}">
														<a class="btn btn-primary w-100 waves-effect waves-light"
															onclick="noProj()">결제</a>
													</c:if>
													<%-- 	                           				<a href="javascript:payment(${plan.id});" class="btn btn-primary w-100 waves-effect waves-light">결제</a> --%>
												</c:if>
											</c:otherwise>
										</c:choose>
										<c:if test="${id eq 'admin'}">
											<div class="mt-4 text-center" id="upDel${plan.id}">
												<button type="button"
													class="btn btn-outline-primary waves-effect waves-light"
													onclick="editPlan(${plan.id})">수정</button>
												<button onclick="delPlan(${plan.id})"
													class="btn btn-outline-danger waves-effect waves-light">삭제</button>
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


<!-- ----------------------------------------------- 프로젝트 선택하는 모달 ------------------------------------------ -->

<!-- Grids in modals -->
<div class="modal fade" id="exampleModalgrid" tabindex="-1"
	aria-labelledby="exampleModalgridLabel" aria-modal="true">
	<div class="modal-dialog">
		<div class="modal-content" style="min-height: 300px;">
			<div class="modal-header pb-6">
				<h5 class="modal-title" id="exampleModalgridLabel">프로젝트 선택</h5>
				<button type="button" class="btn-close close"
					data-bs-dismiss="modal" aria-label="Close" onclick="close()"></button>
			</div>
			<div class="modal-body pt-3">
				<%--                 <form action="javascript:void(0);"> --%>
				<div class="row g-3">
					<div class="col-xxl-12 p-2">
						<div class="hstack gap-3">
							<label for="genderInput" class="form-label">선택 플랜</label> <i
								class="bx bx-right-arrow-alt"></i>
							<h4 id="selectedPlan"></h4>
						</div>
					</div>
					<!--end col-->
					<div class="col-lg-12">
						<div class="hstack gap-2">
							<label for="projList" class="form-label">프로젝트 선택</label> <i
								class="bx bx-right-arrow-alt"></i>
							<div class="btn-group" id="projList">
								<button type="button" class="btn btn-primary dropdown-toggle"
									data-bs-toggle="dropdown" aria-haspopup="true"
									aria-expanded="false" id="typeName" style="min-width: 230px;">선택</button>
								<div class="dropdown-menu dropdownmenu-primary" id="projects"
									style="">
									<c:forEach var="proj" items="${projMadeByMe}">
										<p class="dropdown-item projTtl"
											onclick="selectTtl(${proj.projId}, '${proj.projTtl}')"
											style="cursor: pointer">
											<span class="proj" data-projId="${proj.projId}">${proj.projTtl}</span>
										</p>
									</c:forEach>
									<p class="dropdown-item border-top" onclick="addProj()">
										<i class="bx bx-plus"></i> <span id="addProj"
											style="cursor: pointer">프로젝트 개설하러 가기</span>
									</p>
								</div>
							</div>
							<!--                                 <input type="text" class="form-control" id="firstName" placeholder="Enter firstname"> -->
						</div>
					</div>
					<!--end col-->
					<div class="col-lg-12 pt-5">
						<div class="hstack gap-2 justify-content-end">
							<button type="button" class="btn btn-light close"
								data-bs-dismiss="modal" onclick="close()">닫기</button>
							<button type="submit" class="btn btn-primary" onclick="pay()">결제</button>
						</div>
					</div>
					<!--end col-->
				</div>
				<!--end row-->
				<%--                 </form> --%>
			</div>
		</div>
	</div>
</div>