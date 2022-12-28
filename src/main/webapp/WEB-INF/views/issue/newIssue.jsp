<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/34.2.0/super-build/ckeditor.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/34.2.0/super-build/translations/ko.js"></script>
<script src="/resources/js/jquery-3.6.0.js"></script>
<style>
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
<script type="text/javascript">
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
	var ckgeteditor;	
window.onload = function() {
	var pmemGrp = "${pmemGrp}";
	//시작날짜 오늘날짜로 설정
	 today = new Date();
	 today = today.toISOString().slice(0, 10);
	$("#issueDy").val(today);
	
	//이슈 등록 시 같은 팀의 전체 일감 가져오기
	$.ajax({
		url : "/issue/getTaskInfo",
		type : "post",
		data : pmemGrp,
		contentType : "application/json;charset=utf-8",
		success : function(res) {
			console.log(res);
		}
	})
	
	
	//클릭 시, 발표 데이터 넣기
	$("#issueTtl").on("click", function() {
		$("#issueTtl").val("엘라스틱 서치 구현 기간이 더 필요해요.");
		ckgeteditor.setData("4일은 안 될 것 같아요. 다 영어로 되어있어서 시간이 더 필요할 것 같습니다.");
	})
	
/////////////////
	//상위 일감 검색
	$(".finput").keyup(function(){
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
	
	
	CKEDITOR.ClassicEditor.create(document.getElementById("editor"), {
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

}
function customItemRenderer( item ) {
    const itemElement = document.createElement( 'span' );
    const userNameElement = document.createElement( 'span' );
    itemElement.classList.add( 'mention__item' );
    userNameElement.classList.add( 'mention__item__user-name' );
    userNameElement.textContent = item.id;
    itemElement.appendChild( userNameElement );
    return itemElement;
}

//이슈 등록
function insert() {
	//멘션 태그된 사람의 고유값 추출
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
	
	var issueTtl = $("#issueTtl").val();
	var issueCn = ckgeteditor.getData();
	var taskNo = $("#taskNo").val();
	var	issueStts = $("#issueStts").val();
	var issueType = $("#issueType").val();
	var issueDy = $("#issueDy").val();
	
	//제목 입력안했을 시
 	if(issueTtl == null || issueTtl == "") {
 		$("#issueTtl").css("border", "1px solid red");
 		$("#issueTtl").focus();
 		Swal.fire({
            text: '제목은 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
	
 	//내용 입력안했을 시
 	if(issueCn == null || issueCn == "") {
 		editor.focus();
 		Swal.fire({
            text: '내용은 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
 	
 	//싱태 선택 거르기
 	if(issueStts == null || issueStts == "" || issueStts == "선택") {
 		$("#issueStts").css("border", "1px solid red");
 		$("#issueStts").focus();
 		Swal.fire({
            text: '상태는 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
 	
 	//종류 선택 거르기
 	if(issueType == null || issueType == "" || issueType == "선택") {
 		$("#issueType").css("border", "1px solid red");
 		$("#issueType").focus();
 		Swal.fire({
            text: '종류는 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
 		return;
 	}
	
	var data = {
			"issueTtl" : issueTtl,
			"issueCn" : issueCn,
			"taskNo" : taskNo,
			"issueStts" : issueStts,
			"issueType" : issueType,
			"issueDy" : issueDy,
			"memNoArr" : memNoArr
	}
	
	
	$.ajax({
		url : "/issue/insertIssue",
		type : "post",
		data : JSON.stringify(data),
		contentType : "application/json;charset=utf-8",
		success : function(res) {
			var originTaskNo = "${taskNo}";
			if(res > 0 && originTaskNo == 1) {
				location.href = "/issue/issueMain/${projId}/${pmemGrp}";
			}else {
				location.href = "/task/taskDetail/${taskNo}/${pmemGrp}";
			}
		}
	})
	
	
	
}

</script>



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
	                    <li class="breadcrumb-item active">${projVO.grp}</li>
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/issue/issueMain/${projVO.id}/${projVO.grp}'" style="cursor: pointer">이슈</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->



<div class="d-flex justify-content-sm-center">
	<div class="w-50 p-3" id="allDiv">
		<p>제목 *<br /><input type="text" class="form-control me-auto check" id="issueTtl" placeholder="제목을 입력해주세요"/></p>
		<p></p>
		<p>내용 *</p>
		<p></p>
			<div id="editor" class="check"></div>
	</div>
			
	<div class="w-50 p-3">
		<p>일감번호(#) *
		<c:choose>
			<c:when test="${taskNo != 1}">
				<br /><input type="text" class="form-control me-auto check finput" id="taskNo" value="${taskNo}" readonly />
			</c:when>
			<c:when test="${taskNo == 1}">
				<br /><input type="text" class="form-control me-auto check finput" id="taskNo" />
				<div class="dropdown-menu dropdown-menu-lg" id="search-dropdown">
		            <!-- item-->
		            <div class="dropdown-header mt-2 hideBox">
		                <h6 class="text-overflow text-muted mb-2 text-uppercase"><i class="ri-file-list-line"></i> 일감</h6>
		            </div>
		            <div class="notification-list" id="taskInfo">
		            </div>
			    </div>
		    </c:when>
        </c:choose>
		<p>상태 *	
			<select id="issueStts" class="form-control me-auto check">
				<option selected>신규</option>
				<option>검토</option>
				<option>해결</option>
			</select></p>
		<p>종류 *
			<select id="issueType" class="form-control me-auto check">
				<option selected>결함</option>
				<option>인사</option>
				<option>개선</option>
				<option>기타</option>
			</select></p>
		<p>이슈 발생일 *<input type="date" id="issueDy" class="form-control me-auto check" value=""/></p>
	</div>
</div>
<div class="row g-4 mb-3">
	<div class="col-sm">
		<div class="d-flex justify-content-sm-center gap-2">
			<button type="button" class="btn btn-outline-success waves-effect waves-light" style="float:right;" onclick="insert();">등록</button>		
			<input type="button" class="btn btn-outline-danger wave" value="취소" onclick="history.back()" />
		</div>
	</div>
</div>