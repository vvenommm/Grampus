<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="kr.or.ddit.vo.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
<script>

/////////////////////////
/* 포트폴리오 팝업창으로 보기 */

var foli = 0;
function pol(memNo){
	var url = "/portfolio/" + memNo;
	var win = window.open(url, "포트폴리오"+foli , "width=750 height=900 ");
	foli += 1;
} 





//subproject 리스트. length > 0이면 그룹이 있다는 뜻 -> '모두'에서 역할 표시 안 함
var subArr = new Array;
<c:if test="${!empty getGrpList}">
	<c:forEach items="${getGrpList}" var="grp">
		var data = {"sprojTtl" : "${grp.sprojTtl}"}
		subArr.push(data)
	</c:forEach>
</c:if>

//멤버 전체 리스트
var memArr = new Array;
if(subArr.length > 0){ //그룹이 있다
	<c:forEach items="${projMember}" var="mem">
		var data = {"PROF_NM" : "${mem.PROF_NM}", "MEM_NO" : "${mem.MEM_NO}", "PROF_PHOTO" : "${mem.PROF_PHOTO}", "PMEM_IDY" : "${mem.PMEM_IDY}"}
		memArr.push(data)
	</c:forEach>
}else{//그룹이 없다
	<c:forEach items="${projMember}" var="mem">
		var data = {"PROF_NM" : "${mem.PROF_NM}", "MEM_NO" : "${mem.MEM_NO}", "PROF_PHOTO" : "${mem.PROF_PHOTO}", "PMEM_IDY" : "${mem.PMEM_IDY}", "ROLE_NM" : "${mem.ROLE_NM}"}
		memArr.push(data)
	</c:forEach>
}

//그룹 리스트
var grpArr = new Array;
<c:forEach items="${grpList}" var="grp">
	var data = {"PMEM_GRP" : "${grp.PMEM_GRP}"}
	grpArr.push(data)
</c:forEach>

console.log(memArr);
console.log(grpArr);
console.log(subArr);


