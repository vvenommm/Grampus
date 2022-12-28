<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%
	String memNo = (String) session.getAttribute("memNo");
%>

<c:set var="memNo" value="<%=memNo%>"></c:set>
<div class="page-content">
<form id="frm" action="/qnaWritePost" method="post">
	<c:if test="${memNo != null}">
		<input type="hidden" name="memNo" value="${memNo }" />
	</c:if>
	<c:if test="${memNo == null}">
		<input type="hidden" name="memNo" value="" />
	</c:if>
	<div>
		<button type="button" id="createVal" class="btn btn-ghost-dark waves-effect waves-light"></button>
		<div class="row g-1">
			<div class="col-lg-10">
				<div>
					<input type='text' class='form-control form-control-user'
						id="qnaTtl" name="qnaTtl" placeholder="제목" />
				</div>
			</div>
			<div class="col-lg-2">
				<div>
					<input type='text' class='form-control form-control-user'
						id="qnaNim" name="qnaNim" placeholder="닉네임" />
				</div>
			</div>
		</div>
		<div id="editor"></div>
		<input type="hidden" name="qnaCn" id="qnaCn" />
		<div>
			<br />
			<p>
				<input class="form-check-input" type="radio" type="radio"
					name="radio" value="N"/><label for="r1">공개 </label> &nbsp; <input
					class="form-check-input" type="radio" type="radio" name="radio"
					value="Y" checked/><label for="r2">비공개</label>
			</p>
			<p class="text-muted">비밀번호를 숫자로만 입력하시오.</p>
			<div style="width: 200px;" id="passCheck">
					<input type="password" class="form-control pe-5 password-input" name="qnaPw" id="qnaPw"
						oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
			</div>
		</div>
		<div class="row g-4 mb-3">
			<div class="col-sm">
				<p class="text-muted" style="text-align:center;" >단, 비회원은 수정 삭제가 불가능합니다.</p>
				<div class="d-flex justify-content-sm-center gap-2">
					<input type="submit" id="write" class="btn btn-outline-success waves-effect" value="등록" />
					<a href="/faqList" class="btn btn-outline-danger waves-effect">취소 </a>
				</div>
			</div>
		</div>
	</div>
</form>
</div>
<script
	src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		/* 에디터 */
		const Editor = toastui.Editor;
		const editor = new Editor({
			el : document.querySelector('#editor'),
			height : '300px',
			initialEditType : 'wysiwyg',
			previewStyle : 'vertical'
		});
		
		//테스트 데이터 자동입력
		$('#qnaTtl').on('click', function(){
			$('#qnaTtl').val("플랜 결제 문의");
			editor.setHTML("플랜 결제할 때 계좌이체 되나요?");
			$('#qnaNim').val("고고윤");
			$('#qnaPw').val("0000");
		});
		
		
		/* 비밀글여부 */
		$("input:radio[name=radio]").click(function() {
			if ($("input:radio[name=radio]:checked").val() == "N") {
				// radio 버튼이 0이라면 text상자 비활성화
				$("input:password[name=qnaPw]").attr("readonly", true);
			} else if ($("input:radio[name=radio]:checked").val() == "Y") {
				// radio 버튼이 1이라면 text상자 활성화
				$("input:password[name=qnaPw]").attr("readonly", false);
			}
		})

		/* 등록 */
		$("#write").on("click", function() {
			var qnaTtl = $("#qnaTtl").val();
			var qnaNim = $("#qnaNim").val();
			var qnaCn = editor.getHTML();
			var qnaPw = $("#qnaPw").val();
			
			//p태그 제거하여 DB에 저장하기
			console.log("qnaNim : " + qnaNim);
			console.log("qnaTtl : " + qnaTtl);
			console.log("qnaCn : " + qnaCn);
			console.log("qnaPw : " + qnaPw);
		
			
			//제목 입력 안했을 때
		 	if(qnaTtl == null || qnaTtl == "") {
		 		$("#qnaTtl").css("border", "1px solid red");
		 		$("#qnaTtl").focus();
		 		Swal.fire({
		            text: '제목은 필수 입력값입니다.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
		 		return false;
		 	}
			
			
			//닉네임 입력 안했을 때
		 	if(qnaNim == null || qnaNim == "") {
		 		$("#qnaNim").css("border", "1px solid red");
		 		$("#qnaNim").focus();
		 		Swal.fire({
		            text: '닉네임은 필수 입력값입니다.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
		 		return false;
		 	}
		 	
			//내용 입력안했을 시
		 	if(qnaCn == null || qnaCn == "") {
		 		editor.focus();
		 		Swal.fire({
		            text: '내용은 필수 입력값입니다.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
		 		return false;
		 	}

			if ($("input:radio[name=radio]:checked").val() == "Y") { // radio 버튼이 1이라면 비밀번호 유효성 검사
				//비밀번호 입력안했을 때
				if(qnaPw == null || qnaPw == "") {
					$("#qnaPw").css("border", "1px solid red");
			 		$("#qnaPw").focus();
					Swal.fire({
			            text: '비밀번호는 필수 입력값입니다.',
			            imageUrl: '/resources/image/alertLogo.png',
			            imageHeight: 25,
			            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
			            buttonsStyling: false,
			            showCloseButton: true
			      	})
			 		return false;
					
				}
				if(qnaPw.length != 4) {
					Swal.fire({
			            text: '비밀번호는 4자리 입니다.',
			            imageUrl: '/resources/image/alertLogo.png',
			            imageHeight: 25,
			            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
			            buttonsStyling: false,
			            showCloseButton: true
			      	})
			 		return false;
				}
			}
			
			$("#qnaCn").val(qnaCn);
		})
		
		$("#createVal").on("click",function(){
			$('#qnaTtl').val("플랜 결제 문의");
			editor.setHTML("플랜 결제할 때 계좌이체 되나요?");
			$('#qnaNim').val("고고윤");
			$('#qnaPw').val("0000");
		});

	})
</script>