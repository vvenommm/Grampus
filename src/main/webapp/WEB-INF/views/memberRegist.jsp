<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
	$(function() {
		//전역변수 선언
		let code;
		
		//아이디(이메일) 기본 정규식
		//비밀번호 정규식 최소 8자 이상으로 영문자 대문자, 영문자 소문자, 숫자, 특수문자가 각각 최소 1개 이상
		//이름 기본 정규식
		const idRegex = /(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/;
		const pwRegex = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~#?!@$ %^&*-]).{8,}$/;
		const nmRegex = /^[가-힣]+$/;
		
		//입력값 중 하나라도 만족하지 못한다면 회원가입 처리를 막기 위한 논리형 변수 선언.
		let chk1 = false, chk2 = false, chk3 = false, chk4 = false; chk5=false;
		
		//회원 번호는 자동으로 설정, 회원이 건들지 못하게 막기
		$("#memNo").attr("readonly", true);
		
		//1.ID(이메일)입력값 검증
		$("#memId").keyup(function(){
			let idChk = document.getElementById('idChk');
			let correctColor = "#67b173";
			let wrongColor = "#EB0000";
			
			if($("#memId").val() == ""){ //빈값이라면
				idChk.style.color = wrongColor;
				idChk.innerHTML = "이메일은 필수값입니다.";
				chk1 = false;
			}else if(!idRegex.test($("#memId").val())){ //정규표현식이 틀렸다면
				idChk.style.color = wrongColor;
				idChk.innerHTML = "이메일 형식이 아닙니다. 이메일 형식에 맞게 써주세요.";
				chk1 = false;
			}else if($("#memId").val().length > 30){
				idChk.style.color = wrongColor;
				idChk.innerHTML = "아이디가 너무 깁니다. 다른 아이디를 사용해주세요.";
				chk1 = false;
			}
			else{
				idChk.style.color = correctColor
				idChk.innerHTML = "올바른 이메일 형식입니다.";
				chk1 = true;
			}
		});
		
		//id가 btnDupChk인 버튼을 누르면 아이디 중복 체크 이벤트 처리
		$("#btnDupChk").on("click", function() {
			let memId = $("#memId").val();
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
							
							if(idRegex.test($("#memId").val())){
								$('#emailConfirm').show();
								
								// 메일 ajajx 함수
								$(function mailcode(){
									const email = $("#memId").val(); //이메일 주소값 얻어오기
									console.log('완성된 이메일 : ' + email); //이메일 오는지 확인
									const checkInput = $('.mail-check-input').val(); //인증번호 입력하는곳
									
									$.ajax({
										type : 'get',
										url :'<c:url value="/mailCheck?email="/>'+email, // get방식이라 Url 뒤에 email을 붙일 수 있다.
										success : function(data){
//	 										console.log("data : " + data);
											$("#inputCode").removeAttr('disabled');
// 											code = data;
											code = 0000
											Swal.fire(
									            {
									                text: '인증번호가 전송되었습니다.',
									                icon: 'success',
									                confirmButtonClass: 'btn btn-outline-success w-xs me-2 mt-2',
									                buttonsStyling: false,
									                showCloseButton: true
									            }
										    )
										}
									}); //end ajax
									
								});// end send email
							} else{
								Swal.fire({
							        text: '이메일 형식에 맞게 작성해주세요.',
							        imageUrl: '/resources/image/alertLogo.png',
						            imageHeight: 25,
							        confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
							        buttonsStyling: false,
							        showCloseButton: true
							    })
							}

						} else {
							Swal.fire({
						        text: '이미 가입된 아이디 입니다.',
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
// 		console.log("inputCode " + inputCode);
// 		console.log("code " + code);
		
  		if(inputCode == code){
  			resultMsg.html('인증번호가 일치합니다.');
  			resultMsg.css("color","#67b173");
  			$("#btnDupChk").attr("disabled", true);
  			$("#memId").attr("readonly", true);
  			$("#inputCode").attr("disabled", true);
  			$("mailCheckBtn").attr("disabled", true);
  			chk2 = true;
  		}else{
  			resultMsg.html('인증번호가 불일치 합니다. 다시 확인해주세요!');
  			resultMsg.css("color","red");
  			chk2 = false;
  		}
	});
		
		

		//  	$("#memPwConfirm").on("focusout", function(){
		//  		let memPwConfirm = $("#memPwConfirm").val().trim();
		//  		let memPw = $("#memPw").val().trim();

		//  		//비밀번호 확인이 다르다면
		//  		if(memPwConfirm!=memPw){
		//  			alert("비밀번호확인을 다시 해주세요. 비밀번호가 다릅니다.");
		//  			$("#memPw").val("");
		//  			$("#memPwConfirm").val("");
		//  		}else{
		//  			alert("비밀번호가 일치합니다. 사용 가능합니다.")
		//  		}
		//  	});
		
			
		//비밀번호 필수값 체크
// 		$("#memPw").on("focusout", function(){
// 			let memPw = $("#memPw").val()
// 			let pwChk = document.getElementById('pwChk');
// 			let correctColor = "#67b173";
// 			let wrongColor = "#EB0000";
// 			var passWordTest = pwRegex.test(memPw);
			
// 			if(memPw == ""){
// 				pwChk.style.color = wrongColor;
// 				pwChk.innerHTML = "비밀번호는 필수 정보 입니다.";
// 				chk3 = false;
// 			}else if(!passWordTest){
// 				pwChk.style.color = wrongColor;
// 				pwChk.innerHTML = "비밀번호가 형식에 맞지 않습니다.";
// 				chk3 = false;
// 			}else{
// 				pwChk.innerHTML = "";
// 			}
// 		});
		
		
		//비밀번호 확인 체크
		//아이디가 memPwConfirm인 요소의 focus가 out이 되었을 때
// 		$("#memPwConfirm").on("focusout", function() {
// 			let memPwConfirm = $("#memPwConfirm").val();
// 			let memPw = $("#memPw").val();
// 			let confrimMsg = document.getElementById('#confirmMsg');
// 			let correctColor = "#67b173";
// 			let wrongColor = "#EB0000";
// 			var passWordTest = pwRegex.test(memPw);
// 			console.log("passWordTest : " + passWordTest);
			
			//비밀번호 유효성 검사
// 			if (passWordTest&&memPw == memPwConfirm) {
// 				confirmMsg.style.color = correctColor;
// 				confirmMsg.innerHTML = "비밀번호가 일치합니다.";
// 				chk3 = true;
// 			}
// 			else if(!passWordTest){
// 				confirmMsg.style.color = wrongColor;
// 				confirmMsg.innerHTML = "비밀번호가 형식에 맞지 않습니다.";
// 				$("#memPw").val("");
// 				$("#memPwConfirm").val("");
// 				chk3 = false;
// 			}else if(memPw != memPwConfirm){
// 				confirmMsg.style.color = wrongColor;
// 				confirmMsg.innerHTML = "비밀번호가 일치하지 않습니다. 다시 입력해주세요.";
// 				$("#memPwConfirm").val("");
// 				chk3 = false;
// 			}
// 		});
		
		//이름 입력값 검증
// 		$("#memNm").keyup(function(){
// 			let memNm = $("#memNm").val()
// 			let nmChk = document.getElementById('nmChk');
// 			let correctColor = "#67b173";
// 			let wrongColor = "#EB0000";
			
// 			if(memNm == ""){
// 				nmChk.style.color = wrongColor;
// 				nmChk.innerHTML = "이름은 필수 정보 입니다.";
// 				chk4 = false;
// 			}else if(!nmRegex.test($("#memNm").val())){ //정규표현식이 틀렸다면
// 				nmChk.style.color = wrongColor;
// 				nmChk.innerHTML = "이름 형식이 아닙니다. 이름 형식에 맞게 써주세요.";
// 				chk4 = false;
// 			}else{
// 				nmChk.style.color = correctColor
// 				nmChk.innerHTML = "올바른 이름 형식입니다.";
// 				chk4 = true;
// 			}
// 		});
		
		
		$('#inviYes').on('click', function(){
			if ( $('input[name=inviRadio]:checked').val()) {
				let inviCd = document.getElementById('inviCd');
				let correctColor = "#67b173";
				inviCd.style.color = correctColor;
				inviCd.innerHTML = "";
				chk5 = true;
			}
			
			//초대장 라디오버튼 선택
			if ( $('input[name=inviRadio]:checked').val()) {
				if( $('#inviYes').val() ){
					$('#inviCodeInput').attr('style', 'visibility:show');
				}
			}
		})

		$('#inviNo').on('click', function(){
			if ( $('input[name=inviRadio]:checked').val()) {
				$('#inviCodeInput').attr('style', 'visibility:hidden');
				let inviCd = document.getElementById('inviCd');
				let correctColor = "#67b173";
				inviCd.style.color = correctColor;
				inviCd.innerHTML = "";
				chk5 = true;
			}
		})
		
		//회원가입 버튼 작동
		$('#signUpBtn').click(function(){
			//초대장 라디오버튼 선택
			if ( ! $('input[name=inviRadio]:checked').val()) {
				let inviCd = document.getElementById('inviCd');
				let wrongColor = "#EB0000";
				inviCd.style.color = wrongColor;
				inviCd.innerHTML = "초대장 수신 여부를 선택해주세요.";
				chk5 = false;
			}else{
				let inviCd = document.getElementById('inviCd');
				let correctColor = "#67b173";
				inviCd.style.color = correctColor;
				inviCd.innerHTML = "";
				chk5 = true;
			}
			$(".member").submit();
// 			if(chk1 && chk2 && chk3 && chk4 && chk5){
// 				$(".member").submit();
// 			}else{
// 				Swal.fire({
// 			        text: '필수항목을 입력해주세요.',
// 	                icon: 'warning',
// 	                confirmButtonClass: 'btn btn-warning w-xs me-2 mt-2',
// 	                buttonsStyling: false,
// 			    })
// 			}
		});

		
		
	$('#memId').on('click', function(){
		$('#memId').val("55tggcc@gmail.com");
		$('#memPw').val("000000");
		$('#memPwConfirm').val("000000");
		$('#memNm').val("서고윤");
	});

	});
</script>
<div class="page-content">

<br />
<div class="row justify-content-center">
	<div class="col-md-8 col-lg-6 col-xl-4">
		<div class="text-center mt-2">
                   <h5 class="text-primary"><img src="/resources/image/grampusLetterLogo.png" alt="" height="22"></h5>
                   <p>회원가입</p>
<!-- 					<button class="btn btn-outline-dark" id="join">테스트 데이터</button>  -->
       	</div>
		<div class="p-2 mt-2">
			<form:form modelAttribute="memberVO" class="member" action="/memberRegistPost"
				method="post">
				<div>
					<!-- 텍스트 박스. M + 0000 4자리 숫자 회원번호 -->
					<form:input path="memNo" class="form-control" style="display:none;" />
				</div>
				<div class="mb-3">
					<label for="useremail" class="form-label">회원ID <span class="text-danger">*</span>
					</label>&nbsp;&nbsp;&nbsp;<span id="idChk"></span>
					<!-- 텍스트박스 + 버튼 -->
<!-- 					<div class="hstack gap-3 justify-content-center"> -->
					<div class="row justify-content-center">
						<div class="col-9">
							<form:input path="memId" class="form-control" placeholder="이메일을 작성해주세요." required="" />
						</div>
						<div class="col-3">
						<button type="button" class="btn btn-info waves-effect"
							id="btnDupChk">이메일 인증</button>
						</div>
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
					<label class="form-label" for="password-input">비밀번호 <span class="text-danger">*</span></label>&nbsp;&nbsp;&nbsp;<span id="pwChk"></span>
					<div class="position-relative auth-pass-inputgroup">
						<p>(대문자, 특수문자, 숫자, 영문자 조합으로 8자리 이상 작성해주세요.)</p>
							<form:password path="memPw" class="form-control" placeholder="비밀번호를 입력해주세요." />
					</div>
				</div>
				<!-- 비밀번호 확인 -->
				<div class="mb-3">
					<label class="form-label" for="password-input">비밀번호 확인 <span class="text-danger">*</span></label>&nbsp;&nbsp;&nbsp;<span id="confirmMsg"></span>
					<div class="position-relative auth-pass-inputgroup">
						<input type="password" name="memPwConfirm" id="memPwConfirm"
							class="form-control" placeholder="비밀번호를 한 번 더 입력해주세요." />
					</div>
				</div>
				
				<!-- 이름 입력 -->
				<div class="mb-3">
					<label class="form-label" for="username">이름 <span class="text-danger">*</span>
					</label>&nbsp;&nbsp;&nbsp;<span id="nmChk"></span>
					<div>
						<form:input path="memNm" class="form-control"
							placeholder="이름을 작성해주세요." />
					</div>
				</div>
				
				<!-- 초대장 코드 입력 -->
				<div class="mb-3">
					<label class="form-label" for="inviCd">초대장 수신 <span class="text-danger">*</span></label>&nbsp;&nbsp;&nbsp;<span id="inviCd"></span>
					
					<ul class="inviChk" style="list-style: none;">
						<li>
							<div class="form-check form-radio-dark mb-3">
							    <input class="form-check-input" type="radio" name="inviRadio" id="inviNo">
							    <label class="form-check-label" for="inviNo">
							        초대장 비수신
							    </label>
							</div>
						</li>
						
						<li>
							<div class="form-check form-radio-info mb-3">
							    <input class="form-check-input" type="radio" name="inviRadio" id="inviYes">
							    <label class="form-check-label" for="inviYes">
							        초대장 수신
							    </label>
							</div>
						</li>
					</ul>

					<div id="inviCodeInput" style="visibility: hidden;">
						<form:input path="inviCd" class="form-control"
							placeholder="초대장에 적힌 초대 코드를 입력해주세요." />
					</div>
				</div>
				<!-- 회원가입 등록 버튼 -->
				<div class="hstack gap-2 justify-content-center">
					<button class="btn btn-success w-100" type="button" id="signUpBtn" name="signUpBtn">가입</button>
					<a href="/login" class="btn btn-danger waves-effect waves-light w-100">취소 </a>
				</div>
			</form:form>
		</div>

	</div>
</div>
</div>