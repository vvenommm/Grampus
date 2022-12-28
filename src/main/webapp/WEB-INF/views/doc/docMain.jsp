<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%> 
    

<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<style>
 .ttl:hover { 
	font-weight : bold;
	color : black;
 }
</style>
<script type="text/javascript">
var projId = "${projId}";
var pmemGrp = "${grp}";

window.onload = function(){
	
	detail = function(docNo){
		var writer = event.currentTarget.dataset.cd; //pmemCd
		
// 		var writer = document.getElementById('writer').firstChild.data;
		
		address = "/doc/docDetail/" + docNo + "/" + writer;
		location.href = address;
	}

};

$(function() {
	$("#typeUp").on("click", function() {
		data = {
				"projId" : projId,
				"grp" : pmemGrp
		}
		$.ajax({
			url : "/doc/typeAll",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			success : function(res) {
				console.log(res);
				code = "";
				$.each(res, function(i,v) {
					if(v == null || v == '') {
		    			code += '<tr><td colspan=5 style="text-align:center;">문서가 존재하지 않습니다.</td></tr>';
					}else {
				        code += '<tr>'
				        code += '    <th scope="row">' + v.NO + '</th>'
				        code += '    <td><h5>'
				        if(v.TYPE == "제출") {
						    code += '        	<span class="badge badge-soft-warning">' + v.TYPE + '</span>'
				        }else if(v.TYPE == "양식") {
						    code += '        	<span class="badge badge-soft-success">' + v.TYPE + '</span>'
				        }else if(v.TYPE == "기타") {
						    code += '        	<span class="badge badge-soft-primary">' + v.TYPE + '</span>'
				        }
				        code += '    </h5></td>'
				        code += '    <td onclick="detail(' + v.NO + ')" data-cd="' + v.CD + '"><a href="#"><span style="cursor: pointer">' + v.TTL + '</span></a></td>'
				        code += '    <td class="writer" style="display:none;">' + v.CD + '</td>'
				        code += '    <td>' + v.NM + '</td>'
				        code += '    <td>' + v.DY1 + '</td>'
				        code += '</tr>'
					}
				})
				$("#docTbody").html(code);
			}
		})
	})
})

function docNew(){
	location.href="/doc/docNew";
}

function isSort(type) {
	$.ajax({
		url : "/doc/selectType",
		type : "post",
		data : type,
		contentType : "application/json;charset=utf-8",
		success : function(res) {
			console.log(res);
			code = "";
			$.each(res, function(i,v) {
				if(v == null || v == '') {
	    			code += '<tr><td colspan=5 style="text-align:center;">문서가 존재하지 않습니다.</td></tr>';
				}else {
			        code += '<tr>'
			        code += '    <th scope="row">' + v.DOC_NO + '</th>'
			        code += '    <td><h5>'
			        if(v.DOC_TYPE == "제출") {
					    code += '        	<span class="badge badge-soft-warning">' + v.DOC_TYPE + '</span>'
			        }else if(v.DOC_TYPE == "양식") {
					    code += '        	<span class="badge badge-soft-success">' + v.DOC_TYPE + '</span>'
			        }else if(v.DOC_TYPE == "기타") {
					    code += '        	<span class="badge badge-soft-primary">' + v.DOC_TYPE + '</span>'
			        }
			        code += '    </h5></td>'
			        code += '    <td onclick="detail(' + v.DOC_NO + ')" data-cd="' + v.PMEM_CD + '"><a href="#"><span style="cursor: pointer">' + v.DOC_TTL + '</span></a></td>'
			        code += '    <td class="writer" style="display:none;">' + v.PMEM_CD + '</td>'
			        code += '    <td>' + v.DOC_NM + '</td>'
			        code += '    <td>' + v.DOC_DY + '</td>'
			        code += '</tr>'
				}
			})
			$("#docTbody").html(code);
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
	<div class="w-100 h-100 col-xl-8">
	    <div class="card" style="height: 830px;">
	        <div class="card-body">
		        <div class="row g-4 mb-2">
					<div class="col-sm">
						<div class="d-flex justify-content-sm-end">
							<div class="d-flex justify-content-sm-end gap-2">
								<a id="docNew" onclick="docNew()" class="btn btn-ghost-secondary waves-effect waves-light"> <i
									class="ri-add-line align-bottom me-1"></i> 작성하기
								</a>
							</div>
						</div>
					</div>
				</div>
	            
				<!-- Tables Without Borders -->
				<table class="table table-borderless table-nowrap">
				    <thead>
				        <tr>
				            <th scope="col">번호</th>
   				            <th scope="col">
								<div class="btn-group">
								    <button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false"><span id="typeUp">유형</span></button>
								    <div class="dropdown-menu dropdownmenu-primary">
							        	<a class="dropdown-item" onclick="isSort('양식');">양식</a>
								        <a class="dropdown-item" onclick="isSort('제출');">제출</a>
								        <a class="dropdown-item" onclick="isSort('기타');">기타</a>
								    </div>
								</div>
				            </th>
				            <th scope="col">제목</th>
				            <th scope="col">작성자</th>
				            <th scope="col">작성일</th>
				        </tr>
				    </thead>
				    <tbody id="docTbody">
				    	<c:choose>
				    		<c:when test="${empty docList}">
				    			<td colspan=5 style="text-align:center;">문서가 존재하지 않습니다.</td>
				    		</c:when>
				    		<c:otherwise>
						    	<c:forEach var="doc" items="${docList}" varStatus="stat">
							        <tr>
							            <th scope="row">${doc.NO}</th>
							            <td><h5>
							            	<c:if test="${doc.TYPE eq '제출'}">
								            	<span class="badge badge-soft-warning">${doc.TYPE}</span>
							            	</c:if>
							            	<c:if test="${doc.TYPE eq '양식'}">
								            	<span class="badge badge-soft-success">${doc.TYPE}</span>
							            	</c:if>
							            	<c:if test="${doc.TYPE eq '기타'}">
								            	<span class="badge badge-soft-primary">${doc.TYPE}</span>
							            	</c:if>
							            </h5></td>
							            <td onclick="detail(${doc.NO})" data-cd="${doc.CD}" class="ttl"><a href="#"><span style="cursor: pointer">${doc.TTL}</span></a></td>
							            <td class="writer" style="display:none;">${doc.CD}</td>
							            <td>${doc.NM}</td>
							            <td>${doc.DY1}</td>
							            <td ><a onclick="detail(${doc.NO})" data-cd="${doc.CD}" class="link-info" style="cursor: pointer;">View More</a></td>
							        </tr>
						    	</c:forEach>
				    		</c:otherwise>
				    	</c:choose>
				    </tbody>
				</table>
				
	        </div><!-- end card-body -->
	    </div><!-- end card -->
	</div>
	<!--end col-->
</div>
