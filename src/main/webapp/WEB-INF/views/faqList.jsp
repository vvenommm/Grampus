<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<%
	String adminId = (String) session.getAttribute("id");
%>

<br />
<div class="page-content">
<div id="one">
	<div style="text-align: center;">
		<h5>고객센터</h5>
	</div>
	<div style="text-align: center;">
		<p class="text-muted">자주 찾는 도움말</p>
	</div>
	<!-- 관리자일 경우 작성하기 버튼 구현 -->
	<c:if test="${id == 'admin'}">
		<div style="margin-right: 3%;">
			<div class="row g-4 mb-2">
				<div class="col-sm">
					<div class="d-flex justify-content-sm-end">
						<div class="d-flex justify-content-sm-end gap-2">
							<a href='/faqWrite'
								class="btn btn-ghost-primary waves-effect waves-light"> <i
								class="ri-add-line align-bottom me-1"></i> FAQ 작성하기
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
	<!-- FAQ LIST와 모달 -->
	<div
		style="text-align: center; margin: 0 auto; height: 20%; width: 48%;">
		<c:forEach var="faqList" items="${faqVOList}" varStatus="stat">
			<input type="button"
				class="btn btn-primary  waves-effect waves-light"
				data-bs-toggle="modal" data-bs-target="#myModal"
				id="ttlFaq${stat.index}" onclick="btnModal(${stat.index});"
				value="Q. ${faqList.faqTtl}" style="margin-right: 20px; margin-top:15px;" />
			<input type="hidden" id="cnFaq${stat.index}"
				value="${faqList.faqCn }" />
		</c:forEach>
	</div>
	<div id="myModal" class="modal fade" tabindex="-1"
		aria-labelledby="myModalLabel" aria-hidden="true"
		style="display: none;">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content border-primary">
				<div class="modal-header">
					<h5 class="modal-title" id="myModalLabel"></h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<h5 class="fs-15" id="faqCn"></h5>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<br /> <br />
