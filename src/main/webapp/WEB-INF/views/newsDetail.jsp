<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script
	src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<div class="page-content">
  <div class="row">
      <div class="col-12">
          <div class= "page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/newsList'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item">GRAMPUS</li>
                      <li class="breadcrumb-item active">NEWS</li>
                  </ol>
              </div>
          </div>
      </div>
  </div>
<form name="frm" id="frm" method="post">
<div class="row">
	<div class="col-lg-12">
		<div class="card">
			<div class="card-body">
				<div class="row gx-lg-5">
					<div class="col-xl-4 col-md-8 mx-auto">
						<div class="product-img-slider sticky-side-div">
							<div class="gallery-box card">
								<div class="gallery-container">
									<c:if test="${newsVO.NEWS_PHOTO!=null}">
										<img id="newsPhotoName${newsVO.NEWS_NO}"
											class="card-img-top img-fluid"
											src="../resources/image/${newsVO.NEWS_PHOTO}">
									</c:if>
								</div>
							</div>
							<div class="text-center" style="display: none;" id="fileUpdate">
								<input class="form-control" id="newsPhoto" type="file"
									name="uploadFile" />
							</div>
						</div>
					</div>
					<!-- end col -->

					<div class="col-xl-8">
						<div class="mt-xl-0 mt-5">
							<div class="d-flex">
								<div class="flex-grow-1">
									<input type="hidden" id="newsNo" name="newsNo" value="${newsVO.NEWS_NO}" />
									<h5 class="mb-3 fw-bold text-uppercase" id="newsTtl" name="newsTtl">${newsVO.NEWS_TTL}</h5>
									<div class="hstack gap-3 flex-wrap">
										<div class="text-muted">관리자</div>
										<div class="vr"></div>
										<div class="text-muted"><fmt:formatDate value="${newsVO.NEWS_DY}" pattern="yyyy.MM.dd" /></div>
									</div>
								</div>
							</div>

							<div class="mt-4 text-muted">
								<p><div id="newsCn">${newsVO.NEWS_CN}</div>
									<span id="spn">
										<div id="editor" name="editor">${newsVO.NEWS_CN}</div>
									</span>
								</p>
							</div>
							<div class="flex-shrink-0">
									<c:if test='${sessionScope.id=="admin"}'>
										<div class="row">
											<div class="col-sm">
												<div class="d-flex justify-content-sm-end">
													<span id="spn1">
														<button type="button" id="edit"
															class="btn btn-outline-primary waves-effect">수정</button>
														<button type="button" id="delete"
															class="btn btn-outline-danger waves-effect">삭제</button>
													</span>
													<!-- 수정모드 시작 -->
													<span id="spn2" style="display: none;"> <input
														type=button id="allEdit"
														class="btn btn-outline-success waves-effect" value="확인" /> <a
														href="/detail?newsNo=${newsVO.NEWS_NO}"
														class="btn btn-outline-danger waves-effect">취소 </a>
													</span>
												</div>
											</div>
										</div>
									</c:if>
								</div>
							<!-- end card body -->
						</div>
					</div>
					<!-- end col -->
				</div>
				<!-- end row -->
			</div>
			<!-- end card body -->
		</div>
		<!-- end card -->
	</div>
	<!-- end col -->
</div>
</form>
</div>


