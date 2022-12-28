<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<style>
	#img1 {
		width : 15px;
		height : 15px;
	}
</style>

<script type="text/javascript">
$(function(){
	$('#myProfileUpdate').on('click',function(){
		$('[name="edit"]').show();
		$('#myProfileUpdate').hide();
		$('#myProfileUpdateCancel').show();
		$('[name="planChange"]').hide(); //플랜변경 숨기기
		
	});
	
	//프로필리스트 수정 취소 클릭시
	$('#myProfileUpdateCancel').on('click',function(){
		$('#myProfileUpdateCancel').hide();
		$('#myProfileUpdate').show(); //수정클릭버튼 보이기
		$('[name="planChange"]').show(); //플랜변경 나타나기
		$('[name="edit"]').hide(); //프로필별로 나타나는 수정 버튼 숨기기
		
		
	});

	let varId = '';
	
	$('[name="edit"]').on("click",function(e){
		
		console.log($(e.target).attr('id'));
		
		varId = $(e.target).attr('id');
		
		$('#file'+varId).show(); //input 파일 버튼 보이기
		$('#profNm'+varId).hide(); //닉네임 숨기기
		$('#nm'+varId).show(); //닉네임 수정 창 보이기
		$('#'+varId).hide(); //수정버튼 숨기기
		$('#submit'+varId).show(); //등록버튼 보이기
		$('#cancel'+varId).show(); //취소버튼 보이기	
		$('#myProfileUpdateCancel').hide();
		
		//원래 이미지 value값 가져오기fieImageName
		var fileValue = $("#profPhotoName"+varId).attr("src");
		var fileSplit = fileValue.split('/');
		var fileName = fileSplit[fileSplit.length -1]; //파일명

		
		$('#profImgCheck').val(fileName);
		
	
	});
	
	//프로필 수정 후 취소 누르면 다시 돌아가
	$('[name="cancel"]').on("click",function(){
		$('#file'+varId).hide(); 
		$('#profNm'+varId).show(); 
		$('#nm'+varId).hide(); 
		$('#'+varId).show(); 
		$('#submit'+varId).hide(); 
		$('#cancel'+varId).hide(); 
		$('#myProfileUpdate').show();
		$('#myProfileUpdateCancel').hide();
		$('[name="edit"]').hide();//프로필 수정 숨기기 profPhotoName요기 안의 값
	});
	
});



//프로필 수정 form클릭 이벤트
function btnClick(idx){

	var profileFile = $("#fileImg"+idx).val();

	var profileNmCheck = $("#profileNmCheck"+idx).val();
	var profileProjId = parseInt($("#profileProjId"+idx).val());


	$('#profImgCheck').val(profileFile);
	$('#profNmCheck').val(profileNmCheck);
	$('#profIdCheck').val(profileProjId);
	
}

</script>
	<div class="card">
       <div class="card-header" style="font-size:110%;">
           <h4 class="card-title mb-0" style="display:inline;">프로젝트 프로필</h4>&nbsp;
           <a id="myProfileUpdate"  class="link-success" type="button" title="프로필수정"><i class="ri-edit-2-line align-bottom me-1"></i></a>
		   <a id="myProfileUpdateCancel" type="button"  style="display:none" class="link-danger"><i class="ri-close-circle-line align-bottom me-1"></i></a>
       </div><!-- end card header -->
       
		<div class="card-body"> 
			<c:if test="${profileVOList[0].projId==null}">
				<a href="/jobList"> + 진행중인 프로젝트가 없습니다.</a>
			</c:if>
			<div data-simplebar="init" style="height: 287px; font-size:110%;" class="mx-n3" >
				<div class="simplebar-height-auto-observer-wrapper">
					<div class="simplebar-height-auto-observer"></div>
				</div>
				<div class="simplebar-mask">
					<div class="simplebar-offset" style="right: 0px; bottom: 0px;">
						<div class="simplebar-content-wrapper" tabindex="0" role="region" aria-label="scrollable content"
							style="height: 100%; overflow: hidden scroll;">
							<!-- 반복 -->
							<!-- enctype="multipart/form-data" -->
							<form action="/mypage/profileUpdate" method="post" enctype="multipart/form-data">
								<input type="hidden" name="memNo" value="${memberVO.memNo}" />
									<c:forEach var="profileList" items="${profileVOList}" varStatus="stat">
									<input id="profileRoleId${stat.index}" type="hidden" value="${profileList.roleId}" />
									<input id="payNo${stat.index}" type="hidden" value="${profileList.payNo}" />
									<input id="profileProjId${stat.index}" type="hidden" value="${profileList.projId}" />
									<div class="simplebar-content" style="padding: 0px;">
										<ul class="list list-group list-group-flush mb-0">
											<li class="list-group-item" data-id="01">
												<div class="d-flex align-items-start">
													<div class="flex-shrink-0 me-3">
														<div>
															<div>
																<c:if test="${profileList.profPhoto!=null}"><img id ="profPhotoName${profileList.projId}" class="image avatar-xs rounded-circle" alt="" src="../resources/image/${profileList.profPhoto}"></c:if>
																<!-- 이미지가 널이면 기본 이미지가 보이게 하기 -->
																<c:if test="${profileList.profPhoto==null}"><img id ="profPhotoName${profileList.projId}" class="image avatar-xs rounded-circle" alt="" src="../resources/image/기본.png"></c:if>
															</div>
														</div>
													</div>

													<div class="flex-grow-1 overflow-hidden">
														<h5 id="profNm${profileList.projId}"
															class="contact-name fs-14 mb-1">${profileList.profNm}
															| <span class="badge badge-outline-dark">${profileList.roleNm}</span>
															<!-- 플랜별로 class bg-primary바뀌게 하기 
																 plus : span class="badge bg-success">Success</span
																 premium : span class="badge bg-info">Info</span
																 
															 -->
															 <c:if test="${profileList.planTtl=='BASIC'}"><span class="badge bg-primary">basic</span></c:if>
															 <c:if test="${profileList.planTtl=='PLUS'}"><span class="badge badge bg-success">plus</span></c:if>
															 <c:if test="${profileList.planTtl=='PREMIUM'}"><span class="badge badge bg-warning">premium</span></c:if>
															 <c:if test="${profileList.roleId=='R01'}"> <a href="javascript:location.href='/paymentHistory?projId=${profileList.projId}'" class="badge bg-light text-primary fs-12" id="planChange${stat.index}" name="planChange" type="button" title="플랜변경" ><i class="ri-edit-box-line align-bottom me-1"></i>Payment history</a></c:if>
															 <input name="edit" id="${profileList.projId}" class="btn btn-ghost-primary waves-effect waves-light btn-sm" type="button" value='+ 프로필수정' style="display:none"/>
															 <!-- <img id="img1" src="/resources/image/설정.png" alt="" />이미지로 설정 -->