</div>
<br /><br />
<!-- qna리스트 -->
<form name="frm" id="frm"
	action="<%=request.getContextPath()%>/qnaUpdate" method="post"
	class="user">
	<div style="margin-left: 3%; margin-right: 3%;">
		<!-- qna검색 &작성하기 -->
		<div class="row g-4 mb-2">
			<div class="col-sm-auto">
				<div class="d-flex justify-content-sm-end gap-2">
					<a class="btn btn-primary waves-effect" id="showAll">전체보기</a>
					<div class="search-box ms-2">
						<input type="text" id="searchCn" class="form-control"
							placeholder="Q&A제목 입력" value="${scon}"> <i
							class="ri-search-line search-icon"></i>
					</div>
					<a class="btn btn-primary waves-effect" id="searchQna">검색</a>
				</div>
			</div>
			<div class="col-sm">
				<div class="d-flex justify-content-sm-end">
					<div class="d-flex justify-content-sm-end gap-2">
						<a href='/qnaWrite'
							class="btn btn-ghost-primary waves-effect waves-light"> <i
							class="ri-add-line align-bottom me-1"></i> 작성하기
						</a>
					</div>
				</div>
			</div>
		</div>
		<div
			class="accordion custom-accordionwithicon custom-accordion-border accordion-border-box accordion-primary"
			id="accordionBordered">
			<c:forEach var="qnaList" items="${qnaVOList}" varStatus="stat">
				<c:if test="${id != 'admin'}">
					<input type="hidden" id="memNoUpdate${stat.index}"
						value="${qnaList.memNo}" />
					<input type="hidden" id="qnaNoUpdate${stat.index}"
						value="${qnaList.qnaNo}" />
					<div class="accordion-item">
									<!--////////////////////////////////// 비밀글인 경우///////////////////////////////////////////-->
						<!-- 비밀글일 경우 표시되는 제목 -->
						<span id="find">
						<c:if test="${qnaList.qnaPw != null}">
							<h2 class="accordion-header"
								id="accordionborderedExample${stat.index}">
								<button class="accordion-button" type="button"
									data-bs-toggle="collapse"
									data-bs-target="#accor_borderedExamplecollapse${stat.index}"
									aria-expanded="true"
									aria-controls="accor_borderedExamplecollapse${stat.index}">
										<span id="scTtlOn${stat.index}">${qnaList.rownum}.&nbsp;비밀글&nbsp; <i class=" ri-key-2-fill"></i> </span> <span id="scTtlOff${stat.index}" style="display:none;">${qnaList.rownum}.&nbsp;${qnaList.qnaTtl}</span>
								</button>
							</h2>
							<div id="accor_borderedExamplecollapse${stat.index}"
								class="accordion-collapse collapse show"
								aria-labelledby="accordionborderedExample${stat.index}"
								data-bs-parent="#accordionBordered">
								<div class="accordion-body">
									<div style="float: right; margin-right: 1%;">
										<p>작성자 : ${qnaList.qnaNim}</p>
									</div>
										<div style="float: right; margin-right: 1%;">
											<fmt:formatDate value="${qnaList.qnaDy}" pattern="yyyy.MM.dd" />
										</div>
									<div class="row g-4 mb-2" id="secretOnCn${stat.index}">
										<div class="col-sm-auto">
											<div class="d-flex justify-content-sm-end gap-2">
												<input id="qnaPw${stat.index }" type="hidden"
													class="form-control" value="${qnaList.qnaPw}"> <input
													type="password" id="pwQna${stat.index }"
													class="form-control" style="width: 100px;" /> <a
													class="btn btn-primary waves-effect"
													onclick="btnPw(${stat.index});">확인</a>
											</div>
										</div>
									</div>
									<!-- 비밀번호 일치 시 내용 표시 -->
									<div id="secretOffCn${stat.index}" style="display: none;">
										<p class="text-muted" id="qna${stat.index}" name="qna">${qnaList.qnaCn}</p>
										<p id="cnQna${stat.index}" value="${qnaList.qnaCn}"
											style="display: none">
											<textarea class="form-control bg-light border-light form-control-user4" rows="3" id="Qna${stat.index}" placeholder="">${qnaList.qnaCn}</textarea>
										</p>
										<br />
										<!-- qna 수정 삭제  (비회원일 경우에는 수정 삭제 기능이 없음)-->
										<c:if
											test="${qnaList.memNo != null && qnaList.memNo == memNo}">
											<div class="row">
												<div class="col-sm">
													<div class="d-flex justify-content-sm-end">
														<span id="spn1${stat.index}">
															<button type="button" id="edit${stat.index}t"
																class="btn btn-outline-primary waves-effect"
																onclick="btnUp(${stat.index});">수정</button>
															<button type="button" id="delete${stat.index}"
																class="btn btn-outline-danger waves-effect"
																onclick="btnDel(${stat.index});">삭제</button>
														</span>
														<!-- 수정모드 시작 -->
														<span id="spn2${stat.index}" style="display: none;">
															<button type="submit"
																class="btn btn-outline-success waves-effect"
																onclick="btnOk(${stat.index});">확인</button> <a
															href="/faqList" class="btn btn-outline-danger waves-effect">취소
														</a>
														</span>
													</div>
												</div>
											</div>
										</c:if>
										<br />
										<!-- 관리자  댓글  -->
										<div class="pt-3 border-top border-top-dashed mt-2">
											<p class="text-muted" id="rpl${stat.index}" name="rpl">
												관리자 : ${qnaList.qnaReply}</p>
											<p id="rplQna${stat.index}" value="${qnaList.qnaReply}"
												style="display: none">
												<input type="text" class="form-control form-control-user4"
													id="Rpl${stat.index}" value="${qnaList.qnaReply}" />
											</p>
										</div>
										<br />
									</div>
								</div>
							</div>
						</c:if>
						</span>


						<!--////////////////////////////////// 비밀글 아닌 경우 ///////////////////////////////////////////-->
						<c:if test="${qnaList.qnaPw == null}">
						<h2 class="accordion-header"
							id="accordionborderedExample${stat.index}">
							<button class="accordion-button" type="button"
								data-bs-toggle="collapse"
								data-bs-target="#accor_borderedExamplecollapse${stat.index}"
								aria-expanded="true"
								aria-controls="accor_borderedExamplecollapse${stat.index}">${qnaList.rownum}.&nbsp;
								${qnaList.qnaTtl}</button>
						</h2>
							<div id="accor_borderedExamplecollapse${stat.index}"
								class="accordion-collapse collapse show"
								aria-labelledby="accordionborderedExample${stat.index}"
								data-bs-parent="#accordionBordered">
								<div class="accordion-body">
									<div style="float: right; margin-right: 1%;">
										<p>작성자 : ${qnaList.qnaNim}</p>
									</div>
									<div style="float: right; margin-right: 1%;">
										<fmt:formatDate value="${qnaList.qnaDy}" pattern="yyyy.MM.dd" />
									</div>
									<p class="text-muted" id="qna${stat.index}" name="qna">${qnaList.qnaCn}</p>
									<p id="cnQna${stat.index}" value="${qnaList.qnaCn}"
										style="display: none">
