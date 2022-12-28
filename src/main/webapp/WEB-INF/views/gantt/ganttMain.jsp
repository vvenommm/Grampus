<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!-- dhtmlxgantt -->
<link rel="stylesheet" href="/resources/css/dhtmlxgantt_material.css">
<script src="/resources/js/dhtmlxgantt.js"></script>
<script src="https://export.dhtmlx.com/gantt/api.js"></script>  

<!-- toast editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script src="https://cdn.ravenjs.com/3.10.0/raven.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>

<style>
/* 짝수칸 색 */
.gantt_row.odd{			
/*     background-color:#f4f4fb; */
}
/* 클릭한 칸 색 */
.gantt_grid_data .gantt_row.gantt_selected,
.gantt_grid_data .gantt_row.odd.gantt_selected,
.gantt_task_row.gantt_selected {
    background-color: #BFE4FF;
}

/* 컬럼명 배경색 */
.gantt_grid_scale {
	font-weight : bold;
	font-size: 13px;
}
/* 우선순위 글씨체 클래스 */
.important {
	color : red;
}
/* 승인 글씨체 클래스 */
.approve {
	font-weight : bold;
	color : #00A500;
}
/* 반려 글씨체 클래스 */
.reject {
	font-weight : bold;
	color : #6799FF;
}

.gantt_tree_content {
    overflow:hidden;
    text-overflow: ellipsis;
}

.gantt_task_progress {
	text-align: left;
	padding-left: 10px;
	box-sizing: border-box;
	color: white;
	font-weight: bold;
}

/* 우선순위 기준 막대색 */
.gantt_task_line.emer {
    background-color: #f06548;
    border : #f06548;
}
.gantt_task_line.emer .gantt_task_content {
    color: white;
}
 .gantt_task_line.high { 
    background-color: #f7b84b; 
    border : #f7b84b;
 } 
 .gantt_task_line.high .gantt_task_content { 
     color: #fff; 
 } 

.gantt_task_line.medium { 
    background-color: #67b173; 
    border : #67b173;
} 
.gantt_task_line.medium .gantt_task_content { 
    color: #fff; 
} 

.gantt_task_line.low { 
    background-color: #299cdb; 
 	border : #299cdb; 
 } 
.gantt_task_line.low .gantt_task_content { 
    color: #fff; 
} 
/* 승인,반려 상태 클릭 시 팝업창 */
.gantt-warm-popup div{
  background: Cornsilk;
  border: 5px dotted wheat;
  box-shadow: 0 0 10px khaki;
}


.swal2-container.swal2-backdrop-show, .swal2-container.swal2-noanimation {
  z-index: 11000;
}
#modalTaskNo:hover {
	font-size : 21px;
}
</style>


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
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/task/ganttMain/${projVO.id}/${projVO.grp}'">간트</li>
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
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTaskIng}" id="countTaskIng">0</span>개</h4>
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
                        <h4 class="mt-4 ff-secondary fw-semibold"><span class="counter-value" data-target="${countTaskDone}" id="countTaskDone">0</span>개</h4>
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

<div class="btn-group" style="width:10%;">
	<div class="col">
		<a href="/task/taskMain/${projId}/${pmemGrp}"><i class="ri-file-list-3-line align-bottom me-2"></i> 리스트</a>
	</div>
	<div class="col">
		<a href="/task/kanbanMain/${projId}/${pmemGrp}"><i class="ri-dashboard-line align-bottom me-2"></i> 칸반</a>
	</div>
</div>
<button type="button" class="btn btn-ghost-success waves-effect waves-light float-end" data-bs-toggle="modal" data-bs-target="#creatertaskModal">
<i class="ri-add-line align-bottom me-1"></i>새 일감</button>
<!-- ------------------------------------------------------------body------------------------------------------------------------ -->
<div id="gantt_here" style='width:100%; height:450px;'>
</div>

