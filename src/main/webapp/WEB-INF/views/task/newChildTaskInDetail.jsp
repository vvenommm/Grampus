<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
var memNo = "${memNo}";
window.onload = function() {
	var pmemGrp = "${pmemGrp}";
	//같은 그룹 팀원 가져오기(담당자)
	$.ajax({
		url : "/task/sameGrpMem",
		type : "post",
		data : pmemGrp,
		contentType : "application/json;charset=UTF-8",
		success : function(res) {
			console.log(res);
			var code = "";
			$.each(res, function(i,v) {
				if(v.MEM_NO == memNo){
					code = "<option selected>" + v.PROF_NM + " (" + v.MEM_NO + ")" + "</option>";
				}else{
					code = "<option>" + v.PROF_NM + " (" + v.MEM_NO + ")" + "</option>";
				}
				$("#pmemCd").append(code);
			})
		}
	})
	
}
var editor = "";
$(function(){
	const Editor = toastui.Editor;
	editor = new Editor({
		  el: document.querySelector('#editor'),
		  height: '300px',
		  initialEditType: 'wysiwyg',
		  previewStyle: 'vertical'
	});
	
	//자동 입력 버튼
	$("#taskTtl").on("click", function() {
		$("#taskTtl").val("엘라스틱 서치 구현");
		editor.setHTML("엘라스틱 서치 구현하기");
		$("#taskStts").val("보통");
		$("#taskProgress").val("10");
		$("#taskEdy").val("2022-10-21");
	})
	
	 //시작날짜 오늘날짜로 설정
	 today = new Date();
	 today = today.toISOString().slice(0, 10);
	$("#taskSdy").val(today);
});