<%-- 										<input type="text" class="form-control form-control-user4" id="Qna${stat.index}" value="${qnaList.qnaCn}" /> --%>
										<textarea class="form-control bg-light border-light form-control-user4" rows="3" id="Qna${stat.index}" placeholder="">${qnaList.qnaCn}</textarea>
									</p>

									<br />
									<!-- qna 수정 삭제  (비회원일 경우에는 수정 삭제 기능이 없음)-->
									<c:if test="${qnaList.memNo != null && qnaList.memNo == memNo}">
										<div class="row">
											<div class="col-sm">
												<div class="d-flex justify-content-sm-end">
													<span id="spn1${stat.index}">
														<button type="button" id="edit${stat.index}t"
															class="btn btn-outline-primary waves-effect"
															onclick="btnUp(${stat.index});">수정</button>
														<button type="button" id="delete${stat.index}"
															class="btn btn-outline-danger waves-effect"
															onclick="btnDel(${stat.index});">삭제</button>
													</span>
													<!-- 수정모드 시작 -->
													<span id="spn2${stat.index}" style="display: none;">
														<button type="submit"
															class="btn btn-outline-success waves-effect"
															onclick="btnOk(${stat.index});">확인</button> <a
														href="/faqList" class="btn btn-outline-danger waves-effect">취소
													</a>
													</span>
												</div>
											</div>
										</div>
									</c:if>
									<br />

									<!-- 관리자  댓글  -->
									<div class="pt-3 border-top border-top-dashed mt-2">
										<p class="text-muted" id="rpl${stat.index}" name="rpl">
											관리자 : ${qnaList.qnaReply}</p>
										<p id="rplQna${stat.index}" value="${qnaList.qnaReply}"
											style="display: none">
											<textarea class="form-control bg-light border-light form-control-user4" rows="3" id="Rpl${stat.index}" placeholder="">${qnaList.qnaReply}</textarea>
										</p>
									</div>
								</div>
							</div>
						</c:if>
					</div>
				</c:if>


				<!--/////////////////////////////////// 관리자 페이지 따로 구현 했음/////////////////////////////////// -->


				<c:if test="${id == 'admin'}">
					<input type="hidden" id="memNoUpdate${stat.index}"
						value="${qnaList.memNo}" />
					<input type="hidden" id="qnaNoUpdate${stat.index}"
						value="${qnaList.qnaNo}" />
					<div class="accordion-item">
						<!-- 비밀글일 경우 표시되는 제목 -->
						<h2 class="accordion-header"
							id="accordionborderedExample${stat.index}">
							<button class="accordion-button" type="button"
								data-bs-toggle="collapse"
								data-bs-target="#accor_borderedExamplecollapse${stat.index}"
								aria-expanded="true"
								aria-controls="accor_borderedExamplecollapse${stat.index}">${qnaList.rownum}.
								${qnaList.qnaTtl}</button>
						</h2>
						<div id="accor_borderedExamplecollapse${stat.index}"
							class="accordion-collapse collapse show"
							aria-labelledby="accordionborderedExample${stat.index}"
							data-bs-parent="#accordionBordered">
							<div class="accordion-body">
								<div style="float: right; margin-right: 1%;">
									<fmt:formatDate value="${qnaList.qnaDy}" pattern="yyyy.MM.dd" />
								</div>
								<p class="text-muted" id="qna${stat.index}" name="qna">${qnaList.qnaCn}</p>
								<p id="cnQna${stat.index}" value="${qnaList.qnaCn}"
									style="display: none">
									<input type="text" class="form-control form-control-user4"
										id="Qna${stat.index}" value="${qnaList.qnaCn}" />
								</p>

								<br />
								<div class="row">
									<div class="col-sm">
										<div class="d-flex justify-content-sm-end">
											<span id="spn1${stat.index}">
												<button type="button" id="delete${stat.index}"
													class="btn btn-outline-danger waves-effect"
													onclick="btnDel(${stat.index});">삭제</button>
											</span>
										</div>
									</div>
								</div>
								<br />

								<!-- 관리자  댓글 달기  -->
								<div class="pt-3 border-top border-top-dashed mt-2">
									<p class="text-muted" id="rpl${stat.index}" name="rpl">관리자
										: ${qnaList.qnaReply}</p>
									<p id="rplQna${stat.index}" value="${qnaList.qnaReply}"
										style="display: none">
