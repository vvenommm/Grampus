<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<%
	int projId = (int) session.getAttribute("projId");
	int pmemCd = (int) session.getAttribute("pmemCd");
	String pmemGrp = (String) session.getAttribute("grp");
%>
<c:set var="pmemGrp" value="<%=pmemGrp%>"></c:set>
<c:set var="pmemCd" value="<%=pmemCd%>"></c:set>
<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">
	             	<a href="/board/boardList?brdHead=${boardVO.brdHead}&projId=${projId}&pmemGrp=${pmemGrp}"><i class="bx bx-left-arrow-circle"></i></a>
	             	${projTtl.projTtl} 
					<c:if test="${projTtl.planTtl =='BASIC'}"><span class="badge bg-primary">BASIC</span></c:if>
					<c:if test="${projTtl.planTtl =='PLUS'}"><span class="badge badge bg-success">PLUS</span></c:if>
					<c:if test="${projTtl.planTtl =='PREMIUM'}"><span class="badge badge bg-warning">PREMIUM</span></c:if>
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
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/board/boardList?brdHead=${boardVO.brdHead}&projId=${projId}&pmemGrp=${pmemGrp}'" style="cursor: pointer">
			                <c:if test="${boardVO.brdHead=='1'}">
								자유게시판
							</c:if>
							<c:if test="${boardVO.brdHead=='2'}">
								헬프데스크
							</c:if>
		                </li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->
