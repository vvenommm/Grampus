<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- Dragula css -->
<link rel="stylesheet" href="/resources/velzon/dist/assets/libs/dragula/dragula.min.css" />
<!-- toast editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>

<style>
element.style { 
	padding: 0px 16px;
}

.tasks-wrapper {
    max-height: 680px;
}

div {
	display: block;
}
.simplebar-content-wrapper {
	direction: inherit;
	-webkit-box-sizing: border-box !important;
	box-sizing: border-box !important;
	position: relative;
	display: block;
	height: 100%;
	width: auto;
	visibility: visible;
	overflow: auto;
	max-width: 100%;
	max-height: 100%;
	scrollbar-width: none;
	padding: 0 !important;
}

.tasks-list {
	width:35%;
	border-radius: 10px;
	height: 810px;
}

.tasks-box:hover {
	box-shadow: 4px 4px 5px lightgray outset;
	transform: rotate( 3deg );
}

img {
	width: 40px;
	height : 35px;
	border-radius : 40px;
}

</style>
<script type="text/javascript">
	var editor = "";
	var pmemGrp = "${pmemGrp}";
	var projId = "${projId}";
	var today = "";
	$(function() {

		//시작날짜 오늘날짜로 설정
		today = new Date();
		today = today.toISOString().slice(0, 10);
		$("#taskSdy").val(today);

		//새 일감 등록 에디터
		const Editor = toastui.Editor;
		editor = new Editor({
			el : document.querySelector('#taskCn'),
			height : '300px',
			initialEditType : 'markdown',
			previewStyle : 'vertical'
		});

		//새 일감 등록 모달창 이동하게
		$("#creatertaskModal").draggable();
		
		//모달 종료 시 모달 내용 비우기
	})

	$(function() {
		var todo = document.getElementById("todo");
		var process = document.getElementById("process");
		var complete = document.getElementById("complete");
		//드래그앤드롭
		var drake = dragula();

		function $(id) {
			return document.getElementById(id);
		}

		dragula([ $('todo'), $('process'), $('complete') ], {
			//놓쳤을 때 제자리로
			revertOnSpill : true
		}).on('drop', function(el, target, source, wrapper) { //놓았을 때
			//el:드래그한 요소, target:움직인 위치, source:원래의 위치
			el.className += " ex-moved";

			//진행 상태 변경하기
			var taskNo = el.dataset.cardId; //일감번호
			var id = target.id; //이동된 div
			var taskStts = "";
			var taskProgress = "";

			if (id == "todo") {
				taskStts = "신규";
				taskProgress = 0;
			}
			if (id == "process") {
				taskStts = "진행";
				taskProgress = 0;
			}
			if (id == "complete") { //완료로 변경시 진척도도 100으로
				taskStts = "완료";
				taskProgress = 100;
			}

			var data = {
				"taskNo" : taskNo,
				"taskStts" : taskStts,
				"taskProgress" : taskProgress
			}

			//업데이트 함수 호출
			update(data);

		}).on('dragend', function(el) { //끝났을 때
			el.classList.remove('is-moving');

			// add the 'is-moved' class for 600ms then remove it
			window.setTimeout(function() {
				el.classList.add('is-moved');
				window.setTimeout(function() {
					el.classList.remove('is-moved');
				}, 600);
			}, 100);

		})
		countTask();
	})

	//새 일감 등록------------------------------------------------------------------------------------
	$(function() {
		//같은 그룹 팀원 가져오기(담당자) --> 새 일감 작성 시
		$.ajax({
			url : "/task/sameGrpMem",
			type : "post",
			data : pmemGrp,
			contentType : "application/json;charset=UTF-8",
			success : function(res) {
				var code = "";
				$.each(res, function(i, v) {
					code = "<option value='" + v.MEM_NO + "'>" + v.PROF_NM + " (" + v.MEM_NO + ")"
							+ "</option>";
					$("#pmemCd").append(code);
				})
			}
		})
		
		$("#newTodo").on("click", function() {
			modalClear();
			$("#taskStts").val("신규")
			$("#taskStts").attr("readonly", true);
		})
		$("#newProcess").on("click", function() {
			modalClear();
			$("#taskStts").val("진행")
			$("#taskStts").attr("readonly", true);
		})
		$("#newComplete").on("click", function() {
			modalClear();
			$("#taskStts").val("완료")
			$("#taskStts").attr("readonly", true);
			$("#taskProgress").attr("disabled", true);
			$("#taskProgress").val("100");
		})
		
		$("#newTask").on("click", function() {
			var taskTtl = $("#taskTtl").val();
			var taskCn = editor.getHTML();
			var taskStts = $("#taskStts").val();
			var taskPriority = $("#taskPriority").val();
			var memNo = $("#pmemCd").val();
			var keyword = $("#keyword").val();
			var taskProgress = $("#taskProgress").val();
			var taskSdy = $("#taskSdy").val();
			var taskEdy = $("#taskEdy").val();
	
			var data = {
				"taskTtl" : taskTtl,
				"taskCn" : taskCn,
				"taskStts" : taskStts,
				"taskPriority" : taskPriority,
				"memNo" : memNo,
				"taskProgress" : taskProgress,
				"taskParent" : keyword,
				"taskSdy" : taskSdy,
				"taskEdy" : taskEdy,
				"pmemGrp" : pmemGrp
			}
	
			$.ajax({
				url : "/task/insertTask",
				type : "post",
				data : JSON.stringify(data),
				contentType : "application/json;charset=utf-8",
				success : function(res) {
					if (res == 1) {
						location.href = "/task/kanbanMain/${projId}/${pmemGrp}";
					}
				}
			})
		})
	})
	
	
	
	//함수----------------------------------------------------------------------------------------------
	//상태별 일감 개수 구하기
	function countTask() {
		$.ajax({
			url : "/task/countTask",
			type : "post",
			success : function(res){
				console.log(res);
				$("#countTaskNew5").text("TOTAL " + res.countTaskNew);
				$("#countTaskIng5").text("TOTAL " + res.countTaskIng);
				$("#countTaskDone5").text("TOTAL " + res.countTaskDone);
				$("#countTaskIng").text(res.countTaskIng);
				$("#countTaskDone").text(res.countTaskDone);
			}
		})
	}
	
	
	//상태 수정 함수
	function update(data) {
		console.log("update data : " + data.taskProgress);
		$.ajax({
			url : "/task/updateKanbanStts",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				console.log(res);
				countTask();
			}
		})
	}

	//삭제 함수
	function deleteKan(taskNo) {
		$.ajax({
			url : "/task/deleteKanban",
			type : "post",
			data : taskNo,
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				console.log(res);
			}
		})
	}
	
	//모달 재실행 시 입력값 초기화
	function modalClear() {
		if($("#taskTtl").val() != null) {
			$("#taskTtl").val("");
		}
		if($("#keyword").val() != null) {
			$("#keyword").val("");
		}
		$("#taskProgress").val("0");
		$("#taskPriority").val("낮음");
		$("#taskSdy").val(today);
		$("#taskEdy").val("");
		editor.setHTML("");
	}
	
	$(function(){
		//////////////////////////
		//상위 일감 검색
		$(".finput").keyup(function(){
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
	});
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
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/task/kanbanMain/${projVO.id}/${projVO.grp}'">칸반</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->

<div class="row">
    <div class="col">
        <div class="card card-animate">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="fw-semibold text-muted mb-0">전체 일감</p>
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTask}" id="countTask">0</span>개</h4>
                        <p class="mb-0 text-muted">
                        <c:choose>
                        	<c:when test="${allPercent > 0}">
	                        	<span class="badge bg-light text-success mb-0" id="allPercent"> 
	                        	<i class="ri-arrow-up-line align-middle"></i>
		                        ${allPercent}%</span> 전월 대비
                        	</c:when>
                        	<c:when test="${allPercent == 0}">
	                        	<span class="badge bg-light text-info mb-0" id="allPercent"> 
	                        	<i class="align-middle"></i>
		                        ${allPercent}%</span> 전월 대비
                        	</c:when>
                        	<c:otherwise>
	                        	<span class="badge bg-light text-danger mb-0" id="allPercent">
	                        	<i class="ri-arrow-down-line align-middle"></i>
		                        ${allPercent}%</span> 전월 대비
                        	</c:otherwise>
                        </c:choose>
                        </p>
                    </div>
                    <div>
                        <div class="avatar-sm flex-shrink-0">
                            <span class="avatar-title bg-soft-info text-info rounded-circle fs-4">
                                <i class="ri-ticket-2-line"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div><!-- end card body -->
        </div> <!-- end card-->
    </div>
    <!--end col-->
    <div class="col">
        <div class="card card-animate">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="fw-semibold text-muted mb-0">진행 중 일감</p>
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTaskIng5}" id="countTaskIng">0</span>개</h4>
                        <p class="mb-0 text-muted">
                        <c:choose>
                        	<c:when test="${ingPercent > 0}">
	                        	<span class="badge bg-light text-success mb-0" id="ingPercent"> 
	                        	<i class="ri-arrow-up-line align-middle"></i>
		                        ${ingPercent}%</span> 전월 대비
                        	</c:when>
                        	<c:when test="${ingPercent == 0}">
	                        	<span class="badge bg-light text-info mb-0" id="ingPercent"> 
	                        	<i class="align-middle"></i>
		                        ${ingPercent}%</span> 전월 대비
                        	</c:when>
                        	<c:otherwise>
	                        	<span class="badge bg-light text-danger mb-0" id="ingPercent">
	                        	<i class="ri-arrow-down-line align-middle"></i>
		                        ${ingPercent}%</span> 전월 대비
                        	</c:otherwise>
                        </c:choose>
                        </p>
                    </div>
                    <div>
                        <div class="avatar-sm flex-shrink-0">
                            <span class="avatar-title bg-soft-warning text-warning rounded-circle fs-4">
                                <i class="mdi mdi-timer-sand"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div><!-- end card body -->
        </div>
    </div>
    <!--end col-->
    <div class="col">
        <div class="card card-animate">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="fw-semibold text-muted mb-0">완료 일감</p>
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTaskDone5}" id="countTaskDone">0</span>개</h4>
                        <p class="mb-0 text-muted">
                        <c:choose>
                        	<c:when test="${donePercent > 0}">
	                        	<span class="badge bg-light text-success mb-0" id="donePercent"> 
	                        	<i class="ri-arrow-up-line align-middle"></i>
		                        ${donePercent}%</span> 전월 대비
                        	</c:when>
                        	<c:when test="${donePercent == 0}">
	                        	<span class="badge bg-light text-info mb-0" id="donePercent"> 
	                        	<i class="align-middle"></i>
		                        ${donePercent}%</span> 전월 대비
                        	</c:when>
                        	<c:otherwise>
	                        	<span class="badge bg-light text-danger mb-0" id="donePercent">
	                        	<i class="ri-arrow-down-line align-middle"></i>
		                        ${donePercent}%</span> 전월 대비
                        	</c:otherwise>
                        </c:choose>
                        </p>
                    </div>
                    <div>
                        <div class="avatar-sm flex-shrink-0">
                            <span class="avatar-title bg-soft-primary text-primary rounded-circle fs-4">
                            	<i class="ri-shopping-bag-line"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div><!-- end card body -->
        </div>
    </div>
    <!--end col-->
    <div class="col">
        <div class="card card-animate">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="fw-semibold text-muted mb-0">승인 일감</p>
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTaskApprove}" id="countTaskApprove">0</span>개</h4>
                        <p class="mb-0 text-muted">
                        <c:choose>
                        	<c:when test="${approvePercent > 0}">
	                        	<span class="badge bg-light text-success mb-0" id="approvePercent"> 
	                        	<i class="ri-arrow-up-line align-middle"></i>
		                        ${approvePercent}%</span> 전월 대비
                        	</c:when>
                        	<c:when test="${approvePercent == 0}">
	                        	<span class="badge bg-light text-info mb-0" id="approvePercent"> 
	                        	<i class="align-middle"></i>
		                        ${approvePercent}%</span> 전월 대비
                        	</c:when>
                        	<c:otherwise>
	                        	<span class="badge bg-light text-danger mb-0" id="approvePercent">
	                        	<i class="ri-arrow-down-line align-middle"></i>
		                        ${approvePercent}%</span> 전월 대비
                        	</c:otherwise>
                        </c:choose>
                        </p>
                    </div>
                    <div>
                        <div class="avatar-sm flex-shrink-0">
                            <span class="avatar-title bg-soft-success text-success rounded-circle fs-4">
                            	<i class="ri-checkbox-circle-line"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div><!-- end card body -->
        </div>
    </div>
    <!--end col-->
    <div class="col">
        <div class="card card-animate">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="fw-semibold text-muted mb-0">반려 일감</p>
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTaskReject}" id="countTaskReject">0</span>개</h4>
                        <p class="mb-0 text-muted">
                        <c:choose>
                        	<c:when test="${countTaskReject > 0}">
	                        	<span class="badge bg-light text-success mb-0" id="countTaskReject"> 
	                        	<i class="ri-arrow-up-line align-middle"></i>
		                        ${countTaskReject}%</span> 전월 대비
                        	</c:when>
                        	<c:when test="${countTaskReject == 0}">
	                        	<span class="badge bg-light text-info mb-0" id="countTaskReject"> 
	                        	<i class="align-middle"></i>
		                        ${countTaskReject}%</span> 전월 대비
                        	</c:when>
                        	<c:otherwise>
	                        	<span class="badge bg-light text-danger mb-0" id="countTaskReject">
	                        	<i class="ri-arrow-down-line align-middle"></i>
		                        ${countTaskReject}%</span> 전월 대비
                        	</c:otherwise>
                        </c:choose>
                        </p>
                    </div>
                    <div>
                        <div class="avatar-sm flex-shrink-0">
                            <span class="avatar-title bg-soft-danger text-danger rounded-circle fs-4">
                            	<i class="ri-reply-line"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div><!-- end card body -->
        </div>
    </div>
    <!--end col-->    
    
    
