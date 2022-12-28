<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
var editor = "";

$(function(){

	/* 에디터 */
	const Editor = toastui.Editor;
	editor = new Editor({
		  el: document.querySelector('#editor'),
		  height: '600px',
		  initialEditType: 'wysiwyg',
		  previewStyle: 'vertical'
		});
	
		chk1();
		chk2();

		code = "";
		//파일 첨부 시
		$("input[name='uploadFile']").change(function() {
			code = "";
			
			let inputFile = $("input[name='uploadFile']");
			let files = inputFile[0].files;
			
			if($("#fileTbody").find('tr:eq(0)').attr("class") == "y") {
				//마지막 첨부파일 번호 가져오기
				var dcfNo = $(".dcfNo").last().text();
				dcfNo = Number(dcfNo);
				code = "";
				$(files).each(function(i,v) {
					console.log(v);
					dcfNo += 1;
					
			        code += '<tr class="y">'
		            code += '	<th><input class="form-check-input cbx" type="checkbox" name="cbx" /></th>'
		            code += '	<th scope="row" class="dcfNo">' + dcfNo + '</th>'
		            code += '	<td><span style="cursor: pointer">' + v.name + '</span></td>'
		            code += '	<td><span class="badge badge-soft-primary">' + (v.size / 1000) + ' KB</span></td>'
		        	code += '</tr>'
				})
				$("#fileTbody").find('tr').last().after(code);
				
			}else {
				//첨부파일이 없는 경우 문서번호 최대값 가져오기
				code = "";
				$.ajax({
					url : "/doc/maxDcfNo",
					type : "post",
					success : function(res){
						console.log("res dcfNo : " + res);
						$(files).each(function(i,v) {
							console.log(v);
							res += 1;
							
					        code += '<tr class="y">'
				            code += '	<th><input class="form-check-input cbx" type="checkbox" name="cbx" /></th>'
				            code += '	<th scope="row" class="dcfNo">' + res + '</th>'
				            code += '	<td><span style="cursor: pointer">' + v.name + '</span></td>'
				            code += '	<td><span class="badge badge-soft-primary">' + (v.size / 1000) + ' KB</span></td>'
				        	code += '</tr>'
						})
						$("#fileTbody").html(code);
					}
				})
			}
			
		})
		

});

//전체선택
function chk1() {
	$("#allCbx").on("click", function() {
		if($(this).is(":checked")) {	//체크상태
			$(".cbx").prop("checked", true);
		}else {
			$(".cbx").prop("checked", false);
		}
	})
}

function chk2() {
	$(".cbx").on("click", function() {
		if($("#allCbx").is(":checked")) {
			$("#allCbx").prop("checked", false);
		}
		var now2 = $(this).attr("checked");
		if(typeof now2 == "undefined") {
			$(this).attr("checked", true);
		}else {
			$(this).attr("checked", false);
		}
		
		var total = $("input[name=cbx]").length;
		var checked = $("input[name=cbx]:checked").length;
		if(total == checked) {
			$("#allCbx").prop("checked", true);
		}
	})
}



var typeTitle = "${docVO.TYPE}";

function changeType(type){
	
	var btn = document.getElementById('typeName');
	btn.innerHTML = type;
	typeTitle = type;
}


function edit(no){
	var editBox = document.getElementById("editBox");
	var cnBox = document.getElementById("cn");
	var btnBox2 = document.getElementById("spn2");
	var btnBox1 = document.getElementById("spn1");
	var ttl = document.getElementById("ttl");
	var ttlInput = document.getElementById("ttlInput");
	var typeBox = document.getElementById("typeBox");
	var docType = document.getElementById("docType");
	var fileUpdate = document.getElementById("fileUpdate");
	
	
	editBox.setAttribute('style', 'display:block');
	btnBox2.setAttribute('style', 'display:block');
	cnBox.setAttribute('style', 'display:none');
	btnBox1.setAttribute('style', 'display:none');
	docType.setAttribute('style', 'display:none');
	ttl.setAttribute('style', 'display:none');
	typeBox.setAttribute('style', 'display:block');
	ttlInput.setAttribute('style', 'display:block');
	fileUpdate.setAttribute('style', 'display:block');
	
	var cn = "${docVO.CN}";
	editor.setHTML(cn);
	
}

