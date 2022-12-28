
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta content="Premium Multipurpose Admin & Dashboard Template"
	name="description" />
<meta content="Themesbrand" name="author" />

<style>
input[type=password] {
	font-family: "나눔스퀘어 아닐때 쓸 글꼴";
	&::
	placeholder
	{
	font-family
	:
	"NanumSquare";
}
}

</style>

<script>


</script>
<!-- 로그인페이지 시작 -->
<div class="page-content">

<!-- 로딩구현 -->
<div class="spinner-border text-success loading" role="status" style="display:none;">
    <span class="sr-only">Loading...</span>
</div>


<style>
	.loading{
		position : absolute;
		top: 46%;
		left: 47%;
		z-index : 1;
		width:100px;
		height:100px;
	}
</style>

<script type="text/javascript">
function loadingShow(){
	var maskHeight = $(document).height();
	var maskWidth = window.document.body.clientWidth;
	
	var mask = "<div id='mask' style='position:absolute; z-index:100; background-color:#000000; left:0; top:0;'></div>"
	
	$(".page-content").append(mask);
	
	$("#mask").css({
		'width' : maskWidth,
		'height' : maskHeight,
		'opacity' : '0.2'
	})
	
	$(".loading").show();
	setTimeout("loadingHide()", 5000);
}
</script>


<br />
<div>
	<div class="row justify-content-center mt-4">
		<div class="col-md-8 col-lg-6 col-xl-4">
			<div class="text-center mt-5">
				<h5>
					<img src="/resources/image/grampusLetterLogo.png" alt=""
						height="22">
				</h5>
			</div>
			<div class="p-2 mt-4">
				<form name="frm" class="form-signin" action="/processLogin"
					method="post">

					<div class="mb-3">
						<label for="memId" class="form-label" style="left: 0px;">아이디</label>
						<input type="text" class="form-control" id="memId"
							placeholder="아이디를 입력해주세요." name="memId" required autofocus>
					</div>

					<div class="mb-3">
						<label class="form-label" for="password">비밀번호</label>
						<div class="position-relative auth-pass-inputgroup mb-3">
							<input type="password" class="form-control pe-5"
								placeholder="비밀번호를 입력해주세요." id="password" name="password"
								required>
						</div>
					</div>

					<div class="mt-4">
						<button class="btn btn-success w-100" type="submit" onclick="loadingShow()">로그인</button>
					</div>

					<div class="mt-4 text-center">
						<h5 class="fs-13 mb-4 title">
							<a href="/pwFind" style="color:black;">비밀번호 찾기 </a> | <a href="/memberRegist" style="color:black;"> 회원가입</a>
						</h5>
						<div>
							<button type="button"
								class="btn btn-warning btn-icon waves-effect waves-light">
								<i class="ri-kakao-talk-fill"></i>
							</button>
							<button type="button"
								class="btn btn-primary btn-icon waves-effect waves-light"
								onclick="javascript:location.href='${google_url}'">
								<i class="ri-google-fill fs-16"></i>
							</button>
							<button type="button"
								class="btn btn-success btn-icon waves-effect waves-light">
								<i class="ri-github-fill fs-16"></i>
							</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<!-- end card body -->
	</div>
</div>
</div>