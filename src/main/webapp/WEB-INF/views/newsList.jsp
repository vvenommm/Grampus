<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<% String memNo =(String)session.getAttribute("memNo"); 
   String id =(String)session.getAttribute("id"); %>

<div class="page-content">
<div class="container-fluid">  
<h5 style="text-align:center;">NEWS</h5>
<p class="text-muted text-center">Check out various topics for you.</p>
<c:if test='${sessionScope.id=="admin"}'>
<div class="row g-4 mb-2">
	<div class="col-sm">
		<div class="d-flex justify-content-sm-end">
			<div class="d-flex justify-content-sm-end gap-2">
				<a href='/newsWrite'
					class="btn btn-ghost-primary waves-effect waves-light"> <i
					class="ri-add-line align-bottom me-1"></i> 뉴스 추가하기
				</a>
			</div>
		</div>
	</div>
</div>
</c:if>
<div class="row">
	<div class="col-lg-12">
		<div class="">
			<div class="card-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="row gallery-wrapper">
							<c:forEach items="${list}" var="list" varStatus="stat">
									<input type="hidden" value="${list.MEMLIKE}" id="newsLikeStts${stat.index}" />
									<input type="hidden" value="${list.NEWS_NO}" id="newsNo${stat.index}" />
									<div class="es_ment-item col-xxl-3 col-xl-4 col-sm-6 project designing development"
										data-category="designing development">
										<div class="gallery-box card">
											<div class="gallery-container">
												<a class="image-popup" href="/detail?newsNo=${list.NEWS_NO}" title=""> 
													<c:if test="${list.NEWS_PHOTO!=null}">
															<img id="newsPhotoName${list.NEWS_NO}"
																class="card-img-top img-fluid"
																src="/resources/image/${list.NEWS_PHOTO}" style="width:100%; height:200px;">
													</c:if> <!-- 이미지가 null이면 기본 이미지가 보이게 하기 --> 
													<c:if
															test="${list.NEWS_PHOTO==null}">
															<img id="newsPhotoName${list.NEWS_NO}"
																class="card-img-top img-fluid"
																src="../resources/image/고구마춘식.jpg">
													</c:if>
													<div class="gallery-overlay">
														<h5 class="overlay-caption">${list.NEWS_TTL}</h5>
													</div>
												</a>
											</div>
											<div class="box-content">
												<div class="d-flex align-items-center mt-1">
													<div class="flex-grow-1 text-muted">
														<a href="" class="text-body text-truncate">${list.NEWS_TTL}</a>
													</div>
													<div class="flex-shrink-0">
														<div class="d-flex gap-3">
														<c:choose>
															<c:when test="${list.MEMLIKE eq 0}"> <!-- likecheck가0이면 빈하트-->
															<button type="button"
																class="btn btn-sm fs-13 btn-link text-body text-decoration-none px-0" id="btn_like${stat.index}" onclick="btnLike(${stat.index});" >
																<i class="ri-heart-line"></i>
															</button>
															</c:when>
															<c:otherwise> <!-- likecheck가1이면 빨간 하트-->
															<button type="button"
																class="btn btn-sm fs-13 btn-link text-body text-decoration-none px-0" id="btn_like${stat.index}" onclick="btnLike(${stat.index});">
																<i class="ri-heart-fill" id="btnLikeOk${stat.index}" style="color:red;"></i>
															</button>
															</c:otherwise>
														</c:choose>	
															<dd id="likecnt" style="margin:4px;">${list.HIT}</dd>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
							</c:forEach>
							<div class="row g-4 mb-2">
								<div class="col-12 text-center">
									<a class="btn btn-ghost-primary waves-effect waves-light"
										id="moreList"><i class="ri-add-line align-bottom me-1"></i> 더보기</a>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- end row -->
			</div>
			<!-- ene card body -->
		</div>
		<!-- end card -->
	</div>
	<!-- end col -->
</div>
<!-- end row -->
</div>
</div>

<script type="text/javascript">

$(function(){
	
 	//더 보기 클릭
	$("#moreList").on("click",function(){
		console.log("더보기 창");
		location.href = "/newsList?listcnt="+`${listcnt+1}`;
	});
	
});

function btnLike(idx){
	
	var newsNo = $('#newsNo'+idx).val();
	var memNo = '<%=memNo%>';
	
	//만약 비회원이 누르려고 하면 로그인 해달라고 뜨기
	if(${sessionScope.memNo==null}){
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
	if(${sessionScope.id=="admin"}){
		Swal.fire({
            text: '관리자는 기능권한이 없습니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
	}
	console.log("newsNo : " + newsNo);
	console.log("memNo : " + memNo);
	$.ajax({
		url : "/saveHeart",
		type : "post",
		data :  JSON.stringify({"newsNo" : newsNo,
				"memNo" : memNo}),
		contentType : "application/json; charset=utf-8",
		success : function(res) {
			location.href = "/newsList";
		}
	});
	
}
</script>
