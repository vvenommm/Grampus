<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<script type="text/javascript">
$(function(){
	let code;
	
	//아이디(이메일) 기본 정규식
	//비밀번호 정규식 최소 8자 이상으로 영문자 대문자, 영문자 소문자, 숫자, 특수문자가 각각 최소 1개 이상
	//이름 기본 정규식
	const idRegex = /(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/;
	const pwRegex = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~#?!@$ %^&*-]).{8,}$/;
	const nmRegex = /^[가-힣]+$/;
	
//비밀번호랑 비밀번호 확인 값이 다른데 udPage확인 버튼 누르면 확인해달라고  alert
$('#udPage').on('click',function(){
	var mPw = $('#p1').val();
	var mPwcheck = $('#p2').val();
	
	//아이디가 널이 아닌데 인증이 널이면 inputCode
	var id =$('#mId').val()
	var code = $('#inputCode').val();
	if(id != "" && code == ""){
		Swal.fire({
            text: '아이디 변경을 원하시면 인증번호를 입력해주세요.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
		return false;
	}
	if(mPw != mPwcheck){
		$('#pms').text('비밀번호가 일치하지 않습니다').css("color","red")	//div안에 비밀번호 찾으라고 넣기
		return false;
		//e.preventDefault(); //비밀번호 수정 submit 막기
	}if(mPw==""||mPwcheck==""){
		Swal.fire({
            text: '비밀번호를 입력해주세요.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
	}else{
		var form = $("#frm");
		form.submit();
	}
});
//1.ID(이메일)입력값 검증
$("#mId").keyup(function(){
	let idChk = document.getElementById('idChk');
	let correctColor = "#4AB34A";
	let wrongColor = "#EB0000";
	
	if(!idRegex.test($("#mId").val())){ //정규표현식이 틀렸다면
		idChk.style.color = wrongColor;
		idChk.innerHTML = "이메일 형식이 아닙니다. 이메일 형식에 맞게 써주세요.";
	}else if($("#mId").val().length > 30){
		idChk.style.color = wrongColor;
		idChk.innerHTML = "아이디가 너무 깁니다. 다른 아이디를 사용해주세요.";
	}
	else{
		idChk.style.color = correctColor
		idChk.innerHTML = "올바른 이메일 형식입니다.";
	}
	
});

//id가 btnDupChk인 버튼을 누르면 아이디 중복 체크 이벤트 처리
$("#btnDupChk").on("click", function() {
	
	
	let memId = $("#mId").val();
	//json데이터
	let data = {
		"memId" : memId
	};
	
	$.ajax({
		url : "/dupChk",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		success : function(result) {
			console.log("result : " + JSON.stringify(result));
			//json 응답 데이터 처리
			//.each : jQuery의 반복문
			//첫 번째 인자로 index를 주고, 두 번째 인자로 item(콜백함수)를 줌
			//index를 기준으로 반복 함
			$.each(result, function(index, item) {
				//item : {"result", "1"}
				let rslt = item;
				console.log("rslt : " + rslt);
				if (rslt == "0") {
					
					if(idRegex.test($("#mId").val())){
						$('#emailConfirm').show();
						
						// 메일 ajajx 함수
						$(function mailcode(){
							const email = $("#mId").val(); //이메일 주소값 얻어오기
							console.log('완성된 이메일 : ' + email); //이메일 오는지 확인
							const checkInput = $('.mail-check-input').val(); //인증번호 입력하는곳
							
							$.ajax({
								type : 'get',
								url :'<c:url value="/mailCheck?email="/>'+email, // get방식이라 Url 뒤에 email을 붙일 수 있다.
								success : function(data){
//										console.log("data : " + data);
									$("#inputCode").removeAttr('disabled');
									code = data;
									Swal.fire({
							            text: '인증번호가 전송되었습니다.',
							            icon: 'success',
							            confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
							            buttonsStyling: false,
							            showCloseButton: true
							      	})
								}
							}); //end ajax
							
						});// end send email
					} else{
						Swal.fire({
				            text: '이메일을 작성해주세요.',
				            imageUrl: '/resources/image/alertLogo.png',
				            imageHeight: 25,
				            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
				            buttonsStyling: false,
				            showCloseButton: true
				      	})
					}

				} else {
					Swal.fire({
			            text: '이미 계정이 있습니다. 다시 입력해주세요.',
			            icon: 'warning',
			            confirmButtonClass: 'btn btn-warning w-xs mb-2',
			            buttonsStyling: false,
			            showCloseButton: true
			      	})
				}
			});
		}
	});


}); //아이디 검사, 이메일 전송

//인증번호 비교
//본인인증 버튼을 누를시 이벤트 발생
$("#mailCheckBtn").on("click",function(){
	const inputCode = $("#inputCode").val();
const resultMsg = $("#mail-check-warn");
//	console.log("inputCode " + inputCode);
//	console.log("code " + code);

	if(inputCode == code){
		resultMsg.html('인증번호가 일치합니다.');
		resultMsg.css("color","green");
		$("#btnDupChk").attr("disabled", true);
		$("#mId").attr("readonly", true);
		$("#inputCode").attr("disabled", true);
		$("mailCheckBtn").attr("disabled", true);
	}else{
		resultMsg.html('인증번호가 불일치 합니다. 다시 확인해주세요!');
		resultMsg.css("color","red");
	}
});

});

</script>

    
    
            
            
<div class="row justify-content-center">
	<div class="col-md-8 col-lg-6 col-xl-4">
		<div class="text-center mt-4">
                   <h5 class="text-primary"><img src="/resources/image/grampusLetterLogo.png" alt="" height="22"></h5>
                   <p>아이디 비밀번호 변경</p>
       	</div>
		<div class="p-2 mt-2">
			<form action="/mypage/memUpdate" method="post" id="frm">
			<input type="hidden" name="memNo" id="idValue" value="${memVO.memNo}" />
				<div>
					<!-- 텍스트 박스. M + 0000 4자리 숫자 회원번호 -->
				</div>
				<div class="mb-3">
					<label for="useremail" class="form-label">이메일 <span class="text-danger">*</span></label>
                    <label>${memVO.memId}</label>&nbsp;&nbsp;&nbsp;<div><span id="idChk"></span></div>
					<!-- 텍스트박스 + 버튼 -->
					<div class="hstack gap-3 justify-content-center">
						<div class="col-sm-10">
							  <input type="text" class="form-control" id="mId" name="memId" placeholder="아이디변경을 원하시면 입력해주세요">
						</div>
						<button type="button" id="btnDupChk" class="btn btn-info waves-effect waves-light">인증</button>
					</div>
					<div id="emailConfirm" style="display: none;">
						<label for="email" class="form-label"></label>
						<div class="mail-check-box">
							<div class="hstack gap-3 justify-content">
								<div class="col-sm-5">
									<input id="inputCode" name="inputCode" class="form-control"
										placeholder="인증번호 6자리를 입력해주세요!" disabled="disabled"
										maxlength="6">
								</div>
								<button type="button"
									class="btn btn-success waves-effect waves-light"
									id="mailCheckBtn">확인</button>
							</div>
						</div>
						<span id="mail-check-warn"></span>
					</div>
				</div>
				<!-- 비밀번호 입력 -->
				<div class="mb-3">
				<label for="username" class="form-label">비밀번호<span class="text-danger">*</span></label>&nbsp;&nbsp;&nbsp;<div id="pms"></div>
					<div class="position-relative auth-pass-inputgroup">
						<p>(대문자,특수문자,숫자,영문자 포함  8자리 이상으로 작성해주세요.)</p>
							<input type="password" class="form-control" placeholder="변경할 비밀번호" name="memPw" id="p1">
					</div>
				</div>
				<!-- 비밀번호 확인 -->
				<div class="mb-3">
					<label class="form-label" for="password-input">비밀번호 확인</label>
					<div class="position-relative auth-pass-inputgroup">
						<input type="password" class="form-control" onpaste="return false" placeholder="비밀번호 확인" id="p2" ><span
							id="confirmMsg"></span>
					</div>
				</div>
				
				
				<!-- 비밀번호 변경 등록 버튼 -->
				<div class="hstack gap-2 justify-content-center">
					<button class="btn btn-success w-100"type="button" id="udPage" >확인</button>
					<button type="button" class="btn btn-danger waves-effect waves-light w-100" onclick="location.href='/mypage/myPageMain'">취소</button>
				</div>
			</form>
		</div>

	</div>
</div>
            