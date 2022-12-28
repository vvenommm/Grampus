<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
 th {
 	width : 500px;
 }
 .ttl:hover { 
 	background : #F6F6F6;
 }
 thead {
 	background : #EAEAEA;
 }
.ck-editor__editable[role="textbox"] {
    /* editing area */
    min-height: 200px;
}
.ck-mentions .mention__item {
    display: block;
}

.ck-mentions .mention__item span {
    margin-left: .5em;
}
.ck-content .mention{
    background: #BEEFFF;
    color:black;
}
.ck.ck-list__item .ck-button.ck-on {
	background: #BEEFFF;
    color:black;
}
</style>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/34.2.0/super-build/ckeditor.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/34.2.0/super-build/translations/ko.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
<script type="text/javascript">
 const Editor = toastui.Editor;
 var editor = "";
 var taskNo = "${taskVO.taskNo}";
 var pmemGrp = "${pmemGrp}";
 var projId = "${projId}";
 
 var markerfeed = new Array();
	var sdt = {"projId":"${projId}","pmemGrp":"${pmemGrp}"}
	$.ajax({
		url:"/promem/projGrpSearch",
		type:"post",
		data:JSON.stringify(sdt),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			$.each(res,function(i,v){
				markerfeed.push({id:v.MEM_NM+"("+v.MEM_ID+")",name:v.MEM_ID,userId:v.MEM_NO});
			});
		}
	});
	
 $(function() {
	//이슈 등록 버튼 (모달창)-------------------------------------------------------------------------------------------------------------------------
	 $("#newIssueModal").draggable();

	//새 이슈 등록 시 페이지 이동
	$("#issueModal").on("click", function() {
		location.href = "/issue/newIssue/" + projId + "/" + pmemGrp + "?taskNo=" + taskNo;
	})
 })
 var ckgeteditor;
 $(function() {
	 
	 var code = "";
	 
	 //수정 버튼
	 $("#edit").on("click", function() {
		 //상위일감, 하위일감, 이슈 div 없애기
		 $("#subDiv").hide();
		 $("#issueDiv").hide();
		 $("#spn1").hide();
		 
		 //완료일감버튼 숨기기
		 $("#process").hide();
		 
		 //수정,삭제 버튼 숨기기
		 $("#menu").hide();
		 
		 var editTtl = "${taskVO.taskTtl}";
		 code = "<div><p class='text-muted mb-1' id='titleDiv'>제목 :</p><input type='text' class='form-control me-auto' id='taskTtl' value='" + editTtl+ "'/></div>";
		 $("#editTtl").html(code);
		 
		 var editPmemcd = $("#editPmemcd").text();
		 editPmemcd = editPmemcd.substring(editPmemcd.indexOf("(")+1, editPmemcd.indexOf(")"));
		//같은 그룹 팀원 가져오기(담당자) --> 일감 수정 시
		$.ajax({
			url : "/task/sameGrpMemUp",
			type : "post",
			data : taskNo,
			contentType : "application/json;charset=UTF-8",
			success : function(res) {
				console.log(res);
				var code = "<select class='form-control me-auto' id='pmemCd'>";
				$.each(res, function(i,v) {
					code += "<option value='" + v.MEM_NO + "'>" + v.PROF_NM + " (" + v.MEM_NO + ")" + "</option>";
				})
				code += "</select>";
				$("#editPmemcd").html(code);
				$("#pmemCd").val(editPmemcd);
			}
		})
		 
		 var editSdy =  $("#editSdy").text();
		 editSdy = editSdy.substr(0,4) + "-" + (editSdy.substr(5,2)) + "-" + editSdy.substr(8,2);
		 code = "<input type='date' class='form-control me-auto' id='taskSdy' value='" + editSdy + "'/>";
		 $("#editSdy").html(code);
		 
		 var editEdy = $("#editEdy").text();
		 editEdy = editEdy.substr(0,4) + "-" + (editEdy.substr(5,2)) + "-" + editEdy.substr(8,2);
		 code = "<input type='date' class='form-control me-auto' id='taskEdy' value='" + editEdy + "'/>";
		 $("#editEdy").html(code);
		 
		 var editStts = "${taskVO.taskStts}";
		 code = '<select id="taskStts" class="form-control me-auto"><option>신규</option><option>진행</option><option>완료</option></select></p>';
	     $("#editStts").html(code);		
	     $("#taskStts").val(editStts);		
	     
	     var editPriority = "${taskVO.taskPriority}";
		 code = '<select id="taskPriority" class="form-control me-auto"><option value="낮음">낮음</option><option value="보통">보통</option><option value="높음">높음</option><option value="긴급">긴급</option></select></p>';
	     $("#editPriority").html(code);		 
	     $("#taskPriority").val(editPriority);		 
	     
	     var editProgress = "${taskVO.taskProgress}";
	     console.log(editProgress)
		 code = '<select id="taskProgress" class="form-control me-auto"><option value="0">0%</option><option value="10">10%</option><option value="20">20%</option>';
		 code += '<option value="30">30%</option><option value="40">40%</option><option value="50">50%</option><option value="60">60%</option><option value="70">70%</option>';
		 code += '<option value="80">80%</option><option value="90">90%</option><option value="100">100%</option></select></p>';
	     $("#editProgress").html(code);
	     $("#taskProgress").val(editProgress);
	     
	     var btn = "<br><div class='hstack gap-2' style='float:right;'><button type='button' class='btn btn-ghost-primary waves-effect waves-light' id='newParent' style='float:right;'><i class='ri-add-line align-bottom me-1'></i>상위 일감 추가</button>"
	     btn += "<button type='button' class='btn btn-outline-success waves-effect waves-light' id='updateTask'>등록</button><a href='/task/taskDetail/${taskNo}/${pmemGrp}' class='btn btn-outline-danger waves-effect'>취소 </a></div>"
	     //상위일감 추가 버튼 생성
		 $("#cnParent").append(btn);
	     
		 editor = new Editor({
			   el: document.querySelector('#editCn'),
			   height: '300px',
			   initialEditType: 'wysiwyg',
			   previewStyle: 'vertical'
		 });
		 var editCn = $("#editCn").val();
		 $("#editCn").val(editCn);
		 
	 })

 	 //상위 일감 추가 버튼
 	 $(document).on("click", "#newParent", function() {
 		var code = '<div class="col-lg-4 col-sm-6"><p class="text-muted mb-1">상위일감 :</p><input type="text" class="form-control me-auto finput" id="taskParent" value=""/><div class="dropdown-menu dropdown-menu-lg" id="search-dropdown"><div class="dropdown-header mt-2 hideBox"><h6 class="text-overflow text-muted mb-2 text-uppercase"><i class="ri-file-list-line"></i> 일감</h6></div><div class="notification-list" id="taskInfo"></div></div></div>';
 		$("#editTtl").after(code);
 		$(this).attr("disabled", true);
 	 })
	 	
	 //수정 완료 버튼
	$(document).on("click", "#updateTask", function() {
		 var taskTtl = $("#taskTtl").val();
		 var memNo = $("#pmemCd").val();
	 	 var taskCn = editor.getMarkdown();
	 	 var taskSdy = $("#taskSdy").val();
	 	 var taskEdy = $("#taskEdy").val();
	  	 var taskStts = $("#taskStts").val();
	 	 var taskPriority = $("#taskPriority").val();
	 	 var taskProgress = $("#taskProgress").val();
	 	 var taskParent = $("#taskParent").val();
		 
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
	 	            text: "'완료' 상태의 일감은 진척도를 100%로 설정해야 합니다.",
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
		 var updateData = {
			 "taskNo" : taskNo,
			 "memNo" : memNo,
			 "taskTtl" : taskTtl,
			 "taskCn" : taskCn,
			 "taskSdy" : taskSdy,
			 "taskEdy" : taskEdy,
			 "taskStts" : taskStts,
			 "taskPriority" : taskPriority,
			 "taskProgress" : taskProgress,
			 "taskParent" : taskParent,
			 "pmemGrp" : pmemGrp
		 }
		
		$.ajax({
			url : "/task/updateTask",
			type : "post",
			data : JSON.stringify(updateData),
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				console.log(res);
			    location.href = "/task/taskDetail/${taskVO.taskNo}/${pmemGrp}";
			}
		})
	})
	 
	 
	 //삭제 버튼
	 $("#delete").on("click", function() {
		 Swal.fire({
		        text: "삭제하시겠습니까?",
		        icon : 'question',
		        showCancelButton: true,
		        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
		        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
		        buttonsStyling: false,
		        showCloseButton: true
		      }).then(function (result) {
				 if(result.value) {
					 $.ajax({
						 url : "/task/deleteTask",
						 type : "post",
						 data : taskNo,
						 contentType : "application/json;charset=utf-8",
						 success : function(res) {
							 console.log("delete res : " + res);
							 if(res > 0) {
								 location.href="/task/taskMain/${taskVO.projId}/${pmemGrp}";
							 }
							 
							 //삭제 완료 시 삭제된 일감을 taskParent로 가지고 있던 일감의 taskParent null로 바꾸기
							 $.ajax({
								 url : "/task/updateTaskParent",
								 type : "post",
								 data : taskNo,
								 async : false,
								 contentType : "application/json;charset=utf-8",
								 success : function(res) {
									console.log("updateTaskParent : " + res);
								 }
							 })
						 }
					 })
				 }else if (
			        // Read more about handling dismissals
	                result.dismiss === Swal.DismissReason.cancel
	              ) {
	                Swal.fire({
	                  text: '삭제가 취소되었습니다.',
	                  icon: 'error',
	                  confirmButtonClass: 'btn btn-outline-danger mt-2',
	                  buttonsStyling: false
	                })
	              }
		      })
	 })
	 
	 //하위일감 추가페이지로
	 $("#newChildTask").on("click", function() {
		 location.href = "/task/newChildTaskInDetail/${taskVO.taskNo}/${pmemGrp}";
	 })
	 
	 //완료 일감 처리 
	 $("#process").on("click", function() {
		 var editStts = "${taskVO.taskStts}";
		 var code = '<div class="hstack gap-2"><select id="apreStts" class="form-control"><option value="완료">완료</option><option value="승인">승인</option><option value="반려">반려</option></select>';
		 code += '<button type="button" class="btn btn-outline-success waves-effect waves-light" id="save" style="float:right; width:100px;">저장</button></div>';
		 $("#editStts").html(code);
		 $("#apreStts").val(editStts);
		 $(this).hide();
	 })
	 
	 //저장 버튼
	 $(document).on("click", "#save", function() {
		 var apreStts = $("#apreStts").val();
		 $("#apreStts").val(apreStts);
		 data = {
				 "taskNo" : taskNo,
				 "taskStts" : apreStts
		 }
		$.ajax({
			url  : "/task/updateStts",
			type : "post",
			data : JSON.stringify(data),
		    contentType : "application/json;charset=utf-8",
			success : function(res) {
				console.log(res);
				if(res > 0) {
					location.href = "/task/taskDetail/${taskVO.taskNo}/${pmemGrp}";
				}
			}
		})
	 })
	 
	 
	 //시작날짜 오늘날짜로 설정
	 today = new Date();
	 today = today.toISOString().slice(0, 10);
	$("#issueDy").val(today);
	
//////////////////////////
	//상위 일감 검색
	$(document).on("keyup",".finput",function(){
		if($(".finput").val().length >0){
			$("#search-dropdown").addClass("show");
		}else{
			$("#search-dropdown").removeClass("show");
		}
		$("#taskInfo").children().remove();
		var con = $(".finput").val();
		var mdt = {"projId":"${projId}","pmemGrp":"${pmemGrp}","content":con}
		$.ajax({
			url: "/task/updownSearch",
			type: 'POST',
			dataType: 'json',
			data:JSON.stringify(mdt),
			contentType:"application/json; charset=utf-8",
			success : function(data){
				var code = "";
				$.each(data,function(i,v){
					console.log(v)
	                code += "<a href='#' id='taskbox' name='"+v.TASK_NO+"' class='dropdown-item notify-item py-2' style='display: block;'>";
	                code += "<div class='d-flex'>";
	                code += "<div class='flex-1'>";
					code += "<h6 class='m-0 memberId' style='overflow: hidden;'>#"+v.TASK_NO+" "+v.TASK_TTL+"</h6>";
	                code += "</div>";
	                code += "</div>";
	                code += "</a>";
				});
				console.log(code);
				$("#taskInfo").append(code);
			},
		});
	});

	/////////////////
	/* 검색 내용 클릭 시 일감번호 출력 */
	$(document).on("click","#taskbox",function(){
		var taskNo = $(this).attr("name");
		$(".finput").val(taskNo);
		$("#search-dropdown").removeClass("show");
	});

	///////////////////
	/* 다른곳 클릭 시 검색목록 없애기 */
	$(document).on("click",function(){
		$("#search-dropdown").removeClass("show");
	});
	
 })

 
 //이슈 등록
 function insert() {
	 //멘션 태그된 사람 고유값 추출
	 var count = $(".mention").length;
		var mttag = new Array();
		var memNoArr = new Array();
		for(i=0; i<count; i++){
			var mttext = $(".mention").eq(i).text();
			mttag.push(mttext.substring(mttext.indexOf('(')+1,mttext.indexOf(')')));
		}
		
		for(i=0; i<mttag.length; i++){
			for(j=0; j<markerfeed.length; j++){
				if(mttag[i] == markerfeed[j].name){
					memNoArr.push(markerfeed[j].userId)
				}
			}
		}
	 
	 var issueType = $("#issueType").val();
	 var issueTtl = $("#issueTtl").val();
	 var issueCn = ckgeteditor.getData();
	 var issueStts = $("#issueStts").val();
	 var issueDy = $("#issueDy").val();
	 
	 var data = {
			 "issueType" : issueType,
			 "issueTtl" : issueTtl,
			 "issueCn" : issueCn,
			 "issueStts" : issueStts,
			 "issueDy" : issueDy,
			 "taskNo" : taskNo,
			 "memNoArr" : memNoArr
	 }
	 console.log(data);
	 $.ajax({
		 url : "/issue/insertIssue",
		 type : "post",
		 data : JSON.stringify(data),
		 contentType : "application/json;charset=utf-8",
		 success : function(res) {
			 if(res > 0) {
				 location.href = "/task/taskDetail/${taskVO.taskNo}/${pmemGrp}";
			 }
		 }
	 })
 }
