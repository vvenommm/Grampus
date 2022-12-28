<%@page import="kr.or.ddit.vo.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@mdi/font@5.x/css/materialdesignicons.min.css" rel="stylesheet">
<link href="resources/css/icons.min.css" rel="stylesheet">	
<!-- boxicon css -->
<link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
<!-- boxicon cdn -->
<script src="https://unpkg.com/boxicons@2.1.4/dist/boxicons.js"></script>
<!-- 나눔스퀘어 폰트  -->
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
<script src="/resources/js/jquery-3.6.0.js"></script>

<style>
	header{
 		font-family: 'NanumSquare'; 
	}
	#alertDiv {
		width: 20%;
	    position: fixed;
	    left: 60%;
	    top: 10%;
	    transform: translate(100%, 0);
	    overflow: hidden;
	    opacity: 0;
	    visibility: hidden;
	    transition: opacity .5s, visibility .5s, transform .5s;
	    z-index: 10000;
	}
	#alertDiv.alertShow {
	    opacity: 1;
	    visibility: visible;
	    transform: translate(90%, 0)
	}
	#allAlert:hover{
		cursor:pointer;
	}
</style>



 

<%
String memNo =(String)session.getAttribute("memNo"); %>

<script>

	var oldCount = 0;
	var dbCount = 0;
	
/////////////////////////////
/* 처음 페이지 실행시 알림 가져오기 */
	$.ajax({
		url:"/alert/alertCount",
		type:"post",
		data:{"memNo":"<%= memNo %>"},
		success:function(res){
			dbCount = res;
			if(oldCount < dbCount){
				var divcnt = dbCount-oldCount;
				var sdt = {"memNo":"<%= memNo %>","divcnt":divcnt};
				$.ajax({
					url: "/alert/alertSelect",
					type: "post",
					dataType: 'json',
					data:JSON.stringify(sdt),
					contentType:"application/json; charset=utf-8",
					success : function(data){
						var code = "";
						$.each(data,function(i,v){
							var date = new Date(v.ALT_TM);
							var gminutes = date.getMinutes();
							if(gminutes.toString().length == 1){
								gminutes = "0"+gminutes;
							}
							var altdate = date.getFullYear()+"년 "+(date.getMonth()+1)+"월 "+date.getDate()+"일 "+date.getHours()+":"+gminutes;
							if(v.ALT_CN.toString().substring(0,21) == "<p id='ttl' data-ttl="){
								v.ALT_CN = v.ALT_CN.toString().substring(0,v.ALT_CN.indexOf("보냈습니다.</p>")+10);
							}
							code += "<div class='text-reset notification-item d-block dropdown-item position-relative alertNum' name='"+v.ALT_NO+"' id='"+v.ALT_LINK+"'>";
                            code += "<div class='d-flex'>";
                            code += "<div class='flex-1'>";
                            code += "<a class='stretched-link removeClick'>";
                            code += "<h6 class='mt-0 mb-2 lh-base'>"+v.ALT_CN+"</h6>";
                            code += "</a>";
                            code += "<p class='mb-0 fs-11 fw-medium text-uppercase text-muted'>";
                            code += "<span>"+v.MEM_NM+"</span>";
                            code += "</p>";
                            code += "<p class='mb-0 fs-11 fw-medium text-uppercase text-muted'>";
                            code += "<span><i class='mdi mdi-clock-outline'></i> "+altdate+"</span>";
                            code += "</p>";
                            code += "</div>";
                            code += "</div>";
                        	code += "</div>";
						});
						$(".alertArea").prepend(code);
					},
				});
				oldCount = res;
			}
		}
	});
	
