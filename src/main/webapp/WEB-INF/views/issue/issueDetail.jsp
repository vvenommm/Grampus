<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.ckeditor.com/ckeditor5/34.2.0/super-build/ckeditor.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/34.2.0/super-build/translations/ko.js"></script>
<style type="text/css">
 .row {
 	float : center;
 }
  #ttl {
 	color : #5CD1E5;
	font-weight : bold;
 }
  #ttl:hover { 
	font-size : 15px;
 }
 .ck-editor__editable[role="textbox"] {
        /* editing area */
        min-height: 200px;
    }
    .ck-mentions .mention__item {
        display: block;
    }

    .ck-mentions .mention__item span {
        margin-left: .5em;
    }
    .ck-content .mention{
        background: #BEEFFF;
        color:black;
    }
    .ck.ck-list__item .ck-button.ck-on {
    	background: #BEEFFF;
        color:black;
	}
</style>

<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
 var issueNo = "${resultMap.ISSUE_NO}";
 var pmemGrp = "${pmemGrp}";
 var markerfeed = new Array();
	var sdt = {"projId":"${projId}","pmemGrp":"${pmemGrp}"}
// 	var sdt = {"projId":1,"pmemGrp":"전체"};
	$.ajax({
		url:"/promem/projGrpSearch",
		type:"post",
		data:JSON.stringify(sdt),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			$.each(res,function(i,v){
				markerfeed.push({id:v.MEM_NM+"("+v.MEM_ID+")",name:v.MEM_ID,userId:v.MEM_NO});
			});
		}
	});
 $(function() {
	 //시작날짜 오늘날짜로 설정
	 today = new Date();
	 today = today.toISOString().slice(0, 10);
	
	 //기존 값 가져오기
	 var issueTtl = $("#issueTtl").text();
	 var taskNo = $("#taskNo").text().toString().substring(1);
	 
	 var issueDy = $("#issueDy").text();	//날짜 형태 바꾸기
	 issueDy = new Date(issueDy);
	 var year = issueDy.getFullYear();
	 var month = ('0' + (issueDy.getMonth() + 1)).slice(-2);
	 var day = ('0' + issueDy.getDate()).slice(-2);
	 var dateString = year + '-' + month  + '-' + day;
	 
	 var issueStts = $("#issueStts").text();
	 var issueType = $("#issueType").next().text();
	 var pmemCd = $("#pmemCd").text();
	 var issueCn = $("#issueCn").text();
	 
	 function customItemRenderer( item ) {
	    const itemElement = document.createElement( 'span' );
	    const userNameElement = document.createElement( 'span' );
	    itemElement.classList.add( 'mention__item' );
	    userNameElement.classList.add( 'mention__item__user-name' );
	    userNameElement.textContent = item.id;
	    itemElement.appendChild( userNameElement );
	    return itemElement;
	}
	 var ckgeteditor;
	 //글 수정
	 $("#edit").on("click", function() {
		 $("#spn1").hide(); //글 수정 삭제 가리기
		 $("#menu").hide();
		 
		 var code = "<input type='text' class='form-control me-auto' id='newIssueTtl' value='" + issueTtl + "'/>";
	     $("#issueTtl").html(code);
	     
	     code = "<input type='text' class='form-control me-auto finput' id='newTaskNo' value='" + taskNo + "'/><div class='dropdown-menu dropdown-menu-lg' id='search-dropdown'><div class='dropdown-header mt-2 hideBox'><h6 class='text-overflow text-muted mb-2 text-uppercase'><i class='ri-file-list-line'></i> 일감</h6></div><div class='notification-list' id='taskInfo'></div></div>";
	     $("#taskNo").html(code);
	     
		 code = "<input type='date' class='form-control me-auto' id='newIssueDy' value='" + dateString + "'/>";
	     $("#issueDy").html(code);
	     
	     code = '<select id="newIssueStts" class="form-control me-auto">';
		 code += '<option value="신규">신규</option><option value="검토">검토</option><option value="해결">해결</option></select>';
	     $("#issueStts").html(code);
	     
		 code = '<select id="newIssueType" class="form-control me-auto">';
		 code += '<option value="결함">결함</option><option value="인사">인사</option><option value="개선">개선</option><option value="기타">기타</option></select>';
	     $("#issueType").next().remove();
	     $("#issueType").append(code);
	     
		 //에디터
		CKEDITOR.ClassicEditor.create(document.getElementById("issueCn"), {
			language: 'ko',
	        toolbar: {
	            items: [
	                'findAndReplace', 'selectAll', '|',
	                'heading', '|',
	                'bold', 'italic', 'strikethrough', 'underline', '|',
	                'bulletedList', 'numberedList', 'todoList', '|',
	                'outdent', 'indent', '|',
	                'undo', 'redo',
	                '-',
	                'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor', 'highlight', '|',
	                'alignment', '|',
	                'link', 'blockQuote', 'insertTable', '|',
	                'specialCharacters', 'horizontalLine', '|'
	            ],
	            shouldNotGroupWhenFull: true
	        },
	        list: {
	            properties: {
	                styles: true,
	                startIndex: true,
	                reversed: true
	            }
	        },
	        heading: {
	            options: [
	                { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
	                { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
	                { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
	                { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
	                { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
	                { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' },
	                { model: 'heading6', view: 'h6', title: 'Heading 6', class: 'ck-heading_heading6' }
	            ]
	        },
	        fontFamily: {
	            options: [
	                'default',
	                'Arial, Helvetica, sans-serif',
	                'Courier New, Courier, monospace',
	                'Georgia, serif',
	                'Lucida Sans Unicode, Lucida Grande, sans-serif',
	                'Tahoma, Geneva, sans-serif',
	                'Times New Roman, Times, serif',
	                'Trebuchet MS, Helvetica, sans-serif',
	                'Verdana, Geneva, sans-serif'
	            ],
	            supportAllValues: true
	        },
	        fontSize: {
	            options: [ 10, 12, 14, 'default', 18, 20, 22 ],
	            supportAllValues: true
	        },
	        htmlSupport: {
	            allow: [
	                {
	                    name: /.*/,
	                    attributes: true,
	                    classes: true,
	                    styles: true
	                }
	            ]
	        },
	        link: {
	            decorators: {
	                addTargetToExternalLinks: true,
	                defaultProtocol: 'https://',
	                toggleDownloadable: {
	                    mode: 'manual',
	                    label: 'Downloadable',
	                    attributes: {
	                        download: 'file'
	                    }
	                }
	            }
	        },
	        mention: {
	            feeds: [
	                {
	                    marker: '@',
	                    feed: markerfeed,
	                    minimumCharacters: 1,
	                    itemRenderer: customItemRenderer
	                }
	            ]
	        },
	        removePlugins: [
	            'CKBox',
	            'CKFinder',
	            'EasyImage',
	            'RealTimeCollaborativeComments',
	            'RealTimeCollaborativeTrackChanges',
	            'RealTimeCollaborativeRevisionHistory',
	            'PresenceList',
	            'Comments',
	            'TrackChanges',
	            'TrackChangesData',
	            'RevisionHistory',
	            'Pagination',
	            'WProofreader',
	            'MathType'
	        ]
	    })
	    .then( thiseditor => {
	    	ckgeteditor = thiseditor;
	        } );
	     
	     //등록 버튼 만들기
// 	     code = "<br /><button type='button' class='btn btn-soft-success waves-effect waves-light' id='updateIssue' style='float:right;'>등록</button>";
	     code = "<br /><div class='row'>"
				+ "<div class='col-sm'>"
				+ "<div class='d-flex justify-content-sm-end'>"
				+ "<span id='spn2'>"
				+ "<button type='button' class='btn btn-outline-success waves-effect waves-light' id='updateIssue'>확인</button> "
				+ "<a href='/issue/issueDetail/${resultMap.ISSUE_NO}/${pmemGrp}'class='btn btn-outline-danger waves-effect'>취소 </a>"
				+ "</span></div></div></div>";
	     $("#issueCnButton").append(code);
	     
	     //댓글창 숨기기
	     $("#answerDiv").hide();

	 })
	 
	 //글 수정 완료 버튼
	 $(document).on("click", "#updateIssue", function() {
		 var count = $(".mention").length;
		var mttag = new Array();
		var memNoArr = new Array();
		for(i=0; i<count; i++){
			var mttext = $(".mention").eq(i).text();
			mttag.push(mttext.substring(mttext.indexOf('(')+1,mttext.indexOf(')')));
		}
		
		for(i=0; i<mttag.length; i++){
			for(j=0; j<markerfeed.length; j++){
				if(mttag[i] == markerfeed[j].name){
					memNoArr.push(markerfeed[j].userId)
				}
			}
		}
		 
		 //수정된 값 가져오기
		 var issueTtl = $("#newIssueTtl").val();
		 var taskNo = $("#newTaskNo").val();
		 var issueDy = $("#newIssueDy").val();	
		 var issueStts = $("#newIssueStts").val();
		 var issueType = $("#newIssueType").val();
		 var issueCn = ckgeteditor.getData();
		 
		 var data = {
				 "issueNo" : issueNo,
				 "issueTtl" : issueTtl,
				 "taskNo" : taskNo,
				 "issueDy" : issueDy,
				 "issueStts" : issueStts,
				 "issueType" : issueType,
				 "issueCn" : issueCn,
				 "memNoArr" : memNoArr
		 }
		 $.ajax({
			 url : "/issue/updateIssue",
			 type : "post",
			 data : JSON.stringify(data),
			 contentType : "application/json;charset=utf-8",
			 success : function(res) {
				 location.href = "/issue/issueDetail/" + issueNo + "/" + pmemGrp;
			 }
		 })		 
	 })
	 
	 
	 
	 //글 삭제
	 $("#delete").on("click", function() {
		 var data = {"issueNo" : issueNo, "pmemCd" : "${resultMap.PMEM_CD}"};
		 Swal.fire({
		        text: "해당 이슈를 삭제하시겠습니까?",
		        icon : 'question',
		        showCancelButton: true,
		        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
		        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
		        buttonsStyling: false,
		        showCloseButton: true
		      }).then(function (result) {
		        if (result.value) {
		        	 $.ajax({
						 url : "/issue/deleteIssue",
						 type : "post",
						 data : JSON.stringify(data),
						 contentType : "application/json;charset=utf-8",
						 success : function(res) {
							if(res > 0) {
								location.href = "/issue/issueMain/${resultMap.PROJ_ID}/${pmemGrp}";
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
	 })
	 
	 
	 //--------------------------------------------------------------------------------------------------------
	 
	 
	 //댓글 등록
	 $("#insertAnswer").on("click", function() {
		 var answer = $("#answer").val();
		 var data = {
				 "issueNo" : issueNo,
				 "ansCn" : answer
		 }
		 
		 $.ajax({
			 url : "/issue/newAnswer",
			 type : "post",
			 data : JSON.stringify(data),
			 contentType : "application/json;charset=utf-8",
			 success : function(res) {
				 if(res > 0) {
					 location.href = "/issue/issueDetail/" + issueNo + "/${pmemGrp}";
				 }
			 }
		 })
	 })
	 
	 //댓글 수정
	 $(document).on("click", ".ansEdit", function() {
		 $("#ansDiv").hide();	//댓글 등록 창 없애기
		 $(".divHeight").css("height", "250px");
		 $(".ansEdit").hide();		//수정버튼 숨기기
		 $(".ansDelete").hide();		//삭제버튼 숨기기
		 
		 var content = $(this).parent().next().text();		//댓글 내용 가져오기
		 var code = '<div class="col-12">';
			 code += '	<textarea class="form-control bg-light border-light editAnswer" rows="3" placeholder="댓글을 입력해주세요"></textarea>';
			 code += '</div><br>';         
	         code += '<div class="col-12 text-end">';
	     	 code += '	<a href="javascript:void(0);" class="btn btn-outline-success newAnswer">확인</a>';
	     	 code += '	<a href="/issue/issueDetail/${issueNo}/${pmemGrp}" class="btn btn-outline-danger">취소</a>';
	     	 code += '</div>';
     	 
     	 var ansCn = $(this).parent().next();			//원래 위치
     	 $(ansCn).html(code);
     	 $(".editAnswer").text(content);				//새 위치에 댓글 내용
	 })
	 
	 //댓글 수정 완료 버튼
	 $(document).on("click", ".newAnswer", function() {
		 var newAnswer = $(".editAnswer").val();							//새 댓글 내용
		 var ansNo = $(this).parent().parent().prev().find("input[type=hidden]").val();		//댓글 번호
		 var data = {
				 "ansNo" : ansNo,
				 "ansCn" : newAnswer
		 }
		 $.ajax({
			 url : "/issue/updateAnswer",
			 type : "post",
			 data : JSON.stringify(data),
			 contentType : "application/json;charset=utf-8",
			 success : function(res) {
				if(res > 0) {
					 location.href = "/issue/issueDetail/" + issueNo + "/${pmemGrp}";
				}				 
			 }
		 })
		 
	 })
	 
	 //댓글 삭제
	 $(".ansDelete").on("click", function() {
		var ansNo = $(this).parent().find("input[type=hidden]").val();		//댓글 번호
		 Swal.fire({
		        text: "댓글을 삭제하시겠습니까?",
		        icon : 'question',
		        showCancelButton: true,
		        confirmButtonClass: 'btn btn-outline-info w-xs me-2 mt-2',
		        cancelButtonClass: 'btn btn-outline-danger w-xs mt-2',
		        buttonsStyling: false,
		        showCloseButton: true
		      }).then(function (result) {
		        if (result.value) {
		        	$.ajax({
				 		url : "/issue/deleteAnswer",
				 		type : "post",
				 		data : ansNo,
						contentType : "application/json;charset=utf-8",
						success : function(res) {
							if(res > 0) {
								 location.href = "/issue/issueDetail/" + issueNo + "/${pmemGrp}";
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
	 })	
	 
//////////////////////////
	//상위 일감 검색
	$(document).on("keyup",".finput",function(){
		if($(".finput").val().length >0){
			$("#search-dropdown").addClass("show");
		}else{
			$("#search-dropdown").removeClass("show");
		}
		$("#taskInfo").children().remove();
		var con = $(".finput").val();
		var mdt = {"projId":"${projId}","pmemGrp":"${pmemGrp}","content":con}
		$.ajax({
			url: "/task/updownSearch",
			type: 'POST',
			dataType: 'json',
			data:JSON.stringify(mdt),
			contentType:"application/json; charset=utf-8",
			success : function(data){
				var code = "";
				$.each(data,function(i,v){
					console.log(v)
	                code += "<a href='#' id='taskbox' name='"+v.TASK_NO+"' class='dropdown-item notify-item py-2' style='display: block;'>";
	                code += "<div class='d-flex'>";
	                code += "<div class='flex-1'>";
	                code += "<h6 class='m-0 memberId'>#"+v.TASK_NO+" "+v.TASK_TTL+"</h6>";
	                code += "<span class='fs-11 mb-0 text-muted memberName'>"+v.TASK_CN+"</span>";
	                code += "</div>";
	                code += "</div>";
	                code += "</a>";
				});
				console.log(code);
				$("#taskInfo").append(code);
			},
		});
	});
		
	/////////////////
	/* 검색 내용 클릭 시 일감번호 출력 */
	$(document).on("click","#taskbox",function(){
		var taskNo = $(this).attr("name");
		$(".finput").val(taskNo);
		$("#search-dropdown").removeClass("show");
	});

	///////////////////
	/* 다른곳 클릭 시 검색목록 없애기 */
	$(document).on("click",function(){
		$("#search-dropdown").removeClass("show");
	});
	
	///////////////////
	/* 테스트 데이터 댓글 자동 입력 */
	$('#answer').on("click",function(){
		$("#answer").val("네 깃허브 먼저 할게요~");
	});
 })
</script>

<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">
	             	 <a href="/issue/issueMain/${projId}/${pmemGrp}"><i class="bx bx-left-arrow-circle"></i></a>
	             	${projVO.ttl} 
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
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/issue/issueMain/${projVO.id}/${projVO.grp}'" style="cursor: pointer">이슈</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->

	<div class="row">
      <div class="col-xxl-15 col-xxl-15 project-card">
          <div class="card">
              <div class="card-body">
              <c:choose>
              	<c:when test="${resultMap.ISSUE_TYPE == '개선'}">
                	<div class="p-3 mt-n3 mx-n3 bg-soft-warning rounded-top">
                </c:when>
              	<c:when test="${resultMap.ISSUE_TYPE == '결함'}">
                	<div class="p-3 mt-n3 mx-n3 bg-soft-danger rounded-top">
                </c:when>
              	<c:when test="${resultMap.ISSUE_TYPE == '인사'}">
                	<div class="p-3 mt-n3 mx-n3 bg-soft-success rounded-top">
                </c:when>
              	<c:when test="${resultMap.ISSUE_TYPE == '기타'}">
                	<div class="p-3 mt-n3 mx-n3 bg-soft-info rounded-top">
                </c:when>
			  </c:choose>                  
                      <div class="d-flex align-items-center">
                          <div class="flex-grow-1">
                              <h5 class="mb-0 fs-15"><a href="apps-projects-overview.html" class="text-dark">#${resultMap.ISSUE_NO}</a></h5>
                          </div>
                          <div class="flex-shrink-0" id="menu">
                          </div>
                      </div>
                  </div>

                  <div class="py-3">
                      <div class="row gy-3">
                          <div class="col-6">
                              <div>
                                  <p class="text-muted mb-1">제목</p>
                                  <div class="fs-14" id="issueTtl"><h6>${resultMap.ISSUE_TTL}</h6></div>
                              </div>
                          </div>
                          <div class="col-6">
                              <div>
                                  <p class="text-muted mb-1">발생 일감번호</p>
                                  <div class="fs-14" id="taskNo"><a href="/task/taskDetail/${resultMap.TASK_NO}/${pmemGrp}" id="ttl">#${resultMap.TASK_NO}</a></div>
                              </div>
                          </div>
                      </div>
                      <div class="pt-3 border-top border-top-dashed mt-4">
	                      <div class="row gy-3">
	                          <div class="col-6">
	                              <div>
	                                  <p class="text-muted mb-1">발생일</p>
	                                  <div class="fs-14" id="issueDy"><h6>${resultMap.ISSUE_DY}</h6></div>
	                              </div>
	                          </div>
	                          <div class="col-6">
	                              <div>
	                                  <p class="text-muted mb-1">상태</p>
	                                  <div class="fs-14" id="issueStts"><h6>${resultMap.ISSUE_STTS}</h6></div>
	                              </div>
	                          </div>
	                      </div>
                      </div>
                      <div class="pt-3 border-top border-top-dashed mt-4">
	                      <div class="row gy-3">
	                          <div class="col-6">
	                              <div>
	                                  <p class="text-muted mb-1" id="issueType">타입</p>
	                                  <c:choose>
						              	<c:when test="${resultMap.ISSUE_TYPE == '개선'}">
		                                  	<div class="badge badge-soft-warning fs-12">${resultMap.ISSUE_TYPE}</div>
						                </c:when>
						              	<c:when test="${resultMap.ISSUE_TYPE == '결함'}">
		                                  	<div class="badge badge-soft-danger fs-12">${resultMap.ISSUE_TYPE}</div>
						                </c:when>
						              	<c:when test="${resultMap.ISSUE_TYPE == '인사'}">
		                                  	<div class="badge badge-soft-success fs-12">${resultMap.ISSUE_TYPE}</div>
						                </c:when>
						              	<c:when test="${resultMap.ISSUE_TYPE == '기타'}">
		                                  	<div class="badge badge-soft-info fs-12">${resultMap.ISSUE_TYPE}</div>
						                </c:when>
									  </c:choose>   
	                              </div>
	                          </div>
	                          <div class="col-6">
	                              <div>
	                                  <p class="text-muted mb-1">작성자</p>
	                                  <div class="fs-14" id="pmemCd"><h6>${resultMap.PROF_NM} (${resultMap.MEM_NO})</h6></div>
	                              </div>
	                          </div>
	                      </div>
                      </div>
					  <div class="pt-3 border-top border-top-dashed mt-4">
	                      <div class="row gy-3">
	                          <p class="text-muted mb-1">내용</p>
	                          <div class="fs-14" id="issueCn">${resultMap.ISSUE_CN}</div>
	                          <div class="fs-14" id="issueCnButton"></div>
	                      </div>
	                      <br />
	                      <br />
                      </div>
<%--                       <c:if test="${loginPmemcd == resultMap.PMEM_CD}"> --%>
							<div class="row">
								<div class="col-sm">
									<div class="d-flex justify-content-sm-end">
										<span id="spn1">
											<button type="button" id="edit"
												class="btn btn-outline-info waves-effect">수정</button>
											<button type="button" id="delete"
												class="btn btn-outline-danger waves-effect">삭제</button>
										</span>
									</div>
								</div>
							</div>
<%--                        </c:if> --%>
                  </div>
      <!-- --------------------------------------------------------댓글-------------------------------------------------------- -->
      	<div class="card border" id="answerDiv">
              <div class="card-header align-items-center">
                  <h4 class="card-title mb-0 flex-grow-1">댓글</h4>
              </div><!-- end card header -->
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
											<c:forEach items="${answerList}" var="answer">
							                    	<div class="d-flex mb-4">
							                        	<div class="flex-shrink-0">
							                            	<img src="/resources/image/${answer.profPhoto}" alt="" class="avatar-xs rounded-circle" />
							                          	</div>
							                          	<div class="flex-grow-1 ms-3">
							                            	<h5 class="fs-14">${answer.profNm}<small class="text-muted ms-2">
								                        		<input type="hidden" value="${answer.ansNo}" />
								                            	<fmt:formatDate value="${answer.ansDy}" pattern="yyyy.MM.dd HH:mm:ss"/></small>
								                            	&nbsp;
							                            		<c:if test="${answer.pmemCd == loginPmemcd}">
								                            		<a href="javascript:void(0);" class="ansEdit"><i class="ri-edit-2-line align-bottom me-2 link-info"></i></a>
														        	<a href="javascript:void(0);" class="ansDelete"><i class="ri-delete-bin-line align-bottom me-2 link-danger"></i></a>
													        	</c:if>
							                            	</h5>
							                            	<p class="text-muted" id="ansCn" class="content">${answer.ansCn}</p>
							                          	</div>
							                      	</div>
							               </c:forEach>
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
					<form class="mt-4">
	                     <div class="row g-3" id="ansDiv">
	                         <div class="col-12">
<!-- 	                             <label for="exampleFormControlTextarea1" class="form-label text-body">댓글 남기기</label> -->
	                             <textarea class="form-control bg-light border-light" id="answer" rows="3" placeholder="댓글을 입력해주세요"></textarea>
	                         </div>
	                         <div class="col-12 text-end">
	                             <a href="javascript:void(0);" class="btn btn-outline-success waves-effect waves-light" id="insertAnswer">등록</a>
	                         </div>
	                     </div>
	                 </form>
				</div>
             <!-- end card body -->
          </div>
          <!-- end card -->
        </div>
        <!-- end card body -->
      </div>
	<!-- end card -->
	</div>
   <!-- end col -->