function editInsert(){
	var ttl = document.getElementById("tip").value;
	var cn = editor.getHTML();
	var docNo = "${docVO.NO}";
	var projId = "${projId}";
	var pmemCd = "${docVO.PMEMCD}";
	
	
	var data = {"docType" : typeTitle, "docTtl" : ttl, "docCn" : cn, "docNo" : docNo, "projId" : projId, "pmemCd" : pmemCd};
	
	$.ajax({
		url : "/doc/docEdit",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		success : function(res){
			//문서글 등록 성공 시 첨부파일도 등록되게끔
			//파일배열
			let formData = new FormData();
			let inputFile = $("input[name='uploadFile']");
			let files = inputFile[0].files;
		 	
			formData.append("docNo", res);
			
			for(let i = 0; i < files.length; i++) {
				//확장자 메서드 호출
				if(!checkExtension(files[i].name, files[i].size)) {
						return false;	//반복문 및 함수 종료
				}
				
				//formData에 append
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url : "/doc/docInsertF",
				type : "post",
				data : formData,
				async : false,
				processData : false,
				contentType : false,
				success : function(res){
					console.log("fileUpload : " + res);
					location.href="/doc/docDetail/" + docNo + "/" + pmemCd;
				}
			});
		}
	});
}

//확장자가 exe,sh,zip,alz인지 검사 메서드
let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");	// \.: .이 있는지 검사
let maxSize = 5242880;	//5MB 

function checkExtension(fileName, fileSize) {
	if(fileSize >= maxSize) {
		alert("파일 사이즈가 초과되었습니다.");
		return false;
	}
	if(regex.test(fileName)) {
		alert("해당 확장자의 파일은 업로드할 수 없습니다.");
		return false;
	}
	return true;
}

function del(no){
	 Swal.fire({
	        text: "해당 글과 관련한 문서도 모두 삭제됩니다.\n진행하시겠습니까?",
	        icon : 'question',
	        showCancelButton: true,
	        confirmButtonClass: 'btn btn-ghost-primary w-xs me-2 mt-2',
	        cancelButtonClass: 'btn btn-ghost-danger w-xs mt-2',
	        buttonsStyling: false,
	        showCloseButton: true
	      }).then(function (result) {
			 if(result.value) {
				$.ajax({
					url : "/doc/docDel",
					contentType : "application/json;charset=utf-8",
					data : JSON.stringify(no),
					type : "post",
					success : function(res){
						console.log(res);
						if(res > 0){
							location.href="/doc/docMain/${projId}/${grp}";
						}else{
							alert('삭제 실패!\nGrampus에 문의해주세요.')
						}
					}
				});
			 }
})
}

function backToList(){
	location.href="/doc/docMain/${projId}/${grp}";
}

function download(dcfNo) {
	let vIfrm = document.getElementById("ifrm");
	vIfrm.src  = "/doc/fileDownload?dcfNo=" + dcfNo
}

//파일 삭제
function delFile() {
	if($("input:checkbox[name='cbx']:checked").length == 0) {
 		Swal.fire({
            text: '삭제할 파일을 선택해주세요.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
      	return;
	}else {
		$("input:checkbox[name='cbx']:checked").each(function(i,v) {
			var dcfNo = $(this).parent().next().text();			
			$.ajax({
				url : "/docf/delFile",
				type : "post",
				data : dcfNo,
				contentType : "application/json;charset=utf-8",
				success : function(res) {
					console.log(res);
				}
			})
			//삭제 후 해당 tr 없애기
			$(this).parent().parent().remove();
		    if($("tbody > tr").length == 0) {
				 code = '<tr class="n"><td colspan=4 style="text-align:center;">문서가 존재하지 않습니다</td></tr>'
				 $("#allCbx").prop("checked",false);
				 $("#fileTbody").html(code);
			}
		})
	}
	
}
</script>
<style type="text/css">
#editor{
	width:100%;
}

#editBox{
	display: none;
}

