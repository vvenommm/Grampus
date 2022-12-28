<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>
<!-- <script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script> -->
<% String memNo =(String)session.getAttribute("memNo"); %>
    <!-- start page title -->
  <div class="row">
      <div class="col-12">
          <div class="page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/alert/alertList?memNo=<%=memNo%>'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item"><a href="javascript: void(0);">마이페이지</a></li>
                      <li class="breadcrumb-item active">알림함</li>
                      <li class="breadcrumb-item active">${alertSendVOList[0].altSendNm}</li>
                  </ol>
              </div>

          </div>
      </div>
  </div>
  <!-- end page title -->

<div class="user-chat w-100 overflow-hidden user-chat-show">
   <div class="chat-content d-lg-flex">
       <!-- start chat conversation section -->
       <div class="w-100 overflow-hidden position-relative">
           <!-- conversation user -->
           <div class="position-relative">
               <div class="p-3 user-chat-topbar">
                   <div class="row align-items-center">
                       <div class="col-sm-4 col-8">
                           <div class="d-flex align-items-center">
                               <div class="flex-shrink-0 d-block d-lg-none me-3">
                                   <a href="javascript: void(0);" class="user-chat-remove fs-18 p-1"><i class="ri-arrow-left-s-line align-bottom"></i></a>
                               </div>
                               <div class="flex-grow-1 overflow-hidden">
                                   <div class="d-flex align-items-center">
                                       <div class="flex-shrink-0 chat-user-img online user-own-img align-self-center me-3 ms-0">
                                       		<c:if test="${alertSendVOList[0].altSend=='ADMIN'}"><img alt="" src="/resources/image/관리자.png"  class="image avatar-xs rounded-circle"></c:if>                     
                                       		<c:if test="${alertSendVOList[0].altSend!='ADMIN'}"><img alt="${alertSendVOList[0].altPhoto}" src="/resources/image/${alertSendVOList[0].altPhoto}"  class="rounded-circle avatar-xs"></c:if>
                                           <span class="user-status"></span>
                                       </div>
                                       <div class="flex-grow-1 overflow-hidden">
                                           <h5 class="text-truncate mb-0 fs-16"><a class="text-reset username" data-bs-toggle="offcanvas" href="#userProfileCanvasExample" aria-controls="userProfileCanvasExample">${alertSendVOList[0].altSendNm}</a></h5>
                                           <p class="text-truncate text-muted mb-0 userStatus"><small class="fs-13">Online</small></p>
                                       </div>
                                   </div>
                               </div>
                           </div>
                       </div>
                   </div>
               </div>
               <!-- end chat user head -->

               <div class="position-relative" id="users-chat">
                   <div class="chat-conversation p-3 p-lg-4 " id="chat-conversation" data-simplebar="init"><div class="simplebar-wrapper" style="margin: -24px;"><div class="simplebar-height-auto-observer-wrapper"><div class="simplebar-height-auto-observer"></div></div><div class="simplebar-mask"><div class="simplebar-offset" style="right: 0px; bottom: 0px;"><div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content" style="height: 100%; overflow: hidden scroll;"><div class="simplebar-content" style="padding: 24px;">
                       <ul class="list-unstyled chat-conversation-list" id="users-conversation">
                       	  <c:forEach var="alertSendList" items="${alertSendVOList}" varStatus="stat">
                       	  <input type="hidden" id="altNo${stat.index}" value="${alertSendList.altNo}" />
                       	  <input type="hidden" id="altSend${stat.index}" value="${alertSendList.altSend}" />
                           <li class="chat-list left">
                               <div class="conversation-list">
                                   <div class="chat-avatar">
                                       <c:if test="${alertSendList.altSend=='ADMIN'}"><img alt="" src="/resources/image/관리자.png"  class="image avatar-xs rounded-circle"></c:if>                     
                                       <c:if test="${alertSendList.altSend!='ADMIN'}"><img alt="${alertSendList.altPhoto}" src="/resources/image/${alertSendList.altPhoto}"  class="image avatar-xs rounded-circle"></c:if>
                                   </div>
                                   <div class="user-chat-content">
                                       <div class="ctext-wrap">
                                           <div class="ctext-wrap-content">
                                               <p class="mb-0 ctext-content">${alertSendList.altCn}</p>
                                           </div>
                                           <div class="dropdown align-self-start message-box-drop">
                                               <a class="dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                   <i class="ri-more-2-fill"></i>
                                               </a>
                                               <div class="dropdown-menu">
                                                   <a class="dropdown-item delete-item" href="#" onclick="btnDel(${stat.index});"><i class="ri-delete-bin-5-line me-2 text-muted align-bottom"></i>Delete</a>
                                               </div>
                                           </div>
                                       </div>
                                       <div class="conversation-name"><small class="text-muted time"><fmt:formatDate pattern="yyyy.MM.dd" value="${alertSendList.altTm}"/></small> <span class="text-success check-message-icon"><i class="ri-check-double-line align-bottom"></i></span></div>
                                   </div>
                               </div>
                           </li>
                           <!-- chat-list -->
						  </c:forEach>
                       </ul>
                       <!-- end chat-conversation-list -->

                   </div></div></div></div><div class="simplebar-placeholder" style="width: auto; height: 658px;"></div></div><div class="simplebar-track simplebar-horizontal" style="visibility: hidden;"><div class="simplebar-scrollbar" style="width: 0px; display: none;"></div></div><div class="simplebar-track simplebar-vertical" style="visibility: visible;"><div class="simplebar-scrollbar" style="height: 476px; transform: translate3d(0px, 0px, 0px); display: block;"></div></div></div>
                   <div class="alert alert-warning alert-dismissible copyclipboard-alert px-4 fade show " id="copyClipBoard" role="alert" style="display: none;">
                       Message copied
                   </div>
               </div>

               <!-- end chat-conversation -->

                <div class="replyCard">
                    <div class="card mb-0">
                        <div class="card-body py-3">
                            <div class="replymessage-block mb-0 d-flex align-items-start">
                                <div class="flex-grow-1">
                                    <h5 class="conversation-name"></h5>
                                    <p class="mb-0"></p>
                                </div>
                                <div class="flex-shrink-0">
                                    <button type="button" id="close_toggle" class="btn btn-sm btn-link mt-n2 me-n3 fs-18">
                                        <i class="bx bx-x align-middle"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="live-preview">
    <div>
        <!-- staticBackdrop Modal -->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyb\oard="false" tabindex="-1" role="dialog" aria-hidden="false">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-body text-center p-5">
                        <lord-icon src="https://cdn.lordicon.com/lupuorrc.json" trigger="loop" colors="primary:#121331,secondary:#08a88a" style="width:120px;height:120px"></lord-icon>

                        <div class="mt-4">
                            <h3 class="mb-3">환영합니다!</h3>
                            <p class="text-muted mb-4" id="modalTtl"></p>
                            <div class="hstack gap-2 justify-content-center">
                                <a href="javascript:void(0);" class="btn btn-link link-secondary fw-medium" data-bs-dismiss="modal"><i class="ri-close-line me-1 align-middle"></i> Close</a>
                                <button id="visitProj" class="btn btn-success">프로젝트 방문하기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<script type="text/javascript">
	var projId = $("#okBtn").attr("data-projId");
	var invCd = $("#invCd").attr("data-invCd");
	var memNo = "${loginVO.memNo}";
	var memNm = "${loginVO.memNm}";
	var pmemGrp = $("#noBtn").attr("data-pmemGrp");
