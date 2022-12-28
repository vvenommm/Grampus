<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<!-- dropzone css -->
<link rel="stylesheet" href="resources/velzon/dist/assets/libs/dropzone/dropzone.css" type="text/css" />
<script type="text/javascript">
var editor = "";

$(function(){
	/* 에디터 */
	const Editor = toastui.Editor;
	editor = new Editor({
		  el: document.querySelector('#editor'),
		  height: '400px',
		  initialEditType: 'wysiwyg',
		  previewStyle: 'vertical'
		});
});

// window.onload = function(){

	var typeTitle = "";

function changeType(type){
	var btn = document.getElementById('typeName');
	btn.innerHTML = type;
	typeTitle = type;
	console.log(type);
}

function insert(){
	var projId = ${projId};
	var ttl = document.getElementById('title').value;
	var cn = editor.getHTML();
	var pmemCd = "${pCd}";

	var data = {"projId" : projId, "docType" : typeTitle, "docTtl" : ttl, "docCn" : cn, "pmemCd" : pmemCd};
	
	$.ajax({
		url : "/doc/docInsert",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		success : function(res){
			console.log("docUpload : "  + res);		//방금 저장된 문서번호
			
			//문서글 등록 성공 시 첨부파일도 등록되게끔
			//파일배열
			let formData = new FormData();
			let inputFile = $("input[name='uploadFile']");
			let files = inputFile[0].files;
		 	
			formData.append("docNo", res);
			
			for(let i = 0; i < files.length; i++) {
				//확장자 메서드 호출
				if(!checkExtension(files[i].name, files[i].size)) {
						return false;	//반복문 및 함수 종료
				}
				
				//formData에 append
				formData.append("uploadFile", files[i]);
			}
			
			console.log("formData : " + formData);
			$.ajax({
				url : "/doc/docInsertF",
				type : "post",
				data : formData,
				async : false,
				processData : false,
				contentType : false,
				success : function(res){
					console.log("fileUpload : " + res);
					location.href = "/doc/docMain/${projId}/${grp}";
				}
			});
		}
	});
	
}
//확장자가 exe,sh,zip,alz인지 검사 메서드
let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");	// \.: .이 있는지 검사
let maxSize = 5242880;	//5MB 

function checkExtension(fileName, fileSize) {
	if(fileSize >= maxSize) {
		alert("파일 사이즈가 초과되었습니다.");
		return false;
	}
	if(regex.test(fileName)) {
		alert("해당 확장자의 파일은 업로드할 수 없습니다.");
		return false;
	}
	return true;
}


function backToList(){
// 	history.back;
	location.href="/doc/docMain/${projId}/${grp}";
}
// }
</script>
<!-- start page title -->
<div class="row">
	<div class="col-lg-12">
		<div class="page-title-box d-sm-flex align-items-center justify-content-between">
			<div>
				<h4 class="mb-sm-0">${projVO.ttl}
					<c:if test="${iamPM.pm eq 1}">
						<span
							onclick="javascript:location.href='/project/projectSetting/${projVO.id}/${projVO.grp}'"
							style="cursor: pointer"> <i class="ri-settings-4-line"></i>
						</span>
					</c:if>
				</h4>
			</div>

			<div class="page-title-right">
				<ol class="breadcrumb m-0">
					<li class="breadcrumb-item"><a
						href="javascript: location.href='/project/projMain/${projVO.id}/${projVO.grp}';">
							<i class="ri-home-2-fill"></i>
					</a></li>
					<li class="breadcrumb-item active">${projVO.grp}</li>
					<li class="breadcrumb-item active"
						onclick="javascript: location.href='/doc/docMain/${projVO.id}/${projVO.grp}';"
						style="cursor: pointer">문서</li>
				</ol>
			</div>
		</div>
	</div>
</div>


<h6>문서 등록</h6>
<div>
	<label for="firstnameInput" class="form-label">유형 *</label>
		<br />
		<div class="btn-group">
			<button type="button" class="btn btn-outline-primary dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="typeName">유형</button>
			<div class="dropdown-menu dropdownmenu-secondary">
				<a class="dropdown-item" href="javascript:changeType('양식')">양식</a>
				<a class="dropdown-item" href="javascript:changeType('제출')">제출</a>
				<a class="dropdown-item" href="javascript:changeType('기타')">기타</a>
			</div>
		</div>
	<div class="col-lg-15">
	<div class="mb-3 mt-3">
		<label for="title" class="form-label">제목 *</label> 
		<input type="text" class="form-control" id="title">
		</div>
	</div>
	<!--end col-->
	<div class="col-lg-15">
		<div class="mb-3 pb-2">
			<label for="exampleFormControlTextarea" class="form-label">내용 *</label>
			<div id="editor"></div>
		</div>
	</div>
	<label for="" class="form-label">첨부파일</label>
	<div class="mb-3" id="docFile" style="width: 60%;">
		<input type="file" class="form-control uploadFile" id="uploadFile" name="uploadFile" style="width: 60%;" multiple />
	</div>
</div>		
	
<div class="row g-4 mb-3">
	<div class="col-sm">
		<div class="d-flex justify-content-sm-center gap-2">
			<button type="button" class="btn btn-soft-success" onclick="insert()">등록</button>
			<button type="button" class="btn btn-soft-danger" onclick="backToList()">취소</button>
		</div>
	</div>
</div>