</style>

<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">
	             	<a href="/doc/docMain/${projId}/${grp}"><i class="bx bx-left-arrow-circle"></i></a>
	             	${projVO.ttl} 
	           		<c:if test="${iamPM.pm eq 1}">
		             	<span onclick="javascript:location.href='/project/projectSetting/${projVO.id}/${projVO.grp}'" style="cursor: pointer">
		             			<i class="ri-settings-4-line"></i>
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
		                <li class="breadcrumb-item active" onclick="javascript: location.href='/doc/docMain/${projVO.id}/${projVO.grp}';" style="cursor: pointer">문서</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->


<div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="bg-soft-light">
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md">
                            <div class="row align-items-center g-3">
                                <div class="col-md">
                                    <div>
                                         <div id="typeBox" style="display: none;">
                                         	 <div class="col-lg-2 mb-3 mt-3">
												<div class="hstack gap-2">
													<div class="btn-group">
													    <button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="typeName">${docVO.TYPE}</button>
													    <div class="dropdown-menu dropdownmenu-secondary">
													        <a class="dropdown-item" href="javascript:changeType('양식')">양식</a>
													        <a class="dropdown-item" href="javascript:changeType('제출')">제출</a>
													        <a class="dropdown-item" href="javascript:changeType('기타')">기타</a>
													    </div>
													</div>
													<!-- /btn-group -->
												
	                                        <div id="ttlInput" style="display: none;" class="mb-3 mt-3">
	                                        	<input type="text" id="tip" class="form-control" value="${docVO.TTL}" style="width:100%;"/>
	                                        </div>
												</div>
												
											</div>
											<!--end col-->
                                         </div>
                                        <div class="hstack gap-3 flex-wrap">
                                        	<div id="docType">
                                        	<c:if test="${docVO.TYPE eq '제출'}">
	                                            <div class="badge rounded-pill badge-soft-warning fs-16">${docVO.TYPE}</div>
							            	</c:if>
							            	<c:if test="${docVO.TYPE eq '양식'}">
	                                            <div class="badge rounded-pill badge-soft-success fs-16">${docVO.TYPE}</div>
							            	</c:if>
							            	<c:if test="${docVO.TYPE eq '기타'}">
	                                            <div class="badge rounded-pill badge-soft-primary fs-16">${docVO.TYPE}</div>
							            	</c:if>
                                        	</div>
	                                         <div id="ttl">
		                                         <h4 class="fw-bold">${docVO.TTL}</h4>
	                                         </div>
                                        </div><br />
                                        <div class="hstack gap-3 flex-wrap">
                                            <div class="vr"></div>
                                            <div><i class="ri-building-line align-bottom me-1"></i> ${docVO.NM} (${docVO.ROLENM})</div>
                                            <div class="vr"></div>
                                            <div>작성일 : <span class="fw-medium">${docVO.DY}</span></div>
                                            <div class="vr"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-auto">
                            <div class="hstack gap-1 flex-wrap">
                            </div>
                        </div>
                    </div>
                </div>
                <!-- end card body -->
            </div>
        </div>
        <!-- end card -->
    </div>
    <!-- end col -->
</div>
<!-- end row -->



 <div class="row">
	 <div class="col-lg-12">
	     <div class="card">
	         <div class="card-body">
	         	<!-- 토스트 에디터 -->
	         	<div id="editBox">
		         	<div id="editor"></div>
	         	</div>

	         	<!-- 문서 내용 -->
	             <div class="text-dark">
