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
										<div class="text-muted">?????????</div>
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
															class="btn btn-outline-primary waves-effect">??????</button>
														<button type="button" id="delete"
															class="btn btn-outline-danger waves-effect">??????</button>
													</span>
													<!-- ???????????? ?????? -->
													<span id="spn2" style="display: none;"> <input
														type=button id="allEdit"
														class="btn btn-outline-success waves-effect" value="??????" /> <a
														href="/detail?newsNo=${newsVO.NEWS_NO}"
														class="btn btn-outline-danger waves-effect">?????? </a>
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
		$("#spn").css("display", "none");//????????? ????????? ?????????

		//???????????? ?????? -> ?????? ????????? ??????
		$('#edit').on("click",function() {
			$("#spn").css("display", "block");//????????? ????????? ?????????
			$("#spn1").css("display", "none");//?????? ?????? ?????? ?????????
			$("#spn2").css("display", "block");//?????? ?????? ?????? ????????????
			$("#newsCn").css("display", "none");//?????? ????????? ?????? ?????????
			$("#fileUpdate").css("display", "block");//?????? ????????? ?????? ?????????

			//????????? ?????????
			$("#newsTtl")
					.html(
							"<input type='text' class='form-control' id='newsTtl2' name='newsTtl' value='${newsVO.NEWS_TTL}' placeholder='${newsVO.NEWS_TTL}'/>");
			CKEDITOR.instances['newsTtl'].setReadOnly(false);

			// 							$("#frm").attr("action", "/updatePost");

		})

		/* ????????? ?????? ?????????, ?????? ?????? ?????? */
		$("#newsPhoto").on("change", function() {
			var fImage = $("#newsPhoto")[0].files[0];
			var regex = new RegExp("(.*?)\.(png|jpg)$");
			var maxSize = 5242880;
			var fileName = fImage.name;
			var fileSize = fImage.size;
			if (fileSize >= maxSize) {
				Swal.fire(
		            {
		                text: '?????? ???????????? 5MB??? ????????? ??? ????????????.',
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
		                text: '????????? ?????? ???????????? jpg, png??? ???????????????.',
		                icon: 'warning',
		                confirmButtonClass: 'btn btn-warning w-xs me-2 mt-2',
		                buttonsStyling: false,
		                showCloseButton: true
		            }
				)
				$("#newsPhoto").val("");
			}
		});

		//?????? ??????
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


			//???????????? ??????
			$.ajax({
				url : "/updatePost",
				type : "post",
				data : JSON.stringify(sdt),
				contentType : "application/json; charset=utf-8",
				success : function(res) {
					if (res > 0) {
						//???????????? ?????? ??????
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
								                text: '????????? ????????? ??????',
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
				                text: '?????? ?????? ??????',
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

		//???????????? ??????
		$("#delete").on("click", function() {
			$("#frm").attr("action", "/deletePost");
			 Swal.fire({
			        text: "?????????????????????????",
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
	                  text: '????????? ?????????????????????.',
	                  icon: 'error',
	                  confirmButtonClass: 'btn btn-outline-primary mt-2',
	                  buttonsStyling: false
	                })
	            }
		    });
		})
	})
</script>