<!-- 										<input type="text" class="form-control form-control-user4" -->
<%-- 											id="Rpl${stat.index}" value="${qnaList.qnaReply}" /> --%>
										<textarea class="form-control bg-light border-light form-control-user4" rows="3" id="Rpl${stat.index}" placeholder="">${qnaList.qnaReply}</textarea>
											
									</p>
									<!--////////////////////////// 관리자 댓글이 없을 경우 //////////////////////////////-->
									<c:if test="${qnaList.qnaReply == null}">
										<div class="row">
											<div class="col-sm">
												<div class="d-flex justify-content-sm-end">
													<span id="spn5${stat.index}">
														<button type="button"
															class="btn btn-outline-primary waves-effect"
															onclick="btnWrite(${stat.index});">댓글달기</button>
													</span> <span id="spn6${stat.index}" style="display: none;">
														<button type="submit"
															class="btn btn-outline-success waves-effect"
															onclick="btnWriteOk(${stat.index});">등록</button>
													</span>
												</div>
											</div>
										</div>
									</c:if>
									<!-- ////////////////////////// 관리자 댓글이 있을 경우 //////////////////////////-->
									<c:if test="${qnaList.qnaReply != null}">
										<div class="row">
											<div class="col-sm">
												<div class="d-flex justify-content-sm-end">
													<span id="spn3${stat.index}">
														<button type="button"
															class="btn btn-outline-primary waves-effect"
															onclick="btnUpAdmin(${stat.index});">수정</button>
														<button type="button"
															class="btn btn-outline-danger waves-effect"
															onclick="btnDelAdmin(${stat.index});">삭제</button>
													</span>
													<!-- 수정모드 시작 -->
													<span id="spn4${stat.index}" style="display: none;">
														<button type=submit
															class="btn btn-outline-success waves-effect" value="확인"
															onclick="btnOkAdmin(${stat.index});">확인</button> <a
														href="/faqList" class="btn btn-outline-danger waves-effect">취소
													</a>
													</span>
												</div>
											</div>
										</div>
									</c:if>
								</div>
							</div>
						</div>
					</div>
				</c:if>
			</c:forEach>
			<input id="qnaCn" type="hidden" name="qnaCn" /> <input id="qnaNo"
				type="hidden" name="qnaNo" /> <input id="memNo" type="hidden"
				name="memNo" /> <input id="qnaReply" type="hidden" name="qnaReply" />
		</div>
		<br />
	</div>
</form>
<div class="row g-4 mb-2" id="plus">
	<div class="col-12 text-center">
		<a class="btn btn-ghost-primary waves-effect waves-light"
			id="moreList"><i class="ri-add-line align-bottom me-1"></i> 더보기</a>
	</div>
</div>
</div>



