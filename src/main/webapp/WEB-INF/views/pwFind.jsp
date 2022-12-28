<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<div class="page-content">
<br />
<!-- 비밀번호 찾기 시작 -->
<form name="frm" class="form-signin" action="/pwFindPost" method="post" name="sendEmail">
	<div class="passFind1">
		<div class="row justify-content-center">
			<div class="col-md-8 col-lg-6 col-xl-4">
				<div class="text-center mt-5">
					<h5>비밀번호 찾기</h5>
					<p class="text-mute mt-2">찾고자 하는 비밀번호 아이디를 입력해주세요.</p>
				</div>
					<div class="mt-3 col-sm-9" style="margin-left:60px;">
						<input type="text" class="form-control" id="memId" placeholder="아이디" name="memId">
					</div>
				<div class="mt-4 text-center">
					<button class="btn btn-success" type="button" id="btnNext" onclick="loadingShow();">전송</button>
				</div>
			</div>
			<!-- end card body -->
		</div>
	</div>
	<!-- Primary Alert -->
</form>

<!-- 로딩구현 -->
<div class="spinner-border text-success loading" role="status" style="display:none;">
    <span class="sr-only">Loading...</span>
</div>


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
	setTimeout("loadingHide()", 10000);
}


$(function(){
	const idRegex = /(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/;
	
	//id가 btnDupChk인 버튼을 누르면 아이디 중복 체크 이벤트 처리
	$("#btnNext").on("click", function() {
		let memId = $("#memId").val();
		//json데이터
		let data = {
			"memId" : memId
		};
		
		$.ajax({
			url : "/idCheck",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			success : function(result) {
				console.log("result : " + JSON.stringify(result));
				$.each(result, function(index, item) {
					//item : {"result", "1"}
					let res = item;
					console.log("res : " + res);
					if (res == "1") {
						
						if(idRegex.test($("#memId").val())){
							// 메일 ajax 함수
							$(function mailcode(){
								const email = $("#memId").val(); //이메일 주소값 얻어오기
								console.log('완성된 이메일 : ' + email); //이메일 오는지 확인
								
								$.ajax({
									type : 'get',
									url :'<c:url value="/checkMail?email="/>'+email, // get방식이라 Url 뒤에 email을 붙일 수 있다.
									success : function(data){
										console.log("data : " + data);
										$.ajax({
											type : 'post',
											url : "/findPw",
											data : {"memPw" : data , 
												"memId" : memId},
											success : function(data){
												//성공 시 페이지 이동
												location.href = "/pwEmail";
											}
										})
									}
								}); //end ajax
								
							});// end send email
						}
	
					} else {
						$("#mask").remove();
						$(".loading").hide();
					    Swal.fire(
				            {
				                title: '비밀번호 찾기 실패!',
				                text: '아이디를 다시 입력해주세요.',
				                icon: 'error',
				                showCancelButton: true,
				                confirmButtonClass: 'btn btn-ghost-primary w-xs me-2 mt-2',
				                cancelButtonClass: 'btn btn-ghost-danger w-xs mt-2',
				                buttonsStyling: false,
				                showCloseButton: true
				            }
					    )
					}
				});
			}
		});
	
	}); //아이디 검사, 이메일 전송
	
	 
})


$(document).ready(function() {

$('#loading').hide();
$('#trans').submit(function(){
    $('#loading').show();
    return true;
    });
});

</script>



