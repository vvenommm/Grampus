<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
$(function(){
/* 에디터 */
const Editor = toastui.Editor;
const editor = new Editor({
	  el: document.querySelector('#editor'),
	  height: '500px',
	  initialEditType: 'wysiwyg',
	  previewStyle: 'vertical'
	});

/* 이미지 파일 확장자, 파일 크기 확인 */
$("#newsPhoto").on("change",function(){
	var fImage = $("#newsPhoto")[0].files[0];
	var regex = new RegExp("(.*?)\.(png|jpg)$");
	var maxSize = 5242880;
	var fileName = fImage.name;
	var fileSize = fImage.size;
	if(fileSize >= maxSize) {
	    alert("파일 사이즈는 5MB를 초과할 수 없습니다");
	    $("#newsPhoto").val("");
	}
	if(!regex.test(fileName)) {
	    alert("이미지 파일 확장자는 jpg, png만 가능합니다");
	    $("#newsPhoto").val("");
	}
});

$("#insert").on('click', function(){
	
	var newsTtl = $("#newsTtl").val();
	var cn = editor.getHTML();
	var newsCn = $("#editor").find('p').text();
	var newsPhoto = $("#newsPhoto")[0].files[0];
	
	var sdt = {"newsTtl":newsTtl,"cn":cn,"newsPhoto":newsPhoto};
	
	if(newsTtl==""||newsCn==""){
		Swal.fire({
            text: '필수항목을 입력해주세요.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
	}else{
		//프로젝트 등록
		$.ajax({
			url:"/writePost",
			type:"post",
			data:JSON.stringify(sdt),
			contentType:"application/json; charset=utf-8",
			success:function(res){
				if(res>0){
					//프로젝트 사진 등록
					if(newsPhoto != null){
						newsNo = res;
						var formData = new FormData();
						formData.append('file', newsPhoto);
						$.ajax({
					        type:"POST",
					        enctype:'multipart/form-data',
					        url:"newsImg?newsNo="+newsNo,
					        data:formData,
					        processData:false,
					        contentType:false,
					        success:function(res){
					        	if(res<1){
					        		alert("이미지 업로드 실패");
					        		return;
					        	}
					        }
						});
					}
					
					location.href="newsList";
					
				}else{
					alert("뉴스 등록 실패");
				}
				
			}
		});
		
	}//else
	
})

})
</script>

<%-- <form action="/writePost" method="post" enctype="multipart/form-data"> --%>
<div class="page-content">
<input type='text' class='form-control form-control-user' name="newsTtl" id="newsTtl" placeholder="제목" />

<div id="editor"></div>
<br />
<div class="mb-3">
	<input class="form-control" type="file" name="newsPhoto" id="newsPhoto">
</div>
<br />
<div class="row g-4 mb-3">
   <div class="col-sm">
       <div class="d-flex justify-content-sm-center gap-2">
         	<input type="button" id="insert" class="btn btn-outline-success waves-effect" value="등록" />
    		<input type="button" class="btn btn-outline-danger wave" value="취소" onclick="history.back()"/>
       </div>
   </div>
</div>
</div>

<%-- </form> --%>