<div class="col-xl-15 col-lg-15">
	<div class="card">
		<form name="frm" id="frm"
			action="<%=request.getContextPath()%>/board/boardUpdate"
			method="post" class="user" enctype="multipart/form-data">
			<input type="hidden" value="<%=pmemCd%>" /> <input type="hidden"
				id="pmemGrp" name="pmemGrp" value="<%=pmemGrp%>" /> <input
				type="hidden" id="projId" name="projId" value="<%=projId%>" />
			<div class="card-body">
				<div class="text-muted">
					<input type="hidden" id="pmemCd" name="pmemCd"
						value="${boardVO.pmemCd}"> <input type="hidden"
						id="brdHead" name="brdHead" value="${boardVO.brdHead}"> <input
						type="hidden" id="brdNo" name="brdNo" value="${boardVO.brdNo}">
					<h6 class="mb-3 fw-bold text-uppercase" id="brdTtl" name="brdTtl">${boardVO.brdTtl}</h6>
					<span id="spn">
						<div id="editor">${boardVO.brdCn}</div>
					</span>
					<p1 id="brdCn">${boardVO.brdCn}</p1>
					<input type="hidden" name="brdCn" id="brdCn2" />

					<div class="pt-3 border-top border-top-dashed mt-4">
						<div class="row">
							<div class="col-lg-4 col-sm-6">
								<div>
									<p class="mb-2 text-uppercase fw-medium fs-13">일자</p>
									<h6 class="fs-15 mb-0">
										<fmt:formatDate value="${boardVO.brdDy}" pattern="yyyy.MM.dd" />
									</h6>
								</div>
							</div>
							<div class="col-lg-4 col-sm-6">
								<div>
									<p class="mb-2 text-uppercase fw-medium fs-13">작성자</p>
									<h6 class="fs-15 mb-0">${boardVO.profNm}</h6>
								</div>
							</div>
							<div class="col-lg-4 col-sm-6">
								<div>
									<p class="mb-2 text-uppercase fw-medium fs-13">조회수</p>
									<h6 class="fs-15 mb-0">${boardVO.brdInq}</h6>
								</div>
							</div>
						</div>
					</div>
					<div class="pt-3 border-top border-top-dashed mt-4">
						<h6 class="mb-3 fw-bold text-uppercase">파일 첨부</h6>
						<div class="mb-3" id="fileUpdate"
							style="display: none; width: 400px;">
							<input class="form-control" id="project-thumbnail-img"
								type="file" name="uploadFile" multiple />
						</div>
						<div class="row g-3">

							<!-- /////////////////////////////////////////// 첨부파일 /////////////////////////////////////// -->
							<!-- 첨부파일 리스트가 null이 아닌 경우에 리스트 출력 (null이 출력 되는 것을 방지하기 위함)-->
							<c:forEach var="attachVO" items="${attachVOList}"
								varStatus="stat">
								<c:if test="${attachVO.battSz != 0}">
									<input type="hidden" id="battNoAttach${stat.index}"
										value="${attachVO.battNo}" />
									<div class="col-xxl-4 col-lg-6">
										<div class="border rounded border-dashed p-2">
											<div class="d-flex align-items-center">
												<div class="flex-shrink-0 me-3">
													<div class="avatar-sm">
														<div
															class="avatar-title bg-light text-secondary rounded fs-24">
															<i class="ri-folder-zip-line"></i>
														</div>
													</div>
												</div>
												<div class="flex-grow-1 overflow-hidden">
													<h5 class="fs-15 mb-1">
														<input type="hidden" id="battNm${stat.index}"
															value="${attachVO.battNm}" /> <a
															href="../resources/fileUpload/${attachVO.battNm}" download="${attachVO.battNm}" class="text-body text-truncate d-block">${attachVO.battNm}</a>
													</h5>
													<div>${attachVO.battSz}
														<input type="hidden" id="battSz${stat.index}"
															value="${attachVO.battSz}" />
													</div>
												</div>
												<c:if test="${pmemCd == boardVO.pmemCd}">
													<!-- 삭제 버튼도 로그인 한 사람과 일치할 경우에만 보여준다.  -->
													<div class="flex-shrink-0 ms-2">
														<div class="d-flex gap-1">
															<button type="button" id="fileDel${stat.index}"
																class="btn btn-icon text-muted btn-sm fs-18"
																onclick="fileDelBtn(${stat.index});">
																<i class="ri-delete-bin-fill align-bottom me-2 link-danger"></i>
															</button>
														</div>
													</div>
												</c:if>
											</div>
										</div>
									</div>
									<!-- end col -->
								</c:if>
							</c:forEach>
							<input id="battNo" type="hidden" name="battNo" />
						</div>
						<!-- end row -->
					</div>
					<br />
					<!--////////////////////////////////////////////////// 수정 삭제 버튼 ////////////////////////////////////////-->
					<!-- 본인이 쓴 글만 수정 할 수 있도록 구현 -->
					<c:if test="${pmemCd == boardVO.pmemCd}">
						<div class="row">
							<div class="col-sm">
								<div class="d-flex justify-content-sm-end">
									<span id="spn1">
										<button type="button" id="edit"
											class="btn btn-outline-info waves-effect">수정</button>
										<button type="button" id="delete"
											class="btn btn-outline-danger waves-effect">삭제</button>
									</span>
									<!-- 수정모드 시작 -->
									<span id="spn2" style="display: none;"> <input
										type=button id="allEdit"
										class="btn btn-outline-success waves-effect" value="확인" /> <a
										href="/board/boardDetail?brdNo=${param.brdNo}&projId=${projId}&pmemGrp=${pmemGrp}"
										class="btn btn-outline-danger waves-effect">취소 </a>
									</span>
								</div>
							</div>
						</div>
					</c:if>
				</div>
			</div>
		</form>

		<!--/////////////////////////////////////////////////// 댓글  /////////////////////////////////////////////////////////--->
		<form name="frm3" id="frm3" action="<%=request.getContextPath()%>/reply/replyUpdate" method="post" class="user3">
			<input type="hidden" id="pmemCdRe" name="pmemCd" value="<%=pmemCd%>" />
			<input type="hidden" id="pmemGrpRe" name="pmemGrp" value="<%=pmemGrp%>" />
			<input type="hidden" id="projIdRe" name="projId" value="<%=projId%>" />
			<input type="hidden" name="brdNo" value="${boardVO.brdNo}" id="brdNo2" />
			<div class="row mx-3" id="answerDiv">
				<div class="card">
					<div class="card-header align-items-center d-flex">
						<h4 class="card-title mb-0 flex-grow-1">댓글</h4>
					</div>
		
					<div class="card-body">
						<div data-simplebar="init" style="height: 200px;"
							class="px-3 mx-n3 mb-2">
							<div class="simplebar-wrapper" style="margin: 0px -16px;">
								<div class="simplebar-height-auto-observer-wrapper">
									<div class="simplebar-height-auto-observer"></div>
								</div>
								<div class="simplebar-mask">
									<div class="simplebar-offset" style="right: 0px; bottom: 0px;">
										<div class="simplebar-content-wrapper" tabindex="0"
											role="region" aria-label="scrollable content"
											style="height: 100%; overflow: hidden scroll;">
											<div class="simplebar-content" style="padding: 0px 16px;">
												<!-- 댓글 리스트 띄우기 -->
												<c:forEach var="replyList" items="${replyVOList}" varStatus="stat">
													<input type="hidden" id="rplNoCheck${stat.index}" value="${replyList.rplNo}" />
													<div class="d-flex mb-4">
														<div class="flex-shrink-0">
															<img src="/resources/image/${replyList.profPhoto}" alt="" class="avatar-xs rounded-circle" />
														</div>
														<div class="flex-grow-1 ms-3">
															<h5 class="fs-14">${replyList.profNm}
																<small class="text-muted ms-2"><fmt:formatDate
																		value="${replyList.rplDy}" pattern="yyyy.MM.dd HH:mm:ss"/></small>
																&nbsp;
																<c:if test="${pmemCd == replyList.pmemCd}">
																	<span id="spn5${stat.index}">
																		<a name="replyEdit" id="replyEdit${stat.index}" class="ansEdit" onclick="btnCk(${stat.index});"><i class="ri-edit-2-line align-bottom me-2 link-info"></i></a>
															        	<a name="replyDelete" id="replyDelete${stat.index}" class="ansDelete" onclick="btnDel(${stat.index});"><i class="ri-delete-bin-line align-bottom me-2 link-danger"></i></a>
																	</span>
																</c:if>
															</h5>
		
															<p class="text-muted" id="rpl${stat.index}" name="rpl">${replyList.rplCn}</p>
															<p id="cnRpl${stat.index}" value="${replyList.rplCn}" style="display:none">
		<%-- 														<input type="text" class="form-control form-control-user4" id="Rpl${stat.index}" value="${replyList.rplCn}" /> --%>
																<textarea class="form-control bg-light border-light form-control-user4" rows="3" id="Rpl${stat.index}" placeholder="${replyList.rplCn}"></textarea>
															</p>
															<c:if test="${pmemCd == replyList.pmemCd}">
																<!-- 답변 수정 모드 시작 -->
																<div class="col-sm">
																	<div class="d-flex justify-content-sm-end">
																		<span id="spn6${stat.index}" style="display: none;">
																			<button type="submit"
																				class="btn btn-outline-success waves-effect"
																				onclick="btnClick(${stat.index});">확인</button> <a
																					href="/board/boardDetail?brdNo=${param.brdNo}&projId=${projId}&pmemGrp=${pmemGrp}"
																					class="btn btn-outline-danger waves-effect">취소 </a>
																		</span>
																	</div>
																</div>
															</c:if>
														</div>
													</div>
												</c:forEach>
												<input id="rplCn" type="hidden" name="rplCn" /> <input id="rplNo" type="hidden" name="rplNo" />
											</div>
										</div>
									</div>
								</div>
								<div class="simplebar-placeholder"
									style="width: auto; height: 676px;"></div>
							</div>
							<div class="simplebar-track simplebar-horizontal"
								style="visibility: hidden;">
								<div class="simplebar-scrollbar"
									style="width: 0px; display: none;"></div>
							</div>
							<div class="simplebar-track simplebar-vertical"
								style="visibility: visible;">
								<div class="simplebar-scrollbar"
									style="height: 133px; transform: translate3d(0px, 0px, 0px); display: block;"></div>
							</div>
						</div>
						<div class="mt-4">
							<div class="row g-3">
								<div class="col-12">
									<label for="exampleFormControlTextarea1"
										class="form-label text-body">댓글을 남기기</label>
									<textarea class="form-control bg-light border-light"
										id="exampleFormControlTextarea1" rows="3"
										placeholder="댓글을 남겨주세요...."></textarea>
								</div>
								<div class="col-12 text-end">
									<button type="submit" id="reply"
										class="btn btn-outline-success waves-effect">등록</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>