<script type="text/javascript">
	$(function(idx) {

	})
	$(function() {
		const Editor = toastui.Editor;
		const editor = new Editor({
			el : document.querySelector('#editor'),
			height : '300px',
			initialEditType : 'wysiwyg',
			previewStyle : 'vertical'
		});

		$(".form-control-user").attr("disabled", "disabled");
		$(".form-control-user2").attr("disabled", "disabled");
		$(".form-control-user3").attr("disabled", "disabled");
		$("#spn").css("display", "none");//에디터 편집기 숨기기

		//수정버튼 클릭 -> 수정 모드로 전환
		$('#edit').on("click",function() {
			$("#spn").css("display", "block");//에디더 편집기 보이기
			$("#spn1").css("display", "none");//수정 취소 버튼 숨기기
			$("#spn2").css("display", "block");//확인 취소 버튼 나타나기
			$("#newsCn").css("display", "none");//기존 게시판 내용 숨기기
			$("#fileUpdate").css("display", "block");//파일 업로드 버튼 보이기

			//입력란 활성화
			$("#newsTtl")
					.html(
							"<input type='text' class='form-control' id='newsTtl2' name='newsTtl' value='${newsVO.NEWS_TTL}' placeholder='${newsVO.NEWS_TTL}'/>");
			CKEDITOR.instances['newsTtl'].setReadOnly(false);

			// 							$("#frm").attr("action", "/updatePost");

		})

		/* 이미지 파일 확장자, 파일 크기 확인 */
		$("#newsPhoto").on("change", function() {
			var fImage = $("#newsPhoto")[0].files[0];
			var regex = new RegExp("(.*?)\.(png|jpg)$");
			var maxSize = 5242880;
			var fileName = fImage.name;
			var fileSize = fImage.size;
			if (fileSize >= maxSize) {
				Swal.fire(
		            {
		                text: '파일 사이즈는 5MB를 초과할 수 없습니다.',
		                icon: 'warning',
		                confirmButtonClass: 'btn btn-warning w-xs me-2 mt-2',
		                buttonsStyling: false,
		                showCloseButton: true
		            }
			    )
				$("#newsPhoto").val("");
			}
			if (!regex.test(fileName)) {
				Swal.fire(
		            {
		                text: '이미지 파일 확장자는 jpg, png만 가능합니다.',
		                icon: 'warning',
		                confirmButtonClass: 'btn btn-warning w-xs me-2 mt-2',
		                buttonsStyling: false,
		                showCloseButton: true
		            }
				)
				$("#newsPhoto").val("");
			}
		});

		//확인 버튼
		$("#allEdit").on("click", function() {

			let newsTtl = $("#newsTtl2").val();
			let newsCn = editor.getHTML();
			let newsPhoto = $("#newsPhoto")[0].files[0];
			let newsNo = $("#newsNo").val();

			var sdt = {
				"newsTtl" : newsTtl,
				"newsCn" : newsCn,
				"newsNo" : newsNo
			};

			console.log("newsTtl : " + newsTtl);
			console.log("newsCn : " + newsCn);
			console.log("newsPhoto :" + newsPhoto);

			$("#newsTtl").val(newsTtl);

			let uploadFile = $("[name='uploadFile']");
			console.log("uploadFile", uploadFile);


			//프로젝트 등록
			$.ajax({
				url : "/updatePost",
				type : "post",
				data : JSON.stringify(sdt),
				contentType : "application/json; charset=utf-8",
				success : function(res) {
					if (res > 0) {
						//프로젝트 사진 등록
						if (newsPhoto != null) {
							var formData = new FormData();
							formData.append('file', newsPhoto);
							$.ajax({
								type : "POST",
								enctype : 'multipart/form-data',
								url : "newsImg?newsNo=" + newsNo,
								data : formData,
								processData : false,
								contentType : false,
								success : function(res) {
									if (res < 1) {
										Swal.fire(
								            {
								                text: '이미지 업로드 실패',
								                icon: 'error',
								                confirmButtonClass: 'btn btn-outline-danger w-xs me-2 mt-2',
								                buttonsStyling: false,
								                showCloseButton: true
								            }
										)
										return;
									}
								}
							});
						}

						location.href = "detail?newsNo=${newsVO.NEWS_NO}";

					} else {
						Swal.fire(
				            {
				                text: '뉴스 등록 실패',
				                icon: 'error',
				                confirmButtonClass: 'btn btn-outline-danger w-xs me-2 mt-2',
				                buttonsStyling: false,
				                showCloseButton: true
				            }
						)
					}

				}
			});

			// 			$("#frm").submit();
		});

		//삭제버튼 클릭
		$("#delete").on("click", function() {
			$("#frm").attr("action", "/deletePost");
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
	                  confirmButtonClass: 'btn btn-outline-primary mt-2',
	                  buttonsStyling: false
	                })
	            }
		    });
		})
	})
</script>

