<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.css" />

<script src="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.js"></script>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>

<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js" ></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.1/xlsx.full.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>

<style>
 .ttl:hover { 
	font-weight : bold;
	color : black;
 }
</style>

<script type="text/javascript">
 $(function() {
	 //일감 등록
	 $("#newTask").on("click", function() {
		 location.href="/task/newTask/${pmemGrp}";
	 })
	 
	 $("#exampleModalScrollable").draggable();
	 
	 //일괄 편집 완료 버튼
	 $(document).on("click", "#allEditBtn", function() {
		 var form = document.getElementById("allEdit");
		 form.submit();
	 		Swal.fire({
	            text: '수정 완료되었습니다.',
	            icon: 'success',
	            confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
	 })
 })
 
 //메인에서 카테고리 선택----------------------------------------------------------------------------------------
 var code = "";
 var role = "${role}";
 function category(keyword) {
	 //모두일 경우 모든 일감 나오게
	if(keyword == '모두') {
		$("#up").text(keyword);
		$("#up").attr("onclick", "category('" + keyword + "')");
		$("#down").html('<i class="bx bx-subdirectory-right"></i> 전체');
		$("#down").attr("onclick", "category('전체')");
		
		$.ajax({
			url : "/task/taskList",
			type : "post",
			success : function(res) { 
				code = "";
				$.each(res, function(i,v) {
					    code += '    <tr>'
					    code += '        <th scope="row">' + v.taskNo + '</th>'
				    if(v.taskPriority == "긴급") {
						code += '            	<td><span class="badge badge-soft-danger">' + v.taskPriority + '</span></td>'
				    }else if(v.taskPriority == "높음") {
						code += '            	<td><span class="badge badge-soft-warning">' + v.taskPriority + '</span></td>'
				    }else {
						code += '            	<td><span class="badge badge-soft-success">' + v.taskPriority + '</span></td>'
				    }
			            code += '		<td><a href="/task/taskDetail/' + v.taskNo + '/${pmemGrp}" class="ttl">' + v.taskTtl + '</a></td>'
					    code += '       <td>' + v.profNm + '</td>'
				    if(v.taskProgress == 100 && v.taskStts == "완료") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else if(v.taskProgress == 100 && v.taskStts == "승인") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else if(v.taskProgress == 100 && v.taskStts == "반려") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-danger" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-warning" role="progressbar" style="width: ' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }
				    if(v.taskStts == "완료") {
						code += '	            <td class="link-success">' + v.taskStts + '</td>'
				    }else if(v.taskStts == "승인") {
						code += '	            <td class="link-info">' + v.taskStts + '</td>'
				    }else if(v.taskStts == "반려") {
						code += '	            <td class="link-danger">' + v.taskStts + '</td>'
				    }else {
						code += '	            <td class="link-warning">' + v.taskStts + '</td>'
				    }
					    code += '        <td>' + v.taskEdy + '</td>'
			       		code += '	</tr>'
				})
				$("#taskTbody").html(code);
			
				var page = `
							<li class="page-item <c:if test='${list.startPage<6 }'>disabled</c:if>" id="prevBtn">
			                    <a href="/task/taskMain/${projId}/${grp}?currentPage=${list.startPage-5 }" class="page-link">Previous</a>
			                </li>
							<c:forEach var="pNo" begin="${list.startPage }" end="${list.endPage }" step="1">
			                    <li class="page-item <c:if test='${list.currentPage eq pNo}'>active</c:if>">
			                        <a href="/task/taskMain/${projId}/${grp}?currentPage=${pNo }" class="page-link">${pNo}</a>
			                    </li>
							</c:forEach>
			                <li class="page-item <c:if test='${list.endPage>=list.totalPages }'>disabled</c:if>" id="nextBtn">
			                    <a href="/task/taskMain/${projId}/${grp}?currentPage=${list.startPage+5 }" class="page-link">Next</a>
			                </li>
							`;
				$('#pageUl').empty();
				$('#pageUl').append(page);
			}
		})
		
		//상단 각 상태별 일감 개수 바꾸기
		$.ajax({
			url : "/task/tasks",
			type : "post",
			success : function(res) {
				if(res.allPercent > 0) {
					$("#allPercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.allPercent + "%");
				}else if(res.allPercent < 0) {
					$("#allPercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.allPercent + "%");
					$("#allPercent").attr("data-target", res.allPercent);
				}else {
					$("#allPercent").html('<i class="align-middle"></i>' + res.allPercent + "%");
					$("#allPercent").attr("data-target", res.allPercent);
				}
				
				if(res.ingPercent > 0) {
					$("#ingPercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.ingPercent + "%");
					$("#ingPercent").attr("data-target", res.ingPercent);
				}else if(res.ingPercent < 0) {
					$("#ingPercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.ingPercent + "%");
					$("#ingPercent").attr("data-target", res.ingPercent);
				}else {
					$("#ingPercent").html('<i class="align-middle"></i>' + res.ingPercent + "%");
					$("#ingPercent").attr("data-target", res.ingPercent);
				}
				
				if(res.donePercent > 0) {
					$("#donePercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.donePercent + "%");
					$("#donePercent").attr("data-target", res.donePercent);
				}else if(res.donePercent < 0) {
					$("#donePercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.donePercent + "%");
					$("#donePercent").attr("data-target", res.donePercent);
				}else {
					$("#donePercent").html('<i class="align-middle"></i>' + res.donePercent + "%");
					$("#donePercent").attr("data-target", res.donePercent);
				}
				
				if(res.approvePercent > 0) {
					$("#approvePercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.approvePercent + "%");
					$("#approvePercent").attr("data-target", res.approvePercent);
				}else if(res.approvePercent < 0) {
					$("#approvePercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.approvePercent + "%");
					$("#approvePercent").attr("data-target", res.approvePercent);
				}else {
					$("#approvePercent").html('<i class="align-middle"></i>' + res.approvePercent + "%");
					$("#approvePercent").attr("data-target", res.approvePercent);
				}
				
				if(res.rejectPercent > 0) {
					$("#rejectPercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.rejectPercent + "%");
					$("#rejectPercent").attr("data-target", res.rejectPercent);
				}else if(res.rejectPercent < 0) {
					$("#rejectPercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.rejectPercent + "%");
					$("#rejectPercent").attr("data-target", res.rejectPercent);
				}else {
					$("#rejectPercent").html('<i class="align-middle"></i>' + res.rejectPercent + "%");
					$("#rejectPercent").attr("data-target", res.rejectPercent);
				}
				
				$("#countTask").text(res.countTask);
				$("#countTask").attr("data-target", res.countTask);
				
				$("#countTaskIng").text(res.countTaskIng);
				$("#countTaskIng").attr("data-target", res.countTaskIng);
				
				$("#countTaskDone").text(res.countTaskDone);
				$("#countTaskDone").attr("data-target", res.countTaskDone);
				
				$("#countTaskApprove").text(res.countTaskApprove);
				$("#countTaskApprove").attr("data-target", res.countTaskApprove);
				
				$("#countTaskReject").text(res.countTaskReject);
				$("#countTaskReject").attr("data-target", res.countTaskReject);
				
			}
		})
	}
	if(keyword == '전체') {		
		//전체 클릭 시
		$("#down").text("모두");
		$("#down").attr("onclick", "category('모두')");
		$("#up").html('전체');
		$("#up").attr("onclick", "category('전체')");
		
		$.ajax({
			url : "/task/taskList2",
			type : "post",
			success : function(res) { 
				code = "";
				$.each(res, function(i,v) {
					    code += '    <tr>'
					    code += '        <th scope="row">' + v.taskNo + '</th>'
				    if(v.taskPriority == "긴급") {
						code += '            	<td><span class="badge badge-soft-danger">' + v.taskPriority + '</span></td>'
				    }else if(v.taskPriority == "높음") {
						code += '            	<td><span class="badge badge-soft-warning">' + v.taskPriority + '</span></td>'
				    }else {
						code += '            	<td><span class="badge badge-soft-success">' + v.taskPriority + '</span></td>'
				    }
			            code += '		<td><a href="/task/taskDetail/' + v.taskNo + '/${pmemGrp}" class="ttl">' + v.taskTtl + '</a></td>'
					    code += '       <td>' + v.profNm + '</td>'
				    if(v.taskProgress == 100 && v.taskStts == "완료") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else if(v.taskProgress == 100 && v.taskStts == "승인") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else if(v.taskProgress == 100 && v.taskStts == "반려") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-danger" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-warning" role="progressbar" style="width: ' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }
				    if(v.taskStts == "완료") {
						code += '	            <td class="link-success">' + v.taskStts + '</td>'
				    }else if(v.taskStts == "승인") {
						code += '	            <td class="link-info">' + v.taskStts + '</td>'
				    }else if(v.taskStts == "반려") {
						code += '	            <td class="link-danger">' + v.taskStts + '</td>'
				    }else {
						code += '	            <td class="link-warning">' + v.taskStts + '</td>'
				    }
					    code += '        <td>' + v.taskEdy + '</td>'
			       		code += '	</tr>'
				})
				$("#taskTbody").html(code);
			
			}
		})
		
		//상단 각 상태별 일감 개수 바꾸기
		$.ajax({
			url : "/task/tasks2",
			type : "post",
			success : function(res) {
				if(res.allPercent > 0) {
					$("#allPercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.allPercent + "%");
				}else if(res.allPercent < 0) {
					$("#allPercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.allPercent + "%");
					$("#allPercent").attr("data-target", res.allPercent);
				}else {
					$("#allPercent").html('<i class="align-middle"></i>' + res.allPercent + "%");
					$("#allPercent").attr("data-target", res.allPercent);
				}
				
				if(res.ingPercent > 0) {
					$("#ingPercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.ingPercent + "%");
					$("#ingPercent").attr("data-target", res.ingPercent);
				}else if(res.ingPercent < 0) {
					$("#ingPercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.ingPercent + "%");
					$("#ingPercent").attr("data-target", res.ingPercent);
				}else {
					$("#ingPercent").html('<i class="align-middle"></i>' + res.ingPercent + "%");
					$("#ingPercent").attr("data-target", res.ingPercent);
				}
				
				if(res.donePercent > 0) {
					$("#donePercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.donePercent + "%");
					$("#donePercent").attr("data-target", res.donePercent);
				}else if(res.donePercent < 0) {
					$("#donePercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.donePercent + "%");
					$("#donePercent").attr("data-target", res.donePercent);
				}else {
					$("#donePercent").html('<i class="align-middle"></i>' + res.donePercent + "%");
					$("#donePercent").attr("data-target", res.donePercent);
				}
				
				if(res.approvePercent > 0) {
					$("#approvePercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.approvePercent + "%");
					$("#approvePercent").attr("data-target", res.approvePercent);
				}else if(res.approvePercent < 0) {
					$("#approvePercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.approvePercent + "%");
					$("#approvePercent").attr("data-target", res.approvePercent);
				}else {
					$("#approvePercent").html('<i class="align-middle"></i>' + res.approvePercent + "%");
					$("#approvePercent").attr("data-target", res.approvePercent);
				}
				
				if(res.rejectPercent > 0) {
					$("#rejectPercent").html('<i class="ri-arrow-up-line align-middle"></i>' + res.rejectPercent + "%");
					$("#rejectPercent").attr("data-target", res.rejectPercent);
				}else if(res.rejectPercent < 0) {
					$("#rejectPercent").html('<i class="ri-arrow-down-line align-middle"></i>' + res.rejectPercent + "%");
					$("#rejectPercent").attr("data-target", res.rejectPercent);
				}else {
					$("#rejectPercent").html('<i class="align-middle"></i>' + res.rejectPercent + "%");
					$("#rejectPercent").attr("data-target", res.rejectPercent);
				}
				
				$("#countTask").text(res.countTask);
				$("#countTask").attr("data-target", res.countTask);
				
				$("#countTaskIng").text(res.countTaskIng);
				$("#countTaskIng").attr("data-target", res.countTaskIng);
				
				$("#countTaskDone").text(res.countTaskDone);
				$("#countTaskDone").attr("data-target", res.countTaskDone);
				
				$("#countTaskApprove").text(res.countTaskApprove);
				$("#countTaskApprove").attr("data-target", res.countTaskApprove);
				
				$("#countTaskReject").text(res.countTaskReject);
				$("#countTaskReject").attr("data-target", res.countTaskReject);
			}
		})
	}
	 
 }
 
 
 //--------------------------------------------------------------------------------------------------------------------------------
 
 //모달에서 카테고리 선택-------------------------------------------------------------------------------------------------------------
 function modalCategory(keyword) {
	 //모두일 경우 모든 일감 나오게
	if(keyword == '모두') {
		$("#upModal").text(keyword);
		$("#upModal").attr("onclick", "modalCategory('" + keyword + "')");
		$("#downModal").html('<i class="bx bx-subdirectory-right"></i> 전체');
		$("#downModal").attr("onclick", "modalCategory('전체')");
		
		$.ajax({
			url : "/task/taskList",
			type : "post",
			success : function(res) {
				code = "";
				$.each(res, function(i,v) {
				    code += '    <tr>'
			    	code += '        <th scope="row" class="taskNo">'
				    code += '			<input type="hidden" value="' + v.taskNo + '" name="taskNo" />';
				    code += v.taskNo + '</th>'
				    if(v.taskPriority == "긴급") {
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option>낮음</option>'
						code += '				<option>보통</option>'
						code += '				<option>높음</option>'
						code += '				<option selected>긴급</option>'
						code += '				</select></td>'
				    }else if(v.taskPriority == "높음"){
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option>낮음</option>'
						code += '				<option>보통</option>'
						code += '				<option selected>높음</option>'
						code += '				<option>긴급</option>'
						code += '				</select></td>'
				    }else if(v.taskPriority == "보통"){
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option>낮음</option>'
						code += '				<option selected>보통</option>'
						code += '				<option>높음</option>'
						code += '				<option>긴급</option>'
						code += '				</select></td>'
					}else if(v.taskPriority == "낮음"){
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option selected>낮음</option>'
						code += '				<option>보통</option>'
						code += '				<option>높음</option>'
						code += '				<option>긴급</option>'
						code += '				</select></td>'
					}
				    
		            code += '		<td><input type="text" class="form-control me-auto taskTtl" name="taskTtl" value="' + v.taskTtl + '" /></td>'
				    code += '       <td>'
				    code += '       	<select class="form-control me-auto pmemCd" name="pmemCds">'
						//담당자 받아오기
						$.ajax({
							url : "/task/modalPmemcd",
							type : "post",
							data : v.taskNo,
							async : false,
							contentType : "application/json;charset=utf-8",
							success : function(res2) {
								console.log(res2);
								$.each(res2, function(m, n) {
									if(v.profNm == n.PROF_NM) {
										code += '			<option value="' + n.PMEM_CD + '" selected>' + n.PROF_NM + '(' + n.MEM_NO + ')' + '</option>';
									}else {
										code += '			<option value="' + n.PMEM_CD + '">' + n.PROF_NM + '(' + n.MEM_NO + ')' + '</option>';
									}
								})
							}
						})
					    code += '       	</select>'
					    code += '       </td>'
					    
					    if(v.taskProgress == 100) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100" selected>100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 90) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90" selected>90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 80) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	   		<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80" selected>80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 70) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	   		<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70" selected>70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 60) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60" selected>60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 50) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50" selected>50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						 }else if(v.taskProgress == 40) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40" selected>40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 30) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30" selected>30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 20) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20" selected>20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 10) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10" selected>10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	   		<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 0) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0" selected>0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}
					    
				    if(v.taskStts == "신규") {
						code += '	    <td>'
						code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
						code += '	  		<option selected>신규</option>'
						code += '	   	 	<option>진행</option>'
						code += '	    	<option>완료</option>'
						code += '	    	</select>'
						code += '	    </td>'
				    }else if(v.taskStts == "진행") {
						code += '	    <td>'
						code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
						code += '	  		<option>신규</option>'
						code += '	   	 	<option selected>진행</option>'
						code += '	    	<option>완료</option>'
						code += '	    </select>'
						code += '	    </td>'
				    }else if(v.taskStts == "완료" || v.taskStts == "승인" || v.taskStts == "반려") {
				    	if(role == "R01") {
							code += '	    <td>'
							code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
							code += '	  		<option>완료</option>'
							code += '	  		<option>승인</option>'
							code += '	  		<option>반려</option>'
							code += '	    </select>'
							code += '	    </td>'
				    	}else {
							code += '	    <td>'
							code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
							code += '	  		<option>신규</option>'
							code += '	  		<option>진행</option>'
							code += '	  		<option>완료</option>'
							code += '	    </select>'
							code += '	    </td>'
				    	}
					}
				    	v.taskSdy = v.taskSdy.substr(0,4) + "-" + (v.taskSdy.substr(5,2)) + "-" + v.taskSdy.substr(8,2);
						code += '<td><input type="date" value="' + v.taskSdy + '" class="form-control me-auto taskSdy" name="taskSdy" /></td>'
				    	v.taskEdy = v.taskEdy.substr(0,4) + "-" + (v.taskEdy.substr(5,2)) + "-" + v.taskEdy.substr(8,2);
						code += '<td><input type="date" value="' + v.taskEdy + '" class="form-control me-auto taskEdy" name="taskEdy" /></td>'
						code += '</tr>'
				})
				$("#modalTaskTbody").html(code);
			}
		})
	}
	 
	if(keyword == '전체') {		
		//전체 클릭 시
		$("#downModal").text("모두");
		$("#downModal").attr("onclick", "modalCategory('모두')");
		$("#upModal").text("전체");
		$("#upModal").attr("onclick", "modalCategory('전체')");
		
		$.ajax({
			url : "/task/taskList2",
			type : "post",
			success : function(res) {
				code = "";
				$.each(res, function(i,v) {
				    code += '    <tr>'
			    	code += '        <th scope="row" class="taskNo">'
				    code += '			<input type="hidden" value="' + v.taskNo + '" name="taskNo" />';
				    code += v.taskNo + '</th>'
				    if(v.taskPriority == "긴급") {
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option>낮음</option>'
						code += '				<option>보통</option>'
						code += '				<option>높음</option>'
						code += '				<option selected>긴급</option>'
						code += '				</select></td>'
				    }else if(v.taskPriority == "높음"){
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option>낮음</option>'
						code += '				<option>보통</option>'
						code += '				<option selected>높음</option>'
						code += '				<option>긴급</option>'
						code += '				</select></td>'
				    }else if(v.taskPriority == "보통"){
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option>낮음</option>'
						code += '				<option selected>보통</option>'
						code += '				<option>높음</option>'
						code += '				<option>긴급</option>'
						code += '				</select></td>'
					}else if(v.taskPriority == "낮음"){
						code += '            	<td>'
						code += '				<select class="form-control me-auto taskPriority" name="taskPriority">'
						code += '				<option selected>낮음</option>'
						code += '				<option>보통</option>'
						code += '				<option>높음</option>'
						code += '				<option>긴급</option>'
						code += '				</select></td>'
					}
				    
		            code += '		<td><input type="text" class="form-control me-auto taskTtl" name="taskTtl" value="' + v.taskTtl + '" /></td>'
				    code += '       <td>'
				    code += '       	<select class="form-control me-auto pmemCd" name="pmemCds">'
						//담당자 받아오기
						$.ajax({
							url : "/task/modalPmemcd",
							type : "post",
							data : v.taskNo,
							async : false,
							contentType : "application/json;charset=utf-8",
							success : function(res2) {
								console.log(res2);
								$.each(res2, function(m, n) {
									if(v.profNm == n.PROF_NM) {
										code += '			<option value="' + n.PMEM_CD + '" selected>' + n.PROF_NM + '(' + n.MEM_NO + ')' + '</option>';
									}else {
										code += '			<option value="' + n.PMEM_CD + '">' + n.PROF_NM + '(' + n.MEM_NO + ')' + '</option>';
									}
								})
							}
						})
					    code += '       	</select>'
					    code += '       </td>'
					    
					    if(v.taskProgress == 100) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100" selected>100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 90) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90" selected>90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 80) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	   		<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80" selected>80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 70) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	   		<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70" selected>70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 60) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60" selected>60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
					    }else if(v.taskProgress == 50) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50" selected>50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						 }else if(v.taskProgress == 40) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40" selected>40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 30) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30" selected>30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 20) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20" selected>20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 10) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0">0%</option>'
							code += '	    	<option value="10" selected>10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	   		<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}else if(v.taskProgress == 0) {
						    code += '       <td>'
						    code += '       <select class="form-control me-auto taskProgress" name="taskProgresss">'
							code += '	    	<option value="0" selected>0%</option>'
							code += '	    	<option value="10">10%</option>'
							code += '	    	<option value="20">20%</option>'
							code += '	    	<option value="30">30%</option>'
							code += '	    	<option value="40">40%</option>'
							code += '	    	<option value="50">50%</option>'
							code += '	    	<option value="60">60%</option>'
							code += '	    	<option value="70">70%</option>'
							code += '	    	<option value="80">80%</option>'
							code += '	    	<option value="90">90%</option>'
							code += '	    	<option value="100">100%</option>'
							code += '	    </select>'
							code += '	    </td>'
						}
					    
				    if(v.taskStts == "신규") {
						code += '	    <td>'
						code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
						code += '	  		<option selected>신규</option>'
						code += '	   	 	<option>진행</option>'
						code += '	    	<option>완료</option>'
						code += '	    	</select>'
						code += '	    </td>'
				    }else if(v.taskStts == "진행") {
						code += '	    <td>'
						code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
						code += '	  		<option>신규</option>'
						code += '	   	 	<option selected>진행</option>'
						code += '	    	<option>완료</option>'
						code += '	    </select>'
						code += '	    </td>'
				    }else if(v.taskStts == "완료" || v.taskStts == "승인" || v.taskStts == "반려") {
				    	if(role == "R01") {
							code += '	    <td>'
							code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
							code += '	  		<option>완료</option>'
							code += '	  		<option>승인</option>'
							code += '	  		<option>반려</option>'
							code += '	    </select>'
							code += '	    </td>'
				    	}else {
							code += '	    <td>'
							code += '	    <select class="form-control me-auto taskStts" name="taskStts">'
							code += '	  		<option>신규</option>'
							code += '	  		<option>진행</option>'
							code += '	  		<option>완료</option>'
							code += '	    </select>'
							code += '	    </td>'
				    	}
					}
				    	v.taskSdy = v.taskSdy.substr(0,4) + "-" + (v.taskSdy.substr(5,2)) + "-" + v.taskSdy.substr(8,2);
						code += '<td><input type="date" value="' + v.taskSdy + '" class="form-control me-auto taskSdy" name="taskSdy" /></td>'
						v.taskEdy = v.taskEdy.substr(0,4) + "-" + (v.taskEdy.substr(5,2)) + "-" + v.taskEdy.substr(8,2);
						code += '<td><input type="date" value="' + v.taskEdy + '" class="form-control me-auto taskEdy" name="taskEdy" /></td>'
						code += '</tr>'
				})
				$("#modalTaskTbody").html(code);
			
			}
		})
	}
	
 }
 
 //카드 클릭 시 검색
 function isSort(type) {
	 //현재 카테고리
	 if(document.getElementById('up')) {		//해당 요소가 있다면 true
		 var keyword = $("#up").text();
	 }else {
		 keyword = "${pmemGrp}";
	 }
	 console.log("keyword : " + keyword);
	 
	 var data = {
				"pmemGrp" : keyword,
				"taskStts" : type
		 }
	 
		 $.ajax({
			 url : "/task/cardSort",
			 type : "post",
			 data : JSON.stringify(data),
			 contentType : "application/json;charset=utf-8",
			 success : function(res) {
				 console.log(res);
				 code = "";
				$.each(res, function(i,v) {
					    code += '    <tr>'
					    code += '        <th scope="row">' + v.taskNo + '</th>'
				    if(v.taskPriority == "긴급") {
						code += '            	<td><span class="badge badge-soft-danger">' + v.taskPriority + '</span></td>'
				    }else if(v.taskPriority == "높음") {
						code += '            	<td><span class="badge badge-soft-warning">' + v.taskPriority + '</span></td>'
				    }else {
						code += '            	<td><span class="badge badge-soft-success">' + v.taskPriority + '</span></td>'
				    }
			            code += '		<td><a href="/task/taskDetail/' + v.taskNo + '/${pmemGrp}" class="ttl">' + v.taskTtl + '</a></td>'
					    code += '       <td>' + v.profNm + '</td>'
				    if(v.taskProgress == 100 && v.taskStts == "완료") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else if(v.taskProgress == 100 && v.taskStts == "승인") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else if(v.taskProgress == 100 && v.taskStts == "반려") {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-danger" role="progressbar" style="width:' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }else {
						code += '	            <td>'
						code += '	                <div class="progress progress-sm">'
						code += '	                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-warning" role="progressbar" style="width: ' + v.taskProgress + '%" aria-valuenow="' + v.taskProgress + '" aria-valuemin="0" aria-valuemax="100"></div>'
						code += '	                </div>'
						code += '	            </td>'
				    }
				    if(v.taskStts == "완료") {
						code += '	            <td class="link-success">' + v.taskStts + '</td>'
				    }else if(v.taskStts == "승인") {
						code += '	            <td class="link-info">' + v.taskStts + '</td>'
				    }else if(v.taskStts == "반려") {
						code += '	            <td class="link-danger">' + v.taskStts + '</td>'
				    }else {
						code += '	            <td class="link-warning">' + v.taskStts + '</td>'
				    }
					    code += '        <td>' + v.taskEdy + '</td>'
			       		code += '	</tr>'
				})
				$("#taskTbody").html(code);
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

<div class="row">
    <div class="col">
        <div class="card card-animate">
            <div class="card-body" onclick="isSort('전체');">
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
            <div class="card-body" onclick="isSort('진행');">
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
            <div class="card-body" onclick="isSort('완료');">
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
            <div class="card-body" onclick="isSort('승인');">
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
            <div class="card-body" onclick="isSort('반려');">
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


<!--end row-->
<div class="row">
	<div class="w-100 h-100 col-xl-8">
	    <div class="card">
	        <div class="card-body">
             	<div class="col-xxl-auto">
                	<div>
						<div class="row g-4 mb-3">
                        	<div class="col-sm-auto">
                            	<div>
                            	<c:if test="${role == 'R01' and pmemGrp == '전체'}">
	                            	<div class="btn-group" >
										<button type="button" class="btn btn-light" onclick="category('${pmemGrp}');" id="up">${pmemGrp}</button>
									  	<button type="button" class="btn btn-light dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></button>
										<div class="dropdown-menu" style="cursor: pointer">
											<a class="dropdown-item" onclick="category('모두');" id="down">모두</a>
										</div>
									</div>
								</c:if>
                                <button type="button" class="btn btn-ghost-success" data-bs-toggle="modal" data-bs-target="#exampleModalScrollable">일괄 편집</button>
                            	<div class="btn-group">
	                            	<div class="col-lg">
	                            		<a href="/task/kanbanMain/${projId}/${pmemGrp}"><i class="ri-dashboard-line align-bottom me-2"></i> 칸반</a>
	                            		<a href="/gantt/ganttMain/${projId}/${pmemGrp}"><i class="ri-bar-chart-horizontal-fill align-bottom me-2"></i> 간트</a>
	                            	</div>
	                            </div>
                            	</div>
                            </div>
                            <div class="col-sm">
                            	<div class="d-flex justify-content-sm-end">
                                	<button type="button" class="btn btn-ghost-success waves-effect waves-light" id="newTask"><i class="ri-add-line align-bottom me-1"></i>새 일감</button>
                            	</div>
                           </div>
                        </div>
                        
		<!-- --------------------------------------------------------------- 일괄 편집 modal --------------------------------------------------------------- -->
        <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" id="exampleModalScrollableTitle">일감 일괄 편집</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                       <c:if test="${pmemGrp == '전체'}">
                       <div>
                           	<div class="btn-group" style="margin-left:1%;">
								<button type="button" class="btn btn-light"  onclick="modalCategory('${pmemGrp}');" id="upModal">${pmemGrp}</button>
							  	<button type="button" class="btn btn-light dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></button>
								<div class="dropdown-menu">
									<a class="dropdown-item" onclick="modalCategory('모두');" id="downModal">모두</a>
								</div>
							</div>
						</div>
						</c:if>
                    <div class="modal-body">
			   <!-- Tables Without Borders -->
				<form method="post" action="/task/updateAll" name="allEdit" id="allEdit">
					<table class="table table-borderless table-nowrap" id="modaltaskTable">
					    <thead>
					        <tr>
					            <th scope="col">일감번호(#)</th>
					            <th scope="col">우선순위</th>
					            <th scope="col">제목</th>
					            <th scope="col">담당자</th>
					            <th scope="col">진척도</th>
					            <th scope="col">상태</th>
					            <th scope="col">시작날짜</th>
					            <th scope="col">완료기한</th>
					        </tr>
					    </thead>
					    <tbody id="modalTaskTbody">
							<c:forEach items="${taskList}" var="list">
								<tr>
									<th scope="row" class="taskNo">
										<input type="hidden" value="${list.taskNo}" name="taskNo" />
										${list.taskNo}</th>
									<c:choose>
										<c:when test="${list.taskPriority =='긴급'}">
											<td>
												<select class="form-control me-auto taskPriority" name="taskPriority">
													<option>낮음</option>
													<option>보통</option>
													<option>높음</option>
													<option selected>긴급</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskPriority =='높음'}">
											<td>
												<select class="form-control me-auto taskPriority" name="taskPriority">
													<option>낮음</option>
													<option>보통</option>
													<option selected>높음</option>
													<option>긴급</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskPriority =='보통'}">
											<td>
												<select class="form-control me-auto taskPriority" name="taskPriority">
													<option>낮음</option>
													<option selected>보통</option>
													<option>높음</option>
													<option>긴급</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskPriority =='낮음'}">
											<td>
												<select class="form-control me-auto taskPriority" name="taskPriority">
													<option selected>낮음</option>
													<option>보통</option>
													<option>높음</option>
													<option>긴급</option>
												</select>
											</td>
										</c:when>
									</c:choose>
									<td><input type="text" class="form-control me-auto taskTtl" name="taskTtl" value="${list.taskTtl}" /></td>
									<td>
										<select class="form-control me-auto pmemCd" name="pmemCds">
											<c:forEach items="${memList}" var="mem">
													<c:if test="${list.profNm == mem.PROF_NM}">
														<option  value="${mem.PMEM_CD}" selected>
														${mem.PROF_NM}(${mem.MEM_NO})</option>
													</c:if>
													<c:if test="${list.profNm != mem.PROF_NM}">
														<option value="${mem.PMEM_CD}">${mem.PROF_NM}(${mem.MEM_NO})</option>
													</c:if>
											</c:forEach>
										</select>
									</td>
									<c:choose>
										<c:when test="${list.taskProgress == 100}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">
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
													<option value="100" selected>100%</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskProgress == 90}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30">30%</option>
													<option value="40">40%</option>
													<option value="50">50%</option>
													<option value="60">60%</option>
													<option value="70">70%</option>
													<option value="80">80%</option>
													<option value="90" selected>90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskProgress == 80}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30">30%</option>
													<option value="40">40%</option>
													<option value="50">50%</option>
													<option value="60">60%</option>
													<option value="70">70%</option>
													<option value="80" selected>80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskProgress == 70}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">				            		
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30">30%</option>
													<option value="40">40%</option>
													<option value="50">50%</option>
													<option value="60">60%</option>
													<option value="70" selected>70%</option>
													<option value="80">80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>												
										<c:when test="${list.taskProgress == 60}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">						            	
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30">30%</option>
													<option value="40">40%</option>
													<option value="50">50%</option>
													<option value="60" selected>60%</option>
													<option value="70">70%</option>
													<option value="80">80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>												
										<c:when test="${list.taskProgress == 50}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30">30%</option>
													<option value="40">40%</option>
													<option value="50" selected>50%</option>
													<option value="60">60%</option>
													<option value="70">70%</option>
													<option value="80">80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>												
										<c:when test="${list.taskProgress == 40}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">						            		
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30">30%</option>
													<option value="40" selected>40%</option>
													<option value="50">50%</option>
													<option value="60">60%</option>
													<option value="70">70%</option>
													<option value="80">80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>												
										<c:when test="${list.taskProgress == 30}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">						            		
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20">20%</option>
													<option value="30" selected>30%</option>
													<option value="40">40%</option>
													<option value="50">50%</option>
													<option value="60">60%</option>
													<option value="70">70%</option>
													<option value="80">80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>												
										<c:when test="${list.taskProgress == 20}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">						            		
													<option value="0">0%</option>
													<option value="10">10%</option>
													<option value="20" selected>20%</option>
													<option value="30">30%</option>
													<option value="40">40%</option>
													<option value="50">50%</option>
													<option value="60">60%</option>
													<option value="70">70%</option>
													<option value="80">80%</option>
													<option value="90">90%</option>
													<option value="100">100%</option>
												</select>
											</td>
										</c:when>												
										<c:when test="${list.taskProgress == 10}">
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">						            		
													<option value="0">0%</option>
													<option value="10" selected>10%</option>
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
											</td>
										</c:when>												
										<c:otherwise>
											<td>
												<select class="form-control me-auto taskProgress" name="taskProgresss">						            		
													<option value="0" selected>0%</option>
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
											</td>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${list.taskStts == '신규'}">
											<td>
												<select class="form-control me-auto taskStts" name="taskStts">
													<option selected>신규</option>
													<option>진행</option>
													<option>완료</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskStts =='진행'}">
											<td>
												<select class="form-control me-auto taskStts" name="taskStts">
													<option>신규</option>
													<option selected>진행</option>
													<option>완료</option>
												</select>
											</td>
										</c:when>
										<c:when test="${list.taskStts =='완료' or list.taskStts =='승인' or list.taskStts =='반려'}">
											<c:if test="${role == 'R01'}">
												<td>
													<select class="form-control me-auto taskStts" name="taskStts">
														<option>완료</option>
														<option>승인</option>
														<option>반려</option>
													</select>
												</td>
											</c:if>
											<c:if test="${role != 'R01'}">
												<td>
													<select class="form-control me-auto taskStts" name="taskStts">
														<option>신규</option>
														<option>진행</option>
														<option>완료</option>
													</select>
												</td>
											</c:if>
										</c:when>
									</c:choose>
									<fmt:parseDate value="${list.taskSdy}" pattern="yyyy.MM.dd" var="taskS" />
									<fmt:formatDate value="${taskS}" pattern="yyyy-MM-dd" var="realTs"/>
									<td><input type="date" value="${realTs}" class="form-control me-auto taskSdy" name="taskSdy" /></td>
									<fmt:parseDate value="${list.taskEdy}" pattern="yyyy.MM.dd" var="taskS" />
									<fmt:formatDate value="${taskS}" pattern="yyyy-MM-dd" var="realTe"/>
									<td><input type="date" value="${realTe}" class="form-control me-auto taskEdy" name="taskEdy" /></td>
								</tr>
							</c:forEach>
					    </tbody>
					</table>
				</form>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-outline-success" id="allEditBtn">변경사항 저장</button>
              </div>
              </div>
          </div>
      </div>
        <!-- ---------------------------------------------------------------일괄 편집 modal 끝--------------------------------------------------------------- -->
        
        </div>
		</div><!-- end card-body -->
	
			   <!-- Tables Without Borders -->
				<table class="table table-borderless table-nowrap" id="taskTable">
				    <thead>
				        <tr>
				            <th scope="col" style="width:250px;">일감번호(#)</th>
				            <th scope="col" style="width:250px;">우선순위</th>
				            <th scope="col" style="width:650px;">제목</th>
				            <th scope="col" style="width:200px;">담당자</th>
				            <th scope="col" style="width:150px;">진척도</th>
				            <th scope="col" style="width:200px;">상태</th>
				            <th scope="col" style="width:200px;">완료기한</th>
				        </tr>
				    </thead>
				    <tbody id="taskTbody">
				    	<c:forEach items="${taskList}" var="list" varStatus="stat">
							<tr>
								<th scope="row">${list.taskNo}</th>
								<c:choose>
									<c:when test="${list.taskPriority =='긴급'}">
										<td><span class="badge badge-soft-danger">${list.taskPriority}</span></td>
									</c:when>
									<c:when test="${list.taskPriority =='높음'}">
										<td><span class="badge badge-soft-warning">${list.taskPriority}</span></td>
									</c:when>
									<c:otherwise>
										<td><span class="badge badge-soft-success">${list.taskPriority}</span></td>
									</c:otherwise>
								</c:choose>
								<td><a href="/task/taskDetail/${list.taskNo}/${pmemGrp}" class="ttl">${list.taskTtl}</a></td>
								<td>${list.profNm}</td>
								<c:choose>
									<c:when test="${list.taskProgress == 100 and list.taskStts == '완료'}">
										<td>
											<div class="progress progress-sm">
												<div class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width:${list.taskProgress}%" aria-valuenow="${list.taskProgress}" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</td>
									</c:when>
									<c:when test="${list.taskProgress == 100 and list.taskStts == '승인'}">
										<td>
											<div class="progress progress-sm">
												<div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" style="width:${list.taskProgress}%" aria-valuenow="${list.taskProgress}" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</td>
									</c:when>
									<c:when test="${list.taskProgress == 100 and list.taskStts == '반려'}">
										<td>
											<div class="progress progress-sm">
												<div class="progress-bar progress-bar-striped progress-bar-animated bg-danger" role="progressbar" style="width:${list.taskProgress}%" aria-valuenow="${list.taskProgress}" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</td>
									</c:when>
									<c:otherwise>
										<td>
											<div class="progress progress-sm">
												<div class="progress-bar progress-bar-striped progress-bar-animated bg-warning" role="progressbar" style="width: ${list.taskProgress}%" aria-valuenow="${list.taskProgress}" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</td>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${list.taskStts == '완료'}">
										<td class="link-success">${list.taskStts}</td>
									</c:when>
									<c:when test="${list.taskStts == '승인'}">
										<td class="link-info">${list.taskStts}</td>
									</c:when>
									<c:when test="${list.taskStts == '반려'}">
										<td class="link-danger">${list.taskStts}</td>
									</c:when>
									<c:otherwise>
										<td class="link-warning">${list.taskStts}</td>
									</c:otherwise>
								</c:choose>
								<td>${list.taskEdy}</td>
							</tr>
						</c:forEach>
				    </tbody>
				</table>
				
			<c:if test="${!empty taskList}">
			<!-- pagination -->
			<div class="row g-0 text-center text-sm-start align-items-center mb-4">
            	<ul class="pagination pagination-separated justify-content-center justify-content-sm mb-sm-0" id="pageUl">
                	<li class="page-item <c:if test='${list.startPage<6 }'>disabled</c:if>" id="prevBtn">
                    	<a href="/task/taskMain/${projId}/${grp}?currentPage=${list.startPage-5 }" class="page-link">Previous</a>
                    </li>
				<c:forEach var="pNo" begin="${list.startPage }" end="${list.endPage }" step="1">
                    <li class="page-item <c:if test='${list.currentPage eq pNo}'>active</c:if>">
                        <a href="/task/taskMain/${projId}/${grp}?currentPage=${pNo }" class="page-link">${pNo}</a>
                    </li>
				</c:forEach>
                    <li class="page-item <c:if test='${list.endPage>=list.totalPages }'>disabled</c:if>" id="nextBtn">
                        <a href="/task/taskMain/${projId}/${grp}?currentPage=${list.startPage+5 }" class="page-link">Next</a>
                    </li>
                </ul>
            </div>
			</c:if>	
			</div>
		</div>
	</div>
</div>