<script type="text/javascript">

	$(document).ready(function(){
		$('.accordion-collapse').collapse("hide");
	});

	/* 수정 버튼 클릭 시 */
	function btnUp(idx) {
		$("#spn1" + idx).css("display", "none"); // 수정 삭제 버튼 숨기기
		$("#spn2" + idx).css("display", "block");//확인 취소 버튼 나오기
		$("#spn3" + idx).css("display", "none");//관리자 수정 삭제 버튼 숨기기
		$("#spn4" + idx).css("display", "none");//관리자 확인 취소 버튼 숨기기
		$("#cnQna" + idx).css("display", "block");//댓글 텍스트 함수로 나오기
		$("#qna" + idx).css("display", "none");//보이는 p태그 댓글 숨기기
	}

	/* 수정 후  */
	function btnOk(idx) {
		//		alert("i : " + idx);
		var check = $('#Qna' + idx).val();
// 		alert("check : " + check);
		$('#qnaCn').val(check);
		var qnaNoUpdate = $('#qnaNoUpdate' + idx).val();
		$('#qnaNo').val(qnaNoUpdate);
		var memNoUpdate = $('#memNoUpdate' + idx).val();
		$('#memNo').val(memNoUpdate);
// 		alert("memNoUpdate : " + memNoUpdate);

	}

	/* 삭제 */
	function btnDel(idx) {
		$("#frm").attr("action", "/qnaDelete");
		var qnaNoUpdate = $('#qnaNoUpdate' + idx).val();
		$('#qnaNo').val(qnaNoUpdate);
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
	
	/* 모달 함수 */
	function btnModal(idx) {
		var faqTtl = $('#ttlFaq' + idx).val();
		$("#myModalLabel").html(faqTtl);
		console.log("faqTtl : " + faqTtl);
		
		var faqCn = $('#cnFaq' + idx).val();
		$("#faqCn").html(faqCn);
		console.log("faqCn : " + faqCn);

	}
	
	/* 비밀글 여부  */
	function btnPw(idx){
		let qnaPw = $('#qnaPw' + idx).val();
		let pwQna = $('#pwQna' + idx).val();
		console.log("qnaPw : " + qnaPw);
		console.log("pwQna : " + pwQna);
		if(qnaPw == pwQna){
			
			$("#scTtlOn"+ idx).css("display", "none");//비밀글 제목 숨기기
			$("#scTtlOff"+ idx).css("display", "block");//비밀글 제목 나오기
			$("#secretOnCn"+ idx).css("display", "none");//비밀글 내용 숨기기
			$("#secretOffCn"+ idx).css("display", "block");//비밀글 내용 나오기
			console.log("비밀글 풀기");
		} else {
			Swal.fire({
	            text: '비밀번호가 틀렸습니다.',
	            icon: 'warning',
	            confirmButtonClass: 'btn btn-warning w-xs mb-2',
	            buttonsStyling: false,
	            showCloseButton: true
	      	})
		}
	}

/////////////////////////// 관리자 댓글 ///////////////////////////////

	/* 댓글 등록 */
	function btnWrite(idx){
		$('#rplQna' + idx).css("display", "block");
		$("#spn5" + idx).css("display", "none");
		$("#spn6" + idx).css("display", "block");
	}
	
	/* 댓글 등록 후 확인 */
	function btnWriteOk(idx){
		$("#frm").attr("action", "/qnaReply");
		var qnaNoUpdate = $('#qnaNoUpdate' + idx).val();
		$('#qnaNo').val(qnaNoUpdate);
		
		var qnaReply = $('#Rpl' + idx).val();
		$('#qnaReply').val(qnaReply);
		console.log(" qnaReply : " + qnaReply);
	}
	
	/* 댓글 수정  */
	function btnUpAdmin(idx) {
		$("#spn3" + idx).css("display", "none"); // 수정 삭제 버튼 숨기기
		$("#spn4" + idx).css("display", "block");//확인 취소 버튼 나오기
		$('#rplQna' + idx).css("display", "block");
		$("#rpl" + idx).css("display", "none");//보이는 p태그 댓글 숨기기
	}

	/* 댓글 수정 후 확인  */
	function btnOkAdmin(idx) {
		$("#frm").attr("action", "/qnaReplyUpdate");
		var qnaReply = $('#Rpl' + idx).val();
		$('#qnaReply').val(qnaReply);
		console.log(" qnaReply : " + qnaReply);
		
		var qnaNoUpdate = $('#qnaNoUpdate' + idx).val();
		$('#qnaNo').val(qnaNoUpdate);
		

	}

	/* 댓글 삭제 */
	function btnDelAdmin(idx) {
		$("#frm").attr("action", "/qnaReplyDelete");
		var qnaNoUpdate = $('#qnaNoUpdate' + idx).val();
		$('#qnaNo').val(qnaNoUpdate);
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
	
////////////////// 검색 기능과 페이지 구현 ////////////////
	$(function(){
		/* qna검색 */
		$("#searchQna").on("click",function(){
			var cont = $("#searchCn").val();
			location.href = "/faqList?cont="+cont+"&listcnt=1";
		});

// 			document.getElementById('secTest').innerText
			

		
		/* 전체보기 */
		$("#showAll").on("click",function(){
			location.href = "/faqList?cont=&listcnt=1";
		});
		
		/* qna 더보기 */
		$("#moreList").on("click",function(){
			if(`{param.cont}` == null){
				location.href = "/faqList?cont=&listcnt="+`${listcnt+1}`;
			}else{
				location.href = "/faqList?cont="+`${param.cont}`+"&listcnt="+`${listcnt+1}`;
			}
		});
	})
</script>




