<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<script type="text/javascript">



function alertSend(idx){
 	let memNo = $('#memNo'+idx).val();
 	let altSend = $('#altSend'+idx).val();
 	var url ="/alert/alertSendList?memNo="+memNo+"&altSend="+altSend;
	$(location).attr("href",url);
	$('#h5send').text(altSend);
	$('#action'+idx).attr("class","active") //클릭한곳 div 녹색으로 바뀌기
	$('#alertCheck'+idx).css("display","none");
 	
// 	let data = {
// 			"memNo" : memNo,
// 			"altSend" : altSend
// 	};
	
// 	$.ajax({
// 		url: "/alert/alertList",
// 		contentType : "application/json;charset=utf-8",
// 		data : JSON.stringify(data),
// 		type : "post",
// 		success : function(result){
			
// 		}
// 	})
}
</script>

<style>
	.user-chat{
	 	background : url(../resources/image/채팅 배경화면.jpg);
	}
</style>

    <!-- start page title -->
  <div class="row">
      <div class="col-12">
          <div class="page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/mypage/myPageMain'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item"><a href="javascript: void(0);">마이페이지</a></li>
                      <li class="breadcrumb-item active">알림함</li>
                  </ol>
              </div>

          </div>
      </div>
  </div>
  <!-- end page title -->
  
  <c:forEach var="alertList" items="${alertVOList}" varStatus="stat">
  <input type="hidden" id="memNo${stat.index}" value="${alertList.memNo}" />
  <input type="hidden" id="altSend${stat.index}" value="${alertList.altSend}" />
  <div class="list-group">
   
    <a id="action${stat.index}" href="/alert/alertSendList?memNo=${alertList.memNo}&altSend=${alertList.altSend}" class="list-group-item list-group-item-action">
        <div class="float-end">
        	<fmt:formatDate pattern="yyyy.MM.dd" value="${alertList.altTm}" />
        </div>
        <div class="d-flex mb-2 align-items-center">
            <div class="flex-shrink-0">
            	<c:if test="${alertList.altSend=='ADMIN'}"><img alt="" src="/resources/image/관리자.png"  class="avatar-sm rounded-circle"></c:if>                     
                <c:if test="${alertList.altSend!='ADMIN'}"><img alt="${alertList.altPhoto}" src="/resources/image/${alertList.altPhoto}"  class="avatar-sm rounded-circle"></c:if>
            </div>
            <div class="flex-grow-1 ms-3">
                <h5 class="list-title fs-16 mb-1">
                	<c:if test="${alertList.altSend=='ADMIN'}">관리자</c:if>
                    <c:if test="${alertList.altSend!='ADMIN'}">${alertList.altSendNm}</c:if>
                    &emsp;<span id="alertCheck${stat.index}" class="badge bg-warning">${alertList.altCheck}</span>
                </h5>
                <p class="list-text mb-0 fs-13"></p>
            </div>
        </div>
        <p class="list-text mb-0">
        	${alertList.altCn}
        </p>
      </a>
</div>
</c:forEach>