//일감 insert--------------------------------------------------------------------
function insert() {
	var taskTtl = $("#taskTtl").val();
	var taskCn = editor.getMarkdown();
 	var	taskStts = $("#taskStts").val();
 	var taskPriority = $("#taskPriority").val();
 	var pmemCd = $("#pmemCd").val();
 	var keyword = $("#keyword").val();
 	var taskProgress = $("#taskProgress").val();
 	var taskSdy = $("#taskSdy").val();
 	var taskEdy = $("#taskEdy").val();

 	console.log("taskStts : " + taskStts);
 	console.log("taskProgress : " + taskProgress);
 	
 	
 	
 	//제목 입력안했을 시
 	if(taskTtl == null || taskTtl == "") {
 		$("#taskTtl").css("border", "1px solid red");
 		$("#taskTtl").focus();
 		Swal.fire({
            text: '제목은 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
      	var offset = $('#taskTtl').offset();
 		$("html").animate({scrollTop : offset.top}, 400);
 		return;
 		
 	}
 	
 	//내용 입력안했을 시
 	if(taskCn == null || taskCn == "") {
 		editor.focus();
 		Swal.fire({
            text: '내용은 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
 	
 	//선택 거르기
 	if(taskStts == null || taskStts == "" || taskStts == "선택") {
 		$("#taskStts").css("border", "1px solid red");
 		$("#taskStts").focus();
 		Swal.fire({
            text: '상태는 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
 	
 	if(taskPriority == null || taskPriority == "" || taskPriority == "선택") {
 		$("#taskPriority").css("border", "1px solid red");
 		$("#taskPriority").focus();
 		Swal.fire({
            text: '우선순위는 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
 	
 	//종료날짜 입력안했을 시
 	if(taskEdy == null || taskEdy == "") {
 		$("#taskEdy").css("border", "1px solid red");
 		$("#taskEdy").focus();
 		Swal.fire({
            text: '완료기한은 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
 	
 	//상태 '완료'와 진척도 '100%' 세트
 	if(taskStts == "완료") {
 		if(taskProgress != "100") {
 			Swal.fire({
 	            text: "'완료' 상태의 일감은 진척도 100%로 설정해야 합니다.",
 	            imageUrl: '/resources/image/alertLogo.png',
 	            imageHeight: 25,
 	            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
 	            buttonsStyling: false,
 	            showCloseButton: true
 	      	})
 			return;
 		}
 	}
 	
 	if(taskProgress == "100") {
 		if(taskStts != "완료") {
 			Swal.fire({
 	            text: "진척도 100%의 일감은 '완료'상태로 설정해야 합니다.",
 	            imageUrl: '/resources/image/alertLogo.png',
 	            imageHeight: 25,
 	            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
 	            buttonsStyling: false,
 	            showCloseButton: true
 	      	})
 			return;
 		}
 	}
 	
 	pmemCd = pmemCd.substring(pmemCd.indexOf("(")+1, pmemCd.indexOf(")"));
//  	taskProgress = taskProgress.slice(0,-1);
 	
 	var data = {
 		"taskTtl" : taskTtl,
 		"taskCn" : taskCn,
 		"taskStts" : taskStts,
 		"taskPriority" : taskPriority,
 		"memNo" : pmemCd,
		"taskProgress" : taskProgress,
		"taskSdy" : taskSdy,
		"taskEdy" : taskEdy,
		"taskParent" : keyword
 	}
 	$.ajax({
 		url : "/task/insertTask",
 		type : "post",
 		data : JSON.stringify(data),
 		contentType : "application/json;charset=utf-8",
		success : function(res) {
			if(res == 1) {
				location.href = "/task/taskDetail/${taskNo}/${pmemGrp}";
			}
		}
 	})
}
</script>

<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">${projVO.ttl} 
					<c:if test="${projVO.plan =='BASIC'}"><span class="badge bg-primary">BASIC</span></c:if>
					<c:if test="${projVO.plan =='PLUS'}"><span class="badge badge bg-success">PLUS</span></c:if>
					<c:if test="${projVO.plan =='PREMIUM'}"><span class="badge badge bg-warning">PREMIUM</span></c:if>
	           		<c:if test="${iamPM.pm eq 1}">
		             	<span onclick="javascript:location.href='/project/projectSetting/${projVO.id}/${projVO.grp}'" style="cursor: pointer">
		             			<i class="ri-settings-4-line align-bottom me-2"></i>
		             	</span>
	           		</c:if>
	             </h4>
	            </div>
	
	            <div class="page-title-right">
	                <ol class="breadcrumb m-0">
	                    <li class="breadcrumb-item">
	                    	<a href="javascript: location.href='/project/projMain/${projVO.id}/${projVO.grp}';">
	                    		<i class="ri-home-2-fill"></i>
	                    	</a>
	                    </li>
	                    <li class="breadcrumb-item active">${projVO.grp}</li>
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/task/taskMain/${projVO.id}/${projVO.grp}'" style="cursor: pointer">일감</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->




<h6>하위 일감</h6>
<div class="d-flex justify-content-sm-center">
	<div class="w-50 p-3" id="allDiv">
		<p>제목 *<br /><input type="text" class="form-control me-auto check" id="taskTtl" placeholder="제목을 입력해주세요"/></p>
		<p></p>
		<p>내용 *</p>
		<p></p>
			<div id="editor" class="check"></div>
	</div>
			
	<div class="w-50 p-3">
		<p>상태 *	
			<select id="taskStts" class="form-control me-auto check" style="cursor: pointer">
				<option selected>신규</option>
				<option>진행</option>
				<option>완료</option>
			</select></p>
		<p>우선순위 *
			<select id="taskPriority" class="form-control me-auto check"  style="cursor: pointer">
				<option selected>낮음</option>
				<option>보통</option>
				<option>높음</option>
				<option>긴급</option>
			</select></p>
		<p>담당자 *
			<select id="pmemCd" class="form-control me-auto ui-autocomplete-input" style="cursor: pointer">
			</select></p>
		<p>상위일감 <input type="text" id="keyword" class="form-control me-auto" value="${taskNo}" readonly/>
		</p>			
		<p>진척도 *
			<select id="taskProgress" class="form-control me-auto check" style="cursor: pointer">
				<option value="0">0%</option>
				<option value="10">10%</option>
				<option value="20">20%</option>
				<option value="30">30%</option>
				<option value="40">40%</option>
				<option value="50">50%</option>
				<option value="60">60%</option>
				<option value="70">70%</option>
				<option value="80">80%</option>
				<option value="90">90%</option>
				<option value="100">100%</option>
			</select></p>
		<p>시작날짜 *<input type="date" id="taskSdy" class="form-control me-auto check" value=""/></p>
		<p> 완료기한 *<input type="date" id="taskEdy" class="form-control me-auto check" /></p>
	</div>
</div>
	
	
<div class="row g-4 mb-3">
	<div class="col-sm">
		<div class="d-flex justify-content-sm-center gap-2">
			<button type="button" class="btn btn-outline-success waves-effect waves-light" onclick="insert();">등록</button>
			<a href="/task/taskDetail/${taskNo}/${pmemGrp}" class="btn btn-outline-danger waves-effect">취소 </a>
		</div>
	</div>
</div>

