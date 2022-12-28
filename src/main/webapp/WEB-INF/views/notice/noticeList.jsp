<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />


<% 
	int projId = (int) session.getAttribute("projId");
	String pmemGrp = (String) session.getAttribute("grp");
%>
<c:set var="pmemGrp" value="<%=pmemGrp%>"></c:set>
<c:set var="projId" value="<%=projId%>"></c:set>

<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">${projTtl.projTtl} 
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
	                    	<a href="javascript: location.href='/project/projMain/${projId}/${pmemGrp}';">
	                    		<i class="ri-home-2-fill"></i>
	                    	</a>
	                    </li>
	                    <li class="breadcrumb-item active">${pmemGrp}</li>
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/notice/noticeList/${projId}/${pmemGrp}'" style="cursor: pointer">공지사항</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->

<div class="row g-4 mb-3">
	<div class="col-sm-auto">
		<div class="d-flex justify-content-sm-end gap-2">
			<a class="btn btn-soft-info waves-effect waves-light"
				id="showAll">전체보기</a>
			<div class="search-box ms-2">
				<input type="text" id="searchCn" class="form-control"
					placeholder="검색하기" value="${scon}"> <i
					class="ri-search-line search-icon"></i>
			</div>
			<a class="btn btn-soft-info waves-effect waves-light"
				id="seachNotice">검색</a>
		</div>
	</div>
	<!-- pl만 작성 가능 -->
	 <c:if test="${noticeVO[0].roleNm == 'PM'}">
		<div class="col-sm">
			<div class="d-flex justify-content-sm-end">
				<div class="d-flex justify-content-sm-end gap-2">
					<a href='/notice/noticeWrite?projId=${projId}&pmemGrp=${pmemGrp}'
						class="btn btn-ghost-primary waves-effect waves-light"> <i
						class="ri-add-line align-bottom me-1"></i> 작성하기
					</a>
				</div>
			</div>
		</div>
	</c:if>
</div>

<form name="frm" id="frm" action="<%=request.getContextPath()%>/notice/noticeUpdate" method="post" class="user">
	<input type="hidden" id="pmemGrp" name="pmemGrp" value="<%=pmemGrp%>" />
	<input type="hidden" id="projId" name="projId" value="<%=projId%>" />
	<div class="row">
		<c:forEach var="noticeList" items="${noticeVO}" varStatus="stat">
			<input type="hidden" id="ntcNoCheck${stat.index}" value="${noticeList.ntcNo}" />
		    <div class="col-xxl-3 col-sm-6 project-card">
		        <div class="card card-height-100 border">
		            <div class="card-body">
		                <div class="d-flex flex-column h-100">
		                    <div class="d-flex">
		                        <div class="flex-grow-1">
		                            <div class="text-muted">
		                            	<i class="ri-calendar-event-fill me-1 align-bottom"></i>
		                            	<fmt:formatDate value="${noticeList.ntcDy}" pattern="yyyy.MM.dd" />
		                        	</div>
		                        </div>
		                        <div class="flex-shrink-0">
		                            <div class="d-flex gap-1 align-items-center">
		                                <div class="text-muted">
		                                	<i class="ri-pushpin-fill"></i>
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		                    <div class="d-flex mb-2 mt-2">
		                        <div style="width:100%;">
		                           <!-- 공지사항 제목 -->
									<h6 class="card-title mb-3 text-uppercase" id="ttl${stat.index}" name="ttl">
										${noticeList.ntcTtl}
									</h6>
									<!-- 수정 버튼 클릭 시 보여지는 공지사항 제목 -->
									<h6 id="ttlNtc${stat.index}" value="${noticeList.ntcTtl}"style="display: none">
										<input type="text" class="form-control form-control-user4" id="Ttl${stat.index}" value="${noticeList.ntcTtl}" />
									</h6>
									<!-- 공지사항 내용 -->
									<p1 id="Cn${stat.index}" lass="text-muted text-truncate-two-lines mb-3">${noticeList.ntcCn}</p1>
									<!-- 수정 버튼 클릭 시 보여지는 공지사항 내용 -->
									<div id="cnNtc${stat.index}" value="${noticeList.ntcCn}"style="display: none">
										<div id="editor${stat.index}">${noticeList.ntcCn}</div>
									</div>
		                        </div>
		                    </div>
		                </div>
		
		            </div>
		            <!--  pl만 공지사항의 권한을 가지고 있음  -->
		            <c:if test="${noticeList.roleNm == 'PM'}">
			            <!-- end card body -->
			            <div class="card-footer bg-transparent border-top-dashed py-2">
		                	<div class="hstack gap-2 justify-content-end">
			                	<span id="spn1${stat.index}">
									<button type="button" id="edit${stat.index}"
										class="btn btn-outline-info waves-effect btn-sm" onclick="btnUp(${stat.index});">수정</button>
									<button type="button" id="delete${stat.index}"
										class="btn btn-outline-danger waves-effect btn-sm" onclick="btnDel(${stat.index});">삭제</button>
								</span>
								<!-- 수정모드 시작 -->
								<span id="spn2${stat.index}" style="display: none;"> <input type=button
									id="allEdit${stat.index}" class="btn btn-outline-success waves-effect btn-sm"
									value="확인" onclick="btnClick(${stat.index});"/> <a
									href="/notice/noticeList/${noticeList.projId}/${pmemGrp}"
									class="btn btn-outline-danger waves-effect btn-sm">취소 </a>
								</span>
							</div>
			            </div>
		            </c:if>
			        <!-- end card footer -->
		        </div>
		        <!-- end card -->
		    </div>
		    <!-- end col -->
	    </c:forEach>
	    <input id="ntcTtl" type="hidden" name="ntcTtl" />
		<input id="ntcCn" type="hidden" name="ntcCn" /> <input id="ntcNo" type="hidden" name="ntcNo" />
	</div>
	<!-- end row -->
