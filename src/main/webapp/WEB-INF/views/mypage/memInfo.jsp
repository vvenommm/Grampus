<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<script type="text/javascript">
$(function(){
	//이력서 자격증 없으면 이력서 추가하기 pluRes div띄우기
	var $d = $("#resjob").text();
	$.trim($d);
	console.log("$d : " + $d)
	if($d != ""){ //이력서 자격증이 널이 아니면
		$("#pluRes").hide(); //이력서 추가 숨기기
		$("#resLic").show(); //이력서 나오기
	}
	
	
	//이력서 수정 누르면 안에 <div id=myPage 다 사라지고 비밀번호 입력하게 나옴!
	$('#myPageUpdate').on('click',function(){
		$('#myPageUpdate').hide();//수정버튼 사라져
		$('#rjob').hide();
		$('#rcareer').hide();
		$('#job').show();
		$('#memPhotoUpdate').show();
		$('#career').show();
		$('#rcheck').show();
		$('#rcancel').show();
		$('#licenseUpdateList').show(); 

		
	});
	
	//이력서 수정 취소 누르면
	$('#rcancel').on('click',function(){
		$('#myPageUpdate').show();//수정버튼 다시 보여
		$('#rjob').show();
		$('#rcareer').show();
		$('#job').hide();
		$('#memPhotoUpdate').hide();
		$('#career').hide();
		$('#rcheck').hide();
		$('#rcancel').hide();
		$('#licenseUpdateList').hide(); 
		$('#liceNm').hide();//자격증 추가 삭제 버튼 사라져
	});
	
	//자격증 만료일 없음 라디오버튼 클릭시 만료일 선택 비활성화
	$("#liceEdyNo").change(function(){
		if($('#liceEdyNo').is(":checked")){
			$("input[name='liceExdy']").attr("disabled","false");
		}else{
			Swal.fire({
	            text: '만료일 없음 해제!!',
	            imageUrl: '/resources/image/alertLogo.png',
	            imageHeight: 25,
	            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
			$("input[name='liceExdy']").removeAttr("disabled");
		}
	});

	
	//없으면 입력하라구
	$('#liceSubmit').on("click",function(){
			var licenseNm = $('#licenseNm').val();
			var licenseIsdy = $('#licenseIsdy').val();
			var licenseNum = $('#licenseNum').val();
			var licenseFrom = $('#licenseFrom').val();
			if(licenseNm==""||licenseIsdy==""||licenseNum==""||licenseFrom==""){
				Swal.fire({
		            text: '필수항목을 입력해주세요.',
		            imageUrl: '/resources/image/alertLogo.png',
		            imageHeight: 25,
		            confirmButtonClass: 'btn btn-outline-primary w-xs mb-2',
		            buttonsStyling: false,
		            showCloseButton: true
		      	})
			}else{
				var form = $("#frmLice");
				form.submit();
			}
		});
	
		$('#rcheck').on('click',function(){
			var check = $('#memPhotoUpdate').val();
			//alert(check);
			if(check==""){
				$("#checkPhoto").val(null);
			}else if(check!=null){
				$("#checkPhoto").val("Y");
			}
			var form = $('#resumeUpdate');
			form.submit();
		})
		
		
		//자동 입력 버튼
		$("#rsmJob").on("click", function() {
			$("#rsmJob").val("개발자");
			$("#rsmCareer").val("중급개발자");
		})

	});

function liceDelete(idx){
	var liceNo = $('#liceNo'+idx).val();
	Swal.fire({
        text: "삭제하시겠습니까?",
        icon : 'question',
        showCancelButton: true,
        confirmButtonClass: 'btn btn-outline-primary w-xs me-2 mt-2',
        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
        buttonsStyling: false,
        showCloseButton: true
      }).then(function (result) {
        if (result.value) {
        	location.href = "/mypage/licenseDelete?liceNo="+liceNo;
        } else if (
	        // Read more about handling dismissals
            result.dismiss === Swal.DismissReason.cancel
          ) {
            Swal.fire({
              text: '삭제가 취소되었습니다.',
              icon: 'error',
              confirmButtonClass: 'btn btn-outline-danger mt-2',
              buttonsStyling: false
            })
          }
    });
}

</script>

<style>
 #table{
 	font_size : 200%;
 }
</style>


<!-- -------------- 마이페이지 조회 (이름, 아이디, 자격증 만 조회 가능) ---------------------- -->
<!-- 이력서, 자격증 -->
<div id="resLic" style="display:none">
	<p id="resjob" style="display:none">${resumeVO.rsmJob}</p>
</div>	
<!--myPageUpdate 클릭하면 이력서랑 프로필 이미지,닉네임 만 수정할 수 있음 -->
<!-- 수정 누르고 확인 누르면 이력서 RSM_MDY 최종 수정일 UPDDATE  -->
<!-- 이력서 수정 -->
<form action="/mypage/resuemUpdate" method="post" enctype="multipart/form-data" id="resumeUpdate">
<div class="row">
<div class="col-xl-12">
<div class="card">
	<div class="card-header" style="font-size: 110%;">
		<div>

<!-- 포트폴리오로 볼 때는 안 보이게 -->
<c:if test="${empty fo}">
			<h5 class="card-title mb-3" style="display: inline">내 정보</h5>
			&nbsp;<a id="chIdPw" type="button" class="link-primary" title="회원정보 수정" data-bs-toggle="modal" data-bs-target="#exampleModal">
						<i class="ri-settings-3-fill align-bottom me-1"></i>
					</a>
			<a id="pluRes" data-bs-toggle="modal" data-bs-target="#varyingcontentModal" href="#"> + 내 정보 추가 </a>
</c:if>
<!-- 					<a id="myPageUpdate" class="link-success fs-15" type="button" title="포트폴리오 수정"><i class="ri-edit-2-line"></i></a> &nbsp;&nbsp; -->
		</div>
	</div>
	
	<div class="card-body">
		<div class="row">
			<div class="col-xl-5">
				<p id="memPhoto" style="text-align:center;"><img alt="${memberVO.memPhoto}" src="/resources/image/${memberVO.memPhoto}" class="image avatar-xs rounded-circle" style="width:200px;height:230px;"></p>
				<p style="text-align:center;"><span class="badge badge-outline-dark" style="font-size:100%;">${memberVO.memNm}</span></p>
				<input type="hidden" name="memPhoto" id="checkPhoto" />
				<input id="memPhotoUpdate" type="file" name="file" class="form-control form-control-sm" style="display:none;"/> 
			</div>
			<div class="col-xl-7">
			    <div class="table-responsive">
		    		<input type="hidden" name="memNo" value="${memberVO.memNo}" />
		    		<div></div>
				        <table class="table table-borderless" id="table" style="font-size:110%;">
				            <tbody>
				                <tr>
				                    <th class="ps-0 icon-wrapper icon-container" scope="row"><i class="ri-mail-line"></i></i></th>
				                    <td class="text-muted" >${memberVO.memId}
				                    	<input style="display:none" id="mId" type="text" name="memId" value="${memberVO.memId}" />
				                    </td>
				                </tr>
				                
				                <tr>
				                    <th class="ps-0" scope="row"><i class="ri-briefcase-2-line"></i>  </th> 
				                    <td class="text-muted">
				                    	<p id="rcareer"> ${resumeVO.rsmCareer} </p>
				                    	<p id="career" style="display:none">경력 :<input type="text" class="form-control form-control-user" name="rsmCareer" value="${resumeVO.rsmCareer}"  /></p>
				                    </td>
				                </tr>
				                <tr>
				                    <th class="ps-0" scope="row"><i class="ri-ball-pen-fill"></i> </th>
				                    <td class="text-muted">
				                    	<p id="rjob"> ${resumeVO.rsmJob} </p>
				                    	<p id="job" style="display:none">직무 :<input type="text" class="form-control form-control-user" name="rsmJob" value="${resumeVO.rsmJob}" /></p>
				                    </td>
				                </tr>
				                <c:forEach var="licenseList2" items="${licenseVOList2}" varStatus="stat">
				                	<tr>
				                		<th class="ps-0" scope="row"><i class="ri-profile-line"></i></th>
				                		<td class="text-muted"><p>${licenseList2.liceNm}</p></td>
				                	</tr>
				                </c:forEach>
			               </tbody>
		                </table>
		                <!-- 이력서 수정할 때 나오는 자격증 리스트 -->
		                <!-- 자격증 추가 누르면 모달창 띄움 -->
		                <div id="licenseUpdateList" style="display:none">
							<div class="text-end">
								<a id="plus"  name="plus" type="button" value="+" data-bs-toggle="modal" data-bs-target="#exampleModalgrid" class="badge bg-light text-primary fs-12" >
								<i class="ri-add-fill align-bottom me-1"></i>자격증 추가</a>
							</div>
			                <c:forEach var="licenseList" items="${licenseVOList}" varStatus="stat">
			                <div>
			                    <h6 class="ps-0" scope="row">자격증 ${stat.index+1} : &nbsp;
			                    	<span class="text-muted">${licenseList.liceNm}</span> &nbsp; <input id="liceNo${stat.index}" type="hidden" value="${licenseList.liceNo}" />
				                	<a id="minus${stat.index}" name="minus" class="link-danger fs-15" onclick="liceDelete(${stat.index});">
				                		<i class="ri-delete-bin-line"></i>
				                	</a>
			                    </h6>
			                </div>
			                </c:forEach>
				        </div>
				        <br />
		                <div>	        
			                <!-- 이력서 수정하면 수정 날짜 update 해야 됌~~~~~ -->
			        		<div style="position: absolute; right: 2%; bottom: -5%;" >
				        	<p><input id="rcheck" type="button" value="확인" style="display:none" class="btn btn-outline-primary waves-effect waves-light"/>
							<input id="rcancel" type="button" value="취소" style="display:none" class="btn btn-outline-danger waves-effect waves-light"/></p></div>
						</div>

<!-- 포트폴리오로 볼 때는 안 보이게 -->
<c:if test="${empty fo}">		                
             <c:if test="${!empty resumeVO}">
		                <!-- 자격증, 이력서 수정 -->
					<div style="position: absolute; right: 20px; bottom: 1%;">
						<a id="myPageUpdate" class="link-success fs-15" type="button" title="포트폴리오 수정"><i class="ri-edit-2-line"></i></a>
					</div>	
             </c:if>
</c:if>
  			  </div>
			</div>
		</div>
	</div>
</div>
</div>
</div>
</form>


<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------ -->
<!-- 이력서 추가 모달 -->
<!-- Varying modal content -->

<form action="/mypage/resumeInsert" method="post" >
<div class="modal fade" id="varyingcontentModal" tabindex="-1" aria-labelledby="varyingcontentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="varyingcontentModalLabel">포트폴리오 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                	<input type="hidden" name="memNo" value="${memberVO.memNo}" />
                    <div class="mb-3">
                        <label for="recipient-name" class="col-form-label">직무</label>
                        <input type="text" id="rsmJob" name="rsmJob" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="message-text" class="col-form-label">경력</label>
                        <input type="text" id="rsmCareer" name="rsmCareer" class="form-control">
                    </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </div>
    </div>
  </div>
 </form>
 
 
<!-- 자격증 추가 모달창  -->
<!-- Grids in modals -->
<div class="modal fade" id="exampleModalgrid" tabindex="-1" aria-labelledby="exampleModalgridLabel" aria-modal="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalgridLabel">자격증 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="/mypage/licenseInsert" method="post" id="frmLice">
                <input type="hidden" name="memNo" value="${memberVO.memNo}" />
                    <div class="row g-3">
                            <div class="mb-3">
                        		<label for="license-name" class="col-form-label">자격증명</label>
                        		<input type="text" name="liceNm" class="form-control" id="licenseNm">
                    		</div>
                        <div class="col-xxl-6">
                        	<div class="mb-3">
                        		<label for="license-insertDay" class="col-form-label">취득일</label>
                        		<input type="date" name="liceIsdy" class="form-control" id="licenseIsdy">
                        	</div>
                        </div><!--end col-->
                        <div class="col-xxl-6">
                        	<div class="mb-3">
                        		<label for="license-endDay" class="col-form-label">만료일</label>
                        		<input type="date" name="liceExdy" class="form-control" id="licenseExdy">
                        	</div>
                        </div><!--end col-->
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" name="inlineRadioOptions" id="liceEdyNo">
                            <label class="form-check-label" for="inlineRadio1">만료일 없음</label>
                        </div>
                            <div class="mb-3">
                        		<label for="license-num" class="col-form-label">자격증번호</label>
                        		<input type="text" name="liceSm" class="form-control" id="licenseNum">
                    		</div>
                            <div class="mb-3">
                        		<label for="license-form" class="col-form-label">발급처</label>
                        		<input type="text" name="liceFrom" class="form-control" id="licenseFrom">
                    		</div>
                        <div class="col-lg-12">
                            <div class="hstack gap-2 justify-content-end">
                                <button type="button" class="btn btn-outline-success" id="liceSubmit">등록</button>
<!--                                 <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button> -->
                            </div>
                        </div><!--end col-->
                    </div><!--end row-->
                </form>
            </div>
        </div>
    </div>
</div>