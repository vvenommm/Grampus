<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<% 
int projId = (int)session.getAttribute("projId");
%>
<script type="text/javascript">
$(function(){

	//editor
	const Editor = toastui.Editor;
	const editor = new Editor({
		el: document.querySelector('#editor'),
		height: '300px',
		initialEditType: 'wysiwyg',
		previewStyle: 'vertical'
	});
	
	//ediotr내용 hidden에 넣어서 보내주기
	$('#btn').on('click',function(){
		var wikiTtl = $('#wikiTtl').val();
		//var check = $("#editor").find('p').text();
		var check = editor.getHTML();
		//alert("wikiTtl : " + wikiTtl);
		//alert("check : " + check);
		
		if(wikiTtl==""||check==""){
			Swal.fire({
	            text: '내용은 필수 입력값입니다.',
	            imageUrl: '/resources/image/alertLogo.png',
	            imageHeight: 25,
	            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})

		}else{
			var dd = $('#wikiCn').val(check);
			var form = $("#frm");
			form.submit();
		}
	})
	
	
 }); 
			
</script>

	<div>
		<div style="margin:20px;">
			<form action="/wiki/wikiInsertPost" method="post" id="frm">
				<!-- 프로젝트 아이디 나중에 받아와야함!!!   -->
				<input type="hidden" name="projId" value="<%=projId %>" />
				<div>
				<input id="wikiTtl" type="text" name="wikiTtl" class="form-control" placeholder="제목" />
				</div>
				<div id="editor"></div>
				<input id="wikiCn" type="hidden" name="wikiCn" />
				<br />
				<div class="text-end">
					<button id="btn" class="btn btn-outline-success waves-effect waves-light" type="button">등록</button>
					<button id="cancelInsert" class="btn btn-outline-danger waves-effect waves-light" type="button">취소</button>
				</div>
			</form>
		</div>
	</div>