////////////////////
/* 천단위 구분함수 */
function comma(tx) {
    str = String(tx);
    return str.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function uncomma(tx) {
    str = String(tx);
    return str.replace(/[^\d]+/g, '');
}


$(function(){
//////////////////////////
/* 에디터 */
const Editor = toastui.Editor;
const editor = new Editor({
	  el: document.querySelector('#editor'),
	  height: '500px',
	  initialEditType: 'wysiwyg',
	  previewStyle: 'vertical'
});

var planOn = "${projVO.plan}";
var jobEditor = "";
if(planOn != 'BASIC'){
	jobEditor = new Editor({
	  el: document.querySelector('#jobEditor'),
	  height: '500px',
	  initialEditType: 'wysiwyg',
	  previewStyle: 'vertical'
});
	
}

var ungrp = ${ungrp};
if(ungrp > 0){
	Swal.fire({
		title: '그룹에 배정되지 않은 멤버가 있습니다.',
	    text: '프로젝트 멤버 탭을 확인해주세요.',
	    icon: 'error',
	    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
	    buttonsStyling: false,
	    showCloseButton: true
		})
}

//모달 드래그 가능하게
$("#memInvi").draggable();
$("#newGrpModal").draggable();

//프로젝트 비참여 회원 전체 검색
$(".finput").keyup(function(){
	$("#memberInfo").children().remove();
	var con = $(".finput").val();
	$.ajax({
		url: "/searchMem?content="+con+"&cnt=0",
		type: 'GET',
		dataType: 'json',
		success : function(data){
			var code = "";
			$.each(data,function(i,v){
				console.log(v)
                code += "<a href='#' id='membox' data-memNo='" + v.MEM_NO+ "' class='dropdown-item notify-item py-2' style='display: block;'>";
                code += "<div class='d-flex'>";
            	    code += "<div class='col-2'>";
            		    code += "<img src='/resources/image/" + v.MEM_PHOTO +"' class='rounded-circle avatar-xs'>";
                	code += "</div>";
            	    code += "<div class='col-10'>";
               			code += "<h6 class='m-0 memberId'>"+v.MEM_ID+"</h6>";
                		code += "<span class='fs-11 mb-0 text-muted memberName'>"+v.MEM_NM+"</span>";
                	code += "</div>";
                code += "</div>";
                code += "</a>";
			});
			console.log(code);
			$("#memberInfo").append(code);
		},
	});
});

////////////////
/* 프로젝트 정보 표시 */
var rspanVal = 0;
$("#projName").val("${projInfo.get('PROJ_TTL')}");
if("${projInfo.get('PROJ_STTS')}" == "종료"){
	$("#projStats").val("종료").attr("selected","selected");
	$("#projStats").attr("disabled","true");
}else{
	$("#projStats").val("${projInfo.get('PROJ_STTS')}").attr("selected","selected");
}
editor.setHTML("${projInfo.get('PROJ_CN')}");
$("#joinValue").val("${projInfo.get('PROJ_LIMIT')}").attr("selected","selected");
$("#payment").val("${projInfo.get('PROJ_BGT')}");
$("#codeRating0").val("${projCost[0].get('COST_LV')}").attr("selected","selected");
$("#countPerson0").val("${projCost[0].get('COST_PCNT')}");
$("#ccost0").val("${projCost[0].get('COST_PAY')}");
if(${fn:length(projCost)} > 1){
	var crat1 = $("#codeRating0 option:selected").val();
	var crat2 = $("#codeRating1 option:selected").val();
	var source = "";
	source += "<div class='row'>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<select class='form-select mb-3' id='codeRating1'>";
	if(crat1 == "초급" || crat2 == "초급"){
		source += "<option disabled>초급</option>";
	}else {
		source += "<option>초급</option>";
	}
	if(crat1 == "중급" || crat2 == "중급"){
		source += "<option disabled>중급</option>";
	}else {
		source += "<option>중급</option>";
	}
	if(crat1 == "고급" || crat2 == "고급"){
		source += "<option disabled>고급</option>";
	}else {
		source += "<option>고급</option>";
	}
	source += "</select>";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<input type='text' class='form-control' id='countPerson1' placeholder='인원수'>";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<input type='text' class='form-control' id='ccost1' />";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<button type='button' id='divcon' class='btn btn-outline-danger'><i class='ri-subtract-line'></i></button>";
	source += "</div>";
	source += "</div>";
	source += "</div>";
	$(source).appendTo("#costVal");
	rspanVal = 1;
	$("#codeRating1").val("${projCost[1].get('COST_LV')}").attr("selected","selected");
	$("#countPerson1").val("${projCost[1].get('COST_PCNT')}");
	$("#ccost1").val("${projCost[1].get('COST_PAY')}");
	if(${fn:length(projCost)} > 2){
		var crat1 = $("#codeRating0 option:selected").val();
		var crat2 = $("#codeRating1 option:selected").val();
		var source = "";
		source += "<div class='row'>";
		source += "<div class='col-lg-3'>";
		source += "<div class='mb-3'>";
		source += "<select class='form-select mb-3' id='codeRating2'>";
		if(crat1 == "초급" || crat2 == "초급"){
			source += "<option disabled>초급</option>";
		}else {
			source += "<option>초급</option>";
		}
		if(crat1 == "중급" || crat2 == "중급"){
			source += "<option disabled>중급</option>";
		}else {
			source += "<option>중급</option>";
		}
		if(crat1 == "고급" || crat2 == "고급"){
			source += "<option disabled>고급</option>";
		}else {
			source += "<option>고급</option>";
		}
		source += "</select>";
		source += "</div>";
		source += "</div>";
		source += "<div class='col-lg-3'>";
		source += "<div class='mb-3'>";
		source += "<input type='text' class='form-control' id='countPerson2' placeholder='인원수'>";
		source += "</div>";
		source += "</div>";
		source += "<div class='col-lg-3'>";
		source += "<div class='mb-3'>";
		source += "<input type='text' class='form-control' id='ccost2' />";
		source += "</div>";
		source += "</div>";
		source += "<div class='col-lg-3'>";
		source += "<div class='mb-3'>";
		source += "<button type='button' id='divcon' class='btn btn-outline-danger'><i class='ri-subtract-line'></i></button>";
		source += "</div>";
		source += "</div>";
		source += "</div>";
		$(source).appendTo("#costVal");
		rspanVal = 2;
		$("#codeRating2").val("${projCost[2].get('COST_LV')}").attr("selected","selected");
		$("#countPerson2").val("${projCost[2].get('COST_PCNT')}");
		$("#ccost2").val("${projCost[2].get('COST_PAY')}");
		if(rspanVal==2){
			$("#addcon").hide();
		}
	}
}

//////////////////////////
/* 예산항목 추가 */
$("#addcon").on("click",function(){
	rspanVal = rspanVal+1;
	var crat1 = $("#codeRating0 option:selected").val();
	var crat2 = $("#codeRating1 option:selected").val();
	var source = "";
	source += "<div class='row'>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<select class='form-select mb-3' id='codeRating"+rspanVal+"'>";
	if(crat1 == "초급" || crat2 == "초급"){
		source += "<option disabled>초급</option>";
	}else {
		source += "<option>초급</option>";
	}
	if(crat1 == "중급" || crat2 == "중급"){
		source += "<option disabled>중급</option>";
	}else {
		source += "<option>중급</option>";
	}
	if(crat1 == "고급" || crat2 == "고급"){
		source += "<option disabled>고급</option>";
	}else {
		source += "<option>고급</option>";
	}
	source += "</select>";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<input type='text' class='form-control' id='countPerson"+rspanVal+"' placeholder='인원수'>";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<input type='text' class='form-control' id='ccost"+rspanVal+"' />";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<button type='button' id='divcon' class='btn btn-outline-danger'><i class='ri-subtract-line'></i></button>";
	source += "</div>";
	source += "</div>";
	source += "</div>";
	$(source).appendTo("#costVal");
	if(rspanVal==2){
		$("#addcon").hide();
	}
});

//////////////////////
/* 예산항목 제거 */
$(document).on("click","#divcon",function(){
	$(this).closest(".row").remove();
	rspanVal = rspanVal-1;
	if(rspanVal<2){
		$("#addcon").show();
	}
});

///////////////////////////
/* 이미지 파일 확장자, 파일 크기 확인 */
$("#projImg").on("change",function(){
	var fImage = $("#projImg")[0].files[0];
	var regex = new RegExp("(.*?)\.(png|jpg)$");
	var maxSize = 5242880;
	var fileName = fImage.name;
	var fileSize = fImage.size;
	if(fileSize >= maxSize) {
	    Swal.fire({
            text: '파일 사이즈는 5MB를 초과할 수 없습니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
	    $("#projImg").val("");
	}
	if(!regex.test(fileName)) {
	    Swal.fire({
            text: '이미지 파일 확장자는 jpg, png만 가능합니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
	    $("#projImg").val("");
	}
});

///////////////////////
/* 프로젝트 수정 */
var projId = ${projInfo.get('PROJ_ID')};
$("#modify").on("click",function(){
	var name = $("#projName").val();
	var fileImage = $("#projImg")[0].files[0];
	var explan = editor.getHTML();
	var start = $("#startProj").val();
	var end = $("#endProj").val();
	var joinVal = $("#joinValue").val();
	var paym = uncomma($("#payment").val());
	var stats = $("#projStats option:selected").val();
	var projCost = [];
	var chkCount = 0;
	var pscnt = 0;
	var costSum = 0;
	for(i=0; i<=rspanVal; i++){
		var codeR = $("#codeRating"+i+" option:selected").val();
		var cntP = $("#countPerson"+i).val();
		var ccost = uncomma($("#ccost"+i).val());
		if(cntP == "" || ccost == ""){
			chkCount = chkCount+1;
		}
		costSum = costSum+(parseInt(ccost)*parseInt(cntP));
		pscnt = pscnt+parseInt(cntP);
		projCost.push({"codeR":codeR,"cntP":cntP,"ccost":ccost});		
	}
	if(name == "" || start == "" || end == "" || joinVal == "" || paym == "" || chkCount > 0){
	    Swal.fire({
            text: '작성하지 않은 항목이 있습니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
		return false;
	}
	if(parseInt(joinVal) < pscnt){
	    Swal.fire({
            text: '프로젝트 인원수 보다 등급인원이 더 많습니다 다시 설정해주세요.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
		return false;
	}
	var divstart = new Date(start);
	var divend = new Date(end);
	var divDate = divend.getTime()-divstart.getTime();
	var divValue = Math.floor(divDate / (1000 * 60 * 60 * 24));
	var divide = Math.floor(divValue/30);
	if(divide == 0){
		divide = 1;
	}
	if((divide*costSum) > paym){
		Swal.fire({
            text: '프로젝트 예산보다 보수가 더 많습니다 다시 설정해주세요',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
		return false;
	}
	var sdt = {"id":projId,"name":name,"explan":explan,"start":start,"end":end,"paym":paym,"joinVal":joinVal,"stats":stats};
	console.log(sdt)
	console.log(projCost)
	//프로젝트 정보 수정
	$.ajax({
		url:"/project/modifyProject",
		type:"post",
		data:JSON.stringify(sdt),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			if(res>0){
				//프로젝트 사진 수정
				if(fileImage != null){
					var formData = new FormData();
					formData.append('file', fileImage);
					$.ajax({
				        type:"POST",
				        enctype:'multipart/form-data',
				        url:"/project/projImg?projId="+projId,
				        data:formData,
				        processData:false,
				        contentType:false,
				        success:function(res){
				        	if(res<1){
				        		 Swal.fire({
			        			 	text: '이미지 업로드 실패',
				                  	icon: 'error',
			        	            confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
			        	            buttonsStyling: false,
			        	            showCloseButton: true
			        	      	})
				        	}
				        }
					});
				}
				//인건비 수정
				$.ajax({
					url:"/cost/costDelete?id="+projId,
					type:"post",
					data:JSON.stringify(projCost),
					contentType:"application/json; charset=utf-8",
					success:function(res){
						if(res>0){
							Swal.fire({
					            text: '수정되었습니다.',
					            imageUrl: '/resources/image/alertLogo.png',
					            imageHeight: 25,
					            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
					            buttonsStyling: false,
					            showCloseButton: true
					      	}).then(function(){
					      		location.reload(true);
					      	})
						}else{
							Swal.fire({
		        			 	text: '프로젝트 수정 실패',
			                  	icon: 'error',
		        	            confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
		        	            buttonsStyling: false,
		        	            showCloseButton: true
		        	      	})
						}
					}
				});
			}else{
				Swal.fire({
    			 	text: '프로젝트 수정 실패',
                  	icon: 'error',
    	            confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
    	            buttonsStyling: false,
    	            showCloseButton: true
    	      	})
			}
		}
	});
});

//////////////////////////
/* 예상기간 구하기 */
var stDate = new Date();
var edDate = new Date("${projInfo.get('PROJ_EDY')}");
var calDate = Math.ceil((edDate.getTime()-stDate.getTime())/(1000*3600*24));
$("#totalper").text(calDate + "일");


/////////////////////////
/* 천단위 구분 함수*/
$(document).on("keyup","#payment, #ccost0, #ccost1, #ccost2",function(){
	var testtx = $(this).val();
	var testuc = uncomma(testtx);
	$(this).val(comma(testuc));
});


/////////////////////////
/* 탭 누르면 멤버 쏘기(프로젝트 공고 승인 후 반영이 안 돼서 추가) */
$('#promem').on('click', function(){
	
	
	$.ajax({
		url:"/project/memberList",
		type:"post",
		contentType:"application/json; charset=utf-8",
		success:function(res){
			//그룹 리스트
			var groupList = new Array;
			var groupYes = "";
			<c:forEach items="${grpList}" var="grp">
				groupList.push("${grp.PMEM_GRP}");
			</c:forEach>
			
			var all = 0;
			var ungrp = 0;
			$.each(groupList, function(i, v){
				if("전체" == v){
					all += 1;
				}
				if("미정" == v){
					ungrp += 1;
				}
			});
			
			if((all == 1 && groupList.length == 1) || (all == 1 && ungrp == 1 && groupList.length == 2)){
				groupYes = "N";
			}else{
				groupYes = "Y";
			}
			
			console.log("그룹 리스트 : ", groupList);
			console.log(res);
			console.log(groupYes);
			
			
			var str = `
						<div class="col-lg-2">
					        <div class="nav nav-pills flex-column nav-pills-tab custom-verti-nav-pills text-center" role="tablist" aria-orientation="vertical" id="grpTabs">
				                 <a class="nav-link" id="custom-v-pills-add-tab" data-bs-toggle="modal" data-bs-target=".bs-example-modal-center" style="cursor: pointer;">
				                     <i class="bx bx-plus mb-1"></i> <span id="addGrp">추가</span>
				                 </a>
				                 <a class="nav-link active show grpTab" id="custom-v-pills-all-tab" data-gn="all" data-bs-toggle="pill" href="#custom-v-pills-all" role="tab" aria-controls="custom-v-pills-all" aria-selected="true">
				                     <i class="bx bx-group fs-18 mb-1"></i> <span> 모두</span>
				                 </a>
					  `;

			
			//전체 멤버 리스트 뿌리기
			if(groupYes == "Y"){
				
				//탭(그룹) 반복문으로 뿌리기
				$.each(groupList, function(i, v){
	                  str += `
	                  			<a class="nav-link grpTab" id="custom-v-pills-`+ v +`-tab" data-gn="`+ v +`" data-bs-toggle="pill" href="#custom-v-pills-`+ v +`" role="tab" aria-controls="custom-v-pills-`+ v +`" aria-selected="false">
	                      			<i class="bx bx-subdirectory-right"></i> <span> `+ v +`</span>
	                  			</a>
	                  		 `;
				});
			
			
				
			}else{
				
			}
		}
	});
	
	
	
	var str = ` 
			<div class="col-lg-2">
		        <div class="nav nav-pills flex-column nav-pills-tab custom-verti-nav-pills text-center" role="tablist" aria-orientation="vertical" id="grpTabs">
		                 <a class="nav-link" id="custom-v-pills-add-tab" data-bs-toggle="modal" data-bs-target=".bs-example-modal-center" style="cursor: pointer;">
		                     <i class="bx bx-plus mb-1"></i> <span id="addGrp">추가</span>
		                 </a>
					<c:choose>
						<c:when test="${yesGrp == 0}">
		                 <a class="nav-link active show grpTab" id="custom-v-pills-all-tab" data-gn="all" data-bs-toggle="pill" href="#custom-v-pills-all" role="tab" aria-controls="custom-v-pills-all" aria-selected="true">
		                     <i class="bx bx-group fs-18 mb-1"></i> <span> 모두</span>
		                 </a>
						</c:when>
						<c:otherwise>
		                     <a class="nav-link active show grpTab" id="custom-v-pills-all-tab" data-gn="all" data-bs-toggle="pill" href="#custom-v-pills-all" role="tab" aria-controls="custom-v-pills-all" aria-selected="true">
		                         <i class="bx bx-group fs-18 mb-1"></i> <span> 모두</span>
		                     </a>
							<c:forEach var="grp" items="${getGrpList}">
								<c:if test="${grp.sprojTtl ne '미정'}">
		                         <a class="nav-link grpTab" id="custom-v-pills-${grp.sprojTtl}-tab" data-gn="${grp.sprojTtl}" data-bs-toggle="pill" href="#custom-v-pills-${grp.sprojTtl}" role="tab" aria-controls="custom-v-pills-${grp.sprojTtl}" aria-selected="false">
		                             <i class="bx bx-subdirectory-right"></i> <span> ${grp.sprojTtl}</span>
		                         </a>
								</c:if>
							</c:forEach>
							<c:forEach var="grp" items="${getGrpList}">
								<c:if test="${grp.sprojTtl eq '미정'}">
		                         <a class="nav-link grpTab" id="custom-v-pills-${grp.sprojTtl}-tab" data-gn="${grp.sprojTtl}" data-bs-toggle="pill" href="#custom-v-pills-${grp.sprojTtl}" role="tab" aria-controls="custom-v-pills-${grp.sprojTtl}" aria-selected="false">
		                             <i class="bx bx-subdirectory-right"></i> <span> ${grp.sprojTtl}</span>
		                         </a>
		                      </c:if>
							</c:forEach>
						</c:otherwise>
					</c:choose>
		<!--                                        <a class="nav-link" id="custom-v-pills-adding-tab" data-bs-toggle="pill" href="#custom-v-pills-adding" role="tab" aria-controls="custom-v-pills-adding" aria-selected="false"> -->
		<!--                                            <i class="ri-add-circle-line d-block fs-20 mb-1"></i> 그룹 추가하기 -->
		<!--                                        </a> -->
		        </div>
		    </div> <!-- end col-->
		    
		    <div class="col-lg-10">
		        <div class="tab-content text-muted mt-3 mt-lg-0" id="pmemListBox">
		        <c:choose>
		        	<c:when test="${yesGrp == 0}">
		            <div class="tab-pane fade active show" id="custom-v-pills-all" role="tabpanel" aria-labelledby="custom-v-pills-all-tab">
		             <div class="tab-pane fade active show" id="custom-v-pills-all" role="tabpanel" aria-labelledby="custom-v-pills-all-tab">
		                  <c:forEach var="mem" items="${projMember}" varStatus = "stat">
		                      <div class="d-flex align-items-center mb-3">
			                        <c:choose>
			                        	<c:when test="${iamPM.memNo eq mem.MEM_NO}">
				                        	<div class="form-check form-check-info mb-3">
				                        		<input class="form-check-input" type="checkbox" style="display: none;"/>
				                        	</div>
			                        	</c:when>
			                        	<c:otherwise>
				                        	<div class="form-check form-check-info mb-3">
				                        		<input class="form-check-input chkbox" type="checkbox"/>
				                        	</div>
			                        	</c:otherwise>
			                        </c:choose>
		                          <div class="flex-shrink-0 avatar-sm">
		                              <div class="avatar-title bg-light rounded-circle fs-18">
		                                  <img src="/resources/image/${mem.PROF_PHOTO}" class="rounded-circle avatar-sm" alt="">
		                              </div>
		                          </div>
		                          <div class="flex-grow-1 ms-3">
		                              <h6 class="fs-15">${mem.PROF_NM} 
		                              	<c:if test="${!empty mem.ROLE_NM}">(<span id="rn${mem.MEM_NO}">${mem.ROLE_NM}</span>)</c:if>
		                              	<c:if test="${iamPM.memNo eq mem.MEM_NO}"><span style="font-weight: bold;">(나)</span></c:if>
		                              </h6>
		                              <p class="text-muted mb-0">참여일1 : ${mem.PMEM_IDY}</p>
		                          </div>
		                          
		                          
		                          <div id="box${mem.PROF_NM}">
		                  <div class="row text-end">
		                  	<div class="col-4">
		                              <c:if test="${!empty mem.ROLE_NM}">
				                            <c:choose>
				                            	<c:when test="${mem.MEM_NO eq memNo}">
					                                <div class="btn-group" id="g${mem.MEM_NO}">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled="disabled">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
													    </div>
													</div>
				                            	</c:when>
				                            	<c:otherwise>
					                                <div class="btn-group" id="g${mem.MEM_NO}">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
														    <p class="dropdown-item role" data-rol="R02" data-mno="${mem.MEM_NO}" style="cursor: pointer;">PL</p>
													        <p class="dropdown-item role" data-rol="R03" data-mno="${mem.MEM_NO}" style="cursor: pointer;">TA</p>
													        <p class="dropdown-item role" data-rol="R04" data-mno="${mem.MEM_NO}" style="cursor: pointer;">AA</p>
													        <p class="dropdown-item role" data-rol="R05" data-mno="${mem.MEM_NO}" style="cursor: pointer;">UA</p>
													        <p class="dropdown-item role" data-rol="R06" data-mno="${mem.MEM_NO}" style="cursor: pointer;">DA</p>
													        <p class="dropdown-item role" data-rol="R08" data-mno="${mem.MEM_NO}" style="cursor: pointer;">BA</p>
													    </div>
													</div>
				                            	</c:otherwise>
				                            </c:choose>
		                              </c:if>
		                  	</div>
		              	<div class="col-8"  data-mno="${mem.MEM_NO}">
		                              <c:choose>
			                                <c:when test="${iamPM.memNo eq mem.MEM_NO}">
				                                <button class="btn btn-outline-danger kickOut" data-name="${mem.PROF_NM}" data-id="${mem.MEM_NO}" style="visibility: hidden;">프로젝트에서 내보내기</button>
			                                </c:when>
			                                <c:otherwise>
				                                <button class="btn btn-outline-danger kickOut" data-name="${mem.PROF_NM}" data-id="${mem.MEM_NO}">프로젝트에서 내보내기</button>
			                                </c:otherwise>
		                              </c:choose>
		                  	</div>
		                  </div>
		                          </div>
		                      </div>
		                  </c:forEach>
		             </div>
		             <!--end tab-pane-->
		            </div>
		            <!--end tab-pane-->
		        	</c:when>
		        	<c:otherwise>
		        		<c:forEach var="grp" items="${getGrpList}">
		        			<c:if test="${grp.sprojTtl eq '전체'}">
		                 <div class="tab-pane fade active show" id="custom-v-pills-${grp.sprojTtl}" role="tabpanel" aria-labelledby="custom-v-pills-${grp.sprojTtl}-tab">
		                      <c:forEach var="mem" items="${projMember}" varStatus = "stat">
			                        <div class="d-flex align-items-center mb-3">
				                        <c:choose>
				                        	<c:when test="${iamPM.memNo eq mem.MEM_NO}">
					                        	<div class="form-check form-check-info mb-3">
					                        		<input class="form-check-input" type="checkbox" style="display: none;"/>
					                        	</div>
				                        	</c:when>
				                        	<c:otherwise>
					                        	<div class="form-check form-check-info mb-3">
					                        		<input class="form-check-input chkbox" type="checkbox"/>
					                        	</div>
				                        	</c:otherwise>
				                        </c:choose>
			                            <div class="flex-shrink-0 avatar-sm">
			                                <div class="avatar-title bg-light rounded-circle fs-18">
			                                    <img src="/resources/image/${mem.PROF_PHOTO}" class="rounded-circle avatar-sm" alt="">
			                                </div>
			                            </div>
			                            <div class="flex-grow-1 ms-3">
			                                <h6 class="fs-15">${mem.PROF_NM} <c:if test="${iamPM.memNo eq mem.MEM_NO}"><span style="font-weight: bold;">(나)</span></c:if>
			                                	<c:if test="${!empty mem.ROLE_NM}">(<span id="rn${mem.MEM_NO}">${mem.ROLE_NM}</span>)</c:if>
			                                </h6>
			                                <p class="text-muted mb-0">참여일2 : ${mem.PMEM_IDY}</p>
			                            </div>
			                            
			                            
			                            <div id="box${mem.PROF_NM}">
			                                <c:if test="${!empty mem.ROLE_NM}">
					                            <c:choose>
					                            	<c:when test="${mem.MEM_NO eq memNo}">
						                                <div class="btn-group" id="g${mem.MEM_NO}">
														    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled="disabled">역할</button>
														    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
															    <p class="dropdown-item role" data-rol="R02" data-mno="${mem.MEM_NO}">PL</p>
														        <p class="dropdown-item role" data-rol="R03" data-mno="${mem.MEM_NO}">TA</p>
														        <p class="dropdown-item role" data-rol="R04" data-mno="${mem.MEM_NO}">AA</p>
														        <p class="dropdown-item role" data-rol="R05" data-mno="${mem.MEM_NO}">UA</p>
														        <p class="dropdown-item role" data-rol="R06" data-mno="${mem.MEM_NO}">DA</p>
														        <p class="dropdown-item role" data-rol="R08" data-mno="${mem.MEM_NO}">BA</p>
														    </div>
														</div>
					                            	</c:when>
					                            	<c:otherwise>
						                                <div class="btn-group" id="g${mem.MEM_NO}">
														    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
														    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
															    <p class="dropdown-item role" data-rol="R02" data-mno="${mem.MEM_NO}">PL</p>
														        <p class="dropdown-item role" data-rol="R03" data-mno="${mem.MEM_NO}">TA</p>
														        <p class="dropdown-item role" data-rol="R04" data-mno="${mem.MEM_NO}">AA</p>
														        <p class="dropdown-item role" data-rol="R05" data-mno="${mem.MEM_NO}">UA</p>
														        <p class="dropdown-item role" data-rol="R08" data-mno="${mem.MEM_NO}">BA</p>
														    </div>
														</div>
					                            	</c:otherwise>
					                            </c:choose>
			                                </c:if>
			                                <c:choose>
				                                <c:when test="${iamPM.memNo eq mem.MEM_NO}">
				                                </c:when>
				                                <c:otherwise>
					                                <button class="btn btn-outline-danger kickOut" data-name="${mem.PROF_NM}" data-id="${mem.MEM_NO}">프로젝트에서 내보내기</button>
				                                </c:otherwise>
			                                </c:choose>
			                            </div>
			                        </div>
		                      </c:forEach>
		                 </div>
		                 <!--end tab-pane-->
		        			</c:if>
		        			<c:if test="${grp.sprojTtl ne '전체'}">
		                 <div class="tab-pane fade" id="custom-v-pills-${grp.sprojTtl}" role="tabpanel" aria-labelledby="custom-v-pills-${grp.sprojTtl}-tab" data-grpName="${grp.sprojTtl}">
		
		
		                 </div>
		                 <!--end tab-pane-->
		        			</c:if>
		        		</c:forEach>
		        	</c:otherwise>
		        </c:choose>
		        </div>
		    </div> <!-- end col-->
			  `;
			  
			  $('#promemOnclick').empty();
			  
			  $('#promemOnclick').html(str);
});


//////////////////////////
/* 프로젝트 멤버 - 미정인 사람 그룹 배정 */

$(document).on('click', '.grpList', function(){
	var grp = $(this).attr('data-grplist'); //배정할 그룹명
	var memNo = $(this).attr('data-mno');
	var data = {"newPmemGrp" : grp, "memNo" : memNo};
	
	$.ajax({
		url:"/promem/ungrpToGrp",
		type:"post",
		data: JSON.stringify(data),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			if(res > 0){
			 Swal.fire({
                  text: '배정되었습니다.',
                  icon: 'success',
                  confirmButtonClass: 'btn btn-outline-success mt-2',
                  buttonsStyling: false
                })
                
			}
		}
	});
            $(this).parent().parent().parent().parent().empty();
            $(this).parent().parent().parent().parent().parent().empty();
            $(this).parent().parent().parent().parent().parent().parent().empty();
//             $(this).parent().before().attr("disabled", true);
	
});



var grpC = "";
//////////////////////////
/* 프로젝트 멤버 - 그룹 선택 */
$(document).on('click', '.grpTab', function(event){
	if(event.detail === 2){
		//////////////////////////
		/* 더블 클릭으로 이름 수정하기 */
		$('.grpTab').dblclick(function() {
			var originName = $(this).attr('data-gn');
			var newName = "";
			Swal.fire({
			  title: '그룹명을 수정합니다.',  
			  text: "새 그룹명을 작성해주세요.",
			  input : 'text',
			  showCancelButton: true,
			  closeOnClickOutside:true,
			  closeOnEsc: true, // esc 키 안먹히게(기본 true)
		      confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
		      cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
		      buttonsStyling: false,
		      showCloseButton: true,
			  inputValidator: (value) => {
			    if (!value) {
			      return '그룹명을 작성해주세요.'
			    }else{
			    	newName = value;
			    	
			    	var data = {"newTtl" : newName, "sprojTtl" : originName, "memNo" : ""};
								
					$(this).attr('data-gn', newName);
					$(this).attr('id', 'custom-v-pills-' + newName + '-tab');
					$(this).attr('href', '#custom-v-pills-' + newName + '-tab');
					$(this).attr('aria-controls', 'custom-v-pills-' + newName);
					$(this).find('span').html(newName);

					$.ajax({
						url:"/subproj/newSprojTtl",
						type:"post",
						data: JSON.stringify(data),
						contentType:"application/json; charset=utf-8",
						success:function(res){
							if(res > 0){
								 Swal.fire({
					                  text: '변경되었습니다.',
					                  icon: 'success',
					                  confirmButtonClass: 'btn btn-outline-success mt-2',
					                  buttonsStyling: false
					                })
							}
						}
					});
			    }
			  }
			})
		});

	}else{
		
		$("#pmemListBox").children().remove();
		
		var grpNm = $(this).attr('data-gn');
		console.log("grpNm : ", grpNm);
		
		grpC = grpNm;
		var pm = "${iamPM.memNo}";
		
		if(${yesGrp} == 1 && grpC == 'all' && grpNm != '미정'){ //그룹잇는 프로젝트에서 모두 선택 시
	console.log("그룹 있고 all이고 미정 아님", grpC);
			$.ajax({ //그룹 잇는 프로젝트의 모든 멤버 리스트
				url:"/project/pmemAllList",
				type:"post",
				contentType:"application/json; charset=utf-8",
				success:function(res){
					console.log(res);
					
					var list2 = "";
						list2 += `<div class="tab-pane fade active show" id="custom-v-pills-`+ grpC +`" role="tabpanel" aria-labelledby="custom-v-pills-`+ grpC +`-tab">`;
					$.each(res, function(i, v){
						if(v.MEM_NO == pm){
							list2 += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input" type="checkbox" style="display:none;"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15">` + v.PROF_NM + ` (나)</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
									</div>`;
							
						}else{
							list2 += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input chkbox" type="checkbox"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15">` + v.PROF_NM + `</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
										<div id="box`+ v.PROF_NM +`">
											<div class="row text-end">
												<div class="col-3">
													<div class="btn-group" id="g`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="visibility:hidden;">역할</button>
													</div>
												</div>
												<div class="col-8" data-memNo="`+ v.MEM_NO +`">
					                                <button class="btn btn-outline-danger kickOut" data-name="`+ v.PROF_NM +`" data-id="` + v.MEM_NO + `">프로젝트에서 내보내기</button>
												</div>
											</div>
										</div>
									</div>`;
						}
					});
					list2 += `</div>`;
					
					$("#pmemListBox").append(list2);
				}
			});
			
		}else if(${yesGrp} == 1 && grpC != 'all' && grpNm != '미정'){
			//그룹 있는 프로젝트에서 그룹 선택
			data = {"grp" : grpNm};
			console.log("그룹 있고 all 아니고 미정 아닌 다른 그룹 ", grpNm);
			
			$.ajax({
				url:"/project/pmemGrpList",
				type:"post",
				data: JSON.stringify(data),
				contentType:"application/json; charset=utf-8",
				success:function(res){
					console.log(res);
					var list = "";
						list += `<div class="tab-pane fade active show" id="custom-v-pills-all" role="tabpanel" aria-labelledby="custom-v-pills-all-tab">`;
					$.each(res, function(i, v){
						if(v.MEM_NO == pm){ //pm일 때 (나) 표시와 그룹에서 내보내기 없음
							list += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input" type="checkbox" style="display:none;"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15" id="`+ v.PROF_NM +`" data-grp="`+ grpC +`">` + v.PROF_NM + ` (<span id="rn` + v.MEM_NO+ `">` + v.ROLE_NM + `</span>) (나)</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
										<div id="box`+ v.PROF_NM +`">
											<div class="row text-end">
												<div class="col-4">
													<div class="btn-group" id="g`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ v.MEM_NO +`">
													        <p class="dropdown-item role" data-rol="R02" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">PL</p>
													        <p class="dropdown-item role" data-rol="R03" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">TA</p>
													        <p class="dropdown-item role" data-rol="R04" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">AA</p>
													        <p class="dropdown-item role" data-rol="R05" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">UA</p>
													        <p class="dropdown-item role" data-rol="R06" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">DA</p>
													        <p class="dropdown-item role" data-rol="R08" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">BA</p>
													    </div>
													</div>
												</div>
												<div class="col-8" data-mno="`+ v.MEM_NO +`">
					                                <button class="btn btn-outline-danger outGrp" data-name="`+ v.PROF_NM+`" disabled="true" style="visibility:hidden;">그룹에서 내보내기</button>
												</div>
											</div>
										</div>
									</div>
									`;
							
						}else{ //pm 아닌 멤버들
							
							list += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input" type="checkbox"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15" id="`+ v.PROF_NM +`" data-grp="`+ grpC +`">` + v.PROF_NM + ` (<span id="rn` + v.MEM_NO+ `">` + v.ROLE_NM + `</span>)</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
										<div id="box`+ v.PROF_NM +`">
											<div class="row text-end">
												<div class="col-4">
													<div class="btn-group" id="g`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ v.MEM_NO +`">
													        <p class="dropdown-item role" data-rol="R02" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">PL</p>
													        <p class="dropdown-item role" data-rol="R03" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">TA</p>
													        <p class="dropdown-item role" data-rol="R04" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">AA</p>
													        <p class="dropdown-item role" data-rol="R05" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">UA</p>
													        <p class="dropdown-item role" data-rol="R06" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">DA</p>
													        <p class="dropdown-item role" data-rol="R08" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">BA</p>
													    </div>
													</div>
												</div>
												<div class="col-8" data-mno="` + v.MEM_NO + `">
					                                <button class="btn btn-outline-danger outGrp" data-name="`+ v.PROF_NM+`">그룹에서 내보내기</button>
												</div>
											</div>
										</div>
									</div>
									`;
						}
					});
	
					
					if(${yesGrp} == 1){
						list += `
									<div class="d-flex align-items-center mb-3 btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#intoGrpModal" style="cursor: pointer" id="memIntoGrp">
										<i class="ri-user-add-fill"></i> 참여 멤버 추가
									</div>
								`;
					}
					list += `</div>`;
					
					$("#pmemListBox").append(list);
				}
			});
		}else if(${yesGrp} == 0){
			//그룹 없는 프로젝트
			if(grpC == 'all'){
				grpC = '전체';
			}
			data = {"grp" : grpC};
			console.log("그룹 없이 전체", grpC);
			
			$.ajax({
				url:"/project/pmemGrpList",
				type:"post",
				data: JSON.stringify(data),
				contentType:"application/json; charset=utf-8",
				success:function(res){
					console.log(res);
					var list = "";
						list += `<div class="tab-pane fade active show" id="custom-v-pills-all" role="tabpanel" aria-labelledby="custom-v-pills-all-tab">`;
					$.each(res, function(i, v){
						if(v.MEM_NO == pm){ //pm일 때 (나) 표시와 그룹에서 내보내기 없음
							list += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input" type="checkbox" style="display:none;"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15" id="`+ v.PROF_NM +`" data-grp="`+ grpC +`">` + v.PROF_NM + ` (<span id="rn` + v.MEM_NO+ `">` + v.ROLE_NM + `</span>) (나)</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
										<div id="box`+ v.PROF_NM +`">
											<div class="row text-end">
												<div class="col-4">
													<div class="btn-group" id="g`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled="disabled">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ v.MEM_NO +`">
													        <p class="dropdown-item role" data-rol="R02" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">PL</p>
													        <p class="dropdown-item role" data-rol="R03" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">TA</p>
													        <p class="dropdown-item role" data-rol="R04" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">AA</p>
													        <p class="dropdown-item role" data-rol="R05" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">UA</p>
													        <p class="dropdown-item role" data-rol="R06" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">DA</p>
													        <p class="dropdown-item role" data-rol="R08" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">BA</p>
													    </div>
													</div>
												</div>
												<div class="col-8" data-memNo="`+ v.MEM_NO +`">
					                                <button class="btn btn-outline-danger kickOut" data-name="`+ v.PROF_NM +`" data-id="` + v.MEM_NO + `" style="visibility:hidden;">프로젝트에서 내보내기</button>
												</div>
											</div>
										</div>
									</div>
									`;
							
						}else{ //pm 아닌 멤버들
							
							list += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input" type="checkbox"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15" id="`+ v.PROF_NM +`" data-grp="`+ grpC +`">` + v.PROF_NM + ` (<span id="rn` + v.MEM_NO+ `">` + v.ROLE_NM + `</span>)</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
										<div id="box`+ v.PROF_NM +`">
											<div class="row text-end">
												<div class="col-4">
													<div class="btn-group" id="g`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ v.MEM_NO +`">
													        <p class="dropdown-item role" data-rol="R02" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">PL</p>
													        <p class="dropdown-item role" data-rol="R03" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">TA</p>
													        <p class="dropdown-item role" data-rol="R04" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">AA</p>
													        <p class="dropdown-item role" data-rol="R05" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">UA</p>
													        <p class="dropdown-item role" data-rol="R06" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">DA</p>
													        <p class="dropdown-item role" data-rol="R08" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">BA</p>
													    </div>
													</div>
												</div>
												<div class="col-8" data-memNo="`+ v.MEM_NO +`">
					                                <button class="btn btn-outline-danger kickOut" data-name="`+ v.PROF_NM +`" data-id="` + v.MEM_NO + `">프로젝트에서 내보내기</button>
												</div>
											</div>
										</div>
									</div>
									`;
						}
					});
					
					list += `</div>`;
					
					$("#pmemListBox").append(list);
				}
			});
		}else if(${yesGrp} == 1 && grpNm == '미정'){
			data = {"grp" : grpC};
			console.log("그룹 있는데 미정 고를 때 ", grpNm);
			$.ajax({
				url:"/project/pmemGrpList",
				type:"post",
				data: JSON.stringify(data),
				contentType:"application/json; charset=utf-8",
				success:function(res){
					console.log(res);
					var list = "";
						list += `<div class="tab-pane fade active show" id="custom-v-pills-`+ grpC +`" role="tabpanel" aria-labelledby="custom-v-pills-`+ grpC +`-tab">`;
					$.each(res, function(i, v){
							
							list += `
									<div class="d-flex align-items-center mb-3">
										<div class="form-check form-check-info mb-3">
				                    		<input class="form-check-input" type="checkbox"/>
				                    	</div>
										<div class="flex-shrink-0 avatar-sm">
											<div class="avatar-title bg-light rounded-circle fs-18">
												<img src="/resources/image/` + v.PROF_PHOTO + `" class="rounded-circle avatar-sm" alt="">
											</div>
										</div>
										<div class="flex-grow-1 ms-3">
											<h6 class="fs-15" id="`+ v.PROF_NM +`" data-grp="`+ grpC +`">` + v.PROF_NM + `</h6>
											<p class="text-muted mb-0">가입일 : ` + v.PMEM_IDY + `</p>
										</div>
										<div id="box`+ v.PROF_NM +`">
											<div class="row text-end">
												<div class="col-4">
													<div class="btn-group" id="g`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled="disabled">역할</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ v.MEM_NO +`">
													        <p class="dropdown-item role" data-rol="R02" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">PL</p>
													        <p class="dropdown-item role" data-rol="R03" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">TA</p>
													        <p class="dropdown-item role" data-rol="R04" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">AA</p>
													        <p class="dropdown-item role" data-rol="R05" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">UA</p>
													        <p class="dropdown-item role" data-rol="R06" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">DA</p>
													        <p class="dropdown-item role" data-rol="R08" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">BA</p>
													    </div>
													</div>
												</div>
												<div class="col-8" data-memNo="`+ v.MEM_NO +`">
					                                <div class="btn-group" id="go`+ v.MEM_NO +`">
													    <button type="button" class="btn btn-outline-info dropdown-toggle goToGrp" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">그룹 배정</button>
													    <div class="dropdown-menu dropdownmenu-secondary" id="goTo`+ v.MEM_NO +`">
													    	<c:forEach var="grp" items="${getGrpList}">
													    		<c:if test="${grp.sprojTtl ne '미정'}">
														    	    <p class="dropdown-item grpList" data-grpList="${grp.sprojTtl}" data-mno="`+ v.MEM_NO +`" style="cursor:pointer;">${grp.sprojTtl}</p>
														    	</c:if>
														    </c:forEach>
													    </div>
													</div>
												</div>
											</div>
										</div>
									</div>
									`;
					});
					
					list += `</div>`;
					
					$("#pmemListBox").append(list);
				}
			});
			
		}
	
	}
})

//////////////////////////
/* 멤버 그룹 추가하기 */
$('#newGrp').on('click', function(){
	var newGrpName = $('#newGrpName').val(); //새 그룹명
	
	//탭에 새 그룹명 추가
	var newGrp = `
					<a class="nav-link grpTab" id="custom-v-pills-`+ newGrpName +`-tab" data-gn="`+ newGrpName +`" data-bs-toggle="pill" href="#custom-v-pills-`+ newGrpName +`" role="tab" aria-controls="custom-v-pills-`+ newGrpName +`" aria-selected="false">
				        <i class="bx bx-subdirectory-right"></i> <span> `+ newGrpName +`</span>
				    </a>
				 `;
	var yesGrp = ${yesGrp};
	if(yesGrp == 0){
		var str = '미정';
		newGrp += `
					<a class="nav-link grpTab" id="custom-v-pills-`+ str +`-tab" data-gn="`+ str +`" data-bs-toggle="pill" href="#custom-v-pills-`+ str +`" role="tab" aria-controls="custom-v-pills-`+ str +`" aria-selected="false">
				        <i class="bx bx-subdirectory-right"></i> <span> `+ str +`</span>
				    </a>
				 `;
	}
	
	//새 탭으로 추가
	$('#grpTabs').append(newGrp);
	
	
	//pm을 해당 그룹 참여자로 추가하기
	var data = {"projId" : "${projId}", "pmemGrp" : newGrpName};
	
	
	$.ajax({
		url:"/promem/newGrp",
		type:"post",
		data:JSON.stringify(data),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			console.log("그룹 새로 추가한 후 가져온 값");
			console.log(res);
			
			$('#newGrpName').val("");
		    Swal.fire({
	            text: '추가되었습니다.',
	            imageUrl: '/resources/image/alertLogo.png',
	            imageHeight: 25,
	            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
		}
	});
	
	$("#newGrpModal").modal('hide');
})



//////////////////////////
/* 미정에서 그룹 배정하기 */
// $(document).on('click', ".grpList", function(){
// 	var grp = $(this).attr('data-grpList');
// 	var memNo = $(this).attr('data-mno');
	
// 	console.log('grp ', grp);
// 	console.log('memNo ', memNo);
// })


//////////////////////////
/* 그룹 관리에서 그룹 일괄 추가하기 */
$('#addGrpToTable').keydown(function(key){
	if(key.keyCode == 13){
		var grpName = $(this).val();
		var str = `<tr><td><span>` + grpName + `</span><i class="ri-close-circle-fill align-middle text-danger delGrp" style="cursor: pointer"></i></td></tr>`;
		
		$('#grpTable').append(str);
		
		
	}
});


//////////////////////////
/* 참여 멤버 그룹 배정하기 */
var memList = new Array;



/*
//modal이 열릴 때 다시 영역 한정 (appendTo 옵션)
$("#intoGrpModal").on("shown.bs.modal", function() {
  $("#newMem").autocomplete("option", "appendTo", "#intoGrpModal")
})
*/

//autocomplete
$(document).on('click', '#memIntoGrp', function(){
/*			$('#newMem').autocomplete({
		        source : function(reuqest, response) {
		            $.ajax({
						url:"/project/pmemAllList",
		                type : 'post',
		                dataType : 'json',
		                success : function(res) {
		                    // 서버에서 json 데이터 response 후 목록 추가
		                    response(
		                        $.map(res, function(item) {
		                    console.log("item이 뭐야");
		                    console.log(item);
		                            return {
		                                label : item.PROF_NM,
		                                value : item.PROF_NM,
		                                projId : item.PROJ_ID,
		                                pmemIdy : item.PMEM_IDY,
		                                profPhoto : item.PROF_PHOTO
		                                
		                            }
		                        })
		                    );
		                }
		            });
		        },
		        select : function(event, ui) { //아이템 선택 시
		            console.log("ui 찍는 부분 시작");
		            console.log(ui); //오토컴 목록에서 선택하면 반환되는 객체
		            console.log(ui.item.label); //
		            console.log(ui.item.value);
		            console.log(ui.item.test);
		            console.log("ui 찍는 부분 끄읕");
		        },
		        focus : function(event, ui) {
		            return false; //한글 에러 잡기용
		        },
		        minLength : 1, //최소 입력 글자 수
		        autoFocus : true, //첫 항목 자동 포커스. 기본값 false
		        classes : {
		            'ui-autocomplete': 'highlight'
		        },
		        delay : 500, //글 쓰고나서 autocom 창 뜰 때까지 딜레이 시간(ms)
		        position : { my : 'right top', at : 'right bottom' },
		        close : function(event) { //자동 완성 창 닫아질 때 호출
		            console.log("event 찍는 곳 시작");
		            console.log(event);
		            console.log("event 찍는 곳 끄읕");
		        }
		    }).autocomplete( "instance" )._renderItem = function( ul, item ) {//UI를 마음대로 변경하는 부분
                return $( "<li>" )    //기본 tag가 li로 되어 있음 
                .append( "<div class='d-flex align-items-center mb-3'><div class='flex-shrink-0 avatar-sm'><div class='avatar-title bg-light rounded-circle fs-18'><img src='/resources/image/" + item.profPhoto + "' class='rounded-circle avatar-sm' alt=''></div></div><div class='flex-grow-1 ms-3'><h6 class='fs-15' id='"+ item.label +"' data-grp='"+ grpC +"'>" + item.label + "</h6></div></div></li>") //원하는 모양의 HTML을 만들면 UI가 원하는 모양으로 출력
                .appendTo( ul );
         };
         
         
*/
         
       //프로젝트 회원 검색
//          $(".minput").keyup(function(){
//          	$("#memberInfo").children().remove();
//          	var con = $(".finput").val();
//          	$.ajax({
//          		url: "/project/pmemAllList?content="+con,
//          		type: 'GET',
//          		dataType: 'json',
//          		success : function(data){
//          			var code = "";
//          			$.each(data,function(i,v){
//          				console.log(v)
//                          code += "<a href='#' id='promembox' data-memNo='" + v.MEM_NO+ "' class='dropdown-item notify-item py-2' style='display: block;'>";
//                          code += "<div class='d-flex'>";
//                          code += "<div class='flex-1'>";
//                          code += "<h6 class='m-0 memberId'>"+v.MEM_ID+"</h6>";
//                          code += "<span class='fs-11 mb-0 text-muted promemName'>"+v.+"</span>";
//                          code += "</div>";
//                          code += "</div>";
//                          code += "</a>";
//          			});
//          			console.log(code);
//          			$("#promemInfo").append(code);
//          		},
//          	});
//          });
       
         $(".minput").keyup(function(){
         	$("#memberInfo2").children().remove();
         	var con = $(".minput").val();
         	$.ajax({
         		url: "/searchMem?content="+con+"&cnt=1",
         		type: 'GET',
         		dataType: 'json',
         		success : function(data){
         			var code = "";
         			$.each(data,function(i,v){
         				console.log("each 돌릴 때 : ",v);
						code += "<a href='#' data-memNo='" + v.MEM_NO+ "' class='dropdown-item notify-item py-2' style='display: block;'>";
							code += "<div class='d-flex'>";
								code += "<div class='col-2'>";
									code += "<img src='/resources/image/" + v.PROF_PHOTO +"' class='rounded-circle avatar-xs'>";
								code += "</div>";
								code += "<div class='col-10'>";
									code += "<h6 class='m-0 profNm'>"+v.PROF_NM+"</h6>";
//                          		code += "<span class='fs-11 mb-0 text-muted memberName'>"+v.PROF_NM+"</span>";
								code += "</div>";
							code += "</div>";
						code += "</a>";
         			});
         			console.log(" 완성된 코드 : ", code);
         			$("#memberInfo2").append(code);
         		},
         	});
         });
});


//////////////////////////
/* autocom 목록에서 선택 후 그룹 배정 혹은 enter 누르면 그룹 추가하기 */

// 1. 그룹 배정 버튼 눌러서
$('#newMemSave').on('click', function(){
	var profNm= $('#newMem').val(); //입력한 이메일
	
	var data = {"profNm" : profNm, "pmemGrp" : grpC};
	
	$.ajax({
		url:"/promem/newMemIntoGrp",
		type:"post",
		data:JSON.stringify(data),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			console.log("그룹 새로 추가한 후 가져온 값");
			console.log(res);
			$('#newMem').val(""); //기존 값 없애기
			
			if(res.cnt > 0){
				var str = `
					<div class="d-flex align-items-center mb-3">
						<div class="form-check form-check-info mb-3">
	                		<input class="form-check-input" type="checkbox"/>
	                	</div>
						<div class="flex-shrink-0 avatar-sm">
							<div class="avatar-title bg-light rounded-circle fs-18">
								<img src="/resources/image/` + res.profPhoto + `" class="rounded-circle avatar-sm" alt="">
							</div>
						</div>
						<div class="flex-grow-1 ms-3">
							<h6 class="fs-15" id="`+ res.profNm +`" data-grp="`+ grpC +`">` + res.profNm + ` (<span id="rn` + res.memNo+ `">` + res.roleNm + `</span>)</h6>
							<p class="text-muted mb-0">가입일 : ` + res.pmemIdy2 + `</p>
						</div>
						<div id="box`+ res.profNm +`">
							<div class="row text-end">
								<div class="col-4">
									<div class="btn-group" id="g`+ res.memNo +`">
									    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
									    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ res.memNo +`">
									        <p class="dropdown-item role" data-rol="R02" data-mno="`+ res.memNo +`" style="cursor:pointer;">PL</p>
									        <p class="dropdown-item role" data-rol="R03" data-mno="`+ res.memNo +`" style="cursor:pointer;">TA</p>
									        <p class="dropdown-item role" data-rol="R04" data-mno="`+ res.memNo +`" style="cursor:pointer;">AA</p>
									        <p class="dropdown-item role" data-rol="R05" data-mno="`+ res.memNo +`" style="cursor:pointer;">UA</p>
									        <p class="dropdown-item role" data-rol="R06" data-mno="`+ res.memNo +`" style="cursor:pointer;">DA</p>
									        <p class="dropdown-item role" data-rol="R08" data-mno="`+ res.memNo +`" style="cursor:pointer;">BA</p>
									    </div>
									</div>
								</div>
								<div class="col-8" data-mno="` + res.memNo + `">
	                                <button class="btn btn-outline-danger outGrp" data-name="`+ res.profNm+`">그룹에서 내보내기</button>
								</div>
							</div>
						</div>
					</div>
				  `;
				
				$('#custom-v-pills-all').children(':last-child').before(str); //목록에 추가하기
			    Swal.fire({
		            text: '추가되었습니다.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
			}
		}
	});
})


// 2. enter 누르면 그룹 배정
$('#newMem').keydown(function(key){
	if(key.keyCode == 13){
		var profNm = $(this).val(); //입력한 이메일
		
		var data = {"profNm" : profNm, "pmemGrp" : grpC};
		
		$.ajax({
			url:"/promem/newMemIntoGrp",
			type:"post",
			data:JSON.stringify(data),
			contentType:"application/json; charset=utf-8",
			success:function(res){
				console.log("그룹 새로 추가한 후 가져온 값");
				console.log(res);
				$('#newMem').val(""); //기존 값 없애기
				
				if(res.cnt > 0){
					var str = `
						<div class="d-flex align-items-center mb-3">
							<div class="form-check form-check-info mb-3">
		                		<input class="form-check-input" type="checkbox"/>
		                	</div>
							<div class="flex-shrink-0 avatar-sm">
								<div class="avatar-title bg-light rounded-circle fs-18">
									<img src="/resources/image/` + res.profPhoto + `" class="rounded-circle avatar-sm" alt="">
								</div>
							</div>
							<div class="flex-grow-1 ms-3">
								<h6 class="fs-15" id="`+ res.profNm +`" data-grp="`+ grpC +`">` + res.profNm + ` (<span id="rn` + res.memNo+ `">` + res.roleNm + `</span>)</h6>
								<p class="text-muted mb-0">가입일 : ` + res.pmemIdy2 + `</p>
							</div>
							<div id="box`+ res.profNm +`">
								<div class="row text-end">
									<div class="col-4">
										<div class="btn-group" id="g`+ res.memNo +`">
										    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
										    <div class="dropdown-menu dropdownmenu-secondary" id="g`+ res.memNo +`">
										        <p class="dropdown-item role" data-rol="R02" data-mno="`+ res.memNo +`" style="cursor:pointer;">PL</p>
										        <p class="dropdown-item role" data-rol="R03" data-mno="`+ res.memNo +`" style="cursor:pointer;">TA</p>
										        <p class="dropdown-item role" data-rol="R04" data-mno="`+ res.memNo +`" style="cursor:pointer;">AA</p>
										        <p class="dropdown-item role" data-rol="R05" data-mno="`+ res.memNo +`" style="cursor:pointer;">UA</p>
										        <p class="dropdown-item role" data-rol="R06" data-mno="`+ res.memNo +`" style="cursor:pointer;">DA</p>
										        <p class="dropdown-item role" data-rol="R08" data-mno="`+ res.memNo +`" style="cursor:pointer;">BA</p>
										    </div>
										</div>
									</div>
									<div class="col-8" data-mno="` + res.memNo + `">
		                                <button class="btn btn-outline-danger outGrp" data-name="`+ res.profNm+`">그룹에서 내보내기</button>
									</div>
								</div>
							</div>
						</div>
					  `;
					
					$('#custom-v-pills-all').children(':last-child').before(str); //목록에 추가하기
					
				    Swal.fire({
			            text: '추가되었습니다.',
			            imageUrl: '/resources/image/alertLogo.png',
			            imageHeight: 25,
			            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
			            buttonsStyling: false,
			            showCloseButton: true
			      	})
				}
			}
		});
	}
});


//그룹에 새로운 사람 추가하려다 닫기 버튼 누르면 내용 비우기
$('#newMemClose').on('click', function(){
	$('#newMem').val(""); //기존 값 없애기
})


//////////////////////////
/* 멤버 초대하기 누르면 그룹 생성했을 수도 있어서 그룹 리스트 다시 불러오기 */
$('#memInvi').on('click', function(){
<%-- 	var projId = <%=projId; --%>
	
// 	$.ajax({
// 		url:"/project/grpList",
// 		type:"post",
// 		data:JSON.stringify(projId),
// 		contentType:"application/json; charset=utf-8",
// 		success:function(res){
			
// 		}
// 	});
	
})


//////////////////////////
/* 멤버 초대하려고 이메일 검색해서 table에 넣기 */
var num1 = 0; //inviteModal1
var num2 = 0; //inviteModal2
var emailArr = [];
var grpArr = [];

$(document).on('click', '#membox', function(){
	var email = $(this).children('div').find('h6').html();
	for(i=0; i < emailArr.length; i++){
		if(email == emailArr[i]){
		    Swal.fire({
	            text: '이미 추가했습니다.',
	            icon: 'warning',
	            confirmButtonClass: 'btn btn-warning w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
			return;
		}
	}
	emailArr.push(email);
	
	if(num2 < num1){
		var str =  `
			<tr>
				<td style="width:45%;">
					<span data-num="2">` + email + `</span> <i class="ri-close-circle-fill align-middle text-danger delEmail" style="cursor: pointer"></i>
				</td>
				<td style="width:45%;">
			<c:choose>
				<c:when test="${empty grpList}">
					<div class="btn-group">
						<button type="button" id="selectedGrp"+num2 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">전체</button>
					    <div class="dropdown-menu dropdownmenu-secondary grpNames">
							<p class="dropdown-item selectGrp" href="javascript:changeType('전체')">
								<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="2" style="cursor: pointer">전체</span>
							</p>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="btn-group">
						<button type="button" id="selectedGrp"+num2 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">그룹 선택</button>
					    <div class="dropdown-menu dropdownmenu-secondary grpNames">
							<c:forEach var="grps" items="${grpList}">
								<p class="dropdown-item selectGrp" href="javascript:changeType('${grps.PMEM_GRP}')">
									<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="2" style="cursor: pointer">${grps.PMEM_GRP}</span>
								</p>
							</c:forEach>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			`;
					
		$('#inviteModalBody2').append(str);
		num2 += 1;
	}else{
		var str =  `<tr>
			<td style="width:45%;">
				<span data-num="1">` + email + `</span> <i class="ri-close-circle-fill align-middle text-danger delEmail" style="cursor: pointer"></i>
			</td>
			<td style="width:45%;">
					<c:choose>
						<c:when test="${empty grpList}">
							<div class="btn-group">
								<button type="button" id="selectedGrp"+num1 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">전체</button>
							    <div class="dropdown-menu dropdownmenu-secondary grpNames">
									<p class="dropdown-item selectGrp" href="javascript:changeType('전체')">
										<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="1" style="cursor: pointer">전체</span>
									</p>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="btn-group">
								<button type="button" id="selectedGrp"+num1 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">그룹 선택</button>
							    <div class="dropdown-menu dropdownmenu-secondary grpNames">
									<c:forEach var="grps" items="${grpList}">
										<p class="dropdown-item selectGrp" href="javascript:changeType('${grps.PMEM_GRP}')">
											<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="1" style="cursor: pointer">${grps.PMEM_GRP}</span>
										</p>
									</c:forEach>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
			</td>
		</tr>`;
					
		$('#inviteModalBody1').append(str);
		num1 += 1;
	}
	$('#search-options').val("");
})



//////////////////////////
/* 멤버 초대하려고 이메일 직접 입력해서 enter로 table에 넣기 */
$('#search-options').keydown(function(key){
	if(key.keyCode == 13){
		var email = $(this).val(); //입력한 이메일
		
		for(i=0; i < emailArr.length; i++){
			if(email == emailArr[i]){
			    Swal.fire({
		            text: '이미 추가했습니다.',
		            icon: 'warning',
		            confirmButtonClass: 'btn btn-warning w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
				return;
			}
		}
		emailArr.push(email);
		
		if(num2 < num1){
			var str =  `
						<tr>
							<td style="width:45%;">
								<span data-num="2">` + email + `</span> <i class="ri-close-circle-fill align-middle text-danger delEmail" style="cursor: pointer"></i>
							</td>
							<td style="width:45%;">
						<c:choose>
							<c:when test="${empty grpList}">
								<div class="btn-group">
									<button type="button" id="selectedGrp"+num2 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">전체</button>
								    <div class="dropdown-menu dropdownmenu-secondary grpNames">
										<p class="dropdown-item selectGrp" href="javascript:changeType('전체')">
											<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="2" style="cursor: pointer">전체</span>
										</p>
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="btn-group">
									<button type="button" id="selectedGrp"+num2 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">그룹 선택</button>
								    <div class="dropdown-menu dropdownmenu-secondary grpNames">
										<c:forEach var="grps" items="${grpList}">
											<p class="dropdown-item selectGrp" href="javascript:changeType('${grps.PMEM_GRP}')">
												<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="2" style="cursor: pointer">${grps.PMEM_GRP}</span>
											</p>
										</c:forEach>
									</div>
								</div>
							</c:otherwise>
						</c:choose>
							</td>
						</tr>
						`;
			
			$('#inviteModalBody2').append(str);
			num2 += 1;
		}else{
			var str =  `<tr>
				<td style="width:45%;">
					<span data-num="1">` + email + `</span> <i class="ri-close-circle-fill align-middle text-danger delEmail" style="cursor: pointer"></i>
				</td>
				<td style="width:45%;">
						<c:choose>
							<c:when test="${empty grpList}">
								<div class="btn-group">
									<button type="button" id="selectedGrp"+num1 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">전체</button>
								    <div class="dropdown-menu dropdownmenu-secondary grpNames">
										<p class="dropdown-item selectGrp" href="javascript:changeType('전체')">
											<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="1" style="cursor: pointer">전체</span>
										</p>
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="btn-group">
									<button type="button" id="selectedGrp"+num1 class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="min-width:110px;">그룹 선택</button>
								    <div class="dropdown-menu dropdownmenu-secondary grpNames">
										<c:forEach var="grps" items="${grpList}">
											<p class="dropdown-item selectGrp" href="javascript:changeType('${grps.PMEM_GRP}')">
												<i class="bx bx-subdirectory-right"></i> <span class="selectedGrp" data-tb="1" style="cursor: pointer">${grps.PMEM_GRP}</span>
											</p>
										</c:forEach>
									</div>
								</div>
							</c:otherwise>
						</c:choose>
				</td>
			</tr>`;
			
			$('#inviteModalBody1').append(str);
			num1 += 1;
		}
		$('#search-options').val("");
	}
});

 
//////////////////////////
/* 멤버 초대하려고 이메일 검색해서 table에 빼기 */

$(document).on('click', '.delEmail', function(){
	var tr = $(this).parent().parent();
	var email = $(this).prev().html();
	var idx = 0;
	var click = $(this).prev().attr("data-num");
	
	console.log("adsfdasf  " + emailArr);
	
	//배열에서 빼기
	for(i=0; i < emailArr.length; i++){
		if(email == emailArr[i]){
			idx = i;
		}
	}
	emailArr.splice(idx, 1);
	console.log(emailArr);

	//요소 삭제
	tr.remove();
	
	//num -1하기
	if(click == 1){
		num1 -= 1;
	}else{
		num2 -= 1;
	}
	
})


//////////////////////////
/* 프로젝트 멤버 초대할 때 그룹 지정하는 그룹박스 */
$(document).on('click', '.selectedGrp', function(){
	
	var grpName = $(this).html();
	$(this).parent().parent().prev().html(grpName);
	
	var emailAddress = $(this).parent().parent().parent().parent().prev().find('span:eq(0)').html();

})


//////////////////////////
/* 프로젝트 멤버 초대 */
$(".invite").on('click', function(){
	var emails1 = new Array();
	var groups1 = new Array();
	var emails2 = new Array();
	var groups2 = new Array();
	
	for(i=0; i<num1; i++){
		var em = $('#inviteModalBody1').find('tr:eq('+ i +')').find('td:eq(0)').find('span:eq(0)').html();
		var gr = $('#inviteModalBody1').find('tr:eq('+ i +')').find('td:eq(1)').find('button').html();
		
		if(gr == '그룹 선택'){
			Swal.fire({
	            text: '그룹을 선택해주세요.',
	            imageUrl: '/resources/image/alertLogo.png',
	            imageHeight: 25,
	            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
			emails1 = [];
			groups1 = [];
			num1 = 0;
	console.log("배열 비워졌나? ********************************");
	console.log(emails1);
	console.log(groups1);
			return;
		}
		
		emails1.push(em);
		groups1.push(gr);
		
	console.log("email" , emails1);
	console.log("group", groups1);
		
	}
	
	for(i=0; i<num2; i++){
		var em = $('#inviteModalBody2').find('tr:eq('+ i +')').find('td:eq(0)').find('span:eq(0)').html();
		var gr = $('#inviteModalBody2').find('tr:eq('+ i +')').find('td:eq(1)').find('button').html();
		
		if(gr == '그룹 선택'){
			Swal.fire({
	            text: '그룹을 선택해주세요.',
	            imageUrl: '/resources/image/alertLogo.png',
	            imageHeight: 25,
	            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
			emails2 = [];
			groups2 = [];
			num2 = 0;
	console.log("배열 비운 뒤");
			return;
		}

		emails2.push(em);
		groups2.push(gr);
	}
	
	console.log(emails1);
	console.log(groups1);
	console.log("*********************************");
	console.log(emails2);
	console.log(groups2);
	
	var ttl = "${projInfo.get('PROJ_TTL')}";
	var projCn = "${projInfo.get('PROJ_CN')}";
	var projId = ${projId};
	var alertMemNo = "";
	var ranKey = "";
	
	
	data = {"emailArr1" : emails1,
			"emailArr2" : emails2,
			"groupsArr1" : groups1,
			"groupsArr2" : groups2,
			"ttl" : ttl,
			"projCn" : projCn
			};
	
	
	console.log("*******rkrkrkrk**************************");
	console.log(emails1);
	console.log(groups1);
	console.log("*********************************");
	console.log(emails2);
	console.log(groups2);
	
	$.ajax({
		url:"/invite/invitation",
		type:"post",
		data:JSON.stringify(data),
		contentType:"application/json; charset=utf-8",
		async: false,
		success:function(res){
			console.log(res);
			Swal.fire({
		        text: '초대 완료',
		        icon: 'success',
		        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
		        buttonsStyling: false,
		        showCloseButton: true
		  	})
		}
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	
	for(i=0; i<emails1.length; i++){
		
		var data = {"memId" : emails1[i]};
		console.log("emails1", data);

		
		//프로미스로 바꿔보기
console.log("회원인가?");
		//회원 비회원 구분
		$.ajax({
			url:"/ifMem",
			type:"post",
			data:JSON.stringify(data),
			contentType:"application/json; charset=utf-8",
			async: false,
			success:function(res){
				console.log("afsdfaewfsadfwaeiofjsda " , res);
				if(res.cnt == 0){ //회원임. 그럼 이미 참여 중인지?
console.log("ㅇㅇ 회원임. 그럼 이미 이 프로젝트 참여 중?");
					alertMemNo = res.memNo;
					data = {"memId" : emails1[i],
							"projId" : projId};
					$.ajax({
						url:"/promem/isAlreadyMem",
						type:"post",
						data:JSON.stringify(data),
						contentType:"application/json; charset=utf-8",
						async: false,
						success:function(res){
							if(res > 0){ //이미 참여 중이면 그만
console.log("ㅇㅇ 이미 참여중. 그만~");
								//return 적으면 다 끝나지 않나????????????
							}else{
console.log("ㄴㄴ 참여 멤버 아니니 초대장 보내야됨!");
console.log("어 근데 초대장 이미 보냈나?");
								//회원이지만 참여 중이지 않음
								//근데 초대장 이미 보냈나?
								data = {"invEmail" : emails1[i],
										"projId" : projId,
										"pmemGrp" : groups1[i]};
								$.ajax({
									url:"/invite/inviChk",
									type:"post",
									data:JSON.stringify(data),
									contentType:"application/json; charset=utf-8",
									async: false,
									success:function(res){
										data = {"invEmail" : emails1[i],
												"projId" : projId,
												"pmemGrp" : groups1[i]};
										if(res.invCd != null){
console.log("ㅇㅇ 이미 보냄! 그니까 rankey update만 하자");
											$.ajax({//이미 보낸 사람이니 rankey만 update
												url:"/invite/inviUpdate",
												type:"post",
												data:JSON.stringify(data),
												contentType:"application/json; charset=utf-8",
												async: false,
												success:function(res){
													if(res != null){
console.log("ㅇㅇ 업뎃하고서 ranKey 가져옴!");
														ranKey = res.invCd;
														data = {"invEmail" : emails1[i],
																"ttl" : ttl,
																"projCn" : projCn,
																"ranKey" : ranKey,
																"pmemGrp" : groups1[i]
																};
console.log("좋아! 이제 진짜 이메일 보내자");
														$.ajax({//이메일 발송
															url:"/invite/sendEmail",
															type:"post",
															data:JSON.stringify(data),
															contentType:"application/json; charset=utf-8",
															async: false,
															success:function(res){
																data = {"projId" : projId,
																		"memNo" : alertMemNo,
																		"pmemGrp" : groups1[i]
																		};
																if(res > 0){
																	$.ajax({//promem에도 insert
																		url:"/promem/joinProjfromInvi",
																		type:"post",
																		data:JSON.stringify(data),
																		contentType:"application/json; charset=utf-8",
																		async: false,
																		success:function(res){
																			if(res > 0){
console.log("ㅇㅇ 함! 수락하면 프로필 생길거야 이제");
																				data = {"memNo" : alertMemNo,
																						"ttl" : ttl,
																						"ranKey" : ranKey,
																						"projId" : projId,
																						"pmemGrp" : groups1[i]
																						};
																				$.ajax({//alert에도 insert
																					url:"/alert/invitation",
																					type:"post",
																					data:JSON.stringify(data),
																					contentType:"application/json; charset=utf-8",
																					async: false,
																					success:function(res){
																						data = {"projId" : projId,
																								"memNo" : alertMemNo,
																								"pmemGrp" : groups1[i]
																								};
																						if(res > 0){
console.log("ㅇㅇ alert에도 넣음! 끝!");
																							Swal.fire({
																						        text: '초대 완료',
																						        icon: 'success',
																						        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
																						        buttonsStyling: false,
																						        showCloseButton: true
																						  	})
																						}
																					}
																				});
																			}
																		}
																	});
																}
															}
														});
													}
												}
											});
										}else{
console.log("ㄴㄴ 안 보냄! 처음 보내는거야");
											data = {"invEmail" : emails1[i],
													"projId" : projId,
													"pmemGrp" : groups1[i]
													};
											//이미 회원이고 초대장 처음 보냄
											$.ajax({//처음 보내는 거니까 초대장 insert. 일단 ranKey 가져오고 insert
												url:"/invite/invitation",
												type:"post",
												data:JSON.stringify(data),
												contentType:"application/json; charset=utf-8",
												async: false,
												success:function(res){
													if(res.invCd != null){
console.log("ㅇㅇ 좋아 초대장 insert 햇어!");
														ranKey = res.invCd;
														data = {"invEmail" : emails1[i],
																"ttl" : ttl,
																"projCn" : projCn,
																"ranKey" : ranKey,
																"pmemGrp" : groups1[i]
																};
console.log("이제 진짜 이메일 보내보자!!!");
														$.ajax({//이메일 발송
															url:"/invite/sendEmail",
															type:"post",
															data:JSON.stringify(data),
															contentType:"application/json; charset=utf-8",
															async: false,
															success:function(res){
console.log("이메일도 보냄~~~!");
console.log("ㅇㅋ promem에도 넣자");
																data = {"projId" : projId,
																		"memNo" : alertMemNo,
																		"pmemGrp" : groups1[i]
																		};
																$.ajax({//alert에도 insert
																	url:"/promem/joinProjfromInvi",
																	type:"post",
																	data:JSON.stringify(data),
																	contentType:"application/json; charset=utf-8",
																	async: false,
																	success:function(res){
																		if(res > 0){
console.log("ㅇㅇ 넣음! alert에도 넣자");
																			data = {"memNo" : alertMemNo,
																					"ttl" : ttl,
																					"ranKey" : ranKey,
																					"projId" : projId,
																					"pmemGrp" : groups1[i]
																					};
																			$.ajax({//alert에도 insert
																				url:"/alert/invitation",
																				type:"post",
																				data:JSON.stringify(data),
																				contentType:"application/json; charset=utf-8",
																				async: false,
																				success:function(res){
																					data = {"projId" : projId,
																							"memNo" : alertMemNo,
																							"pmemGrp" : groups1[i]
																							};
																					if(res > 0){
console.log("ㅇㅇ alert에도 넣음! 끝!");
																						Swal.fire({
																					        text: '초대 완료',
																					        icon: 'success',
																					        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
																					        buttonsStyling: false,
																					        showCloseButton: true
																					  	})
																					}
																				}
																			});
																		}
																	}
																});
															}
														});
													}
												}
											});
										}
									}
								});
								
							}
						}
					});
				}else{
console.log("ㄴㄴ 회원 아님. 비회원임.");
					data = {"invEmail" : emails1[i],
							"projId" : projId,
							"pmemGrp" : groups1[i]
							};
					//비회원이면 바로 이메일 보내기
					//이미 보냈는지 확인
console.log("이미 초대장 보냈던 이메일인가?");
					$.ajax({
						url:"/invite/inviChk",
						type:"post",
						data:JSON.stringify(data),
						contentType:"application/json; charset=utf-8",
						async: false,
						success:function(res){
							if(res.invNo != 0){ //이미 보낸적 있으니 update
console.log("ㅇㅇ 이미 보냇음. ranKey만 update하자!");
								$.ajax({//이미 보낸 사람이니 rankey만 update
									url:"/invite/inviUpdate",
									type:"post",
									data:JSON.stringify(data),
									contentType:"application/json; charset=utf-8",
									async: false,
									success:function(res){
										if(res != null){
console.log("ㅇㅇ 업뎃 하고 ranKey도 가져왔어!");
											ranKey = res.invCd;
											data = {"invEmail" : emails1[i],
													"ttl" : ttl,
													"projCn" : projCn,
													"ranKey" : ranKey,
													"pmemGrp" : groups1[i]
													};
console.log("오키키 이메일 보내자!");
											$.ajax({//이메일 발송
												url:"/invite/sendEmail",
												type:"post",
												data:JSON.stringify(data),
												contentType:"application/json; charset=utf-8",
												async: false,
												success:function(res){
													Swal.fire({
												        text: '초대 완료',
												        icon: 'success',
												        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
												        buttonsStyling: false,
												        showCloseButton: true
												  	})
													
												}
											});
										}
									}
								});
							}else{
console.log("ㄴㄴ 이메일 처음 보냄!");
								data = {"invEmail" : emails1[i],
										"projId" : projId,
										"pmemGrp" : groups1[i]
										};
								//초대장 처음 보냄
								$.ajax({//처음 보내는 거니까 초대장 insert. 일단 ranKey 가져오고 insert
									url:"/invite/invitation",
									type:"post",
									data:JSON.stringify(data),
									contentType:"application/json; charset=utf-8",
									async: false,
									success:function(res){
										if(res.invCd != null){
console.log("ㅇㅇ 좋아 초대장 insert 햇어!");
										ranKey = res.invCd;
										data = {"invEmail" : emails1[i],
												"ttl" : ttl,
												"projCn" : projCn,
												"ranKey" : ranKey,
												"pmemGrp" : groups1[i]
												};
console.log("이제 진짜 이메일 보내보자!!!");
										$.ajax({//이메일 발송
											url:"/invite/sendEmail",
											type:"post",
											data:JSON.stringify(data),
											contentType:"application/json; charset=utf-8",
											async: false,
											success:function(res){
console.log("이메일도 보냄~~~!");
													Swal.fire({
												        text: '초대 완료',
												        icon: 'success',
												        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
												        buttonsStyling: false,
												        showCloseButton: true
												  	})
												}
											});
										}
									}
								});
							}
						}
					});
				}
			}
		});
	}
	
	
	for(i=0; i<emails2.length; i++){
		
		var data = {"memId" : emails2[i]};
		console.log("emails2", data);
		
		console.log("회원인가?");

		//회원 비회원 구분
		$.ajax({
			url:"/ifMem",
			type:"post",
			data:JSON.stringify(data),
			contentType:"application/json; charset=utf-8",
			async: false,
			success:function(res){
				console.log("afsdfaewfsadfwaeiofjsda " , res.memNo); 
				if(res.cnt == 0){ //회원임. 그럼 이미 참여 중인지?
console.log("ㅇㅇ 회원임. 그럼 이미 이 프로젝트 참여 중?");
					alertMemNo = res.memNo;
					data = {"memId" : emails2[i],
							"projId" : projId};
					$.ajax({
						url:"/promem/isAlreadyMem",
						type:"post",
						data:JSON.stringify(data),
						contentType:"application/json; charset=utf-8",
						async: false,
						success:function(res){
							if(res > 0){ //이미 참여 중이면 그만
console.log("ㅇㅇ 이미 참여중. 그만~");
								//return 적으면 다 끝나지 않나????????????
							}else{
console.log("ㄴㄴ 참여 멤버 아니니 초대장 보내야됨!");
console.log("어 근데 초대장 이미 보냈나?");
								//회원이지만 참여 중이지 않음
								//근데 초대장 이미 보냈나?
								data = {"invEmail" : emails2[i],
										"projId" : projId,
										"pmemGrp" : groups2[i]};
								$.ajax({
									url:"/invite/inviChk",
									type:"post",
									data:JSON.stringify(data),
									contentType:"application/json; charset=utf-8",
									async: false,
									success:function(res){
										data = {"invEmail" : emails2[i],
												"projId" : projId,
												"pmemGrp" : groups2[i]};
										if(res.invCd != null){
console.log("ㅇㅇ 이미 보냄! 그니까 rankey update만 하자");
											$.ajax({//이미 보낸 사람이니 rankey만 update
												url:"/invite/inviUpdate",
												type:"post",
												data:JSON.stringify(data),
												contentType:"application/json; charset=utf-8",
												async: false,
												success:function(res){
													if(res != null){
console.log("ㅇㅇ 업뎃하고서 ranKey 가져옴!");
														ranKey = res.invCd;
														data = {"invEmail" : emails2[i],
																"ttl" : ttl,
																"projCn" : projCn,
																"ranKey" : ranKey,
																"pmemGrp" : groups2[i]
																};
console.log("좋아! 이제 진짜 이메일 보내자");
														$.ajax({//이메일 발송
															url:"/invite/sendEmail",
															type:"post",
															data:JSON.stringify(data),
															contentType:"application/json; charset=utf-8",
															async: false,
															success:function(res){
																data = {"projId" : projId,
																		"memNo" : alertMemNo,
																		"pmemGrp" : groups2[i]
																		};
																if(res > 0){
																	$.ajax({//promem에도 insert
																		url:"/promem/joinProjfromInvi",
																		type:"post",
																		data:JSON.stringify(data),
																		contentType:"application/json; charset=utf-8",
																		async: false,
																		success:function(res){
																			if(res > 0){
console.log("ㅇㅇ 함! 수락하면 프로필 생길거야 이제");
																				data = {"memNo" : alertMemNo,
																						"ttl" : ttl,
																						"ranKey" : ranKey,
																						"projId" : projId,
																						"pmemGrp" : groups2[i]
																						};
																				$.ajax({//alert에도 insert
																					url:"/alert/invitation",
																					type:"post",
																					data:JSON.stringify(data),
																					contentType:"application/json; charset=utf-8",
																					async: false,
																					success:function(res){
																						data = {"projId" : projId,
																								"memNo" : alertMemNo,
																								"pmemGrp" : groups2[i]
																								};
																						if(res > 0){
console.log("ㅇㅇ alert에도 넣음! 끝!");
																							Swal.fire({
																						        text: '초대 완료',
																						        icon: 'success',
																						        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
																						        buttonsStyling: false,
																						        showCloseButton: true
																						  	})
																						}
																					}
																				});
																			}
																		}
																	});
																}
															}
														});
													}
												}
											});
										}else{
console.log("ㄴㄴ 안 보냄! 처음 보내는거야");
											data = {"invEmail" : emails2[i],
													"projId" : projId,
													"pmemGrp" : groups2[i]
													};
											//이미 회원이고 초대장 처음 보냄
											$.ajax({//처음 보내는 거니까 초대장 insert. 일단 ranKey 가져오고 insert
												url:"/invite/invitation",
												type:"post",
												data:JSON.stringify(data),
												contentType:"application/json; charset=utf-8",
												async: false,
												success:function(res){
													if(res.invCd != null){
console.log("ㅇㅇ 좋아 초대장 insert 햇어!");
														ranKey = res.invCd;
														data = {"invEmail" : emails2[i],
																"ttl" : ttl,
																"projCn" : projCn,
																"ranKey" : ranKey,
																"pmemGrp" : groups2[i]
																};
console.log("이제 진짜 이메일 보내보자!!!");
														$.ajax({//이메일 발송
															url:"/invite/sendEmail",
															type:"post",
															data:JSON.stringify(data),
															contentType:"application/json; charset=utf-8",
															async: false,
															success:function(res){
console.log("이메일도 보냄~~~!");
console.log("ㅇㅋ promem에도 넣자");
																data = {"projId" : projId,
																		"memNo" : alertMemNo,
																		"pmemGrp" : groups2[i]
																		};
																$.ajax({//alert에도 insert
																	url:"/promem/joinProjfromInvi",
																	type:"post",
																	data:JSON.stringify(data),
																	contentType:"application/json; charset=utf-8",
																	async: false,
																	success:function(res){
																		if(res > 0){
console.log("ㅇㅇ 넣음! alert에도 넣자");
																			data = {"memNo" : alertMemNo,
																					"ttl" : ttl,
																					"ranKey" : ranKey,
																					"projId" : projId,
																					"pmemGrp" : groups2[i]
																					};
																			$.ajax({//alert에도 insert
																				url:"/alert/invitation",
																				type:"post",
																				data:JSON.stringify(data),
																				contentType:"application/json; charset=utf-8",
																				async: false,
																				success:function(res){
																					data = {"projId" : projId,
																							"memNo" : alertMemNo,
																							"pmemGrp" : groups2[i]
																							};
																					if(res > 0){
console.log("ㅇㅇ alert에도 넣음! 끝!");
																						Swal.fire({
																					        text: '초대 완료',
																					        icon: 'success',
																					        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
																					        buttonsStyling: false,
																					        showCloseButton: true
																					  	})
																					}
																				}
																			});
																		}
																	}
																});
															}
														});
													}
												}
											});
										}
									}
								});
								
							}
						}
					});
				}else{
console.log("ㄴㄴ 회원 아님. 비회원임.");
					data = {"invEmail" : emails2[i],
							"projId" : projId,
							"pmemGrp" : groups2[i]
							};
					//비회원이면 바로 이메일 보내기
					//이미 보냈는지 확인
console.log("이미 초대장 보냈던 이메일인가?");
					$.ajax({
						url:"/invite/inviChk",
						type:"post",
						data:JSON.stringify(data),
						contentType:"application/json; charset=utf-8",
						async: false,
						success:function(res){
							if(res.invNo != 0){ //이미 보낸적 있으니 update
console.log("ㅇㅇ 이미 보냇음. ranKey만 update하자!");
								$.ajax({//이미 보낸 사람이니 rankey만 update
									url:"/invite/inviUpdate",
									type:"post",
									data:JSON.stringify(data),
									contentType:"application/json; charset=utf-8",
									async: false,
									success:function(res){
										if(res != null){
console.log("ㅇㅇ 업뎃 하고 ranKey도 가져왔어!");
											ranKey = res.invCd;
											data = {"invEmail" : emails2[i],
													"ttl" : ttl,
													"projCn" : projCn,
													"ranKey" : ranKey,
													"pmemGrp" : groups2[i]
													};
console.log("오키키 이메일 보내자!");
											$.ajax({//이메일 발송
												url:"/invite/sendEmail",
												type:"post",
												data:JSON.stringify(data),
												contentType:"application/json; charset=utf-8",
												async: false,
												success:function(res){
													Swal.fire({
												        text: '초대 완료',
												        icon: 'success',
												        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
												        buttonsStyling: false,
												        showCloseButton: true
												  	})
													
												}
											});
										}
									}
								});
							}else{
console.log("ㄴㄴ 이메일 처음 보냄!");
								data = {"invEmail" : emails2[i],
										"projId" : projId,
										"pmemGrp" : groups2[i]
										};
								//초대장 처음 보냄
								$.ajax({//처음 보내는 거니까 초대장 insert. 일단 ranKey 가져오고 insert
									url:"/invite/invitation",
									type:"post",
									data:JSON.stringify(data),
									contentType:"application/json; charset=utf-8",
									async: false,
									success:function(res){
										if(res.invCd != null){
console.log("ㅇㅇ 좋아 초대장 insert 햇어!");
										ranKey = res.invCd;
										data = {"invEmail" : emails2[i],
												"ttl" : ttl,
												"projCn" : projCn,
												"ranKey" : ranKey,
												"pmemGrp" : groups2[i]
												};
console.log("이제 진짜 이메일 보내보자!!!");
										$.ajax({//이메일 발송
											url:"/invite/sendEmail",
											type:"post",
											data:JSON.stringify(data),
											contentType:"application/json; charset=utf-8",
											async: false,
											success:function(res){
console.log("이메일도 보냄~~~!");
													Swal.fire({
												        text: '초대 완료',
												        icon: 'success',
												        confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
												        buttonsStyling: false,
												        showCloseButton: true
												  	})
												}
											});
										}
									}
								});
							}
						}
					});
				}
			}
		});
	}
	
	*/
	
	$('#inviteModalBody1').empty();
	$('#inviteModalBody2').empty();
	
	emails1 = [];
	emails2 = [];
	groups1 = [];
	groups2 = [];
	emailArr = [];
	grpArr = [];
	num1 = 0;
	num2 = 0;
  	
	console.log("초대 완료");
	$('#search-options').val("");
	$("#memInvi").modal('hide');
	
	
});


//////////////////////////
/* 프로젝트 멤버 초대하는 모달 창 닫기 누르면 내용 비우기 */
$('.closeModal').on('click', function(){
	$('#inviteModalBody1').empty();
	$('#inviteModalBody2').empty();
	$('#search-options').val("");
	
	emailArr = [];
	grpArr = [];
	num1 = 0;
	num2 = 0;
})


//////////////////////////
/* 프로젝트 멤버 역할 변경 */

$(document).on("click",".role", function(){
	var projId = ${projId};
	var memNo = $(this).attr('data-mno');
	
	
	if(grpC == "all") grpC = "전체";
	var grp; grp = grpC;
	console.log("grp : ", grp);
	var role = $(this).attr('data-rol');
	console.log("role : ", role);
	var profNm = $(this).parent().parent().parent().parent().parent().attr('id');
	var arr = profNm.split("x");
	profNm = arr[1];
	console.log("profNm : ", profNm);
	var roleName = "";
	if(role == "R02") roleName = "PL";
	if(role == "R03") roleName = "TA";
	if(role == "R04") roleName = "AA";
	if(role == "R05") roleName = "UA";
	if(role == "R06") roleName = "DA";
	if(role == "R08") roleName = "BA";
	
	var ment = profNm + "님에게 " + roleName + "역할을 부여하시겠습니까?";
	Swal.fire({
		        text: ment,
		        icon : 'question',
		        showCancelButton: true,
		        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
		        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
		        buttonsStyling: false,
		        showCloseButton: true
		      }).then(function (result) {
		        if (result.value) {
		        	var data = {"roleId" : role, "projId" : projId, "memNo" : memNo, "pmemGrp" : grp};
		    		console.log(data);
		    		
		    		$.ajax({
		    			url:"/promem/updateRole",
		    			type:"post",
		    			data:JSON.stringify(data),
		    			contentType:"application/json; charset=utf-8",
		    			success:function(res){
		    				if(res>0){
		    					var rn = "#rn" + memNo;
		    					$(rn).html(roleName);
		    				}
		    			}
		    		});
		        } else if (
			        // Read more about handling dismissals
	                result.dismiss === Swal.DismissReason.cancel
	              ){
		        	ment = profNm + "님에게 " + roleName + "역할을 부여하지 못했습니다.";
					Swal.fire({
	                    text: ment,
	                    icon: 'error',
	                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
	                    buttonsStyling: false,
	                    showCloseButton: true
	              	})
	            }  
		    });
});


//////////////////////////
/* 프로젝트 멤버 그룹에서 내보내기 */
$(document).on("click",".outGrp", function(){
	var userName = $(this).attr('data-name');
	str = userName + "님을 " + grpC + "에서 내보내겠습니까?";
	
	var memNo = $(this).parent().attr('data-mno');
	var data = {"memNo" : memNo, "pmemGrp" : grpC};
	
	Swal.fire({
        text: str,
        icon : 'question',
        showCancelButton: true,
        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
        buttonsStyling: false,
        showCloseButton: true
      }).then(function (result) {
        if (result.value) {
        	var id = $(this).data('id');
    		$.ajax({
    			url:"/promem/getOutFromGrp",
    			type:"post",
    			data:JSON.stringify(data),
    			contentType:"application/json; charset=utf-8",
    			success:function(res){
    				if(res>0){
    					str = userName + "님을 " + grpC + "에서 내보냈습니다."
    					Swal.fire({
    	                    text: str,
    	                    icon: 'success',
    	                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
    	                    buttonsStyling: false,
    	                    showCloseButton: true
    	              	})
    					
    					//이거 왜 안 먹히냐...버튼 비활성화 ㅠㅠ
//     					$(this).attr("disabled",true); 
//     					$(this).before().attr("disabled",true);
    				}
    			}
    		});
        } else if (
	        // Read more about handling dismissals
            result.dismiss === Swal.DismissReason.cancel
          ){
			str = userName + "님을 내보내지 못 했습니다.";
			Swal.fire({
                text: str,
                icon: 'error',
                confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                buttonsStyling: false,
                showCloseButton: true
          	})
        }  
    });
		$(this).parent().parent().parent().parent().empty();
})


//////////////////////////
/* 프로젝트 멤버 내보내기 */
$(document).on("click",".kickOut", function(){
	var name = $(this).data('name');
	var id = $(this).data('id');
		str = name + "님을 해당 프로젝트에서 내보내겠습니까?";
		
		Swal.fire({
	        text: str,
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
	        	//여기 왜 attr로 되다 data로 되다 그러냐..
	        	console.log("추방할 회원 id : ", id);
	    		var data = {"memNo" : id};
	    		$.ajax({
	    			url:"/project/kickOut",
	    			type:"post",
	    			data:JSON.stringify(data),
	    			contentType:"application/json; charset=utf-8",
	    			success:function(res){
	    				if(res>0){
	    					str = name + "님을 내보냈습니다."
	    					Swal.fire({
	    	                    text: str,
	    	                    icon: 'success',
	    	                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
	    	                    buttonsStyling: false,
	    	                    showCloseButton: true
	    	              	})
	    					$(this).attr("disabled", true);
	    					$(this).parent().parent().empty();
	    				}
	    			}
	    		});
	        } else if (
		        // Read more about handling dismissals
	            result.dismiss === Swal.DismissReason.cancel
	          ){
	        	str = name + "님을 내보내지 못 했습니다.";
				Swal.fire({
                    text: str,
                    icon: 'error',
                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
	        }  
	    });	
})


if(planOn != 'BASIC'){
///////////////////////
/* 프로젝트 공고 정보 */
if(${empty projJob}){
	$("#jobMod").hide();
	$("#jobDel").hide();
}else{
	$("#jobReg").hide();
}
jobEditor.setHTML("${projJob.get('JOB_CN')}");

/////////////////////////
/* 프로젝트 공고 등록 */	
$("#jobReg").on("click",function(){
	var jobEnd = $("#jobEnd").val();
	var jobRec = $("#jobRec").val();
	var jobTval = $("#jobTval").val();
	var jobCon = jobEditor.getHTML();
	var jdt = {"projId":${projInfo.get('PROJ_ID')},"jobEnd":jobEnd,"jobRec":jobRec,"jobTval":jobTval,"jobCon":jobCon};
	$.ajax({
		url:"/jobRegist",
		type:"post",
		data:JSON.stringify(jdt),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			if(res>0){
				Swal.fire({
                    text: '프로젝트 공고 등록 완료',
                    icon: 'success',
                    confirmButtonClass: 'btn btn-warning w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
				$("#jobReg").hide();
				$("#jobMod").show();
				$("#jobDel").show();
			}else{
				Swal.fire({
                    text: '프로젝트 공고 등록 실패.',
                    icon: 'error',
                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
			}
		}
	});
});

/////////////////////////
/* 프로젝트 공고 수정 */	

$("#jobMod").on("click",function(){
	var jobEnd = $("#jobEnd").val();
	var jobRec = $("#jobRec").val();
	var jobTval = $("#jobTval").val();
	var jobCon = jobEditor.getHTML();
	var jdt = {"projId":${projInfo.get('PROJ_ID')},"jobEnd":jobEnd,"jobRec":jobRec,"jobTval":jobTval,"jobCon":jobCon};
	$.ajax({
		url:"/job/jobModify",
		type:"post",
		data:JSON.stringify(jdt),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			if(res>0){
				Swal.fire({
                    text: '프로젝트 공고 수정 완료.',
                    icon: 'success',
                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
			}else{
				Swal.fire({
                    text: '프로젝트 공고 등록 실패.',
                    icon: 'error',
                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
			}
		}
	});
});

/////////////////////////
/* 프로젝트 공고 삭제 */	
$("#jobDel").on("click",function(){
	$.ajax({
		url:"/job/jobDelete",
		type:"post",
		data:{"projId":${projInfo.get('PROJ_ID')}},
		success:function(res){
			if(res>0){
				Swal.fire({
                    text: '프로젝트 공고 삭제 완료.',
                    icon: 'success',
                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
				$("#jobEnd").val("");
				$("#jobRec").val("");
				$("#jobTval").val("");
				jobEditor.setHTML("");
				$("#jobReg").show();
				$("#jobMod").hide();
				$("#jobDel").hide();
			}else{
				Swal.fire({
                    text: '프로젝트 공고 삭제 실패.',
                    icon: 'error',
                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
			}
		}
	});
});

/////////////////////////////
/* 포트폴리오 보기 */
 
 
// $(".viewRes").on("click", function(){
// 	var memNo = $(this).attr('data-memno');
// 	var url = "/mypage/myPageMain?memNo=" + memNo + "&fo=Y"
// 	window.open(url, "포트폴리오", "width=400 height=500 scrollbars=yes");

// 		$.ajax({
// 		url:"/myMain",
// 		type:"post",
// 		data:{"projId":${projInfo.get('PROJ_ID')}},
// 		success:function(res){
// 			if(res>0){
// 				Swal.fire({
//                     text: '프로젝트 공고 삭제 완료.',
//                     icon: 'success',
//                     confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
//                     buttonsStyling: false,
//                     showCloseButton: true
//               	})
// 				$("#jobEnd").val("");
// 				$("#jobRec").val("");
// 				$("#jobTval").val("");
// 				jobEditor.setHTML("");
// 				$("#jobReg").show();
// 				$("#jobMod").hide();
// 				$("#jobDel").hide();
// 			}else{
// 				Swal.fire({
//                     text: '프로젝트 공고 삭제 실패.',
//                     icon: 'error',
//                     confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
//                     buttonsStyling: false,
//                     showCloseButton: true
//               	})
// 			}
// 		}
// 	});
// });
}
 
/////////////////////////////
/* 지원자 승인 */
$(document).on("click",".appliY",function(){
	
	var tmp = $(this).parent().parent();
	var memNo = $(this).parent().parent().attr("name");
	var jdt = {"projId":${projInfo.get('PROJ_ID')},"memNo":memNo,"stat":"Y"}
	 Swal.fire({
	        text: "승인하시겠습니까?",
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
	        if (result.value) {
	        	$.ajax({
	    			url:"/applicant/appliUpdate",
	    			type:"post",
	    			data:JSON.stringify(jdt),
	    			contentType:"application/json; charset=utf-8",
	    			success:function(res){
	    				if(res>0){
	    					Swal.fire({
	    	                    text: '승인 완료',
	    	                    icon: 'success',
	    	                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
	    	                    buttonsStyling: false,
	    	                    showCloseButton: true
	    	              	})
	    					$(this).attr("disabled", true);
// 	    					tmp.find(".appliY").attr("disabled",true);
// 	    					tmp.find(".appliN").attr("disabled",true);
	    					tmp.find(".appStat").text("승인");
	    				}
	    			}
	    		});
	        } else if (
		        // Read more about handling dismissals
             result.dismiss === Swal.DismissReason.cancel
           ){
	        	Swal.fire({
                    text: '승인 실패!',
                    icon: 'error',
                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
         }  
	   });
});

/////////////////////////////
/* 지원자 거절 */
$(document).on("click",".appliN",function(){
	var tmp = $(this).parent().parent();
	var memNo = $(this).parent().parent().attr("name");
	var jdt = {"projId":${projInfo.get('PROJ_ID')},"memNo":memNo,"stat":"N"}
	
	 Swal.fire({
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
	    			url:"/applicant/appliUpdate",
	    			type:"post",
	    			data:JSON.stringify(jdt),
	    			contentType:"application/json; charset=utf-8",
	    			success:function(res){
	    				if(res>0){
	    					Swal.fire({
	    	                    text: '거절 완료',
	    	                    icon: 'success',
	    	                    confirmButtonClass: 'btn btn-outline-success w-xs mb-2',
	    	                    buttonsStyling: false,
	    	                    showCloseButton: true
	    	              	})
// 	    					tmp.find(".appliY").attr("disabled",true);
// 	    					tmp.find(".appliN").attr("disabled",true);
	    					tmp.find(".appStat").text("거절");
	    				}
	    			}
	    		});
	        } else if (
		        // Read more about handling dismissals
             result.dismiss === Swal.DismissReason.cancel
           ){
	        	Swal.fire({
                    text: '거절 실패!',
                    icon: 'error',
                    confirmButtonClass: 'btn btn-outline-danger w-xs mb-2',
                    buttonsStyling: false,
                    showCloseButton: true
              	})
         }  
	    });
});

$("#createVal").on("click",function(){
	$("#jobRec").val("5");
	$("#jobTval").val("JAVA, Spring Framework, JSP");
	jobEditor.setHTML("<p>1) 요구 사항</p><p>- 기존의 워드프레스 기반으로 개발 후 운영 중인 4개의 웹사이트(한국어, 영어, 일본어, 중국어)의 리뉴얼이 필요한 상황입니다.</p><p>- 국문 웹사이트는 요구사항 정의서를 기준으로 리뉴얼 작업 진행 부탁드리며 나머지 3개의 게시판 형태의 사이트는 국문의 디자인 컨셉을 적용하며 추가 변경되는 기능 없습니다.</p><br><p>2) 추가 기능</p><p>1. 사용자</p><p>- PDF 뷰어 개선</p><p>* 낮은 해상도 개선 가능한지 확인 및 현재 (+) 버튼 누르지 않으면 읽기 어려운 점 개선</p><p>- 10일 이용권 신설</p><p>- 검색 최적화 : 관련성 높은 내용이 상단으로 제대로 나올 수 있도록 검색환경 개선</p><p>- 주문 배송 조회</p><p>- 쿠폰</p><p>2. 관리자</p><p>- 각 아티클 조회수 확인 기능 필요, 콘텐츠 업로드 시 실시간 반영이 아닌 최종 저장 버튼 누른 뒤 반영되도록 구성 요청</p><p>* 지금은 작업하는 동안의 값이 실시간으로 노출됨</p><p>- 간단한 통계 기능 추가</p><p>- 현금영수증 자동 발행</p><p>* 결제 방식 무통장입금(하나은행 1004 계좌) 관리자 페이지에서 승인 처리 시 현금영수증 자동 발행</p><p>- 통합 DB 도서 정보 연동(정가 인상, 품절, 절판)</p>");
});


});
</script>

<!-- /////////////////////////////////////////////////////////////////////////////////////////////////// -->

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
<%-- 	                    <li class="breadcrumb-item active">${projVO.grp}</li> --%>
		                <li class="breadcrumb-item active">설정</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->

<div class="container-fluid">
	<button type="button" id="createVal" class="btn btn-ghost-dark waves-effect waves-light"></button>
	<div class="row">
	    <div class="col-lg-12">
	        <div class="card border p-2" style="min-height: 800px;">
	            <div class="card-header">
	                <ul class="nav nav-tabs-custom rounded card-header-tabs border-bottom-0" role="tablist">
	                    <li class="nav-item">
	                        <a class="nav-link active" data-bs-toggle="tab" href="#projInfo" role="tab" aria-selected="true">
	                            <i class="fas fa-home"></i> 프로젝트 정보
	                        </a>
	                    </li>
<!-- 	                    <li class="nav-item"> -->
<!-- 	                        <a class="nav-link" data-bs-toggle="tab" href="#projRoadmap" role="tab" aria-selected="false"> -->
<!-- 	                            <i class="far fa-user"></i> 로드맵 -->
<!-- 	                        </a> -->
<!-- 	                    </li> -->
	                    <li class="nav-item">
	                        <a class="nav-link" data-bs-toggle="tab" href="#projMember" role="tab" aria-selected="false" id="promem">
	                            <i class="far fa-user"></i> 프로젝트 멤버
	                        </a>
	                    </li>
	                    <li class="nav-item">
	                        <a class="nav-link" data-bs-toggle="tab" href="#jobAnnounce" role="tab" aria-selected="false">
	                            <i class="far fa-envelope"></i> 프로젝트 공고
	                        </a>
	                    </li>
	                    <li class="nav-item">
	                        <a class="nav-link" data-bs-toggle="tab" href="#projVol" role="tab" aria-selected="false">
	                            <i class="far fa-envelope"></i> 프로젝트 지원자
	                        </a>
	                    </li>
	                </ul>
	            </div>
	            <div class="card-body p-6">
	                <div class="tab-content">
	                    <div class="tab-pane active" id="projInfo" role="tabpanel">
							<div class="row">
							    <div class="col-lg-12">
							    	<div class="card">
							    	<div class="card-body">
							    	<div class="row">
								    	<div class="col-lg-6">
							                <div class="mb-3">
							                    <label class="form-label" for="projName">프로젝트 이름</label>
							                    <input type="text" class="form-control" id="projName" />
							                </div>
							            </div>
						                <div class="col-lg-6">
							                <div class="mb-3">
							                    <label class="form-label" for="projName">프로젝트 상태</label>
							                    <select class="form-select mb-3" id="projStats">
						                        	<option>신규</option>
						                        	<option>진행</option>
						                        	<option>종료</option>
				                                </select>
							                </div>
										</div>
										<div class="col-lg-12">
							                <div class="mb-3">
							                    <label class="form-label" for="projImg">프로젝트 사진</label>
							                    <input class="form-control" id="projImg" type="file" />
							                </div>
							            </div>
							            <div class="col-lg-12">
							                <div class="mb-3">
							                    <label class="form-label">프로젝트 내용</label>
							                    <div id="editor"></div>
							                </div>
										</div>
									</div>
					                <div class="row">
					                    <div class="col-lg-3">
					            <c:if test="${projVO.plan eq 'PREMIUM'}">
					                        <div class="mb-3">
					                            <label for="joinValue" class="form-label">프로젝트 인원 수</label>
					                            <input type="text" class="form-control" value="${i}" id="joinValue">
					                        </div>
					            </c:if>
					            <c:if test="${projVO.plan ne 'PREMIUM'}">
					                        <div class="mb-3">
					                            <label for="joinValue" class="form-label">프로젝트 인원 수</label>
					                            <select class="form-select mb-3" id="joinValue">
					                                   <c:forEach var="i" begin="1" end="30" step="1">
														<c:choose>
															<c:when test="${i eq 2}">
																<option selected="selected">${i}</option>
															</c:when>
															<c:otherwise>
																<option>${i}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
				                                </select>
					                        </div>
					            </c:if>
					                    </div>
					                    <div class="col-lg-3">
					                        <div class="mb-3">
					                            <label for="payment" class="form-label">프로젝트 예산</label>
					                            <input type="text" class="form-control" id="payment" placeholder="금액을 입력하세요" />
					                        </div>
					                    </div>
		                    <c:if test="${projVO.plan eq 'BASIC'}">
					                    <div class="col-lg-3">
					                        <div class="mb-3">
					                            <label for="startProj" class="form-label">프로젝트 시작일</label>
					                            <input type="date" class="form-control" id="startProj" value=<fmt:formatDate pattern='yyyy-MM-dd' value="${projInfo.get('PROJ_SDY')}" /> disabled="disabled"/>
					                        </div>
					                    </div>
					                    <div class="col-lg-3">
					                        <div class="mb-3">
					                            <label for="endProj" class="form-label">프로젝트 종료일</label>
					                            <input type="date" class="form-control" id="endProj" value=<fmt:formatDate pattern='yyyy-MM-dd' value="${projInfo.get('PROJ_EDY')}" /> />
					                        </div>
					                    </div>
		                    </c:if>
		                    <c:if test="${projVO.plan ne 'BASIC'}">
					                    <div class="col-lg-3">
					                        <div class="mb-3">
					                            <label for="startProj" class="form-label">프로젝트 시작일</label>
					                            <input type="date" class="form-control" id="startProj" value=<fmt:formatDate pattern='yyyy-MM-dd' value="${projInfo.get('PROJ_SDY')}" /> />
					                        </div>
					                    </div>
					                    <div class="col-lg-3">
					                        <div class="mb-3">
					                            <label for="endProj" class="form-label">프로젝트 종료일</label>
					                            <input type="date" class="form-control" id="endProj" value=<fmt:formatDate pattern='yyyy-MM-dd' value="${projInfo.get('PROJ_EDY')}" /> />
					                        </div>
					                    </div>
		                    </c:if>
					                </div>
					                </div>
					                </div>
					                <div class="card">
									<div class="card-body">
						            <div id="costVal">
						                <div class="mb-3">
						                    <label class="form-label">등급 별 보수</label>
						                </div>
						                <div class="row">
						                    <div class="col-lg-3">
						                        <div class="mb-3">
						                        	<label for="codeRating0" class="form-label">등급</label>
						                        	<select class="form-select mb-3" id="codeRating0">
														<option>초급</option>
														<option>중급</option>
														<option>고급</option>
													</select>
						                        </div>
						                    </div>
						                    <div class="col-lg-3">
						                        <div class="mb-3">
						                            <label for="countPerson0" class="form-label">인원 수</label>
						                            <input type="text" class="form-control" id="countPerson0" placeholder="인원 수" />
						                        </div>
						                    </div>
						                    <div class="col-lg-3">
						                        <div class="mb-3">
						                            <label for="ccost0" class="form-label">금액</label>
						                            <input type="text" class="form-control" id="ccost0" />
						                        </div>
						                    </div>
						                    <div class="col-lg-3">
						                       	<label class="form-label">항목 추가/제거</label>	
						                        <div class="mb-3">
						                        	<button type="button" id="addcon" class="btn btn-outline-primary"><i class="ri-add-line"></i></button>
						                        </div>
						                    </div>
						                </div>
						            </div>
						            </div>
						            </div>
						            <div class="card">
									<div class="card-body">
							        <div class="row g-4 mb-3">
								        <div class="col-sm">
								            <div class="d-flex justify-content-sm-center gap-2">
									        	<button type="button" id="modify" class="btn btn-outline-info waves-effect waves-light">수정</button>
								            </div>
								        </div>
								    </div>
								    </div>
								    </div>
							    </div>
							    <!-- end col -->
							</div>	                    
	                    </div>
	                    <!--end tab-pane-->

	                    <div class="tab-pane" id="projRoadmap" role="tabpanel">
							<div class="row">
							    <div class="col-lg-12">
로드맵
							    <div class="col-lg-2"></div>
							    <div class="col-lg-8">
									<div class="progress progress-step-arrow progress-info">
				                    	<c:forEach var="road" items="${roadmap}">
				                    		<c:if test="${road.SEC == 1}">
		   										<a href="javascript:void(0);" class="progress-bar" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">${road.CN}</a>
				                    		</c:if>
				                    		<c:if test="${road.SEC == 2}">
		   										<a href="javascript:void(0);" class="progress-bar" role="progressbar" style="width: 100%" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100">${road.CN}</a>
				                    		</c:if>
				                    		<c:if test="${road.SEC == 3}">
		   										<a href="javascript:void(0);" class="progress-bar bg-light text-dark" role="progressbar" style="width: 100%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">${road.CN}</a>
				                    		</c:if>
			                    		</c:forEach>
			                    	</div>
	                    			</div>
							    <div class="col-lg-2"></div>
	                    		</div>
	                    	</div>
	                    </div>

<!-- ///////////////////////////////////////////////////////// 프로젝트 멤버 관리 시작 ///////////////////////////////////////////////////////// -->
	                    
	                        
	      <!-- ///////////////////// 그룹 추가할 때 이름 적는 모달 ///////////////////// -->
                           <div id="newGrpModal" class="modal fade bs-example-modal-center" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
                               <div class="modal-dialog modal-dialog-centered">
                                   <div class="modal-content" style="width:400px; height:350px;">
                                       <div class="modal-body text-center p-5">
                                           <div class="mt-4 mb-4" style="height:250px;">
                                               <h3 class="pb-6"><i class="bx bx-group"></i> 그룹 추가</h3>
                                               <div class="app-search d-none d-md-block"  style="width:300px;">
												    <div class="position-relative">
												        <input type="text" class="form-control" placeholder="그룹명을 적어주세요." autocomplete="off" id="newGrpName">
												    </div>
												</div>
                                               <div class="hstack gap-2 justify-content-center">
                                                   <a href="javascript:void(0);" id="newGrp"class="btn btn-soft-success">추가</a>
                                                   <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
                                               </div>
                                           </div>
                                       </div>
                                   </div><!-- /.modal-content -->
                               </div><!-- /.modal-dialog -->
                           </div><!-- /.modal --> 
	                        
	                        
	                        
           <!-- ///////////////////// 그룹에 참여 멤버 추가하는 모달 ///////////////////// -->
               <div id="intoGrpModal" class="modal fade bs-example-modal-center" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
                   <div class="modal-dialog modal-dialog-centered">
                       <div class="modal-content" style="width:400px; height:350px;">
                           <div class="modal-body text-center p-5">
                               <div class="mt-4 mb-4" style="height:250px;">
                                   <h3 class="pb-6"><i class="ri-user-search-line"></i> 참여 멤버 검색</h3>
                                   <div class="app-search d-none d-md-block"  style="width:300px;">
									    <div class="position-relative">
									        <input type="text" class="form-control minput" placeholder="이름을 적어주세요." autocomplete="off" id="newMem">
									        <span class="mdi mdi-magnify search-widget-icon"></span>
									        <span class="mdi mdi-close-circle search-widget-icon search-widget-icon-close d-none" id="search-close-options2"></span>
									    </div>
									    <div class="dropdown-menu dropdown-menu-lg" id="search-dropdown2">
								            <!-- item-->
								            <div class="dropdown-header mt-2">
								                <h6 class="text-overflow text-muted mb-2 text-uppercase"><i class='ri-user-3-line'></i> 프로젝트 멤버</h6>
								            </div>
								            <div class="notification-list" id="memberInfo2">
								            </div>
									    </div>
									</div>
                                   <div class="hstack gap-2 justify-content-center">
                                       <a href="javascript:void(0);" id="newMemSave"class="btn btn-soft-info">그룹 배정</a>
                                       <button type="button" class="btn btn-light" data-bs-dismiss="modal" id="newMemClose">닫기</button>
                                   </div>
                               </div>
                           </div>
                       </div><!-- /.modal-content -->
                   </div><!-- /.modal-dialog -->
               </div><!-- /.modal --> 
	                        
	                        
	                        
	                        
	                        
	                        
	                        
	                        
             <div class="tab-pane" id="projMember" role="tabpanel">
                 <div class="mt-4 mb-3 border-bottom pb-4">
                 	<div class="row ">
                 		<div class="col-10">
		                     <h5 class="card-title">프로젝트 멤버 
		                     	&nbsp;
		                     	<button type="button" class="btn btn-outline-info btn-sm" data-bs-toggle="modal" data-bs-target="#memInvi">
									<i class="bx bx-plus"></i> 멤버 초대하기
							     </button>
							     							     &nbsp;
		                     	<button type="button" class="btn btn-outline-info btn-sm" id="btnSync">
									<i class="bx bx-plus"></i> promem sync profile
							     </button>
		                     </h5>
		                     <p class="text-muted"> <c:if test="${empty projMember[0].ROLE_NM}">그룹 더블클릭 시 그룹명을 변경할 수 있습니다.</c:if></p>
                 		</div>
                 	</div>
                 </div>
                        
                        
                <div class="card shadow-none" style="min-height: 360px;">
                      <div class="card-body" style="min-height: 300px;">
                          <div class="row mb-2">
                          	<div class="col-10">
								<button type="button" class="btn btn-outline-success dropdown-toggle roleNameAll" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class=""></i>선택 역할부여</button>
                          		<div class="btn-group" id="roleNameAll">
<!-- 										 <div class="flex-shrink-2" > -->
<!-- 									   		선택 역할부여 -->
<!-- 										 </div> -->
									    <div class="dropdown-menu dropdownmenu-secondary" id="btnroleNameAll">
										    <p class="dropdown-item role" data-rol="R02" style="cursor: pointer;">PL</p>
									        <p class="dropdown-item role" data-rol="R03" style="cursor: pointer;">TA</p>
									        <p class="dropdown-item role" data-rol="R04" style="cursor: pointer;">AA</p>
									        <p class="dropdown-item role" data-rol="R05" style="cursor: pointer;">UA</p>
									        <p class="dropdown-item role" data-rol="R06" style="cursor: pointer;">DA</p>
									        <p class="dropdown-item role" data-rol="R08" style="cursor: pointer;">BA</p>
									    </div>
								</div> 
                          	</div>
                          	<div class="col-2 text-end">
							     <button type="button" class="btn btn-outline-danger kickOutAll" data-bs-toggle="modal" data-bs-target="#memGroup">
									 <div class="" >
								   		<i class=""></i>선택 내보내기
									 </div>
								 </button>
                          	</div>
                          </div>
                          
                          <div class="row" id="promemOnclick">
                              <div class="col-lg-2">
                                  <div class="nav nav-pills flex-column nav-pills-tab custom-verti-nav-pills text-center" role="tablist" aria-orientation="vertical" id="grpTabs">
	                                       <a class="nav-link" id="custom-v-pills-add-tab" data-bs-toggle="modal" data-bs-target=".bs-example-modal-center" style="cursor: pointer;">
	                                           <i class="bx bx-plus mb-1"></i> <span id="addGrp">추가</span>
	                                       </a>
									<c:choose>
										<c:when test="${yesGrp == 0}">
	                                       <a class="nav-link active show grpTab" id="custom-v-pills-all-tab" data-gn="all" data-bs-toggle="pill" href="#custom-v-pills-all" role="tab" aria-controls="custom-v-pills-all" aria-selected="true">
	                                           <i class="bx bx-group fs-18 mb-1"></i> <span> 모두</span>
	                                       </a>
										</c:when>
										<c:otherwise>
		                                       <a class="nav-link active show grpTab" id="custom-v-pills-all-tab" data-gn="all" data-bs-toggle="pill" href="#custom-v-pills-all" role="tab" aria-controls="custom-v-pills-all" aria-selected="true">
		                                           <i class="bx bx-group fs-18 mb-1"></i> <span> 모두</span>
		                                       </a>
											<c:forEach var="grp" items="${getGrpList}">
												<c:if test="${grp.sprojTtl ne '미정'}">
			                                       <a class="nav-link grpTab" id="custom-v-pills-${grp.sprojTtl}-tab" data-gn="${grp.sprojTtl}" data-bs-toggle="pill" href="#custom-v-pills-${grp.sprojTtl}" role="tab" aria-controls="custom-v-pills-${grp.sprojTtl}" aria-selected="false">
			                                           <i class="bx bx-subdirectory-right"></i> <span> ${grp.sprojTtl}</span>
			                                       </a>
												</c:if>
											</c:forEach>
											<c:forEach var="grp" items="${getGrpList}">
												<c:if test="${grp.sprojTtl eq '미정'}">
			                                       <a class="nav-link grpTab" id="custom-v-pills-${grp.sprojTtl}-tab" data-gn="${grp.sprojTtl}" data-bs-toggle="pill" href="#custom-v-pills-${grp.sprojTtl}" role="tab" aria-controls="custom-v-pills-${grp.sprojTtl}" aria-selected="false">
			                                           <i class="bx bx-subdirectory-right"></i> <span> ${grp.sprojTtl}</span>
			                                       </a>
			                                    </c:if>
											</c:forEach>
										</c:otherwise>
									</c:choose>
<!--                                        <a class="nav-link" id="custom-v-pills-adding-tab" data-bs-toggle="pill" href="#custom-v-pills-adding" role="tab" aria-controls="custom-v-pills-adding" aria-selected="false"> -->
<!--                                            <i class="ri-add-circle-line d-block fs-20 mb-1"></i> 그룹 추가하기 -->
<!--                                        </a> -->
                                  </div>
                              </div> <!-- end col-->
                              
                              <div class="col-lg-10">
                                  <div class="tab-content text-muted mt-3 mt-lg-0" id="pmemListBox">
                                  <c:choose>
                                  	<c:when test="${yesGrp == 0}">
                                      <div class="tab-pane fade active show" id="custom-v-pills-all" role="tabpanel" aria-labelledby="custom-v-pills-all-tab">
                                       <div class="tab-pane fade active show" id="custom-v-pills-all" role="tabpanel" aria-labelledby="custom-v-pills-all-tab">
					                        <c:forEach var="mem" items="${projMember}" varStatus = "stat">
						                        <div class="d-flex align-items-center mb-3">
							                        <c:choose>
							                        	<c:when test="${iamPM.memNo eq mem.MEM_NO}">
								                        	<div class="form-check form-check-info mb-3">
								                        		<input class="form-check-input" type="checkbox" style="display: none;"/>
								                        	</div>
							                        	</c:when>
							                        	<c:otherwise>
								                        	<div class="form-check form-check-info mb-3">
								                        		<input class="form-check-input chkbox" type="checkbox"/>
								                        	</div>
							                        	</c:otherwise>
							                        </c:choose>
						                            <div class="flex-shrink-0 avatar-sm">
						                                <div class="avatar-title bg-light rounded-circle fs-18">
						                                    <img src="/resources/image/${mem.PROF_PHOTO}" class="rounded-circle avatar-sm" alt="">
						                                </div>
						                            </div>
						                            <div class="flex-grow-1 ms-3">
						                                <h6 class="fs-15">${mem.PROF_NM} 
						                                	<c:if test="${!empty mem.ROLE_NM}">(<span id="rn${mem.MEM_NO}">${mem.ROLE_NM}</span>)</c:if>
						                                	<c:if test="${iamPM.memNo eq mem.MEM_NO}"><span style="font-weight: bold;">(나)</span></c:if>
						                                </h6>
						                                <p class="text-muted mb-0">참여일3 : ${mem.PMEM_IDY}</p>
						                            </div>
						                            
						                            
						                            <div id="box${mem.PROF_NM}">
			                                <div class="row text-end">
			                                	<div class="col-4">
						                                <c:if test="${!empty mem.ROLE_NM}">
								                            <c:choose>
								                            	<c:when test="${mem.MEM_NO eq memNo}">
									                                <div class="btn-group" id="g${mem.MEM_NO}">
																	    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled="disabled">역할</button>
																	    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
																	    </div>
																	</div>
								                            	</c:when>
								                            	<c:otherwise>
									                                <div class="btn-group" id="g${mem.MEM_NO}">
																	    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
																	    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
																		    <p class="dropdown-item role" data-rol="R02" data-mno="${mem.MEM_NO}" style="cursor: pointer;">PL</p>
																	        <p class="dropdown-item role" data-rol="R03" data-mno="${mem.MEM_NO}" style="cursor: pointer;">TA</p>
																	        <p class="dropdown-item role" data-rol="R04" data-mno="${mem.MEM_NO}" style="cursor: pointer;">AA</p>
																	        <p class="dropdown-item role" data-rol="R05" data-mno="${mem.MEM_NO}" style="cursor: pointer;">UA</p>
																	        <p class="dropdown-item role" data-rol="R06" data-mno="${mem.MEM_NO}" style="cursor: pointer;">DA</p>
																	        <p class="dropdown-item role" data-rol="R08" data-mno="${mem.MEM_NO}" style="cursor: pointer;">BA</p>
																	    </div>
																	</div>
								                            	</c:otherwise>
								                            </c:choose>
						                                </c:if>
			                                	</div>
		                                	<div class="col-8"  data-mno="${mem.MEM_NO}">
						                                <c:choose>
							                                <c:when test="${iamPM.memNo eq mem.MEM_NO}">
								                                <button class="btn btn-outline-danger kickOut" data-name="${mem.PROF_NM}" data-id="${mem.MEM_NO}" style="visibility: hidden;">프로젝트에서 내보내기</button>
							                                </c:when>
							                                <c:otherwise>
								                                <button class="btn btn-outline-danger kickOut" data-name="${mem.PROF_NM}" data-id="${mem.MEM_NO}">프로젝트에서 내보내기</button>
							                                </c:otherwise>
						                                </c:choose>
			                                	</div>
			                                </div>
						                            </div>
						                        </div>
					                        </c:forEach>
                                       </div>
                                       <!--end tab-pane-->
                                      </div>
                                      <!--end tab-pane-->
                                  	</c:when>
                                  	<c:otherwise>
                                  		<c:forEach var="grp" items="${getGrpList}">
                                  			<c:if test="${grp.sprojTtl eq '전체'}">
	                                       <div class="tab-pane fade active show" id="custom-v-pills-${grp.sprojTtl}" role="tabpanel" aria-labelledby="custom-v-pills-${grp.sprojTtl}-tab">
						                        <c:forEach var="mem" items="${projMember}" varStatus = "stat">
							                        <div class="d-flex align-items-center mb-3">
								                        <c:choose>
								                        	<c:when test="${iamPM.memNo eq mem.MEM_NO}">
									                        	<div class="form-check form-check-info mb-3">
									                        		<input class="form-check-input" type="checkbox" style="display: none;"/>
									                        	</div>
								                        	</c:when>
								                        	<c:otherwise>
									                        	<div class="form-check form-check-info mb-3">
									                        		<input class="form-check-input chkbox" type="checkbox"/>
									                        	</div>
								                        	</c:otherwise>
								                        </c:choose>
							                            <div class="flex-shrink-0 avatar-sm">
							                                <div class="avatar-title bg-light rounded-circle fs-18">
							                                    <img src="/resources/image/${mem.PROF_PHOTO}" class="rounded-circle avatar-sm" alt="">
							                                </div>
							                            </div>
							                            <div class="flex-grow-1 ms-3">
							                                <h6 class="fs-15">${mem.PROF_NM} <c:if test="${iamPM.memNo eq mem.MEM_NO}"><span style="font-weight: bold;">(나)</span></c:if>
							                                	<c:if test="${!empty mem.ROLE_NM}">(<span id="rn${mem.MEM_NO}">${mem.ROLE_NM}</span>)</c:if>
							                                </h6>
							                                <p class="text-muted mb-0">참여일4 : ${mem.PMEM_IDY}</p>
							                            </div>
							                            
							                            
							                            <div id="box${mem.PROF_NM}">
							                                <c:if test="${!empty mem.ROLE_NM}">
									                            <c:choose>
									                            	<c:when test="${mem.MEM_NO eq memNo}">
										                                <div class="btn-group" id="g${mem.MEM_NO}">
																		    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled="disabled">역할</button>
																		    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
																			    <p class="dropdown-item role" data-rol="R02" data-mno="${mem.MEM_NO}">PL</p>
																		        <p class="dropdown-item role" data-rol="R03" data-mno="${mem.MEM_NO}">TA</p>
																		        <p class="dropdown-item role" data-rol="R04" data-mno="${mem.MEM_NO}">AA</p>
																		        <p class="dropdown-item role" data-rol="R05" data-mno="${mem.MEM_NO}">UA</p>
																		        <p class="dropdown-item role" data-rol="R06" data-mno="${mem.MEM_NO}">DA</p>
																		        <p class="dropdown-item role" data-rol="R08" data-mno="${mem.MEM_NO}">BA</p>
																		    </div>
																		</div>
									                            	</c:when>
									                            	<c:otherwise>
										                                <div class="btn-group" id="g${mem.MEM_NO}">
																		    <button type="button" class="btn btn-outline-success dropdown-toggle roleName" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">역할</button>
																		    <div class="dropdown-menu dropdownmenu-secondary" id="d${mem.MEM_NO}">
																			    <p class="dropdown-item role" data-rol="R02" data-mno="${mem.MEM_NO}">PL</p>
																		        <p class="dropdown-item role" data-rol="R03" data-mno="${mem.MEM_NO}">TA</p>
																		        <p class="dropdown-item role" data-rol="R04" data-mno="${mem.MEM_NO}">AA</p>
																		        <p class="dropdown-item role" data-rol="R05" data-mno="${mem.MEM_NO}">UA</p>
																		        <p class="dropdown-item role" data-rol="R06" data-mno="${mem.MEM_NO}">DA</p>
																		        <p class="dropdown-item role" data-rol="R08" data-mno="${mem.MEM_NO}">BA</p>
																		    </div>
																		</div>
									                            	</c:otherwise>
									                            </c:choose>
							                                </c:if>
							                                <c:choose>
								                                <c:when test="${iamPM.memNo eq mem.MEM_NO}">
								                                </c:when>
								                                <c:otherwise>
									                                <button class="btn btn-outline-danger kickOut" data-name="${mem.PROF_NM}" data-id="${mem.MEM_NO}">프로젝트에서 내보내기</button>
								                                </c:otherwise>
							                                </c:choose>
							                            </div>
							                        </div>
						                        </c:forEach>
	                                       </div>
	                                       <!--end tab-pane-->
                                  			</c:if>
                                  			<c:if test="${grp.sprojTtl ne '전체'}">
	                                       <div class="tab-pane fade" id="custom-v-pills-${grp.sprojTtl}" role="tabpanel" aria-labelledby="custom-v-pills-${grp.sprojTtl}-tab" data-grpName="${grp.sprojTtl}">


	                                       </div>
	                                       <!--end tab-pane-->
                                  			</c:if>
                                  		</c:forEach>
                                  	</c:otherwise>
                                  </c:choose>
                                  </div>
                              </div> <!-- end col-->
                          </div> <!-- end row-->
                      </div><!-- end card-body -->
	        	</div>
            </div>
            <!--end tab-pane-->
	                    
<!-- ///////////////////////////////////////////////////////// 프로젝트 멤버 관리 끄읕 ///////////////////////////////////////////////////////// -->
	                    
	                    
<!-- ///////////////////////////////////////////////////////// 프로젝트 공고 시작 ///////////////////////////////////////////////////////// -->
                   <c:if test="${projVO.plan ne 'BASIC'}">
	                    <div class="tab-pane" id="jobAnnounce" role="tabpanel">
							<div class="row">
							    <div class="col-lg-12">
							        <div class="tab-content text-muted">
							            <div class="tab-pane fade show active" id="project-overview" role="tabpanel">
							                <div class="row">
							                    <div class="col-lg-12">
							                    	<div class="card shadow-none p-0 m-0">
								                        <div class="card-body">
								                            <div class="row">
														        <div class="col-sm">
														            <div class="d-flex float-end justify-content-sm-start gap-2">
													               		<button type="button" id="jobReg" class="btn btn-outline-success waves-effect waves-light">공고등록</button>
													               		<button type="button" id="jobMod" class="btn btn-outline-info waves-effect waves-light">공고수정</button>
															        	<button type="button" id="jobDel" class="btn btn-outline-danger waves-effect waves-light">공고삭제</button>
														            </div>
														        </div>
														    </div>
													    </div>
												    </div>
							                        <div class="card">
							                            <div class="card-body">
							                                <div class="text-muted">
							                                	<h4 class="fw-bold"><span id="jobStat"></span>${projInfo.get('PROJ_TTL')}</h4>
							                                    <div class="pt-3 border-top border-top-dashed mt-4">
							                                        <div class="row">
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
							                                                    <p class="mb-2 text-uppercase fw-medium fs-13">등록일자</p>
							                                                    <c:if test="${empty projJob}">
							                                                    	<c:set var="todayVal" value="<%= new java.util.Date() %>" />
							                                                    	<h5 class="fs-15 mb-0" id=jobStart><fmt:formatDate pattern="yyyy.MM.dd" value="${todayVal}"/></h5>
							                                                    </c:if>
							                                                    <c:if test="${not empty projJob}">
							                                						<h5 class="fs-15 mb-0" id=jobStart><fmt:formatDate pattern="yyyy.MM.dd" value="${projJob.get('JOB_WDY')}"/></h5>
							                                                	</c:if>
							                                                </div>
							                                            </div>
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
							                                                    <p class="mb-2 text-uppercase fw-medium fs-13">마감일자</p>
<!-- 											                                                    <input type="text" class="form-control flatpickr-input active" data-provider="flatpickr" data-date-format="Y/m/d" readonly="readonly"> -->
																		<c:if test="${!empty projJob}">
							                                                    <input type="date" class="form-control" id="jobEnd" value=<fmt:formatDate pattern='yyyy-MM-dd' value="${projJob.get('JOB_EDY')}"/> />
																		</c:if>
																		<c:if test="${empty projJob}">
							                                                    <input type="date" class="form-control" id="jobEnd" value=<fmt:formatDate pattern='yyyy-MM-dd' value="${projInfo.get('PROJ_EDY')}"/> />
																		</c:if>
							                                                </div>
							                                            </div>
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
							                                                    <p class="mb-2 text-uppercase fw-medium fs-13">모집인원</p>
							                                                    <input type="text" class="form-control" id="jobRec" value="${projJob.get('JOB_RECRU')}" placeholder="모집인원수를 입력하세요" />
							                                                </div>
							                                            </div>
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
							                                                    <p class="mb-2 text-uppercase fw-medium fs-13">지원자수</p>
							                                                    <c:if test="${empty projJob}">
							                                                    	<h5 class="fs-15 mb-0" id="jobVol"></h5>
							                                                    </c:if>
							                                                    <c:if test="${not empty projJob}">
							                                                    <h5 class="fs-15 mb-0" id="jobVol">${projJob.get('JOB_VOLCNT')}명</h5>
							                                                    </c:if>
							                                                </div>
							                                            </div>
							                                        </div>
							                                    </div>
							                                    <div class="pt-3 border-top border-top-dashed mt-4">
							                                        <div class="row">
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
						                                                  		<p class="mb-2 text-uppercase fw-medium fs-13">초급</p>
						                                                  		<c:set var="flag1" value="false" />
						                                        				<c:forEach var="clist" items="${projCost}" varStatus="stat">
						                                        					<c:if test="${not flag1}">
							                                        					<c:choose>
										                                					<c:when test="${clist.get('COST_LV') eq '초급'}">
																								<c:set var="flag1" value="true" />		                                					
																								<h5 class="fs-15 mb-0">&#8361;${clist.get("COST_PAY")}</h5>
										                                					</c:when>
										                                					<c:when test="${stat.last}">
																								<h5 class="fs-15 mb-0">내역 없음</h5>		                                					
										                                					</c:when>
									                                					</c:choose>
								                                					</c:if>
									                                            </c:forEach>
							                                                </div>
							                                            </div>
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
						                                                  		<p class="mb-2 text-uppercase fw-medium fs-13">중급</p>
						                                        				<c:set var="flag2" value="false" />
						                                        				<c:forEach var="clist" items="${projCost}" varStatus="stat">
						                                        					<c:if test="${not flag2}">
							                                        					<c:choose>
										                                					<c:when test="${clist.get('COST_LV') eq '중급'}">
																								<c:set var="flag2" value="true" />		                                					
																								<h5 class="fs-15 mb-0">&#8361;${clist.get("COST_PAY")}</h5>
										                                					</c:when>
										                                					<c:when test="${stat.last}">
																								<h5 class="fs-15 mb-0">내역 없음</h5>		                                					
										                                					</c:when>
									                                					</c:choose>
								                                					</c:if>
									                                            </c:forEach>
							                                                </div>
							                                            </div>
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
						                                                  		<p class="mb-2 text-uppercase fw-medium fs-13">고급</p>
						                                        				<c:set var="flag3" value="false" />
						                                        				<c:forEach var="clist" items="${projCost}" varStatus="stat">
						                                        					<c:if test="${not flag3}">
							                                        					<c:choose>
										                                					<c:when test="${clist.get('COST_LV') eq '고급'}">
																								<c:set var="flag3" value="true" />		                                					
																								<h5 class="fs-15 mb-0">&#8361;${clist.get("COST_PAY")}</h5>
										                                					</c:when>
										                                					<c:when test="${stat.last}">
																								<h5 class="fs-15 mb-0">내역 없음</h5>		                                					
										                                					</c:when>
									                                					</c:choose>
								                                					</c:if>
									                                            </c:forEach>
							                                                </div>
							                                            </div>
							                                            <div class="col-lg-3 col-sm-6">
							                                                <div>
							                                                    <p class="mb-2 text-uppercase fw-medium fs-13">기술분야</p>
											                                    <input type="text" class="form-control" id="jobTval" value="${projJob.get('JOB_TECH')}" placeholder="반점(,)으로 구분하여 입력하세요" />
							                                                </div>
							                                            </div>
							                                        </div>
							                                    </div>
							                                </div>
							                            </div>
							                            <!-- end card body -->
							                        </div>
							                        <!-- end card -->
							                        <div class="card">
							                            <div class="card-body">
							                                <div class="text-muted">
							                                    <div>
							                                        <div class="row">
						                                                <div>
						                                                    <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 내용</p>
						                                					<h5 class="fs-15 mb-0">${projInfo.get("PROJ_CN")}</h5>
						                                                </div>
							                                        </div>
							                                    </div>
							                                    <div class="pt-3 border-top border-top-dashed mt-4">
							                                        <div class="row">
						                                                <div>
						                                                    <p class="mb-2 text-uppercase fw-medium fs-13">프로젝트 공고 내용</p>
						                                					<div id="jobEditor"></div>
						                                                </div>
							                                        </div>
							                                    </div>
							                                </div>
							                            </div>
							                            <!-- end card body -->
							                        </div>
							                        <!-- end card -->
							                    </div>
							                    <!-- ene col -->
							                </div>
							                <!-- end row -->
							            </div>
							            <!-- end tab pane -->
							        </div>
							    </div>
							    <!-- end col -->
							</div>
							<!-- end row -->	                    	
	                    </div>
	                    <!--end tab-pane-->
	           </c:if>
	           <c:if test="${projVO.plan eq 'BASIC'}">
				  <div class="tab-pane" id="jobAnnounce" role="tabpanel">
						<div class="row">
						    <div class="col-lg-12">
						        <div class="tab-content text-muted">
						            <div class="tab-pane fade show active" id="project-overview" role="tabpanel">
						                <div class="row">
						                    <div class="col-lg-12 pt-5">
						                    	<div class="card shadow-none mt-5" style="height: 300px;">
							                        <div class="card-body text-center pt-5 mt-5">
									               		<h5 class="text-muted mt-5 mb-5">프로젝트 공고는 PLUS 플랜 이상만 사용 가능합니다.</h5>
									               		<a href="javascript:location.href='/plan'"><button class='btn btn-primary'>플랜 변경</button></a>
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
<!-- ///////////////////////////////////////////////////////// 프로젝트 구인 공고 끄읕 ///////////////////////////////////////////////////////// -->


	                    
<!-- ///////////////////////////////////////////////////////// 프로젝트 구인 공고 지원자 시작 ///////////////////////////////////////////////////////// -->
	                    <div class="tab-pane" id="projVol" role="tabpanel">
	                    	<div class="team-list list-view-filter">
	           <c:if test="${projVO.plan eq 'BASIC'}">
					<div class="row">
					    <div class="col-lg-12">
					        <div class="tab-content text-muted">
					            <div class="tab-pane fade show active" id="project-overview" role="tabpanel">
					                <div class="row">
					                    <div class="col-lg-12 pt-5">
					                    	<div class="card shadow-none mt-5">
						                        <div class="card-body text-center pt-5 mt-5">
								               		<h5 class="text-muted mt-5 mb-5">등록된 구인 공고가 없어 지원자를 받을 수 없습니다.</h5>
<!-- 								               		<a href="javascript:location.href='/plan'"><button class='btn btn-primary'>플랜 변경</button></a> -->
											    </div>
										    </div>
									    </div>
								    </div>
							    </div>
						    </div>
					    </div>
				    </div>
	           </c:if>
	           <c:if test="${projVO.plan ne 'BASIC'}">
		           	<c:if test="${empty projAppli}">
						<div class="row">
						    <div class="col-lg-12">
						        <div class="tab-content text-muted">
						            <div class="tab-pane fade show active" id="project-overview" role="tabpanel">
						                <div class="row">
						                    <div class="col-lg-12">
						                    	<div class="card shadow-none">
							                        <div class="card-body text-center">
									               		<h5 class="text-muted">프로젝트 지원자가 없습니다.</h5>
	<!-- 								               		<a href="javascript:location.href='/plan'"><button class='btn btn-primary'>플랜 변경</button></a> -->
												    </div>
											    </div>
										    </div>
									    </div>
								    </div>
							    </div>
						    </div>
					    </div>
					</c:if>	                    	
		           	<c:if test="${!empty projAppli}">
	                    		<c:forEach var="applist" items="${projAppli}">
	                            <div class="card team-box">
	                                <div class="card-body px-4">
	                                    <div class="row align-items-center team-row">
	                                        <div class="col-lg-4 col">
	                                            <div class="team-profile-img">
	                                                <div class="team-content">
	                                                    <a class="d-block">
	                                                        <h5 class="fs-16 mb-1">${applist.get('MEM_NM')}(${applist.get('MEM_ID')})</h5>
	                                                    </a>
	                                                </div>
	                                            </div>
	                                        </div>
	                                        <div class="col-lg-8 col">
	                                            <div class="row text-muted text-center" name="${applist.get('MEM_NO')}">
	                                                <div class="col-3 border-end border-end-dashed">
	                                                	<c:if test="${applist.get('APP_YN') eq 'W'}">
	                                                	<h5 class="mb-1">상태</h5>
	                                                	<p class="text-muted mb-0 appStat">대기</p>
	                                                	</c:if>
	                                                	<c:if test="${applist.get('APP_YN') eq 'Y'}">
	                                                	<h5 class="mb-1">상태</h5>
	                                                	<p class="text-muted mb-0 appStat">승인</p>
	                                                	</c:if>
	                                                	<c:if test="${applist.get('APP_YN') eq 'J'}">
	                                                	<h5 class="mb-1">상태</h5>
	                                                	<p class="text-muted mb-0 appStat">승인</p>
	                                                	</c:if>
	                                                	<c:if test="${applist.get('APP_YN') eq 'N'}">
	                                                	<h5 class="mb-1">상태</h5>
	                                                	<p class="text-muted mb-0 appStat">거절</p>
	                                                	</c:if>
	                                                </div>
	                                                <div class="col-3 border-end border-end-dashed">
<%-- 	                                                	<c:if test="${applist.get('APP_YN') eq 'W'}"> --%>
<%-- 		                                                	<button type="button" name="viewRes" class="btn btn-outline-secondary waves-effect waves-light viewRes" data-memno="${applist.get('MEM_NO')}" onclick='javascript:location.href="/mypage/myPageMain?memNo=${applist.get("MEM_NO")}&fo=Y"'>포트폴리오</button> --%>
<%-- 		                                                	<button type="button" name="viewRes" class="btn btn-outline-secondary waves-effect waves-light viewRes" data-memno="${applist.get('MEM_NO')}">포트폴리오</button> --%>
		                                                	<button type="button" class="btn btn-outline-secondary waves-effect waves-light" onclick='pol("${applist.get("MEM_NO")}")'>포트폴리오</button>
<%-- 	                                                	</c:if> --%>
<%-- 	                                                	<c:if test="${applist.get('APP_YN') ne 'W'}"> --%>
<%-- 		                                                	<button type="button" name="viewRes" class="btn btn-outline-secondary waves-effect waves-light" onclick='javascript:location.href="/main/myMain?no=${applist.get("MEM_NO")}"' disabled>포트폴리오</button> --%>
<%-- 	                                                	</c:if> --%>
	                                                </div>
<%-- 	                                                <c:if test="${applist.get('APP_YN') eq 'Y' or applist.get('APP_YN') eq 'N' or applist.get('APP_YN') eq 'J'}"> --%>
<!-- 	                                                <div class="col-3 border-end border-end-dashed"> -->
<!-- 	                                                    <button type="button" class="btn btn-outline-success waves-effect waves-light appliY" disabled>승인</button> -->
<!-- 	                                                </div> -->
<!-- 	                                                <div class="col-3"> -->
<!-- 	                                                    <button type="button" class="btn btn-outline-danger waves-effect waves-light appliN" disabled>거절</button>                                                            	 -->
<!-- 	                                                </div> -->
<%-- 	                                                </c:if> --%>
<%-- 	                                                <c:if test="${applist.get('APP_YN') eq 'W'}"> --%>
	                                                <div class="col-3 border-end border-end-dashed">
	                                                    <button type="button" class="btn btn-outline-success waves-effect waves-light appliY">승인</button>
	                                                </div>
	                                                <div class="col-3">
	                                                    <button type="button" class="btn btn-outline-danger waves-effect waves-light appliN">거절</button>                                                            	
	                                                </div>
<%-- 	                                                </c:if> --%>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                            <!--end card-->
	                            </c:forEach>
		           </c:if>
	           </c:if>
	                        </div>
	                    </div>
	                    <!--end tab-pane-->
<!-- ///////////////////////////////////////////////////////// 프로젝트 구인 공고 지원자 끄읕 ///////////////////////////////////////////////////////// -->


	                </div>
	            </div>
	        </div>
	    </div>
	    <!--end col-->
	</div>
	<!--end row-->
	
	
	
	<!-- ///////////////////////////////////////////////////////// 멤버 초대 모달 ///////////////////////////////////////////////////////// -->
	<div class="modal fade bs-example-modal-lg" tabindex="-1" aria-labelledby="myLargeModalLabel" style="display: none;" aria-hidden="true" id="memInvi">
		<div class="modal-dialog modal-lg">
		    <div class="modal-content" style="min-height:700px;">
		        <div class="modal-header">
		            <h5 class="modal-title fw-bold" id="myLargeModalLabel">멤버 초대 <sub style="color:gray;">Enter 혹은 클릭 시 이메일이 추가됩니다.</sub></h5>
		            <button type="button" class="btn-close closeModal" data-bs-dismiss="modal" aria-label="Close"></button>
		        </div>
		        <div class="modal-body">
		            <div class="d-flex border-bottom mb-4">
		                <div class="flex-grow-1 ms-2">
		                    <div class="row g-2">
	                            <div class="col-lg-12">
	                                <div class="hstack gap-3 float-end">
										<!-- 엘라스틱 서치 -->
										<div class="d-flex">
											<div class="app-search d-none d-md-block"  style="width:300px;">
											    <div class="position-relative">
											        <input type="text" class="form-control finput" placeholder="이메일을 입력해주세요." autocomplete="off" id="search-options">
											        <span class="mdi mdi-magnify search-widget-icon"></span>
											        <span class="mdi mdi-close-circle search-widget-icon search-widget-icon-close d-none" id="search-close-options"></span>
											    </div>
											    <div class="dropdown-menu dropdown-menu-lg" id="search-dropdown">
										            <!-- item-->
										            <div class="dropdown-header mt-2">
										                <h6 class="text-overflow text-muted mb-2 text-uppercase"><i class='ri-user-3-line'></i> 회원</h6>
										            </div>
										            <div class="notification-list" id="memberInfo">
										            </div>
											    </div>
											</div>
										</div>
									</div>
								</div>
							</div>
		            	</div>
		          	</div>
		            <div class="d-flex mt-2">
				        <table class="table table-borderless table-nowrap" id="inviteModal1">
						    <tbody id="inviteModalBody1"></tbody>
						</table>
				        <table class="table table-borderless table-nowrap" id="inviteModal2">
						    <tbody id="inviteModalBody2"></tbody>
						</table>
		            </div>
		        </div>
		        <div class="modal-footer">
		            <a href="javascript:void(0);" class="btn btn-link link-danger fw-medium invite"><i class="ri-mail-send-fill"></i> 초대</a>
		            <a href="javascript:void(0);" class="btn btn-link link-primary fw-medium closeModal" data-bs-dismiss="modal"><i class="ri-close-line me-1 align-middle"></i> 닫기</a>
		        </div>
		    </div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div>
</div>

<script>
var plan = "${projVO.plan}";

if(plan == 'BASIC'){
	var startProj = "${projInfo.get('PROJ_SDY')}";
	console.log(startProj);
	var year = startProj.substr(0, 4);
	var mon = startProj.substr(5, 2);
	var day = startProj.substr(8, 2);
	
	mon = parseInt(mon)+3;
	
	if(mon > 12) {
		mon = mon-12;
		mon = "0" + mon;
		year = parseInt(year)+1;
	}
	
	var max = year + "-" + mon + "-" + day;
	console.log(max);
	
	$("#endProj").attr("max", max);
}

</script>
<script type="text/javascript">
////////////////promem에는 있는데 profile에는 없을 때 해당 회원을 profile에 넣어줌///////////////////
$("#btnSync").on("click",function(){
	let rslt = confirm("promem에는 있는데 profile에는 없을 때 해당 회원을 profile에 넣어줍니다");
	//전체 URL 문자열을 가져옵니다.
	let strUrl = window.location.href;
	console.log("strUrl : " + strUrl);
	let urlArr = strUrl.split("/");
// 	console.log(urlArr[urlArr.length-2]);
	//프로젝트 번호 가져오기
	let projId = urlArr[urlArr.length-2];
	let data = {"projId":projId};
	
	if(rslt){
		$.ajax({
			url : "/project/syncPromemProfile",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
            success : function(res) {
            	console.log("res :" + res);
            	alert("처리되었습니다");
            }
		});
	}else{
		alert("취소되었습니다");
	}
});
</script>