<!-- ------------------------------------------------------일감 등록 Modal------------------------------------------------------ -->
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
							<select id="taskStts" class="form-control">
								<option>신규</option>
								<option>진행</option>
								<option>완료</option>
							</select>
						</div>
						<div class="col-lg-6">
							<label for="task-description" class="form-label">우선순위</label> 
							<select id="taskPriority" class="form-control">
								<option>낮음</option>
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
								<option>0%</option>
								<option>10%</option>
								<option>20%</option>
								<option>30%</option>
								<option>40%</option>
								<option>50%</option>
								<option>60%</option>
								<option>70%</option>
								<option>80%</option>
								<option>90%</option>
								<option>100%</option>
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
		

<!-- ------------------------------------------------------------일감 상세정보 modal------------------------------------------------------------ -->

<!-- tooltips and popovers modal -->
<div class="modal fade" id="exampleModalPopovers" tabindex="-1" aria-labelledby="exampleModalPopoversLabel" aria-modal="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-header">
                <h4 class="modal-title" id="exampleModalPopoversLabel"></h4><br />
            </div>
            <div class="modal-body">
            <blockquote class="blockquote fs-14">
			    <div class="flex-grow-1">
			        <h5 class="fs-15">제목</h5>
			        <p id="ttl"></p>
			    </div>
			</blockquote>
            <blockquote class="blockquote fs-14">
			    <div class="내용">
			        <h5 class="fs-15">내용</h5>
			        <p id="cn"></p>
			    </div>
			</blockquote>
			<blockquote class="blockquote fs-14">
			    <div class="flex-grow-1">
			        <h5 class="fs-15">기간</h5>
			        <p id="dy"></p>
			    </div>
		    </blockquote>
		    <blockquote class="blockquote fs-14">
			    <div class="flex-grow-1">
			        <h5 class="fs-15">우선순위</h5>
			        <p id="pri"></p>
			    </div>
		    </blockquote>
			<blockquote class="blockquote fs-14">
			    <div class="flex-grow-1">
			        <h5 class="fs-15">상태</h5>
			        <p id="stts"></p>
			    </div>
		    </blockquote>
			<blockquote class="blockquote fs-14">
			    <div class="flex-grow-1">
			        <h5 class="fs-15">진척도</h5>
			        <p id="pro"></p>
			    </div>
			</blockquote>
            </div>
        </div>
    </div>
</div>


<!-- ------------------------------------------------------------script------------------------------------------------------------ -->
<script>
gantt.i18n.setLocale("kr");	//한글 설정
gantt.init("gantt_here");

var pmemGrp = "${pmemGrp}";
var projId = "${projId}";
var today = new Date();