//초대장 수락 거절 버튼 이벤트
$('.okBtn').on('click', function(){
	var data = {"projId" : projId, "invCd" : invCd, "memNo" : memNo, "pmemGrp" : pmemGrp, "pmemRsvp" : 'Y', "memNm" : memNm};
	console.log(data);
	
	$.ajax({
		url : "/promem/RSVP",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		success : function(res){
			console.log(res);
			
			if(res.expire > 0){
				var ttl = $("#ttl").attr("data-ttl");
				var str = "이제 <" + ttl + ">의 일원이 되었습니다.</br>멤버들에게 이 소식을 알려주세요!";
				$('#modalTtl').html(str);
				
				$('#staticBackdrop').modal('show');
			}else{
				Swal.fire({
			        text: '초대장의 유효기간이 경과했습니다.',
			        icon: 'error',
			        confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
			        buttonsStyling: false
			  	})
			}
		}
	});
})

$('.noBtn').on('click', function(){
	var data = {"projId" : projId, "invCd" : invCd, "memNo" : memNo, "pmemGrp" : pmemGrp, "pmemRsvp" : 'N', "memNm" : memNm};
	
	Swal.fire({
		title : "한 번 거절하면 되돌릴 수 없습니다.",
        text: "거절하시겠습니까?",
        icon : 'question',
        showCancelButton: true,
        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
        buttonsStyling: false,
        showCloseButton: true
      }).then(function (result) {
        if (result.value) {
			$.ajax({
				url : "/promem/RSVP",
				contentType : "application/json;charset=utf-8",
				data : JSON.stringify(data),
				type : "post",
				success : function(res){
					console.log(res);
					
					if(res > 0){
						Swal.fire({
					        text: '거절하였습니다.',
					        icon: 'success',
					        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
					        buttonsStyling: false,
					        showCloseButton: true
					  	})
					}
				}
			});
        } else if (
	        // Read more about handling dismissals
            result.dismiss === Swal.DismissReason.cancel
          ){
            Swal.fire({
              text: '다시 한 번 시도해주세요.',
              icon: 'error',
              confirmButtonClass: 'btn btn-outline-danger mt-2',
              buttonsStyling: false
            })
        }  
    });
	
})

$('#visitProj').on('click', function(){
// 	var projId = document.getElementById('okBtn').dataset.projId;
// 	var pmemGrp = document.getElementById('okBtn').dataset.pmemGrp;
	location.href="/project/projMain/" + projId + '/' + pmemGrp;
})

function btnDel(idx){
	var altNo = $('#altNo'+idx).val();
	console.log("altNo : " + altNo)
	var altSend = $('#altSend'+idx).val();
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
        	$.ajax({
        		url:"/alert/alertDelete",
        		type: "post",
        		data:{"altNo":altNo},
        		success : function(res) {
        			location.href = "/alert/alertSendList?memNo=<%=memNo%>&altSend="+altSend;
        		}
        	});//ajax
        } 
    });

	
}
</script>