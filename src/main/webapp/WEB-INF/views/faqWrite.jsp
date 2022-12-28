<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="page-content">
<form action="/faqWritePost" method="post">
	<div>
		<input type='text' class='form-control form-control-user' id="faqTtl" name="faqTtl" placeholder="제목" />
	</div>
	<div id="editor">
		
	</div>
	<input type="hidden" name="faqCn" id="faqCn" />
	<br />
	<div class="row g-4 mb-3">
       <div class="col-sm">
           <div class="d-flex justify-content-sm-center gap-2">
             	<input type="submit" id="write" class="btn btn-outline-success waves-effect" value="등록" />
             	<!-- 목록 페이지 바꿔주기!!!!! -->
        		<a href="/faqList" class="btn btn-outline-danger waves-effect">취소 </a>
           </div>
       </div>
    </div>
</form>
</div>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	/* 에디터 */
	const Editor = toastui.Editor;
	const editor = new Editor({
		  el: document.querySelector('#editor'),
		  height: '300px',
		  initialEditType: 'wysiwyg',
		  previewStyle: 'vertical'
	});
	
	$("#write").on("click", function(){
		var faqTtl = $("#faqTtl").val();
		var faqCn = editor.getMarkdown();
		
		//닉네임 입력 안했을 때
	 	if(faqTtl == null || faqTtl == "") {
	 		$("#faqTtl").css("border", "1px solid red");
	 		$("#faqTtl").focus();
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
	 	
		//내용 입력안했을 시
	 	if(faqCn == null || faqCn == "") {
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
	 	$("#faqCn").val(faqCn);
	 	return true;
	})
})
</script>