<%-- 	                 <h6 class="mb-3 fw-bold text-uppercase">${docVO.ttl}</h6> --%>
<%-- 	                 <p>${docVO.cn}</p> --%>
	                 <div class="pt-3 mb-5" id="cn">
						${docVO.CN}
					</div>
	                 
	                 <!-- ------------------------------------------------------------ 첨부파일 시작 ------------------------------------------------------------ -->
	
	                 <div class="pt-3 border-top border-top-dashed mt-4">
	                 	<div class="hstack gap-2">
		                    <h6 class="mb-3 fw-bold text-uppercase">첨부파일</h6>
	                    	<c:if test="${!empty fileList}">
	                    		<a href="javascript:void(0);" class="mb-3 ansDelete" onclick="delFile();"><i class="ri-delete-bin-line align-bottom me-2 link-danger"></i></a>
		                    </c:if>
                        </div><br />
						<div class="mb-3" id="fileUpdate"
							style="display: none; width: 100%;">
							<input style="width: 100%;" class="form-control" id="project-thumbnail-img" type="file" name="uploadFile" multiple />
						</div>
	                     
	                     <!-- Small Tables -->
						<table class="table table-hover table-sm table-nowrap w-100">
						    <thead>
						        <tr>
						        	<th scope="col"><input class="form-check-input" type="checkbox" id="allCbx" /></th>
						            <th scope="col">번호</th>
						            <th scope="col">파일명</th>
						            <th scope="col">크기</th>
						        </tr>
						    </thead>
						    <tbody id="fileTbody">
						    	<c:choose>
							    	<c:when test="${empty fileList}">
							    		<tr class="n"><td colspan=4 style="text-align:center;">문서가 존재하지 않습니다</td></tr>
							    	</c:when>
							    	<c:otherwise>
								    	<c:forEach items="${fileList}" var="file">
									        <tr class="y">
									            <th><input class="form-check-input cbx" type="checkbox" name="cbx" /></th>
									            <th scope="row" class="dcfNo">${file.dcfNo}</th>
									            <td><span style="cursor: pointer" onclick="download('${file.dcfNo}');">${file.dcfNm}</span></td>
									            <td><span class="badge badge-soft-primary">${file.dcfSz} KB</span></td>
									        </tr>
								        </c:forEach>
							        </c:otherwise>
						        </c:choose>
						    </tbody>
						</table>
                        <div class="flex-shrink-0 ms-2">
                        </div>
	                   </div>
	                   
	                   <iframe id="ifrm" name="ifrm" style="display:none;"></iframe>	<!-- 가상의 영역 -->
	                 <!-- ------------------------------------------------------------ 첨부파일 끄읕 ------------------------------------------------------------ -->

		            <!-- 수정 삭제 버튼 -->
	                <div class="pt-3 border-top border-top-dashed mt-4">
	                    <div class="row">
	                        <div class="col-sm">
	                            <div class="d-flex justify-content-sm-end">
	                               <span id="spn1">
										<c:if test="${pCd == docVO.PMEMCD}">
				                            <div class="hstack gap-2">
												<button type="button" id="edit" class="btn btn-outline-info waves-effect" onclick="edit(${docVO.NO})">수정</button>
												<button type="button" id="delete" class="btn btn-outline-danger waves-effect" onclick="del(${docVO.NO})">삭제</button>
											</div>
										</c:if>
									</span> 
									<!-- 수정모드 시작 --> 
									<span id="spn2" style="display: none;">
										<input type=button id="allEdit" class="btn btn-outline-success waves-effect" onclick="editInsert()" value="확인" /> 
										<a href="/doc/docMain/${projId}/${grp}" class="btn btn-outline-danger waves-effect">취소 </a>
									</span>
	                            </div>
	                        </div>
	                	</div>
	              	</div>
	             </div>
			</div>
		</div>
	</div>
</div>