//////////////////////
/* db에 새로운 알림이 있는지 확인하여 알림 가져오기 */
	setInterval(function () {
		$.ajax({
			url:"/alert/alertCount",
			type:"post",
			data:{"memNo":"<%= memNo %>"},
			success:function(res){
				dbCount = res;
				if(oldCount < dbCount){
					var divcnt = dbCount-oldCount;
					var sdt = {"memNo":"<%= memNo %>","divcnt":divcnt};
					$.ajax({
						url: "/alert/alertSelect",
						type: "post",
						dataType: 'json',
						data:JSON.stringify(sdt),
						contentType:"application/json; charset=utf-8",
						success : function(data){
							var removeAlert;
							var code = "";
							var alertcode = "";
							console.log(data)
							$.each(data,function(i,v){
								var date = new Date(v.ALT_TM);
								var gminutes = date.getMinutes();
								if(gminutes.toString().length == 1){
									gminutes = "0"+gminutes;
								}
								var altdate = date.getFullYear()+"년 "+(date.getMonth()+1)+"월 "+date.getDate()+"일 "+date.getHours()+":"+gminutes;
								if(v.ALT_CN.toString().substring(0,21) == "<p id='ttl' data-ttl="){
									v.ALT_CN = v.ALT_CN.toString().substring(0,v.ALT_CN.indexOf("보냈습니다.</p>")+10);
								}
								code += "<div class='text-reset notification-item d-block dropdown-item position-relative alertNum' name='"+v.ALT_NO+"' id='"+v.ALT_LINK+"'>";
                                code += "<div class='d-flex'>";
                                code += "<div class='flex-1'>";
                                code += "<a class='stretched-link removeClick'>";
                                code += "<h6 class='mt-0 mb-2 lh-base'>"+v.ALT_CN+"</h6>";
                                code += "</a>";
                                code += "<p class='mb-0 fs-11 fw-medium text-uppercase text-muted'>";
                                code += "<span>"+v.MEM_NM+"</span>";
                                code += "</p>";
                                code += "<p class='mb-0 fs-11 fw-medium text-uppercase text-muted'>";
                                code += "<span><i class='mdi mdi-clock-outline'></i> "+altdate+"</span>";
                                code += "</p>";
                                code += "</div>";
                                code += "</div>";
                            	code += "</div>";
                            	
                            	alertcode += "<div class='alert alert-primary alert-border-left alert-dismissible fade show' role='alert'>"+v.ALT_CN+"</div>";
                            	
							});
							$(".alertArea").prepend(code);
							
							/* 사라지는 알림 */
							$("#alertDiv").addClass("alertShow");
                   			$("#alertDiv").append(alertcode);	
                   			if($("#alertDiv").hasClass("alertShow")){
                   				clearTimeout(removeAlert);
                   				removeAlert = setTimeout(function () {
                   					$("#alertDiv").removeClass("alertShow");
                   		        }, 4000);
                   			}else{
                   				removeAlert = setTimeout(function () {
                   					$("#alertDiv").removeClass("alertShow");
                   		        }, 4000);
                   			}
                   			if($("#alertDiv").children().length > 10){
                   				var lengthVal = $("#alertDiv").children().length-10;
                   				for(i=0; i<lengthVal; i++){
                   					$("#alertDiv").find(".alert").eq(0).remove();
                   				}
                   			}
                   			setTimeout(function () {
                   				$("#alertDiv").children().remove();
                   			}, 8000);
						},
					});
					oldCount = res;
				}
			}
		});	
	}, 3000);

////////////////////////
	/* 알림 클릭시 확인상태 변경 후 제거 */
		$(document).on("click",".alertNum",function(){
			var altcard = $(this)
			var altNo = $(this).attr("name");
			var altLink = $(this).attr("id");
			$.ajax({
				url: "/alert/alertCheck",
				type: "post",
				data:{"altNo":altNo},
				success : function(data){
					if(data > 0){
						if(altLink.length){
							location.href = altLink;
							altcard.remove();
						}else{
							altcard.remove();
						}
					}
				},
			});
		});

//////////////////////
/* 확인 하지 않은 알림 개수 표시 */
	setInterval(function () {
		var chCnt = $(".alertArea").children().length;
		$(".noRead, .newCnt").text(chCnt);
		if(chCnt == 0){
			$(".noRead").hide();
		}else{
			$(".noRead").show();
		}
	}, 500);
	
$(function(){	
////////////////////////
/* 전체 알림보기 이동 */
	$("#allAlert").on("click",function(){
		location.href="/alert/alertList?memNo=<%= memNo %>";
	});

});

</script>

<header id="page-topbar" style="left:0px;">
    <div class="layout-width">
        <div class="navbar-header">
            <div class="d-flex">
                <!-- LOGO -->
                <div class="navbar-brand-box horizontal-logo">
                    <a href="/main" class="logo logo-dark">
                        <span class="logo-lg">
                            <img src="/resources/image/grampusLogo.png" alt="" height="35">
                        </span>
                    </a>

                    <a href="/main" class="logo logo-light">
                        <span class="logo-lg">
                            <img src="/resources/image/grampusLogo.png" alt="" height="35">
                        </span>
                    </a>
                </div>

                <!-- App Search-->
                <!-- 해당 링크 넣기  -->
                <button type="button" class="btn btn-ghost-primary waves-effect" onclick="location.href='/newsList'">NEWS</button>
                <button type="button" class="btn btn-ghost-primary waves-effect" onclick="location.href='/jobList'">프로젝트 공고</button>
                <button type="button" class="btn btn-ghost-primary waves-effect" onclick="location.href='/plan'">플랜</button>
                <button type="button" class="btn btn-ghost-primary waves-effect" onclick="location.href='/faqList'">고객센터</button>
                
            </div>
            
            <!-- 로그인 한 사람만 보이도록 출력 -->
            <c:if test="${!empty id}">
            <div class="d-flex align-items-center">

                <div class="dropdown d-md-none topbar-head-dropdown header-item">
                    <button type="button" class="btn btn-icon btn-topbar btn-ghost-primary rounded-circle" id="page-header-search-dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="bx bx-search fs-22"></i>
                    </button>
                    <div class="dropdown-menu dropdown-menu-lg dropdown-menu-end p-0" aria-labelledby="page-header-search-dropdown">
                        <form class="p-3">
                            <div class="form-group m-0">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Search ..." aria-label="Recipient's username">
                                    <button class="btn btn-primary" type="submit"><i class="mdi mdi-magnify"></i></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
