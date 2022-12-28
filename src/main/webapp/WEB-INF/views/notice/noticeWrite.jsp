<%@page import="kr.or.ddit.vo.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="/resources/js/jquery-3.6.0.js"></script>

<% 
	int projId = (int) session.getAttribute("projId");
	String pmemGrp = (String) session.getAttribute("grp");
	MemberVO memberVO = (MemberVO) session.getAttribute("loginVO");
	String memNo = memberVO.getMemNo();
%>

<form id="frm" action="/notice/noticeWritePost" method="post">
	<input type="hidden" id="pmemGrp" name="pmemGrp" value="<%=pmemGrp %>" />
	<input type="hidden" id="projId" name="projId" value="<%=projId %>" />
	<input type="hidden" id="memNo" name="memNo" value="<%=memNo %>" />
	<div>
		<input type="text" class="form-control form-control-user" id="ntcTtl" name="ntcTtl" placeholder="제목을 작성해주세요"/>
	</div>
	<div id="editor"></div>
	<input type="hidden" name="ntcCn" id="ntcCn" />
	<br />
	<div class="row g-4 mb-3">
       <div class="col-sm">
           <div class="d-flex justify-content-sm-center gap-2">
             	<input type="button" id="write" class="btn btn-outline-success waves-effect" value="등록" />
             	<a class="btn btn-outline-danger waves-effect" onclick="history.back()">취소 </a>
           </div>
       </div>
    </div>
</form>

<script type="text/javascript">
$(function() {
	
	/* 에디터 */
	const Editor = toastui.Editor;
	const editor = new Editor({
		el : document.querySelector('#editor'),
		height : '300px',
		initialEditType : 'wysiwyg',
		previewStyle : 'vertical'
	});
	$("#write").on("click", function() {
		var ntcTtl = $("#ntcTtl").val();
		var projId = $("#projId").val();
		var pmemCd = $("#pmemCd").val();
		var pmemGrp = $("#pmemGrp").val();
		var memNo = $("#memNo").val();
		var ntcCn = editor.getHTML();
		console.log(ntcTtl);
		console.log(ntcCn);
		console.log(projId);
		console.log(pmemCd);
		
		//닉네임 입력 안했을 때
	 	if(ntcTtl == null || ntcTtl == "") {
	 		$("#ntcTtl").css("border", "1px solid red");
	 		$("#ntcTtl").focus();
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
	 	if(ntcCn == null || ntcCn == "") {
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
		
		$("#ntcCn").val(ntcCn);	
		
		var sdt = {"ntcTtl":ntcTtl,"projId":projId,"ntcCn":ntcCn,"pmemGrp":pmemGrp, "memNo":memNo};
		
		$.ajax({
			url:"/notice/noticeWritePost",
			type:"post",
			data:JSON.stringify(sdt),
			contentType:"application/json; charset=utf-8",
			success:function(res){
				console.log("res : " + JSON.stringify(res));
				
				console.log("res.projId : " + res.projId);
				console.log("res.pmemGrp : " + res.pmemGrp);
				
					location.href="/notice/noticeList/"+res.projId+"/"+res.pmemGrp;
			}
		});
		
		return true;
		
	});
})

</script>