function customItemRenderer( item ) {
    const itemElement = document.createElement( 'span' );
    const userNameElement = document.createElement( 'span' );
    itemElement.classList.add( 'mention__item' );
    userNameElement.classList.add( 'mention__item__user-name' );
    userNameElement.textContent = item.id;
    itemElement.appendChild( userNameElement );
    return itemElement;
}
 function toIssueDetail(issueNo) {
	 location.href = "/issue/issueDetail/" + issueNo + "/${pmemGrp}";
 }
 function toTaskDetail(taskNo) {
	 location.href = "/task/taskDetail/" + taskNo + "/${pmemGrp}";
 }
</script>

<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">
		             <a href="/task/taskMain/${projId}/${pmemGrp}"><i class="bx bx-left-arrow-circle"></i></a>
		             ${projVO.ttl} 
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


<div class="row">
    <div class="col-lg-15">
        <div class="card">
            <div class="bg-soft-light">
                <div class="card-body pb-0 px-4">
                    <div class="row mb-3">
                        <div class="col-md">
                            <div class="row align-items-center g-3">
                                <div class="col-md">
                                    <div>
                                        <div class="hstack gap-3 flex-wrap">
                                            <div><i class="ri-building-line align-bottom me-1"></i>새 기능 &nbsp;<a href="#">#${taskVO.taskNo}</a></div>
                                            <div class="vr"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
 <div class="col-lg-15" id="1">
     <div class="card">
         <div class="card-body">
         	<div id="mainDiv"> 
	             <h5 class="fs-30 mb-0">#${taskVO.taskNo}</h5><br />
	             <div class='row'>
	                 <div class="col-lg-4 col-sm-6" id="editTtl">
	                    <h5 class="fs-30 mb-0">${taskVO.taskTtl}</h5>
	                 </div>
                 </div>
               </div>
             <div id="cn" class="text-muted">
                 <div class="pt-3 border-top border-top-dashed mt-4">
                     <div class="row">
                         <div class="col-lg-4 col-sm-6">
                             <div>
                                 <p class="text-muted mb-1">담당자 :</p>
                                 <h5 class="fs-15 mb-0" id="editPmemcd">${taskVO.profNm}(${taskVO.memNo})</h5>
                             </div>
                         </div>
                         <div class="col-lg-4 col-sm-6">
                             <div>
                                 <p class="text-muted mb-1">시작날짜 :</p>
                                 <h5 class="fs-15 mb-0" id="editSdy">${taskVO.taskSdy}</h5>
                             </div>
                         </div>
                         <div class="col-lg-4 col-sm-6">
                             <div>
                                 <p class="text-muted mb-1">완료기한 :</p>
                                 <h5 class="fs-15 mb-0" id="editEdy">${taskVO.taskEdy}</h5>
                             </div>
                         </div>
                     </div>
                     <br />
                     <div class="row">
                         <div class="col-lg-4 col-sm-6">
                             <div>
                                <p class="text-muted mb-1">상태 :</p>
                             	         <c:if test="${roleId == 'R01' and (taskVO.taskStts == '완료' or taskVO.taskStts == '승인' or taskVO.taskStts == '반려')}">
      										<button type="button" class="btn btn-outline-success waves-effect waves-light" id="process" style="float:right;">일감 처리</button>	  
      									</c:if>
                                 <div id="editStts">
	                                 <c:choose>
	                                 	<c:when test="${taskVO.taskStts == '승인'}">
			                                 <div class="badge bg-success fs-12">${taskVO.taskStts}</div>
	                                 	</c:when>
	                                 	<c:when test="${taskVO.taskStts == '반려'}">
			                                 <div class="badge bg-danger fs-12">${taskVO.taskStts}</div>
	                                 	</c:when>
	                                 	<c:otherwise>
			                                 <div class="badge bg-warning fs-12">${taskVO.taskStts}</div>
	                                 	</c:otherwise>
	                                 </c:choose>
                                 </div>
                             </div>
                         </div>
                         <div class="col-lg-4 col-sm-6">
                             <div>
                                 <p class="text-muted mb-1">우선순위 :</p>
                                 <div id="editPriority">
	                                 <c:choose>
		                                 <c:when test="${taskVO.taskPriority == '긴급'}">
		                                 	<div class="badge bg-danger fs-12">${taskVO.taskPriority}</div>
		                                 </c:when>
		                                 <c:otherwise>
		                                 	<div class="badge bg-warning fs-12">${taskVO.taskPriority}</div>
		                                 </c:otherwise>
	                                 </c:choose>
                                 </div>
                             </div>
                     	</div>
                        <div class="col-lg-4 col-sm-6" id="here">
                             <div id="progressDiv">
                                 <p class="text-muted mb-1">진척도 :</p>
                                 <h5 class="fs-15 mb-0" id="editProgress">${taskVO.taskProgress}%</h5>
                             </div>
                        </div>
                     </div>
                 </div>
                 <div class="pt-3 border-top border-top-dashed mt-4" id="cnParent">
                      <p class="text-muted md-1">내용</p><br />
                     <div class="row g-10">
                         <div class="col-lg-10" id="editCn" style="font-weight:bold;">
                         	${taskVO.taskCn}
                         </div>
                     </div>
                     <!-- end row -->
                 </div>
                 <!-- 수정 삭제 버튼 -->
                <c:if test="${taskVO.taskStts == '신규' or taskVO.taskStts == '진행' or taskVO.taskStts == '완료'}">
					<div class="pt-3 border-top border-top-dashed mt-4" id="spn1">
						<div class="row">
							<div class="col-sm">
								<div class="d-flex justify-content-sm-end">
									<span>
										<button type="button" id="edit" class="btn btn-outline-info waves-effect">수정</button>
										<button type="button" id="delete" class="btn btn-outline-danger waves-effect">삭제</button>
									</span>
								</div>
							</div>
						</div>
					</div>
				</c:if>
             </div>
		</div>
	</div>
