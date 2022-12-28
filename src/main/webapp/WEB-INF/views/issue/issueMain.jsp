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
var code = "";
$(function() {
	//모달 이동되게
	$("#exampleModalScrollable").draggable();
	
	 //일괄 편집 완료 버튼
	 $(document).on("click", "#allEditBtn", function() {
		 var form = document.getElementById("allEdit");
		 form.submit();
	 		Swal.fire({
	            text: '수정 완료되었습니다.',
	            icon : 'success',
	            confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
	 })
	 
	 //종류 버튼 클릭 시 전체 종류 나오게
	 $("#typeUp").on("click", function() {
		 var up = "";
		 if(document.getElementById('up')) {		//해당 요소가 있다면 true
			 up = $("#up").text();
			 if(up == "전체") {
					$.ajax({
						url : "/issue/issueList2",
						type : "post",
						success : function(res) {
							code = "";
							$.each(res, function(i,v) {
						        code += '<tr>'
						        code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
						        if(v.ISSUE_TYPE == "결함") {
								    code += '        	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
						        }else if(v.ISSUE_TYPE == "개선") {
								    code += '        	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
						        }else if(v.ISSUE_TYPE == "인사") {
								    code += '        	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
						        }else {
								    code += '        	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE +'</span></td>'
						        }
					           	code += '	 <td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">'+ v.ISSUE_TTL +'</a></td>'
						        code += '    <td>' + v.PROF_NM + '</td>'
						        code += '    <td>' + v.ISSUE_STTS + '</td>'
						        code += '    <td>' + v.ISSUE_DY + '</td>'
					      		code += '</tr>'
							})
							$("#issueTbody").html(code);
						}
					})
				 }else {
						$.ajax({
							url : "/issue/issueList",
							type : "post",
							success : function(res) {
								code = "";
								$.each(res, function(i,v) {
							        code += '<tr>'
							        code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
							        if(v.ISSUE_TYPE == "결함") {
									    code += '        	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
							        }else if(v.ISSUE_TYPE == "개선") {
									    code += '        	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
							        }else if(v.ISSUE_TYPE == "인사") {
									    code += '        	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
							        }else {
									    code += '        	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE +'</span></td>'
							        }
						           	code += '	 <td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">'+ v.ISSUE_TTL +'</a></td>'
							        code += '    <td>' + v.PROF_NM + '</td>'
							        code += '    <td>' + v.ISSUE_STTS + '</td>'
							        code += '    <td>' + v.ISSUE_DY + '</td>'
						      		code += '</tr>'
								})
								$("#issueTbody").html(code);
							}
						})
				 }
		 }else {
			$.ajax({
				url : "/issue/issueList2",
				type : "post",
				success : function(res) {
					code = "";
					$.each(res, function(i,v) {
				        code += '<tr>'
				        code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
				        if(v.ISSUE_TYPE == "결함") {
						    code += '        	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
				        }else if(v.ISSUE_TYPE == "개선") {
						    code += '        	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
				        }else if(v.ISSUE_TYPE == "인사") {
						    code += '        	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
				        }else {
						    code += '        	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE +'</span></td>'
				        }
			           	code += '	 <td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">'+ v.ISSUE_TTL +'</a></td>'
				        code += '    <td>' + v.PROF_NM + '</td>'
				        code += '    <td>' + v.ISSUE_STTS + '</td>'
				        code += '    <td>' + v.ISSUE_DY + '</td>'
			      		code += '</tr>'
					})
					$("#issueTbody").html(code);
				}
			})
		 }

	 })
})
function category(keyword) {
	 //모두일 경우 모든 이슈 나오게
	if(keyword == '모두') {
		$("#up").text(keyword);
		$("#up").attr("onclick", "category('" + keyword + "')");
		$("#down").html('<i class="bx bx-subdirectory-right"></i> 전체');
		$("#down").attr("onclick", "category('전체')");
		
		$.ajax({
			url : "/issue/issueList",
			type : "post",
			success : function(res) {
				code = "";
				$.each(res, function(i,v) {
			        code += '<tr>'
			        code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
			        if(v.ISSUE_TYPE == "결함") {
					    code += '        	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
			        }else if(v.ISSUE_TYPE == "개선") {
					    code += '        	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
			        }else if(v.ISSUE_TYPE == "인사") {
					    code += '        	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
			        }else {
					    code += '        	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE +'</span></td>'
			        }
		           	code += '	 <td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">'+ v.ISSUE_TTL +'</a></td>'
			        code += '    <td>' + v.PROF_NM + '</td>'
			        code += '    <td>' + v.ISSUE_STTS + '</td>'
			        code += '    <td>' + v.ISSUE_DY + '</td>'
		      		code += '</tr>'
				})
				$("#issueTbody").html(code);
			}
		})
		
		//상단 각 상태별 일감 개수 바꾸기
		$.ajax({
			url : "/issue/issues",
			type : "post",
			success : function(res) {
				$("#improveCount").text(res.improveCount);
				$("#defectCount").text(res.defectCount);
				$("#personalCount").text(res.personalCount);
				$("#etcCount").text(res.etcCount);
			}
		})
	}
	if(keyword == '전체') {		
		//전체 클릭 시
		$("#down").text("모두");
		$("#down").attr("onclick", "category('모두')");
		$("#up").text('전체');
		$("#up").attr("onclick", "category('전체')");
		
		$.ajax({
			url : "/issue/issueList2",
			type : "post",
			success : function(res) {
				code = "";
				$.each(res, function(i,v) {
			        code += '<tr>'
			        code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
			        if(v.ISSUE_TYPE == "결함") {
					    code += '        	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
			        }else if(v.ISSUE_TYPE == "개선") {
					    code += '        	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
			        }else if(v.ISSUE_TYPE == "인사") {
					    code += '        	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
			        }else {
					    code += '        	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE +'</span></td>'
			        }
		           	code += '	 <td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">'+ v.ISSUE_TTL +'</a></td>'
			        code += '    <td>' + v.PROF_NM + '</td>'
			        code += '    <td>' + v.ISSUE_STTS + '</td>'
			        code += '    <td>' + v.ISSUE_DY + '</td>'
		      		code += '</tr>'
				})
				$("#issueTbody").html(code);
			}
		})
		
		//상단 각 상태별 일감 개수 바꾸기
		$.ajax({
			url : "/issue/issues2",
			type : "post",
			success : function(res) {
				console.log(res);
				$("#improveCount").text(res.improveCount);
				$("#defectCount").text(res.defectCount);
				$("#personalCount").text(res.personalCount);
				$("#etcCount").text(res.etcCount);
			}
		})
	}
}


//--------------------------------------------------------------------------------------------------------------------

//모달창 일괄편집-------------------------------------------------------------------------------------------------------
function modalCategory(keyword) {
	 //모두일 경우 모든 이슈 나오게
	if(keyword == '모두') {
		$("#upModal").text(keyword);
		$("#upModal").attr("onclick", "modalCategory('" + keyword + "')");
		$("#downModal").html('<i class="bx bx-subdirectory-right"></i> 전체');
		$("#downModal").attr("onclick", "modalCategory('전체')");
		
		$.ajax({
			url : "/issue/issueList",
			type : "post",
			success : function(res) {
				console.log("Rrrr: " + res);
				code = "";
				$.each(res, function(i,v) {
						code += '<tr>'
						code += '	<th scope="row" class="issueNo" name="issueNo">';
						code += '		<input type="hidden" value="' + v.ISSUE_NO + '" name="issueNo" />';
						code += v.ISSUE_NO + '</th>'
					if(v.ISSUE_TYPE == '결함') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option selected>결함</option>'
						code += '				<option>개선</option>'
						code += '				<option>인사</option>'
						code += '				<option>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}else if(v.ISSUE_TYPE == '개선') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option>결함</option>'
						code += '				<option selected>개선</option>'
						code += '				<option>인사</option>'
						code += '				<option>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}else if(v.ISSUE_TYPE == '인사') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option>결함</option>'
						code += '				<option>개선</option>'
						code += '				<option selected>인사</option>'
						code += '				<option>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}else if(v.ISSUE_TYPE == '기타') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option>결함</option>'
						code += '				<option>개선</option>'
						code += '				<option>인사</option>'
						code += '				<option selected>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}
					
						code += '<td><input type="text" class="form-control me-auto issueTtl" value="' + v.ISSUE_TTL + '" name="issueTtl" /></td>'
						code += '<td scope="row" class="pmemCd">'; 
						code += '<input type="hidden" value="' + v.PMEM_CD + '" name="pmemCds" />'
						code +=  v.PROF_NM + '</td>'
						code += '<td>'
    					code += '	<select class="form-control me-auto issueStts" name="issueStts">'
    					
    				if(v.ISSUE_STTS == '신규') {
    					code += '		<option selected>신규</option>'
    					code += '		<option>검토</option>'
    					code += '		<option>해결</option>'
    				}else if(v.ISSUE_STTS == '검토') {
    					code += '		<option>신규</option>'
       					code += '		<option selected>검토</option>'
       					code += '		<option>해결</option>'
        			}else if(v.ISSUE_STTS == '해결') {
    					code += '		<option>신규</option>'
       					code += '		<option>검토</option>'
       					code += '		<option selected>해결</option>'
            		}
            			code += '	</select>'				
            			code += '</td>'				
           				v.ISSUE_DY = v.ISSUE_DY.substr(0,4) + "-" + (v.ISSUE_DY.substr(5,2)) + "-" + v.ISSUE_DY.substr(8,2);
    					code += '<td><input type="date" value="' + v.ISSUE_DY + '" class="form-control me-auto issueDy" name="issueDy"/></td>'
    					code += '</tr>'
				})
				$("#modalIssueTbody").html(code);
			}
		})
	}
	 
	 
	if(keyword == '전체') {		
		//전체 클릭 시
		$("#downModal").text("모두");
		$("#downModal").attr("onclick", "modalCategory('모두')");
		$("#upModal").text('전체');
		$("#upModal").attr("onclick", "modalCategory('전체')");
		
		$.ajax({
			url : "/issue/issueList2",
			type : "post",
			success : function(res) {
				code = "";
				$.each(res, function(i,v) {
						code += '<tr>'
						code += '	<th scope="row" class="issueNo" name="issueNo">';
						code += '		<input type="hidden" value="' + v.ISSUE_NO + '" name="issueNo" />';
						code += v.ISSUE_NO + '</th>'
					if(v.ISSUE_TYPE == '결함') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option selected>결함</option>'
						code += '				<option>개선</option>'
						code += '				<option>인사</option>'
						code += '				<option>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}else if(v.ISSUE_TYPE == '개선') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option>결함</option>'
						code += '				<option selected>개선</option>'
						code += '				<option>인사</option>'
						code += '				<option>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}else if(v.ISSUE_TYPE == '인사') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option>결함</option>'
						code += '				<option>개선</option>'
						code += '				<option selected>인사</option>'
						code += '				<option>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}else if(v.ISSUE_TYPE == '기타') {
						code += '		<td>'
						code += '			<select class="form-control me-auto issueType" name="issueType">'
						code += '				<option>결함</option>'
						code += '				<option>개선</option>'
						code += '				<option>인사</option>'
						code += '				<option selected>기타</option>'
						code += '			</select>'
						code += '		</td>'
					}
					
						code += '<td><input type="text" class="form-control me-auto issueTtl" name="issueTtl" value="' + v.ISSUE_TTL + '" /></td>'
						code += '<td scope="row" class="pmemCd">';
						code += '	<input type="hidden" value="' + v.PMEM_CD + '" name="pmemCds" />';
						code += v.PROF_NM + '</td>'
						code += '<td>'
    					code += '	<select class="form-control me-auto issueStts" name="issueStts">'
    					
    				if(v.ISSUE_STTS == '신규') {
    					code += '		<option selected>신규</option>'
    					code += '		<option>검토</option>'
    					code += '		<option>해결</option>'
    				}else if(v.ISSUE_STTS == '검토') {
    					code += '		<option>신규</option>'
       					code += '		<option selected>검토</option>'
       					code += '		<option>해결</option>'
        			}else if(v.ISSUE_STTS == '해결') {
    					code += '		<option>신규</option>'
       					code += '		<option>검토</option>'
       					code += '		<option selected>해결</option>'
            		}
            			code += '	</select>'				
            			code += '</td>'				
           				v.ISSUE_DY = v.ISSUE_DY.substr(0,4) + "-" + (v.ISSUE_DY.substr(5,2)) + "-" + v.ISSUE_DY.substr(8,2); 
    					code += '<td><input type="date" value="' + v.ISSUE_DY + '" class="form-control me-auto issueDy" name="issueDy" /></td>'
    					code += '</tr>'
				})
				$("#modalIssueTbody").html(code);
			}
		})
		
	}
}


//이슈 종류별 정렬
function isSort(type) {
	var pmemGrp = "${pmemGrp}";	
	var up = "";				//전체,모두 중 현재 카테고리
	
	 //현재 카테고리
	 if(document.getElementById('up')) {		//해당 요소가 있다면 true
		 up = $("#up").text();
		 if(up == "전체") {
				$.ajax({
					url  : "/issue/isSortGrp",
					type : "post",
					data : type,
					contentType : "application/json;charset=utf-8",
					success : function(res) {
						code = "";
						$.each(res, function(i,v) {
							code += '<tr>'
							code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
							if(v.ISSUE_TYPE == "결함") {
								code += '	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
							}else if(v.ISSUE_TYPE == "개선") {
								code += '	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
							}else if(v.ISSUE_TYPE == "인사") {
								code += '	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
							}else {
								code += '	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE + '</span></td>'
							}				
							code += '		<td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">' + v.ISSUE_TTL + '</a></td>'
							code += '   <td>' + v.PROF_NM + '</td>'
							code += '   <td>' + v.ISSUE_STTS + '</td>'
							code += '   <td>' + v.ISSUE_DY + '</td>'
							code += '</tr>'
						})
						$("#issueTbody").html(code);
					}
				})
		 }else {
				$.ajax({
					url  : "/issue/isSortAll",
					type : "post",
					data : type,
					contentType : "application/json;charset=utf-8",
					success : function(res) {
						code = "";
						$.each(res, function(i,v) {
							code += '<tr>'
							code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
							if(v.ISSUE_TYPE == "결함") {
								code += '	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
							}else if(v.ISSUE_TYPE == "개선") {
								code += '	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
							}else if(v.ISSUE_TYPE == "인사") {
								code += '	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
							}else {
								code += '	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE + '</span></td>'
							}				
							code += '		<td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">' + v.ISSUE_TTL + '</a></td>'
							code += '   <td>' + v.PROF_NM + '</td>'
							code += '   <td>' + v.ISSUE_STTS + '</td>'
							code += '   <td>' + v.ISSUE_DY + '</td>'
							code += '</tr>'
						})
						$("#issueTbody").html(code);
					}
				})
			}
	 }else {
		 up = "${pmemGrp}";
		$.ajax({
			url  : "/issue/isSortGrp",
			type : "post",
			data : type,
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				code = "";
				$.each(res, function(i,v) {
					code += '<tr>'
					code += '    <th scope="row">' + v.ISSUE_NO + '</th>'
					if(v.ISSUE_TYPE == "결함") {
						code += '	<td><span class="badge badge-soft-danger">' + v.ISSUE_TYPE + '</span></td>'
					}else if(v.ISSUE_TYPE == "개선") {
						code += '	<td><span class="badge badge-soft-warning">' + v.ISSUE_TYPE + '</span></td>'
					}else if(v.ISSUE_TYPE == "인사") {
						code += '	<td><span class="badge badge-soft-success">' + v.ISSUE_TYPE + '</span></td>'
					}else {
						code += '	<td><span class="badge badge-soft-primary">' + v.ISSUE_TYPE + '</span></td>'
					}				
					code += '		<td><a href="/issue/issueDetail/' + v.ISSUE_NO + '/${pmemGrp}" class="ttl">' + v.ISSUE_TTL + '</a></td>'
					code += '   <td>' + v.PROF_NM + '</td>'
					code += '   <td>' + v.ISSUE_STTS + '</td>'
					code += '   <td>' + v.ISSUE_DY + '</td>'
					code += '</tr>'
				})
				$("#issueTbody").html(code);
			}
		})
	 }

	
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
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/issue/issueMain/${projVO.id}/${projVO.grp}'" style="cursor: pointer">이슈</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->
 
	<h6 class="text-uppercase fw-semibold mt-4 mb-3 text-muted" style="margin-left:100px;">Total :</h6>
	<div class="hstack gap-2" style="margin-left:100px;">
		<div class="col-xxl-3 col-sm-6">
			<div class="mini-stats-wid d-flex align-items-center mt-3">
			    <div class="flex-shrink-0 avatar-sm">
			    	<a onclick="isSort('개선');" style="cursor:pointer;">
				        <span class="mini-stat-icon avatar-title rounded-circle text-danger bg-soft-danger fs-4" id="improveCount">
				            ${improveCount}
				        </span>
			        </a>
			    </div>
			    <div class="flex-grow-1 ms-3">
			        <h6 class="mb-1">개선</h6>
			        <p class="text-muted mb-0">더 나은 기능 구현이 필요한 상태 </p>
			    </div>
			</div><!-- end -->
		</div>
		<div class="col-xxl-3 col-sm-6">
			<div class="mini-stats-wid d-flex align-items-center mt-3">
			    <div class="flex-shrink-0 avatar-sm">
			    	<a onclick="isSort('결함');" style="cursor:pointer;">
				        <span class="mini-stat-icon avatar-title rounded-circle text-danger bg-soft-danger fs-4" id="defectCount">
				            ${defectCount}
				        </span>
			        </a>
			    </div>
			    <div class="flex-grow-1 ms-3">
			        <h6 class="mb-1">결함</h6>
			        <p class="text-muted mb-0">기능적 이슈</p>
			    </div>
			</div><!-- end -->
		</div>
		<div class="col-xxl-3 col-sm-6">
			<div class="mini-stats-wid d-flex align-items-center mt-3">
			    <div class="flex-shrink-0 avatar-sm">
			    	<a onclick="isSort('인사');" style="cursor:pointer;">
				        <span class="mini-stat-icon avatar-title rounded-circle text-danger bg-soft-danger fs-4" id="personalCount">
				            ${personalCount}
				        </span>
			        </a>
			    </div>
			    <div class="flex-grow-1 ms-3">
			        <h6 class="mb-1">인사</h6>
			        <p class="text-muted mb-0">직원과 관련된 행정적 이슈</p>
			    </div>
			</div><!-- end -->
		</div>
		<div class="col-xxl-3 col-sm-6">
			<div class="mini-stats-wid d-flex align-items-center mt-3">
			    <div class="flex-shrink-0 avatar-sm">
			    	<a onclick="isSort('기타');" style="cursor:pointer;">
				        <span class="mini-stat-icon avatar-title rounded-circle text-danger bg-soft-danger fs-4" id="etcCount">
				            ${etcCount}
				        </span>
				    </a>
			    </div>
			    <div class="flex-grow-1 ms-3">
			        <h6 class="mb-1">기타</h6>
			        <p class="text-muted mb-0">그 외 이슈</p>
			    </div>
			</div><!-- end -->
		</div>
	</div><br /><br />

<div class="row">
	<div class="w-100 h-100 col-xl-8">
	    <div class="card">
	        <div class="card-body">
	        	<div class="row g-4 mb-3">
                	<div class="col-sm-auto">
            	       	<div>
                           	<c:if test="${role == 'R01' and pmemGrp == '전체'}">
                            	<div class="btn-group">
									<button type="button" class="btn btn-light" onclick="category('${pmemGrp}');" id="up">${pmemGrp}</button>
								  	<button type="button" class="btn btn-light dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></button>
									<div class="dropdown-menu">
										<a class="dropdown-item" onclick="category('모두');" id="down">모두</a>
									</div>
								</div>
							</c:if>
                            <button type="button" class="btn btn-ghost-danger" data-bs-toggle="modal" data-bs-target="#exampleModalScrollable">일괄 편집</button>
                       </div>
                   </div>
                   <div class="col-sm">
                   		<div class="d-flex justify-content-sm-end">
                     		<button type="button" class="btn btn-ghost-danger waves-effect waves-light" id="newIssue"><i class="ri-add-line align-bottom me-1"></i>새 이슈</button>
                 		</div>
                   </div>
                </div>
                
			
			
			  <!-- -----------------------------------------------메인 테이블----------------------------------------------- -->
				<table class="table table-borderless table-nowrap" id="taskTable">
				    <thead>
				        <tr>
				            <th scope="col" style="width:200px;">이슈번호(#)</th>
				            <th scope="col" style="width:180px;">
								<div class="btn-group">
								    <button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false"><span id="typeUp">종류</span></button>
								    <div class="dropdown-menu dropdownmenu-primary">
							        	<a class="dropdown-item" onclick="isSort('개선');">개선</a>
								        <a class="dropdown-item" onclick="isSort('결함');">결함</a>
								        <a class="dropdown-item" onclick="isSort('인사');">인사</a>
								        <a class="dropdown-item" onclick="isSort('기타');">기타</a>
								    </div>
								</div>
				            </th>
				            <th scope="col" style="width:500px;">제목</th>
				            <th scope="col">작성자</th>
				            <th scope="col" style="width:180px;">상태</th>
				            <th scope="col" style="width:150px;">발생일</th>
				        </tr>
				    </thead>
				    <tbody id="issueTbody">
				    	<c:forEach items="${issueList}" var="list" varStatus="stat">
				        <tr>
				            <th scope="row">${list.ISSUE_NO}</th>
				            <c:choose>
					            <c:when test="${list.ISSUE_TYPE =='결함'}">
					            	<td><span class="badge badge-soft-danger">${list.ISSUE_TYPE}</span></td>
					            </c:when>
					            <c:when test="${list.ISSUE_TYPE =='개선'}">
					            	<td><span class="badge badge-soft-warning">${list.ISSUE_TYPE}</span></td>
					            </c:when>
					            <c:when test="${list.ISSUE_TYPE =='인사'}">
					            	<td><span class="badge badge-soft-success">${list.ISSUE_TYPE}</span></td>
					            </c:when>
					            <c:otherwise>
					            	<td><span class="badge badge-soft-primary">${list.ISSUE_TYPE}</span></td>
					            </c:otherwise>
				            </c:choose>
			           		<td><a href="/issue/issueDetail/${list.ISSUE_NO}/${pmemGrp}" class="ttl">${list.ISSUE_TTL}</a></td>
				            <td>${list.PROF_NM}</td>
		            		<td>${list.ISSUE_STTS}</td>
				            <td>${list.ISSUE_DY}</td>
			      		</tr>
				        </c:forEach>
				    </tbody>
				</table>
			</div>
		</div>
	</div>
</div>

			<!-- ------------------------------------------------------------------------일괄편집 모달------------------------------------------------------------------------ -->
	        <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
	            <div class="modal-dialog modal-dialog-scrollable modal-xl">
	                <div class="modal-content">
	                    <div class="modal-header">
	                        <h5 class="modal-title fw-bold" id="exampleModalScrollableTitle">이슈 일괄 편집</h5>
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
                    	<form method="post" action="/issue/updateAll" name="allEdit" id="allEdit">
                    		<table class="table table-borderless table-nowrap" id="modalIssueTable">
                    			<thead>
                    				<tr>
                    					<th scope="col">이슈번호(#)</th>
                    					<th scope="col">종류</th>
                    					<th scope="col">제목</th>
                    					<th scope="col">작성자</th>
                    					<th scope="col">상태</th>
                    					<th scope="col">발생일</th>
                    				</tr>
                    			</thead>
                    			<tbody id="modalIssueTbody">
                    				<c:forEach items="${issueList}" var="list">
                    				<tr>
                    					<th scope="row" class="issueNo">
                    					<input type="hidden" value="${list.ISSUE_NO}" name="issueNo" />
                    					${list.ISSUE_NO}</th>
                    					<c:choose>
                    						<c:when test="${list.ISSUE_TYPE == '결함'}">
                    							<td>
                    								<select class="form-control me-auto issueType" name="issueType">
                    									<option selected>결함</option>
                    									<option>개선</option>
                    									<option>인사</option>
                    									<option>기타</option>
                    								</select>
                    							</td>
                    						</c:when>
                    						<c:when test="${list.ISSUE_TYPE == '개선'}">
                    							<td>
                    								<select class="form-control me-auto issueType" name="issueType">
                    									<option>결함</option>
                    									<option selected>개선</option>
                    									<option>인사</option>
                    									<option>기타</option>
                    								</select>
                    							</td>
                    						</c:when>
                    						<c:when test="${list.ISSUE_TYPE == '인사'}">
                    							<td>
                    								<select class="form-control me-auto issueType" name="issueType">
                    									<option>결함</option>
                    									<option>개선</option>
                    									<option selected>인사</option>
                    									<option>기타</option>
                    								</select>
                    							</td>
                    						</c:when>
                    						<c:when test="${list.ISSUE_TYPE == '기타'}">
                    							<td>
                    								<select class="form-control me-auto issueType" name="issueType">
                    									<option>결함</option>
                    									<option>개선</option>
                    									<option>인사</option>
                    									<option selected>기타</option>
                    								</select>
                    							</td>
                    						</c:when>
                    					</c:choose>
                    					<td><input type="text" class="form-control me-auto issueTtl" value="${list.ISSUE_TTL}" name="issueTtl" /></td>
                    					<td scope="row" class="pmemCd">
										<input type="hidden" value="${list.PMEM_CD}" name="pmemCds" />
                    					${list.PROF_NM}</td>
                    					<td>
                    						<select class="form-control me-auto issueStts" name="issueStts">
                    						<c:choose>
                    							<c:when test="${list.ISSUE_STTS == '신규'}">
		                    							<option selected>신규</option>
		                    							<option>검토</option>
		                    							<option>해결</option>
                    							</c:when>
                    							<c:when test="${list.ISSUE_STTS == '검토'}">
		                    							<option>신규</option>
		                    							<option selected>검토</option>
		                    							<option>해결</option>
			                    				</c:when>
			                    				<c:when test="${list.ISSUE_STTS == '해결'}">
		                    							<option>신규</option>
		                    							<option>검토</option>
		                    							<option selected>해결</option>
			                    				</c:when>
                    						</c:choose>
                    						</select>
                    					</td>
                    					<fmt:parseDate value="${list.ISSUE_DY}" pattern="yyyy.MM.dd" var="issueD" />
										<fmt:formatDate value="${issueD}" pattern="yyyy-MM-dd" var="realId"/>
                    					<td><input type="date" value="${realId}" class="form-control me-auto issueDy" name="issueDy" /></td>
                   					</tr>
                    				</c:forEach>
                    			</tbody>
                    		</table>
                    	</form>
                   </div>
                  <div class="modal-footer">
                      <button type="button" class="btn btn-outline-success" id="allEditBtn">변경사항 저장</button>
                  </div>
              </div><!-- /.modal-content -->
          </div><!-- /.modal-dialog -->
      </div><!-- /.modal -->
      
      
<script type="text/javascript">
 $(function() {
	 //일감 등록
	 $("#newIssue").on("click", function() {
		 location.href="/issue/newIssue/${projId}/${pmemGrp}";
	 })
	 
 })
</script>