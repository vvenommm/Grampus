<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>

<script type="text/javascript">
	$(document).ready(function(){
		$('#selectProj').on('change',function(){
			if(this.value !==""){
				//selected 값 가져옴
				var optval = $(this).find(":selected").val();
				console.log("optval :" + optval);
				var form = $("#frm");
				form.submit();

			}//if
		})//onchange
		
	});
</script>
    <!-- start page title -->
  <div class="row">
      <div class="col-12">
          <div class="page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/main/myMain'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item">내 대시보드</li>
                      <li class="breadcrumb-item active">지난 일감</li>
                  </ol>
              </div>

          </div>
      </div>
  </div>
  <!-- end page title -->

<div class="col-md-3">

<div class="btn-group">

	<form action ="/task/endTaskList" method="get" id="frm">
	<input type="hidden" value="${memberVO.memNo}" name="memNo" />
    <select class="form-select btn-light" name="projId" id="selectProj" required="">
        <option selected="" disabled="" value="" >프로젝트 선택</option>
        	<option value="0">전체</option>
        	<c:forEach var="projList" items="${projVOList}">
	        <option value="${projList.projId}">${projList.projTtl}</option>
        	</c:forEach>
    </select>
    </form>
</div>
</div><br />
<div class="row">
	<div class="w-100 h-100 col-xl-8">
	    <div class="card">
	        <div class="card-body">
			   <!-- Tables Without Borders -->
				<table class="table table-borderless table-nowrap" id="taskTable">
				    <thead>
				        <tr>
				            <th scope="col">일감번호(#)</th>
				            <th scope="col">우선순위</th>
				            <th scope="col">제목</th>
				            <th scope="col">프로젝트명</th>
				            <th scope="col">진척도</th>
				            <th scope="col">상태</th>
				            <th scope="col">완료기한</th>
				        </tr>
				    </thead>
				    <tbody>
				    	<c:forEach items="${taskVOList}" var="list" varStatus="stat">
				        <tr id="tr${stat.index}" style="display:show;">
				            <th scope="row">${list.taskNo}</th>
				            <c:choose>
					            <c:when test="${list.taskPriority =='긴급'}">
					            	<td><span class="badge badge-soft-danger">${list.taskPriority}</span></td>
					            </c:when>
					            <c:otherwise>
					            	<td><span class="badge badge-soft-success">${list.taskPriority}</span></td>
					            </c:otherwise>
				            </c:choose>
				            <!-- /task/taskDetail/${list.taskNo}/${pmemGrp} -->
		            		<td><a href="/task/taskDetail/${list.taskNo}/${list.pmemGrp}?newProjId=${list.projId}">${list.taskTtl}</a></td>
				            <td >${list.projTtl}</td>
				            <c:choose>
				            	<c:when test="${list.taskProgress == 100}">
						            <td>
						                <div class="progress progress-sm">
						                    <div class="progress-bar bg-success" role="progressbar" style="width:${list.taskProgress}%" aria-valuenow="${list.taskProgress}" aria-valuemin="0" aria-valuemax="100"></div>
						                </div>
						            </td>
				            	</c:when>
				            	<c:otherwise>
						            <td>
						                <div class="progress progress-sm">
						                    <div class="progress-bar bg-warning" role="progressbar" style="width: ${list.taskProgress}%" aria-valuenow="${list.taskProgress}" aria-valuemin="0" aria-valuemax="100"></div>
						                </div>
						            </td>
				            	</c:otherwise>
				            </c:choose>
				            <c:choose>
				            	<c:when test="${list.taskStts == '완료' or list.taskStts == '승인'}">
						            <td class="link-success">${list.taskStts}</td>
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
		       			<div style="display:none" id="projTtl${stat.index}">${list.projTtl}</div>
				        </c:forEach>
				    </tbody>
				</table>
			</div>
		</div>
	</div>
</div>
								