$(function() {
	//일감 목록 가져오기
	$.ajax({
		url  : "/gantt/selectTask",
		type : "post",
		data : pmemGrp,
		dataType : "json",
		contentType : "application/json;charset=utf-8",
		success : function(res) {
			console.log(res);

			//간트 출력
			$.each(res, function(i,v) {
				taskSdy = new Date(v.taskSdy);
				taskEdy = new Date(v.taskEdy);
				if(taskEdy - taskSdy == 0) {			//기간이 0일인 일감은 milestone으로
					gantt.parse({
						data: [	
							{ id: v.taskNo, text: v.taskTtl, start_date: taskSdy, end_date : taskEdy, progress: v.taskProgress, 
								open: true, parent: v.taskParent, priority: v.taskPriority, users: v.profNm, stts : v.taskStts, type:gantt.config.types.milestone},		//마일스톤은 end_date, duration, progress속성 사용 x
						],
						links: [	//연결선
							{id: v.taskNo, source: v.taskParent, target: v.taskNo, type: "1", color: "#FFC19E"},
						]
					});
				}else {
					gantt.parse({
						data: [	
							{ id: v.taskNo, text: v.taskTtl, start_date: taskSdy, end_date : taskEdy, progress: v.taskProgress, 
								open: true, parent: v.taskParent, priority: v.taskPriority, users: v.profNm, stts : v.taskStts },
						],
						links: [	//연결선
							{id: v.taskNo, source: v.taskParent, target: v.taskNo, type: "1", color: "#405189"},
						]
					});
				}
				
				if(v.taskStts == "승인") {
					gantt.getTask(v.taskNo).readonly = true;
				}
				if(v.taskStts == "반려") {
					gantt.getTask(v.taskNo).readonly = true;
				}
			})
			
			
		}
	})
	
	
	//컬럼명 설정
	gantt.config.columns = [
	    {name:"text",       label:"일감",   width:"*", tree:true },	//"*" : 남은공간차지
	    {name:"stts",       label:"상태", width:80,  align:"center", template:myFunc1 },
	    {name:"progress",   label:"진척도", width:80,  align:"center" },
	    {name:"priority",   label:"우선순위", width:80,  align:"center", template:myFunc },
	    {name:"users",      label:"담당자", width:100,  align:"center" },
	];
	
	//우선순위에 효과주는 함수
	function myFunc(task){
	    if(task.priority =='긴급')
	        return "<div class='important'>" + task.priority + "</div>";
	    return task.priority;
	};
	
	//상태에 효과주는 함수
	function myFunc1(task){
	    if(task.stts == '승인')
	        return "<div class='approve'>" + task.stts + "</div>";
	    if(task.stts == '반려')
	        return "<div class='reject'>" + task.stts + "</div>";
	    return task.stts;
	};
	
	gantt.config.buttons_left = ["gantt_save_btn", "gantt_delete_btn"];
	gantt.config.buttons_right = ["gantt_cancel_btn"];

	//드래그로 진척도 조절 불가
	gantt.config.drag_progress = false;
	
	//컬럼영역 넓이
	gantt.config.grid_width = 600;
	
	//자동정렬
	gantt.config.sort = true;
	
	gantt.plugins({
	    click_drag: true,
	    auto_scheduling: true,
	    quick_info: true,
	    keyboard_navigation: true,
	    undo: true,
	    tooltip: true 
	});
	
	//드래그 중 자동 스크롤
	gantt.config.autoscroll = true;
	gantt.config.autoscroll_speed = 50;
	
	//드래그 이벤트
	gantt.config.click_drag = {
	    singleRow: true
	};
	
	
	//바 넓이
	gantt.config.bar_height = 20;	
	
	//컬럼 날짜
	gantt.config.scales = [
	    {unit: "month", step: 1, format: "%Y" + "년 " + "%F"},
	    {unit: "day", step: 1, format: "%j" + "일 (" + "%D" + ")"}
	];
	
	
	gantt.config.scale_height = 50; 	//컬럼 높이
	
	
	gantt.config.layout = {
		    css: "gantt_container",
		    cols: [
		    	   {
		    	     width:400,
		    	     min_width: 300,
		    	 
		    	     // adding horizontal scrollbar to the grid via the scrollX attribute
		    	     rows:[
		    	      {view: "grid", scrollX: "gridScroll", scrollable: true, scrollY: "scrollVer"}, 
		    	      {view: "scrollbar", id: "gridScroll"}  
		    	     ]
		    	   },
		    	   {resizer: true, width: 1},
		    	   {
		    	     rows:[
		    	      {view: "timeline", scrollX: "scrollHor", scrollY: "scrollVer"},
		    	      {view: "scrollbar", id: "scrollHor"}
		    	     ]
		    	   },
		    	   {view: "scrollbar", id: "scrollVer"}
		    	  ]
	}
	
	
	//각종 이벤트-----------------------------------------------------------------------------------------------------
	
	//수정창 - 수정 후 저장버튼 클릭 시 이벤트
	gantt.attachEvent("onLightboxSave", function(id, task, is_new){
		var taskNo = id;
		var taskTtl = task.text;
		var taskPriority = task.priority;
		var taskProgress = task.progress;
		var taskStts = task.stts;
		
		if(taskPriority == null || taskPriority == "") {
			gantt.alert({
			    text:"우선순위를 선택해주세요",
			    title:"경고",
			    ok:"예",
			});
			return;
		}
		if(taskProgress == null || taskProgress == "") {
			gantt.alert({
			    text:"진척도를 선택해주세요",
			    title:"경고",
			    ok:"예",
			});
			return;
		}
		if(taskTtl == null || taskTtl == "") {
			gantt.alert({
			    text:"제목을 입력해주세요",
			    title:"경고",
			    ok:"예",
			});
		}
		if(taskStts == null || taskStts == "") {
			gantt.alert({
			    text:"상태을 입력해주세요",
			    title:"경고",
			    ok:"예",
			});
		}
		
		var data = {
				"taskNo" : taskNo,
				"taskTtl" : taskTtl,
				"taskPriority" : taskPriority,
				"taskProgress" : taskProgress,
				"taskStts" : taskStts
		}
		
		if(is_new) {	//true: 새 일감 생성
			
		}else {			//false: 기존 일감 수정
			$.ajax({
				url : "/gantt/updateAllGantt",
				type : "post",
				data : JSON.stringify(data),
				contentType : "application/json;charset=utf-8",
				success : function(res) {
					location.href = "/gantt/ganttMain/${projId}/${pmemGrp}";
				}
			})
		}
	})
	
	
	//수정창 - 일감 삭제
	gantt.attachEvent("onLightboxDelete", function(id, task, is_new){
		Swal.fire({
	        text: "삭제하시겠습니까?",
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
	        	 if(result){
 					$.ajax({
 						url : "/gantt/deleteTask",
 						type : "post",
 						data : id,
 						contentType : "application/json;charset=utf-8",
 						success : function(res) {
 							location.href = "/gantt/ganttMain/${projId}/${pmemGrp}";
 						}
 					})
 		        }
	        } else if (
		        // Read more about handling dismissals
                result.dismiss === Swal.DismissReason.cancel
              ){
                Swal.fire({
                  text: '삭제가 취소되었습니다.',
                  icon: 'error',
                  confirmButtonClass: 'btn btn-outline-danger mt-2',
                  buttonsStyling: false
                })
            }  
	    });
	});
	
	
	//수정창
	gantt.config.lightbox_additional_height = 150;		//수정창 길이
	gantt.config.lightbox.sections=[
	    {name:"text", height:50, map_to:"text", type:"textarea", focus:true},
	    {name:"priority", height: 50, map_to:"priority", type:"select", options: [
					{key: "낮음", label: "낮음"},
					{key: "보통", label: "보통"},
					{key: "높음", label: "높음"},
					{key: "긴급", label: "긴급"}
				]},
	    {name:"stts", height: 50, map_to:"stts", type:"select", options: [
					{key: "신규", label: "신규"},
					{key: "진행", label: "진행"},
					{key: "완료", label: "완료"},
				]},
	    {name:"progress", height: 50,  map_to:"progress", type:"select", options: [
					{key: "0",  label: "0%"},
					{key: "10", label: "10%"},
					{key: "20", label: "20%"},
					{key: "30", label: "30%"},
					{key: "40", label: "40%"},
					{key: "50", label: "50%"},
					{key: "60", label: "60%"},
					{key: "70", label: "70%"},
					{key: "80", label: "80%"},
					{key: "90", label: "90%"},
					{key: "100", label: "100%"},
				]},
	];
	gantt.locale.labels.section_priority = "우선순위";
	gantt.locale.labels.section_progress = "진척도";
	gantt.locale.labels.section_text = "제목";
	gantt.locale.labels.section_stts = "상태";
	
	gantt.config.lightbox.milestone_sections= [
	    {name:"text", height:50, map_to:"text", type:"textarea", focus:true},
	    {name:"priority", height: 50, map_to:"priority", type:"select", options: [
					{key: "낮음", label: "낮음"},
					{key: "보통", label: "보통"},
					{key: "높음", label: "높음"},
					{key: "긴급", label: "긴급"}
				]},
	    {name:"stts", height: 50, map_to:"stts", type:"select", options: [
					{key: "신규", label: "신규"},
					{key: "진행", label: "진행"},
					{key: "완료", label: "완료"},
				]},
	    {name:"progress", height: 50,  map_to:"progress", type:"select", options: [
					{key: "0",  label: "0%"},
					{key: "10", label: "10%"},
					{key: "20", label: "20%"},
					{key: "30", label: "30%"},
					{key: "40", label: "40%"},
					{key: "50", label: "50%"},
					{key: "60", label: "60%"},
					{key: "70", label: "70%"},
					{key: "80", label: "80%"},
					{key: "90", label: "90%"},
					{key: "100", label: "100%"},
				]},
	];
	gantt.locale.labels.milestone_sections_priority = "우선순위";
	gantt.locale.labels.milestone_section_progress = "진척도";
	gantt.locale.labels.milestone_sections_text = "제목";
	gantt.locale.labels.milestone_sections_stts = "상태";
	
	gantt.templates.lightbox_header = function(start_date,end_date,task){
	    return "#" + task.id;
	};
	
	
	//quick info창
	gantt.config.quickinfo_buttons=["advanced_details_button", "icon_edit"];
	gantt.locale.labels["advanced_details_button"] = "상세 정보";
	//상세정보 클릭 시
	gantt.$click.buttons.advanced_details_button=function(id){
		//상세정보 모달
		$.ajax({
			url : "/gantt/taskDetail",
			type : "post",
			data : id,
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				console.log(res);
				console.log(res.profNm);
				code = "<a href='/task/taskDetail/" + res.taskNo + "/" + pmemGrp +  "' id='modalTaskNo'>#" + res.taskNo + "</a>"
				$("#exampleModalPopoversLabel").html(code);
				$("#ttl").text(res.taskTtl);
				$("#cn").text(res.taskCn);
				$("#dy").text(res.taskSdy + " ~ " + res.taskEdy);
				$("#pri").text(res.taskPriority);
				$("#stts").text(res.taskStts);
				$("#pro").text(res.taskProgress + "%");
			}
		})
		$("#exampleModalPopovers").modal('show');
		
	};
	
	gantt.templates.quick_info_date = function(start, end, task){
		if(task.stts == "승인" || task.stts == "반려") {
			gantt.message({
				type : "warm-popup", 
				text : task.stts + " 상태의 일감은 수정할 수 없습니다."
			})
		}
	    return "# " + task.id;
	};
	gantt.message.position = 'bottom';
	
	
	//연결선 클릭 시
	gantt.attachEvent("onLinkDblClick", function(id,e){
		var data = {
				"taskNo" : id,
				"taskParent" : "none"
		}
		Swal.fire({
	        text: "해당 하위일감과의 관계를 삭제하시겠습니까?",
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
	        	console.log(id);	//하위일감번호
	        	console.log(e);	//하위일감번호
		        if(result){
		        	$.ajax({
		        		url : "/gantt/updateParent",
		        		type : "post",
		        		data : JSON.stringify(data),
		        		contentType : "application/json;charset=utf-8",
		        		success : function(res) {
							location.href = "/gantt/ganttMain/${projId}/${pmemGrp}";
		        		}
		        	})
		        }
	        } else if (
		        // Read more about handling dismissals
                result.dismiss === Swal.DismissReason.cancel
              ){
                Swal.fire({
                  text: '삭제가 취소되었습니다.',
                  icon: 'error',
                  confirmButtonClass: 'btn btn-outline-danger mt-2',
                  buttonsStyling: false
                })
            }  
	    });
	});
	
	//새 연결선 추가
	gantt.attachEvent("onBeforeLinkAdd", function(id,item){
		console.log(item);
		var child = item.target;	//하위일감
		var parent = item.source;	//상위일감
		
		var data = {
				"taskNo" : child,
				"taskParent" : parent
		}
    	$.ajax({
    		url : "/gantt/updateParent",
    		type : "post",
    		data : JSON.stringify(data),
    		contentType : "application/json;charset=utf-8",
    		success : function(res) {
				location.href = "/gantt/ganttMain/${projId}/${pmemGrp}";
    		}
    	})
	});
	
	
	gantt.templates.leftside_text = function(start, end, task){
	    return task.duration + "일";
	};
	
	gantt.templates.grid_folder = function(item) {
	    return "<div class='gantt_tree_icon gantt_folder_" +
	    (item.$open ? "open" : "closed") + "'></div>";
	};
	
	gantt.templates.grid_file = function(item) {
	    return "<div class='gantt_tree_icon gantt_file'></div>";
	};
	
	//----------------------------------------------------------------------------------------------
	//같은 그룹 팀원 가져오기(담당자) --> 새 일감 작성 시
	$.ajax({
		url : "/task/sameGrpMem",
		type : "post",
		data : pmemGrp,
		contentType : "application/json;charset=UTF-8",
		success : function(res) {
			console.log(res);
			var code = "";
			$.each(res, function(i, v) {
				code = "<option>" + v.PROF_NM + " (" + v.MEM_NO + ")"
						+ "</option>";
				$("#pmemCd").append(code);
			})
		}
	})
		
	//일감 등록 
	$("#newTask").on("click", function() {
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
	
			memNo = memNo.substring(memNo.indexOf("(") + 1, memNo.indexOf(")"));
			taskProgress = taskProgress.slice(0, -1);
	
			var data = {
				"taskTtl" : taskTtl,
				"taskCn" : taskCn,
				"taskStts" : taskStts,
				"taskPriority" : taskPriority,
				"memNo" : memNo,
				"taskProgress" : taskProgress,
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
						var taskId = gantt.addTask({
						    id: "1500",
						    text: taskTtl,
						    start_date: taskSdy,
						    end_date : taskEdy,
						});
						location.href = "/gantt/ganttMain/${projId}/${pmemGrp}";
					}
				}
			})
		})
	})
	
	//새 일감 등록 에디터
	const Editor = toastui.Editor;
	editor = new Editor({
		el : document.querySelector('#taskCn'),
		height : '300px',
		initialEditType : 'wysiwyg',
		previewStyle : 'vertical'
	});

	//새 일감 등록 모달창 이동하게
	$("#creatertaskModal").draggable();
	
	//모달의 시작날짜 오늘날짜로 설정
	 today = new Date();
	 today = today.toISOString().slice(0, 10);
	 $("#taskSdy").val(today);
	
	
	//드래그 이동 시 일감 수정
	gantt.attachEvent("onTaskDrag", function(id, mode, e){
		console.log(e);
		var taskSdy = e.start_date;
		var taskEdy = e.end_date;
		var taskProgress = e.progress;
		
		taskSdy = taskSdy.getFullYear() + "-" + (taskSdy.getMonth()+1) + "-" + taskSdy.getDate();
		taskEdy = taskEdy.getFullYear() + "-" + (taskEdy.getMonth()+1) + "-" + taskEdy.getDate();
		var data = {
				"taskNo" : id,
				"taskSdy" : taskSdy,
				"taskEdy" : taskEdy,
				"taskProgress" : taskProgress
		}
		
		$.ajax({
			url : "/gantt/updateDateGantt",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				gantt.hideLightbox();
			}
			
		})
	});
	
	
	//////////////////////////
	//전체 회원 검색
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
	                code += "<h6 class='m-0 memberId'>#"+v.TASK_NO+" "+v.TASK_TTL+"</h6>";
	                code += "<span class='fs-11 mb-0 text-muted memberName'>"+v.TASK_CN+"</span>";
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


//함수--------------------------------------------------------------------------------------------------------------

//우선순위에 따라 색 설정 함수
gantt.templates.task_class  = function(start, end, task){
    switch (task.priority){
        case "긴급":
            return "emer";
            break;
        case "높음":
            return "high";
            break;
        case "보통":
            return "medium";
            break;
        case "낮음":
            return "low";
            break;
    }
};
</script>
			