</div>


<!-- 상위일감 -->
<div class="row" id="2">
	<div class="col-lg-7" id="subDiv">
     	<div class="card">
         	<div class="card-body" style="min-height:450px;">       
                 <div class="pt-3 border-top border-top-dashed mt-4">
                     <h6 class="mb-3 fw-bold text-uppercase">상위일감</h6>
		    	    	<table class="table align-middle table-nowrap mb-0">
		    				<thead>
		        				<tr>
		            				<th scope="col">#</th>
		            				<th scope="col">담당자</th>
		            				<th scope="col">상태</th>
		            				<th scope="col">진척도</th>
		        				</tr>
		    				</thead>	
		    				<tbody>
		    				<c:choose>
					    		<c:when test="${empty taskParentList}">
					    			<tr>
					    				<td colspan=4 style="text-align:center;">상위 일감이 존재하지 않습니다</td>
					    			</tr>
					    		</c:when>
					    		<c:otherwise>
						    		<c:forEach items="${taskParentList}" var="parentList"> 
							            <tr onclick="toTaskDetail(${parentList.taskNo});" class="ttl" style="cursor:pointer;">
							            	<td style="font-weight:bold;"># ${parentList.taskNo}: ${parentList.taskTtl}<br /></td>
							            	<td>${parentList.profNm}(${parentList.memNo})</td>
							            	<c:choose>
								            	<c:when test="${parentList.taskStts == '완료'}">
										            <td class="link-success">${parentList.taskStts}</td>
								            	</c:when>
								            	<c:when test="${parentList.taskStts == '승인'}">
										            <td class="link-info">${parentList.taskStts}</td>
								            	</c:when>
								            	<c:when test="${parentList.taskStts == '반려'}">
										            <td class="link-danger">${parentList.taskStts}</td>
								            	</c:when>
								            	<c:otherwise>
										            <td class="link-warning">${parentList.taskStts}</td>
								            	</c:otherwise>
								            </c:choose>
							            	<td>${parentList.taskProgress}%</td>
							            </tr>
									</c:forEach>
							</c:otherwise>
							</c:choose>
		 				</table>
                 </div><br />
                 
                 <!-- 하위일감 -->
                 <div class="pt-3 border-top border-top-dashed mt-4">
                     <h6 class="mb-3 fw-bold text-uppercase">하위일감
	                     <button type="button" class="btn btn-ghost-primary waves-effect waves-light" id="newChildTask" style="float:right;">
	                     	<i class="ri-add-line align-bottom me-1"></i>추가</button>
                     </h6>
                     <br />
	    	    	<table class="table align-middle table-nowrap mb-0">
	    				<thead>
	        				<tr>
	            				<th scope="col">#</th>
	            				<th scope="col">담당자</th>
	            				<th scope="col">상태</th>
	            				<th scope="col">진척도</th>
	        				</tr>
	    				</thead>	
	    				<tbody>
				    	<c:choose>
				    		<c:when test="${empty taskChildList}">
				    			<tr>
				    				<td colspan=4 style="text-align:center;">하위 일감이 존재하지 않습니다</td>
				    			</tr>
				    		</c:when>
		    			<c:otherwise>
				    		<c:forEach items="${taskChildList}" var="childList"> 
					            <tr onclick="toTaskDetail(${childList.taskNo});" class="ttl" style="cursor:pointer;">
					            	<td style="font-weight:bold;"># ${childList.taskNo} : ${childList.taskTtl}<br /></td>
					            	<td>${childList.profNm}(${childList.memNo})</td>
			            			<c:choose>
						            	<c:when test="${childList.taskStts == '완료'}">
								            <td class="link-success">${childList.taskStts}</td>
						            	</c:when>
						            	<c:when test="${childList.taskStts == '승인'}">
								            <td class="link-info">${childList.taskStts}</td>
						            	</c:when>
						            	<c:when test="${childList.taskStts == '반려'}">
								            <td class="link-danger">${childList.taskStts}</td>
						            	</c:when>
						            	<c:otherwise>
								            <td class="link-warning">${childList.taskStts}</td>
						            	</c:otherwise>
						            </c:choose>
					            	<td>${childList.taskProgress}%</td>
					            </tr>
							</c:forEach>
						</c:otherwise>
				    	</c:choose>
	 				</table>
                </div>
            </div>
		</div>
	</div>
	
	<!-- 이슈 목록 -->
	<div class="col-lg-5">
     	<div class="card" id="issueDiv">
         	<div class="card-body" style="min-height:450px;">
         		<div class="pt-3 border-top border-top-dashed mt-4">
                     <h6 class="mb-3 fw-bold text-uppercase">이슈
                        <button type="button" class="btn btn-ghost-primary waves-effect waves-light" style="float:right;" id="issueModal">
                        	<i class="ri-add-line align-bottom me-1"></i>이슈</button>
                      </h6>
                      <br />
		    	    	<table class="table align-middle table-nowrap mb-0">
		    				<thead>
		        				<tr>
		            				<th scope="col">#</th>
		            				<th scope="col">유형</th>
		            				<th scope="col">제목</th>
		            				<th scope="col">발생일</th>
		        				</tr>
		    				</thead>	
		    				<tbody>
					    	<c:choose>
					    		<c:when test="${empty issueList}">
					    			<tr>
					    				<td colspan=4 style="text-align:center;">관련 이슈가 존재하지 않습니다</td>
					    			</tr>
					    		</c:when>
		    				<c:otherwise>
					    		<c:forEach items="${issueList}" var="issueList"> 
						            <tr onclick="toIssueDetail(${issueList.issueNo});" style="cursor:pointer;" class="ttl">
						            	<td style="font-weight:bold;">${issueList.issueNo}</td>
           					            <c:choose>
								            <c:when test="${issueList.issueType =='결함'}">
								            	<td><span class="badge badge-soft-danger">${issueList.issueType}</span></td>
								            </c:when>
								            <c:when test="${issueList.issueType =='개선'}">
								            	<td><span class="badge badge-soft-warning">${issueList.issueType}</span></td>
								            </c:when>
								            <c:when test="${issueList.issueType =='인사'}">
								            	<td><span class="badge badge-soft-success">${issueList.issueType}</span></td>
								            </c:when>
								            <c:otherwise>
								            	<td><span class="badge badge-soft-primary">${issueList.issueType}</span></td>
								            </c:otherwise>
							            </c:choose>
						            	<td>${issueList.issueTtl}</td>
						            	<td>${issueList.issueDy}</td>
						            </tr>
								</c:forEach>
				    		</c:otherwise>
				    		</c:choose>
		 				</table>
                 </div>
         	</div>
         </div>
    </div> 
</div>