<!-- 				내 대시보드 가기 -->
                <!-- 로그인 한 사람만 보이는 아이콘 -->
                <div class="ms-1 header-item d-none d-sm-flex">
                    <button type="button" class="btn btn-icon btn-topbar btn-ghost-primary rounded-circle" onclick="location.href='/main/myMain'">
                        <i class="ri-article-line"></i>
                    </button>
                </div>

<!-- 				달 표시 -->
<!--                 <div class="ms-1 header-item d-none d-sm-flex"> -->
<!--                     <button type="button" class="btn btn-icon btn-topbar btn-ghost-primary rounded-circle light-dark-mode"> -->
<!--                        	<i class="ri-moon-line"></i> -->
<!--                     </button> -->
<!--                 </div> -->
                
<!-- 				알림표시 -->
<div id="alertDiv"></div>
      <div class="dropdown topbar-head-dropdown ms-1 header-item">
                    <button type="button" class="btn btn-icon btn-topbar btn-ghost-primary rounded-circle alertButton" id="page-header-notifications-dropdown" data-bs-toggle="collapse" aria-haspopup="true" aria-expanded="false" data-bs-target="#alertcollapse" aria-controls="alertcollapse">
                        <i class="ri-notification-2-line"></i>
                        <span class="position-absolute topbar-badge fs-10 translate-middle badge rounded-pill bg-danger noRead"></span>
                    </button>
                    <div class="dropdown-menu dropdown-menu-lg dropdown-menu-end p-0 collapse" id="alertcollapse" aria-labelledby="page-header-notifications-dropdown" style="position: absolute; inset: 0px 0px auto auto; margin: 0px; transform: translate3d(0px, 60px, 0px);" data-popper-placement="bottom-end">

                        <div class="dropdown-head bg-primary rounded-top">
                            <div class="p-3">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <h6 class="m-0 fs-16 fw-semibold text-white">알림함</h6>
                                    </div>
                                    <div class="col-auto dropdown-tabs">	
                            	            <span class="badge badge-soft-light fs-13" id="allAlert">전체 알림 보기</span>
                                    </div>
                                    <div class="col-auto dropdown-tabs">	
                            	            <span class="badge badge-soft-light fs-13 newCnt"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-content" id="notificationItemsTabContent">
                            <div class="tab-pane fade show active py-2 ps-2" id="all-noti-tab" role="tabpanel">
                                <div data-simplebar="init" style="max-height: 300px;" class="pe-2"><div class="simplebar-wrapper" style="margin: 0px -8px 0px 0px;"><div class="simplebar-height-auto-observer-wrapper"><div class="simplebar-height-auto-observer"></div></div><div class="simplebar-mask"><div class="simplebar-offset" style="right: 0px; bottom: 0px;"><div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content" style="height: auto; overflow: hidden scroll;"><div class="simplebar-content alertArea" style="padding: 0px 8px 0px 0px;">
                                </div></div></div></div><div class="simplebar-placeholder" style="width: auto; height: 499px;"></div></div><div class="simplebar-track simplebar-horizontal" style="visibility: hidden;"><div class="simplebar-scrollbar" style="width: 0px; display: none;"></div></div><div class="simplebar-track simplebar-vertical" style="visibility: visible;"><div class="simplebar-scrollbar" style="height: 180px; display: block; transform: translate3d(0px, 0px, 0px);"></div></div></div>
                            </div>
                        </div>
                    </div>
                </div> 
                </c:if>
		     <c:choose>
       		<c:when test="${empty id}">
       			<a class="btn" onclick="location.href='login'">로그인</a>
       		</c:when>
       		<c:otherwise>
                <div class="dropdown ms-sm-3 header-item topbar-user" style="background-color:white;">
                    <button type="button" class="btn" id="page-header-user-dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <span class="d-flex align-items-center">
                            <span class="text-start ms-xl-2">
		                                <span class="d-none d-xl-inline-block ms-1 fw-medium user-name-text">${loginVO.memNm}님</span>
		<!--                                 <span class="d-none d-xl-block ms-1 fs-12 text-muted user-name-sub-text">환영합니다.</span> -->
                            </span>
                        </span>
                    </button>
                    <div class="dropdown-menu dropdown-menu-end">
                        <!-- item-->
                        <h6 class="dropdown-header">${loginVO.memNm}님 반가워요!</h6>
                        <a class="dropdown-item" href="/mypage/myPageMain?memNo=<%=memNo%>"><i class="ri-user-settings-line"></i><span class="align-middle">  마이페이지</span></a>
                        <a class="dropdown-item" href="/logout"><i class="ri-logout-box-r-line"></i> <span class="align-middle">  로그아웃</span></a>
                    </div>
                </div>
       		</c:otherwise>
       	</c:choose>
            </div>
        </div>
    </div>
</header>