</div>
    <div class="btn-group mb-2" style="width:10%; margin-left:2%;">
            		<div class="col-xl">
            			<a href="/task/taskMain/${projId}/${pmemGrp}"><i class="ri-file-list-3-line align-bottom me-1"></i>리스트 </a>
    	        	</div>
            		<div class="col-xl">
        	    		<a href="/gantt/ganttMain/${projId}/${pmemGrp}"><i class="ri-bar-chart-horizontal-fill align-bottom me-2"></i>간트</a>
    	        	</div>
	            </div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12" style="margin-left:1%;">
				<div class="tasks-board mb-3">
					<!-- ------------------------------------------------------------ 시작전 칸반  ------------------------------------------------------------ -->
					<div class="tasks-list bg-info bg-opacity-10">
						<div class="d-flex mb-1">
							<div class="flex-grow-1" style="text-align: center;">
								<h6 class="fs-14 text-uppercase fw-semibold mb-0" style="padding:15px;">
									시작<small class="badge bg-success align-bottom ms-1 totaltask-badge" id="countTaskNew5"></small>
								</h6>
							</div>
						</div>
                       	<div class="d-flex justify-content-sm-end mx-2">
   	                       	<button type="button" class="btn btn-ghost-success waves-effect waves-light" data-bs-toggle="modal"
										data-bs-target="#creatertaskModal" id="newTodo"><i class="ri-add-line align-bottom me-1"></i>새 일감</button>
                       	</div>
						<div data-simplebar class="tasks-wrapper px-3 mx-n3 m-3">
						<div style="min-height:500px;" id="todo">
							<c:forEach items="${taskList}" var="list">
								<c:if test="${list.taskStts == '신규'}">
								<div data-simplebar class="tasks-wrapper todoDiv m-3" data-card-id="${list.taskNo}" data-card-pos="data.pos">
									<div class="simplebar-content-wrapper" tabindex="0"
										role="region" aria-label="scrollable content"
										style="height: auto; overflow: hidden;">
										<div class="simplebar-content" style="padding: 0px 16px;">
											<div class="tasks">
												<div class="card tasks-box">
													<div class="card-body">
														<div class="d-flex mb-2">
															<a href="javascript:void(0)"
																class="text-muted fw-medium fs-14 flex-grow-1" style="font-weight:bold;">#${list.taskNo}</a>
														</div>
														<h6 class="fs-16 mb-0 flex-grow-1 text-truncate task-title">
															<a href="/task/taskDetail/${list.taskNo}/${list.pmemGrp}"
																class="link-dark d-block" id="ttl">${list.taskTtl}</a>
														</h6>
														<p class="mb-0 flex-grow-1 text-muted">${list.taskCn}</p><br />
														<p class="mb-0 flex-grow-1 text-muted text-end"><img src="/resources/image/${list.profPhoto}" />&nbsp;&nbsp;${list.profNm}</p><br />
														<div class="card-footer border-top-dashed">
															<div class="d-flex align-items-right">
																<div class="flex-grow-1">
																	<span class="text-muted"><i
																		class="ri-time-line align-right"></i> 완료기한 : ${list.taskEdy}</span>
																	<c:choose>
																		<c:when test="${list.taskPriority == '낮음'}">
																			<span class="badge badge-soft-warning float-end">낮음</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '보통'}">
																			<span class="badge badge-soft-warning float-end">보통</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '높음'}">
																			<span class="badge badge-soft-success float-end">높음</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '긴급'}">
																			<span class="badge badge-soft-danger float-end">긴급</span>
																		</c:when>
																	</c:choose>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>	
								</c:if>
							</c:forEach>
							</div>
							</div>
						</div>
					<!-- ------------------------------------------------------------ 시작전 칸반  ------------------------------------------------------------ -->

					<!-- ------------------------------------------------------------ 진행중 칸반  ------------------------------------------------------------ -->
					<div class="tasks-list bg-info bg-opacity-10">
						<div class="d-flex mb-1">
							<div class="flex-grow-1" style="text-align: center;">
								<h6 class="fs-14 text-uppercase fw-semibold mb-0" style="padding:15px;">
									진행중 <small
										class="badge bg-secondary align-bottom ms-1 totaltask-badge" id="countTaskIng5"></small>
								</h6>
							</div>
						</div>
                       	<div class="d-flex justify-content-sm-end mx-2">
   	                       	<button type="button" class="btn btn-ghost-success waves-effect waves-light" data-bs-toggle="modal"
										data-bs-target="#creatertaskModal" id="newProcess"><i class="ri-add-line align-bottom me-1"></i>진행 일감</button>
   	               		</div>
						<div data-simplebar class="tasks-wrapper px-3 mx-n3 m-3">
						<div style="min-height:500px;" id="process">
						<c:forEach items="${taskList}" var="list">
							<c:if test="${list.taskStts == '진행'}">
									<div class="todoDiv m-3" data-card-id="${list.taskNo}" data-card-pos="data.pos">
									<div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content" style="height: auto; overflow: hidden;">
										<div class="simplebar-content" style="padding: 0px 16px;">
											<div class="tasks" id="${list.taskNo}">
												<div class="card tasks-box">
													<div class="card-body">
														<div class="d-flex mb-2">
															<a href="javascript:void(0)"
																class="text-muted fw-medium fs-14 flex-grow-1" style="font-weight:bold;">#${list.taskNo}</a>
														</div>
														<h6
															class="fs-16 mb-0 flex-grow-1 text-truncate task-title">
															<a href="/task/taskDetail/${list.taskNo}/${list.pmemGrp}"
																class="link-dark d-block" id="ttl">${list.taskTtl}</a>
														</h6>
														<p class="mb-0 flex-grow-1 text-muted">${list.taskCn}</p><br />
														<p class="mb-0 flex-grow-1 text-muted text-end"><img src="/resources/image/${list.profPhoto}" />&nbsp;&nbsp;${list.profNm}</p><br />
														<div class="card-footer border-top-dashed">
															<div class="d-flex align-items-left">
																<div class="flex-grow-1">
																	<span class="text-muted"><i class="ri-time-line align-right"></i> 완료기한 : ${list.taskEdy}</span>
																	<c:choose>
																		<c:when test="${list.taskPriority == '낮음'}">
																			<span class="badge badge-soft-warning float-end">낮음</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '보통'}">
																			<span class="badge badge-soft-warning float-end">보통</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '높음'}">
																			<span class="badge badge-soft-success float-end">높음</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '긴급'}">
																			<span class="badge badge-soft-danger float-end">긴급</span>
																		</c:when>
																	</c:choose>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
						</div>
						</div>
					</div>
					<!-- ------------------------------------------------------------ 진행중 칸반  ------------------------------------------------------------ -->

					<!-- ------------------------------------------------------------ 완료 칸반  ------------------------------------------------------------ -->
					<div class="tasks-list bg-info bg-opacity-10">
						<div class="d-flex mb-1">
							<div class="flex-grow-1" style="text-align: center;">
								<h6 class="fs-14 text-uppercase fw-bold mb-0" style="padding:15px;">
									완료 <small
										class="badge bg-warning align-bottom ms-1 totaltask-badge" id="countTaskDone5"></small>
								</h6>
							</div>
						</div>
	                 	<div class="d-flex justify-content-sm-end mx-2">
                           	<button type="button" class="btn btn-ghost-success waves-effect waves-light" data-bs-toggle="modal"
										data-bs-target="#creatertaskModal" id="newComplete"><i class="ri-add-line align-bottom me-1"></i>완료 일감</button>
                       	</div>
						<div data-simplebar class="tasks-wrapper px-3 mx-n3 m-3">
						<div style="min-height:500px;" id="complete">
						<c:forEach items="${taskList}" var="list">
							<c:if test="${list.taskStts == '완료'}">
							<div class="todoDiv m-3" data-card-id="${list.taskNo}" data-card-pos="data.pos">
									<div class="simplebar-content-wrapper" tabindex="0"
										role="region" aria-label="scrollable content"
										style="height: auto; overflow: hidden;">
										<div class="simplebar-content" style="padding: 0px 16px;">
											<div class="tasks" id="${list.taskNo}">
												<div class="card tasks-box">
													<div class="card-body">
														<div class="d-flex mb-2">
															<a href="javascript:void(0)"
																class="text-muted fw-medium fs-14 flex-grow-1" style="font-weight:bold;">#${list.taskNo}</a>
														</div>
														<h6
															class="fs-16 mb-0 flex-grow-1 text-truncate task-title">
															<a href="/task/taskDetail/${list.taskNo}/${list.pmemGrp}"
																class="link-dark d-block" id="ttl">${list.taskTtl}</a>
														</h6>
														<p class="mb-0 flex-grow-1 text-muted">${list.taskCn}</p><br />
														<p class="mb-0 flex-grow-1 text-muted text-end"><img src="/resources/image/${list.profPhoto}" />&nbsp;&nbsp;${list.profNm}</p><br />
														<div class="card-footer border-top-dashed">
															<div class="d-flex align-items-left">
																<div class="flex-grow-1">
																	<span class="text-muted"><i class="ri-time-line align-right"></i> 완료기한 : ${list.taskEdy}</span>
																	<c:choose>
																		<c:when test="${list.taskPriority == '낮음'}">
																			<span class="badge badge-soft-warning float-end">낮음</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '보통'}">
																			<span class="badge badge-soft-success float-end">보통</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '높음'}">
																			<span class="badge badge-soft-success float-end">높음</span>
																		</c:when>
																		<c:when test="${list.taskPriority == '긴급'}">
																			<span class="badge badge-soft-danger float-end">긴급</span>
																		</c:when>
																	</c:choose>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
						</div>
					</div>
				</div>
				<!-- ------------------------------------------------------------ 완료 칸반  ------------------------------------------------------------ -->
			</div>
		</div>
		</div>
		<br />
		<!-- ------------------------------------------------------------ 새 일감 생성 모달창 ------------------------------------------------------------ -->

		<div class="modal fade" id="creatertaskModal" tabindex="-1"
			aria-labelledby="creatertaskModalLabel" aria-hidden="true"
			data-bs-target="creatertaskModalLabel">
			<div class="modal-dialog modal-dialog-centered modal-lg">
				<div class="modal-content border-0">
					<div class="modal-header p-3 bg-soft-success">
						<h5 class="modal-title" id="creatertaskModalLabel">새 일감</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<form action="#">
							<div class="row g-3">
								<div class="col-lg-12">
									<label for="projectName" class="form-label">제목</label> <input
										type="text" class="form-control" id="taskTtl"
										placeholder="제목을 입력해주세요">
								</div>
								<div class="col-lg-12">
									<label for="sub-tasks" class="form-label">내용</label>
									<div id="taskCn"></div>
								</div>
								<div class="col-lg-6">
									<label for="task-description" class="form-label">상태</label>
									<input type="text" class="form-control" id="taskStts"> 
								</div>
								<div class="col-lg-6">
									<label for="task-description" class="form-label">우선순위</label> <select
										id="taskPriority" class="form-control">
										<option selected>낮음</option>
										<option>보통</option>
										<option>높음</option>
										<option>긴급</option>
									</select>
								</div>
								<div class="col-lg-12">
									<label for="tasks-progress" class="form-label">담당자</label> <select
										id="pmemCd" class="form-control"></select>
								</div>
								<!--end col-->
								<div class="col-lg-6">
									<label for="due-date" class="form-label">상위일감</label> <input
										type="text" id="keyword" class="form-control finput" />
										<div class="dropdown-menu dropdown-menu-lg" id="search-dropdown">
									            <!-- item-->
									            <div class="dropdown-header mt-2 hideBox">
									                <h6 class="text-overflow text-muted mb-2 text-uppercase"><i class="ri-file-list-line"></i> 일감</h6>
									            </div>
									            <div class="notification-list" id="taskInfo">
									            </div>
									    </div>
								</div>
								<!--end col-->
								<div class="col-lg-6">
									<label for="categories" class="form-label">진척도</label> <select
										id="taskProgress" class="form-control">
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
									</select>
								</div>
								<div class="col-lg-6">
									<label for="tasks-progress" class="form-label">시작날짜</label> <input
										type="date" id="taskSdy" class="form-control" value="" />
								</div>
								<div class="col-lg-6">
									<label for="tasks-progress" class="form-label">완료기한</label> <input
										type="date" id="taskEdy" class="form-control" />
								</div>
								<div class="mt-4">
									<div class="hstack gap-2 justify-content-end">
										<button type="button" class="btn btn-outline-success" id="newTask">등록</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>


<!-- JAVASCRIPT -->
<script src="/resources/velzon/dist/assets/libs/bootstrap/js/bootstrap.min.js"></script>
<script src="/resources/velzon/dist/assets/libs/bootstrap/js/popper.js"></script>
<script src="/resources/velzon/dist/assets/libs/choices.js/public/assets/scripts/choices.min.js"></script>
<!-- dragula init js -->
<script src='/resources/velzon/dist/assets/libs/dragula/dragula.min.js'></script>

<!-- dom autoscroll -->
<script src="/resources/velzon/dist/assets/libs/dom-autoscroller/dom-autoscroller.min.js"></script>

<!--taks-kanban-->
<script src="/resources/velzon/dist/assets/js/pages/tasks-kanban.init.js"></script>