<script
	src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script type="text/javascript">
	$(function() {
		const Editor = toastui.Editor;
		const editor = new Editor({
			  el: document.querySelector('#editor'),
			  height: '300px',
			  initialEditType: 'wysiwyg',
			  previewStyle: 'vertical'
		});
		
		$(".form-control-user").attr("disabled", "disabled");
		$(".form-control-user2").attr("disabled", "disabled");
		$(".form-control-user3").attr("disabled", "disabled");
		$("#spn").css("display", "none");//에디터 편집기 숨기기
		

		//수정버튼 클릭 -> 수정 모드로 전환
		$('#edit').on("click", function() {
			$("#answerDiv").css("display", "none");//에디더 편집기 보이기
			$("#spn").css("display", "block");//에디더 편집기 보이기
			$("#spn1").css("display", "none");//수정 취소 버튼 숨기기
			$("#spn2").css("display", "block");//확인 취소 버튼 나타나기
			$("#brdCn").css("display", "none");//기존 게시판 내용 숨기기
			$("#fileUpdate").css("display", "block");//파일 업로드 버튼 보이기
			
			//입력란 활성화
			$("#brdTtl").html("<input type='text' class='form-control form-control-user' id='brdTtl2' name='brdTtl' value='${boardVO.brdTtl}' placeholder='${boardVO.brdTtl}'/>");
			CKEDITOR.instances['brdTtl'].setReadOnly(false);
			
			$("#frm").attr("action", "/board/boardUpdate");
			
			
		})
		
		//확인 버튼
		$("#allEdit").on("click", function(){
			
			let brdTtl = $("#brdTtl2").val();
			var brdCn = $("#editor").find('p').text();
			$("#brdTtl").val(brdTtl);
			$("#brdCn2").val(brdCn);
			//글제목
			//글내용
			console.log("brdCn : " + brdCn);

			
			$("#frm").submit();
		});
		
		//삭제버튼 클릭
		$("#delete").on("click", function() {
			$("#frm").attr("action", "/board/boardDelete");
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
		})
		
///////////////////////////////////////// 답변에 대한 함수들 //////////////////////////////////////////////
		//답변 등록 버튼 시
		$("#reply").on("click", function(){
			$("#frm3").attr("action", "/reply/replyWrite");
			let rplCn = $("#exampleFormControlTextarea1").val();
			console.log("rplCn : " + rplCn);
			$('#rplCn').val(rplCn);
			let brdNo = $("#brdNo2").val();
// 			alert("brdNo : " + brdNo);
			//로그인한 pmemCd로 변경 해야함
			var pmemCd = $("#pmemCdRe").val();
			console.log("pmemCd : " + pmemCd);
			
		})
	})
	
	//수정 버튼 클릭 시
	function btnCk(idx){
		$("#spn5"+idx).css("display", "none");
		$("#spn6"+idx).css("display", "block");
		$("#cnRpl"+idx).css("display", "block");
		$("#rpl"+idx).css("display", "none");
	}
	
	//수정 후 확인 버튼 클릭 시
	function btnClick(idx){
		var check = $('#Rpl'+idx).val();
		$('#rplCn').val(check);
		var rplNoCheck = $('#rplNoCheck'+idx).val();
		$('#rplNo').val(rplNoCheck);
		
	}
	
	//삭제버튼 클릭 시
	function btnDel(idx){
		$("#frm3").attr("action", "/reply/replyDelete");
		var rplNoCheck = $('#rplNoCheck'+idx).val();
		$('#rplNo').val(rplNoCheck);
		console.log("rplNo : " + rplNoCheck);
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
	            $("#frm3").submit();
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
	
////////////////////////////////// 파일 삭제 ///////////////////////////
	function fileDelBtn(idx){
		$("#frm").attr("action", "/attach/attachDelete");
		let battNoAttach = $('#battNoAttach'+idx).val();
		$("#battNo").val(battNoAttach);
		let brdNo = $('#brdNo').val();
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
	
	
</script>