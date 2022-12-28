<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%
	int projId = (int) session.getAttribute("projId");
	int pmemCd = (int) session.getAttribute("pmemCd");
	String pmemGrp = (String) session.getAttribute("grp");
%>
<c:set var="pmemGrp" value="<%=pmemGrp%>"></c:set>
<c:set var="pmemCd" value="<%=pmemCd%>"></c:set>

<form id="frm" action="/board/boardWritePost" method="post" enctype="multipart/form-data">
	<input type="hidden" id="pmemCd" name="pmemCd" value="<%=pmemCd%>" />
	<input type="hidden" id="pmemGrp" name="pmemGrp" value="<%=pmemGrp%>" />
	<input type="hidden" id="projId" name="projId" value="<%=projId%>" />
	<div class="col-sm-12 col-md-6">
		<div class="dataTables_length" id="dataTable_length">
			<label> <select name=brdHead id="brdHead"
				class="form-select mb-3" aria-label="Default select example">
					<option value="2" selected>헬프데스크</option>
					<option value="1">자유게시판</option>
			</select>
			</label>
		</div>
	</div>
	<div>
		<input type='text' class='form-control form-control-user' id="brdTtl"
			name="brdTtl" placeholder="제목" />
	</div>
	<div id="editor"></div>
	<input type="hidden" name="brdCn" id="brdCn" />
	<br />
	<div class="mb-3">
		<input class="form-control" id="project-thumbnail-img" type="file" name="uploadFile" multiple />
	</div>
	<div class="row g-4 mb-3">
       <div class="col-sm">
           <div class="d-flex justify-content-sm-center gap-2">
             	<input type="submit" id="write" class="btn btn-outline-success waves-effect" value="등록" />
<!--              	헤더가 들어오지 않아 그냥 이전으로 가기. -->
        		<input type="button" class="btn btn-outline-danger wave" value="취소" onclick="history.back()"/>
           </div>
       </div>
    </div>
</form>


<script
	src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="/resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script type="text/javascript">
	$(function() {
		//////////////////////////
		/* 에디터 */
		const Editor = toastui.Editor;
		const editor = new Editor({
			el : document.querySelector('#editor'),
			height : '300px',
			initialEditType : 'wysiwyg',
			previewStyle : 'vertical'
		});
		$("#write").on("click", function() {
			var brdTtl = $("#brdTtl").val();
			var projId = $("#projId").val();
			var brdCn = editor.getHTML();
			console.log(projId);
			console.log(brdTtl);
			console.log(brdCn);
			
			//닉네임 입력 안했을 때
		 	if(brdTtl == null || brdTtl == "") {
		 		$("#brdTtl").css("border", "1px solid red");
		 		$("#brdTtl").focus();
		 		Swal.fire({
		            text: '제목은 필수 입력값입니다.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
		 		return false;
		 	}
		 	
			//내용 입력안했을 시
		 	if(brdCn == null || brdCn == "") {
		 		editor.focus();
		 		Swal.fire({
		            text: '내용은 필수 입력값입니다.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
		 		return false;
		 	}
			
			$("#brdCn").val(brdCn);
			return true;

		})
	})
</script>