<%-- 															 <input id="planChange${stat.index}" name="planChange" type="button" value="플랜변경" onclick="javascript:location.href='/plan/planList'"/> --%>
														</h5>
														<p class="contact-born text-muted mb-0">${profileList.projTtl}</p><br />
														<p id="nm${profileList.projId}" style="display:none"><input type="text" id="profileNmCheck${stat.index}" value="${profileList.profNm }" class="form-control form-control-sm mb-2"/></p>
														<div id="file${profileList.projId}" style="display:none">
															<input type="file" id="fileImg${stat.index}" name="fieImageName" class="form-control form-control-sm mb-2"/>
<!-- 															<div class="col-lg-6"> ${profileList.projId} -->
<!-- 							                                    <div class="card"> -->
<!-- 							                                        <div class="card-header"> -->
<!-- 							                                            <h4 class="card-title mb-0">Profile Picture Selection</h4> -->
<!-- 							                                        </div>end card header -->
							
<!-- 							                                        <div class="card-body"> -->
<!-- 							                                            <p class="text-muted">FilePond is a JavaScript library with profile picture-shaped file upload variation.</p> -->
<!-- 							                                            <div class="avatar-xl mx-auto"> -->
<!-- 							                                                <div class="filepond--root filepond filepond-input-circle filepond--hopper" data-style-panel-layout="compact circle" data-style-button-remove-item-position="left bottom" data-style-button-process-item-position="right bottom" data-style-load-indicator-position="center bottom" data-style-progress-indicator-position="right bottom" data-style-button-remove-item-align="false" style="height: 120px;"><input class="filepond--browser" type="file" id="filepond--browser-y94aznucu" name="filepond" aria-controls="filepond--assistant-y94aznucu" aria-labelledby="filepond--drop-label-y94aznucu"><a class="filepond--credits" aria-hidden="true" href="https://pqina.nl/" target="_blank" rel="noopener noreferrer" style="transform: translateY(120px);">Powered by PQINA</a><div class="filepond--drop-label" style="transform: translate3d(0px, 0px, 0px); opacity: 1;"><label for="filepond--browser-y94aznucu" id="filepond--drop-label-y94aznucu" aria-hidden="true">Drag &amp; Drop your picture or <span class="filepond--label-action" tabindex="0">Browse</span></label></div><div class="filepond--list-scroller" style="transform: translate3d(0px, 0px, 0px);"><ul class="filepond--list" role="list"></ul></div><div class="filepond--panel filepond--panel-root" data-scalable="false"><div class="filepond--panel-top filepond--panel-root"></div><div class="filepond--panel-center filepond--panel-root" style="transform: translate3d(0px, 0px, 0px) scale3d(1, 1.2, 1);"></div><div class="filepond--panel-bottom filepond--panel-root" style="transform: translate3d(0px, 120px, 0px);"></div></div><span class="filepond--assistant" id="filepond--assistant-y94aznucu" role="status" aria-live="polite" aria-relevant="additions"></span><div class="filepond--drip"></div> -->
<%-- 							                                                <fieldset class="filepond--data" id="fileImg${stat.index}" name="fieImageName${profileList.projId}" ></fieldset></div> --%>
<!-- 							                                            </div> -->
							
<!-- 							                                        </div> -->
<!-- 							                                        end card body -->
<!-- 							                                    </div> -->
<!-- 							                                    end card -->
<!-- 							                                </div> -->
														</div>
														<input id="submit${profileList.projId}" class="btn btn-outline-success waves-effect waves-light" type="submit" value="확인" style="display:none"  onclick="btnClick(${stat.index});"/>
														<input name="cancel" id="cancel${profileList.projId}" class="btn btn-outline-danger waves-effect waves-light" type="button" value="취소" style="display:none"/>
													</div>
												</div>
											</li>
										</ul>
										<!-- end ul list -->
									</div>
								</c:forEach>
								<input type="hidden" id="profIdCheck" name="projId"/>
								<input type="hidden" id="profNmCheck" name="profNm"/>
								<input type="hidden" id="profImgCheck" name="profPhoto"/>
<!-- 								<input type="file" id="profImgCheck" name="profImg" style="display:none"/> -->
							</form>
						</div>
					</div>
				</div>
			</div>
			<!-- end card -->
		</div>
		<!-- end col -->
		</div>