</form>

<c:if test="${empty noticeVO}">
	<p class="text-center">공지사항이 존재하지 않습니다.</p>
</c:if>
<div class="row g-4 mb-2">
	<div class="col-12 text-center">
		<a class="btn btn-ghost-primary waves-effect waves-light"
			id="moreList"><i class="ri-add-line align-bottom me-1"></i> 더보기</a>
	</div>
</div>


<script type="text/javascript">
$(function(){
	
	//수정 editor
	var cnt = '${noticeVO[0].cnt}';
	console.log('cnt : ' + cnt);
	
	const Editor = toastui.Editor;
    for(var i = 0; i<cnt; i++){
		const editor = new Editor({
			  el: document.querySelector('#editor'+i),
			  height: '300px',
			  initialEditType: 'wysiwyg',
			  previewStyle: 'vertical'
		});
    }
	
	$(".form-control-user").attr("disabled", "disabled");
	$(".form-control-user2").attr("disabled", "disabled");
	$(".form-control-user3").attr("disabled", "disabled");
	
})

//수정 버튼 클릭 시
function btnUp(idx){
	$("#spn1"+idx).css("display", "none");
	$("#spn2"+idx).css("display", "block");
	$("#ttl"+idx).css("display", "none");
	$("#ttlNtc"+idx).css("display", "block");
	$("#Cn"+idx).css("display", "none");//기존 게시판 내용 숨기기
	$("#cnNtc"+idx).css("display", "block");//에디더 편집기 보이기
}

//수정 후 확인 버튼 클릭 시
function btnClick(idx){
	var Ttlcheck = $('#Ttl'+idx).val();
	$('#ntcTtl').val(Ttlcheck);
	var Cncheck = $("#editor"+idx).find('p').text();
	console.log("Cncheck:"+Cncheck);
	$('#ntcCn').val(Cncheck);
	var ntcNoCheck = $('#ntcNoCheck'+idx).val();
	$('#ntcNo').val(ntcNoCheck);
	
	$("#frm").submit();
	
}

//삭제버튼 클릭 시
function btnDel(idx){
	$("#frm").attr("action", "/notice/noticeDelete");
	var ntcNoCheck = $('#ntcNoCheck'+idx).val();
	$('#ntcNo').val(ntcNoCheck);
	console.log("ntcNo : " + ntcNoCheck);
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
            $("#frm").submit();
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
}


//////////////////검색 기능과 페이지 구현 ////////////////
$(function(){
	/* qna검색 */
	$("#seachNotice").on("click",function(){
		var cont = $("#searchCn").val();
		location.href = "/notice/noticeList/${projId}/${pmemGrp}?cont="+cont+"&listcnt=1";
	});
	
	/* 전체보기 */
	$("#showAll").on("click",function(){
		location.href = "/notice/noticeList/${projId}/${pmemGrp}?cont=&listcnt=1";
	});
	
	/* qna 더보기 */
	$("#moreList").on("click",function(){
		if(`${param.cont}` == null){
			location.href = "/notice/noticeList/${projId}/${pmemGrp}?cont=&listcnt="+`${listcnt+1}`;
		}else{
			location.href = "/notice/noticeList/${projId}/${pmemGrp}?cont="+`${param.cont}`+"&listcnt="+`${listcnt+1}`;
		}
	});
})


</script>