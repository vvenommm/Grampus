<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style type="text/css">
 .directBtn:hover {
 	font-size : 13px;
 	font-weight : bold;
 	color : #5D5D5D;
 }
 #div1 {
 	background : #F9F9F9;
 	padding : 10px;
 	border-radius : 10px;
 }
 .profNm {
 	font-weight : bold;
 	color : #49556F;
 	font-size : 20px;
 }
 
</style>
</head>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js" ></script>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.js"></script>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>

<link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>

<script type="text/javascript">
 const Calendar = tui.Calendar;
 var calendar = "";
 var calNo = "";		//달력번호 저장할 변수
 var title = "";
 var start = "";
 var end = "";
 var attendees = "";
 var code = "";
 var profNm = "";
 var profPhoto = "";
 
 $(document).ready(function() {
	 //개인일정 가져오기----------------------------------------------------------
  	 $.ajax({
		 url :"/calendar/selectCalendar",
		 type :"post",
         success: function(data) {
        	console.log("data :" + data);
            $.each(data, function(i,v) {
            	//개인일정 출력
            	$("#calCn1").html(code);
            	
            	var state = v.CAL_GROUP;
            	if(state == "N") {
            		state = "개인";
            	}else {
            		state = "그룹";
            	}
	            	calendar.createEvents([		
			    		 {
			    			 id : v.CAL_NO,
			    			 calendarId : v.CAL_NO,
			    			 title : v.CAL_CN,
			    			 start : v.CAL_SDY,
			    			 state : state,
			    			 end : v.CAL_EDY,
			    			 isReadOnly : false,
			    			 backgroundColor: '#ffdea8',
			    		 }
			    	 ])
		    	   
            	 //달력 설정
		    	 calendar.setOptions({
		    		  template: {
			    		    //팝업창
			    		    popupStateBusy() {
			    		        return '개인';
			    		    },
			    		    popupStateFree() {
			    			    return '그룹';
			    			},
			    		    titlePlaceholder() {
			    			    return '일정';
			    			},
			    		    locationPlaceholder() {
  		    			        return '장소';
			    			},
			    		    startDatePlaceholder() {
		    			        return '시작일';
			    			},
		    			    endDatePlaceholder() {
		    			        return '종료일';
			    	        },
			    	        popupSave() {
			    	            return '등록';
			    	        },
			    	        popupUpdate() {
			    	            return '수정';
			    	        },
			    	        
			    	        //상세 팝업 (수정 버튼 클릭 시)
			    	        popupEdit() {
			    	            return '수정';
			    	        },
			    	        popupDelete() {
			    	            return '삭제';
			    	        },
			    	        popupDetailTitle({ title }) {
			    	            return title;
			    	        },
			    	        popupDetailBody({ body }) {
			    	            return body;
			    	        },
			    	        popupIsAllday() {
			    	            return '온 종일';
			    	        },
			    	  },
			    	  //month설정
			    	  month: {
			    		    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
			    		    startDayOfWeek: 0,		//시작 요일
// 			    		    visibleWeeksCount: 5,	//1달에 보여지는 주 수	==> 설정하면 오늘 날짜가 무조건 맨 위에 위치

			    	  },  
			    	  //week설정
			    	  week: {
			    		    dayNames: ['일', '화', '수', '목', '금', '토', '월'],
			    		    startDayOfWeek: 0,
			    		    taskView: 'task',
			    	  },
		    	});
            	 
	    	   calendar.setTheme({
	    		  month: {
		    		    weekend: {
		    		        backgroundColor: 'aliceblue',		//주말 색
		    		      },
	    		  },
	    		  week: {
	    			    dayGridLeft: {
	    			      borderRight: 'none',
	    			      backgroundColor: 'rgba(81, 92, 230, 0.05)',
	    			      width: '70px',
	    			    },
	    			    nowIndicatorLabel: {
	    			        color: '#4641D9',
	    			    },
	    			    nowIndicatorBullet: {
	    			        backgroundColor: '#4641D9',
	    			    },
	    			    nowIndicatorToday: {
	    			        border: '2px solid #4641D9',
	    			    },
	    		  },
	    		  common: {
	    			    backgroundColor: 'white',		//달력 배경색
	    			    border: '2px pink pink',		//테두리색
	    			    gridSelection: {				//드래그 영역
	    			        backgroundColor: 'rgba(255, 216, 216, 0.5)',
	    			        border: '2px dotted pink',
	    			    },
	    			    holiday: {
	    			        color: 'rgba(255, 18, 18, 0.4)',
	    			    },
	    			    saturday: {
	    			        color: 'rgba(49, 98, 198, 0.4)',
	    			    },
    			  },
	    		});
				profNm = v.PROF_NM;
				profPhoto = v.PROF_PHOTO;
            })
            
            //상위 카드바디 출력하기
    	    code = "";
   		    code += '<div class="flex-shrink-0">'        
   		    code += '<img src="/resources/image/' + profPhoto + '" class="avatar-sm rounded-circle">&nbsp;'        
   		    code += '</div>'
   	        code += '<div class="flex-grow-1 ms-2">'
   	        code += '<h6 class="card-title mb-1"><span class="profNm"> ' + profNm + '</span> 님의 일정</h6>'
            code += '</div>'
            $("#profile").html(code);
            
            
     	    //개인일정 출력하기
   	    	code = "";                                                       
	    	$.each(data, function(i,v) {
	    	   taskSdy = new Date(v.CAL_SDY);
	    	   taskSdy = taskSdy.getFullYear() + "-" + (taskSdy.getMonth()+1) + "-" + taskSdy.getDate();
	    	   taskEdy = new Date(v.CAL_EDY);
	    	   taskEdy = taskEdy.getFullYear() + "-" + (taskEdy.getMonth()+1) + "-" + taskEdy.getDate();
	    	   
               code += '<div class="d-flex">';
               code += '	<div class="flex-shrink-0">';
               code += '    	<i class="ri-checkbox-circle-fill text-warning"></i>'
               code += '	</div>';
               code += '	<div class="flex-grow-1 ms-2 text-muted">';
               code += 			'<span class="directBtn" onclick="direct(' + v.CAL_SDY + ');" style="cursor:pointer;">' + v.CAL_CN + "<br>";
               code += 			' (' + taskSdy + " ~ " + taskEdy + ")</span><br />";
               code += '	</div>';
           	   code += '</div><br>';
	    	})  
    	   $("#privateDiv").html(code);
         }
	 })  
	 
  	 //그룹 일정 가져오기----------------------------------------------------------------------------------
 	 $.ajax({
 		url : "/calendar/selectCalendarGrp",
 		type : "post",
 		success : function(res) {
 			$.each(res, function(i,v) {
            	var state = v.CAL_GROUP;
            	if(state == "N") {
            		state = "개인";
            	}else {
            		state = "그룹";
            	}
            	calendar.createEvents([		
		    		 {
		    			 id : v.CAL_NO,
		    			 calendarId : v.CAL_NO,
		    			 title : v.CAL_CN,
		    			 start : v.CAL_SDY,
		    			 end : v.CAL_EDY,
		    			 state : state,
		    			 location: '회사',
// 		    			 isReadOnly : true,
		    			 backgroundColor: '#b2d6b8'
		    		 }
		    	 ])
 			})
 			
     	    //그룹일정 출력하기
    	    	code = "";                  
		    	$.each(res, function(i,v) {
		    	   taskSdy = new Date(v.CAL_SDY);
		    	   taskSdy = taskSdy.getFullYear() + "-" + (taskSdy.getMonth()+1) + "-" + taskSdy.getDate();
		    	   taskEdy = new Date(v.CAL_EDY);
		    	   taskEdy = taskEdy.getFullYear() + "-" + (taskEdy.getMonth()+1) + "-" + taskEdy.getDate();
		    	   
	               code += '<div class="d-flex">';
	               code += '	<div class="flex-shrink-0">';
	               code += '    	<i class="ri-checkbox-circle-fill text-success"></i>'
	               code += '	</div>';
	               code += '	<div class="flex-grow-1 ms-2 text-muted">';
	               code += 			'<span class="directBtn" onclick="direct(' + v.CAL_SDY + ');" style="cursor:pointer;">' + v.CAL_CN + "<br>";
	               code += 			' (' + taskSdy + " ~ " + taskEdy + ")</span><br />";
	               code += '	</div>';
	           	   code += '</div><br>';
	    	})  
	    	   $("#publicDiv").html(code);
 		}
 	 })
 	
	 //달력 설정-------------------------------------------------------------
	 const div = document.getElementById("calendar");
	 const options = {
			defaultView : "month",	//"day", "week", "month"  : 단위
			useFormPopup : true,		//일정 생성 팝업
			useDetailPopup: true,		//일정 수정 팝업
	 };
	 

	 calendar = new Calendar(div, options);
	 calendar.render();
	 
	 
	 //일정 삭제------------------------------------------------------------
	 calendar.on('beforeDeleteEvent', (eventObj) => {
	    Swal.fire({
	        text: "정말 삭제하시겠습까?",
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
	        	calendar.deleteEvent(eventObj.id, eventObj.calendarId);
			   	calNo = eventObj.id;
				 $.ajax({
					 url:"/calendar/deleteCalendar?calNo="+calNo,
					 type:"get",
			         success: function(data) {
			        	 if(data == 1) {
			        		 alert("삭제하였습니다.");
			        	 }
			         }
				 })
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
	 
	 
	 //일정 수정------------------------------------------------------------
	 calendar.on('beforeUpdateEvent', (eventObj) => {
		 console.log("eventObj.event : " , eventObj.event);			//기존 이벤트
		 console.log("eventObj.changes : ", eventObj.changes);		//변경 이벤트
		 
		 calNo = eventObj.event.id;
		 calCn = eventObj.changes.title;
		 calSdy = eventObj.changes.start;
		 calEdy = eventObj.changes.end;
		 calState = eventObj.changes.state;
		 
		 if(calCn == null) {
			 calCn = eventObj.event.title;
		 }
		 if(calSdy == null) {
			 calSdy =  eventObj.event.start;
		 }
		 if(calEdy == null) {
			 calEdy =  eventObj.event.end;
		 }
		 if(calState == null) {
			 calState =  eventObj.event.state;
		 }
		 if(calState == 'Busy') {
			 calState = "N";
		 }
		 if(calState == 'Free') {
			 calState = "Y";
		 }
		 if(calState == '개인') {
			 calState = "N";
		 }
		 if(calState == '그룹') {
			 calState = "Y";
		 }
		 
		 calSdy = new Date(calSdy);
		 calEdy = new Date(calEdy);
		 
		 var newData = {
					"calNo" : calNo,
					"calCn" : calCn,
					"calSdy" : calSdy,
					"calEdy" : calEdy,
					"calGroup" : calState
				}
		 console.log("newData : " ,newData);
		 
		 calendar.updateEvent(eventObj.id, eventObj.calendarId, eventObj);
		 $.ajax({
		 	 url : "/calendar/updateCalendar",
		 	 type : "post",
			 data : JSON.stringify(newData),
			 contentType : "application/json;charset=utf-8",
			 success : function(res) {
				 console.log("update Res : " + res);
				 location.href = "/calendar/myCalendar/${projId}/${pmemGrp}";
			 }
		 })
	 })
	 
	 //일정 생성----------------------------------------------------------
	 calendar.on('beforeCreateEvent', (eventObj) => {
		 //calNo 구해오기
		 $.ajax({
			 url : "/calendar/maxcalNo",
			 type : "get",
			 success : function(res) {
				 calNo = res;
				 
				 const events = {
						id : calNo,
						calendarId : calNo,
						title : eventObj.title,
						start : eventObj.start,
						end : eventObj.end
				 }
				 title = eventObj.title;
				 start = new Date(eventObj.start)
				 end = new Date(eventObj.end)
				 calGroup = "";
				 if(eventObj.state == 'Free') {
					 calGroup = 'Y';
				 }else {
					 calGroup = 'N';
				 }
				 
				 calendar.createEvents([events]);
				 
				 var createData = {
					 "calNo" : calNo,
					 "calSdy" : start,
					 "calEdy" : end,
					 "calCn" : title,
					 "calGroup" : calGroup
				 }
				 
				 console.log("createData : " + createData);
				 $.ajax({
					 url : "/calendar/createCalendar",
					 type : "post",
					 data : JSON.stringify(createData),
					 contentType : "application/json;charset=utf-8",
					 success : function(res) {
						 console.log(res);
						 Swal.fire({
					            text: '일정이 생성되었습니다.',
					            imageUrl: '/resources/image/alertLogo.png',
					            imageHeight: 25,
					            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
					            buttonsStyling: false,
					            showCloseButton: true
					      	})
						 location.href = "/calendar/myCalendar/${projId}/${pmemGrp}";
					 }
				 })
			 }
		 })
 })
 

 $(function() {
	 today = calendar.getDate();
	 $("#know").text(today.d.getFullYear() + "." + (today.d.getMonth()+1));
	 
	 //<
	 $("#previous").on("click", function() {
		 calendar.prev();
		 knowToday();
	 })
	 //>
	 $("#next").on("click", function() {
		 calendar.next();
		 knowToday();
	 })
	 //오늘
	 $("#today").on("click", function() {
		 calendar.today();
		 knowToday();
	 })
	 //일간
	 $("#dayCal").on("click", function() {
		 calendar.changeView("day");
		 knowToday();
	 })
	 //주간
	 $("#weekCal").on("click", function() {
		 calendar.changeView("week");
		 knowToday();
	 })
	 //월간
	 $("#monthCal").on("click", function() {
		 calendar.changeView("month");
		 knowToday();
	 })
	 //일정 모두 삭제
	 $("#removeAllCal").on("click", function() {
		calendar.clear();
	    Swal.fire({
	        text: "모두 삭제하시겠습니까?",
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
	        	 $.ajax({
					 url : "/calendar/deleteAllCalendar",
					 type : "get",
					 success : function(res) {
					 }
				 })
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
	    calendar.clear();
	 })
 })
 
 })

 function knowToday() {
	 today = calendar.getDate();
	 $("#know").text(today.d.getFullYear() + "." + (today.d.getMonth()+1));
 }
 function direct(taskSdy) {
	 calendar.setDate(taskSdy);
	 knowToday();
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
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/calendar/myCalendar/${projVO.id}/${projVO.grp}'" style="cursor: pointer">달력</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->

<!-- ---------------------------------------------------------------상위 카드바디--------------------------------------------------------------- -->
<!--  <div class="row">
	<div class="w-100 h-100 col-xl-8">
	    <div class="card">
	        <div class="card-body">
		         <div class="d-flex align-items-center" id="profile">
		         </div>
	        </div>
	    </div>
	</div>
</div>
-->
<!-- ---------------------------------------------------------------달력 본문--------------------------------------------------------------- -->
<div class="row">
	<!-- 달력 -->
	<div class="col-xl-8">
	    <div class="card" id="div1">
	        <div class="card-body">
	        	<div class="">
	                <div class="btn-group" role="group" aria-label="Basic example">
					    <button type="button" class="btn btn-light prev" id="previous">&lt;</button>
					    <button type="button" class="btn btn-light" id="know"></button>
					    <button type="button" class="btn btn-light next" id="next">&gt;</button>
					    <button type="button" class="btn btn-info today" id="today">Today</button>
					    <button type="button" class="btn btn-info" id="dayCal">Day</button>
					    <button type="button" class="btn btn-info" id="weekCal">Week</button>
					    <button type="button" class="btn btn-info" id="monthCal">Month</button>
					</div>
				</div>
				<div id="calendar" style="height:550px;"></div>
			</div>
		</div>
	</div>
	<!-- 일정목록 div -->
	<div class="col-xl-4">
		<!-- 개인일정 -->
	    <div id="private">
	        <div class="card">
				<div class="alert alert-warning alert-border-left alert-dismissible fade show" role="alert">
				    <i class="ri-user-3-line align-middle"></i><strong style="font-size:15px;"> 개인일정</strong>
				</div>
	            <div class="card-body collapse show" style="margin-left:10px;">
	                <div data-simplebar="init" style="max-height: 210px;"><div class="simplebar-wrapper" style="margin: 0px;"><div class="simplebar-height-auto-observer-wrapper">
	                	<div class="simplebar-height-auto-observer"></div></div><div class="simplebar-mask"><div class="simplebar-offset" style="right: 0px; bottom: 0px;">
	                		<div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content" style="height: auto; overflow: hidden scroll;">
	                			<div class="simplebar-content" style="padding: 0px;" id="privateDiv">
	                			</div></div></div></div>
	                		<div class="simplebar-placeholder" style="width: auto; height: 277px;"></div></div>
	                	<div class="simplebar-track simplebar-horizontal" style="visibility: hidden;">
	                <div class="simplebar-scrollbar" style="width: 0px; display: none;"></div></div>
	                <div class="simplebar-track simplebar-vertical" style="visibility: visible;">
	               <div class="simplebar-scrollbar" style="height: 173px; transform: translate3d(0px, 0px, 0px); display: block;"></div></div></div>
	            </div>
	        </div>
	    </div>
	    <!-- 그룹일정 -->
	    <div id="public">
	        <div class="card">
				<div class="alert alert-success alert-border-left alert-dismissible fade show" role="alert">
				    <i class="ri-team-line align-middle"></i><strong style="font-size:15px;"> 그룹일정</strong>
				</div>
	            <div class="card-body collapse show" style="margin-left:10px;">
     	        	<div data-simplebar="init" style="max-height: 210px;"><div class="simplebar-wrapper" style="margin: 0px;"><div class="simplebar-height-auto-observer-wrapper">
	                	<div class="simplebar-height-auto-observer"></div></div><div class="simplebar-mask"><div class="simplebar-offset" style="right: 0px; bottom: 0px;">
	                		<div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content" style="height: auto; overflow: hidden scroll;">
	                			<div class="simplebar-content" style="padding: 0px;" id="publicDiv">
	                			</div></div></div></div>
	                		<div class="simplebar-placeholder" style="width: auto; height: 277px;"></div></div>
	                	<div class="simplebar-track simplebar-horizontal" style="visibility: hidden;">
	                <div class="simplebar-scrollbar" style="width: 0px; display: none;"></div></div>
	                <div class="simplebar-track simplebar-vertical" style="visibility: visible;">
	               <div class="simplebar-scrollbar" style="height: 173px; transform: translate3d(0px, 0px, 0px); display: block;"></div></div></div>
	            </div>
	        </div>
	    </div>
	</div>	
</div>		