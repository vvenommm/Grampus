<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<% int projId =(int)session.getAttribute("projId"); %>
 
<!-- start page title -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
	            <div>
	             <h4 class="mb-sm-0">${projTtl.projTtl} 
					<c:if test="${projTtl.planTtl =='BASIC'}"><span class="badge bg-primary">BASIC</span></c:if>
					<c:if test="${projTtl.planTtl =='PLUS'}"><span class="badge badge bg-success">PLUS</span></c:if>
					<c:if test="${projTtl.planTtl =='PREMIUM'}"><span class="badge badge bg-warning">PREMIUM</span></c:if>
	             </h4>
	            </div>
	
	            <div class="page-title-right">
	                <ol class="breadcrumb m-0">
	                    <li class="breadcrumb-item">
	                    	<a href="#">
	                    		<i class="ri-home-2-fill"></i>
	                    	</a>
	                    </li>
	                    <li class="breadcrumb-item active">${projTtl.projTtl} </li>
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/wiki/wikiList?projId=${projId}'" style="cursor: pointer">위키
		                </li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->

<div class="row">
    <div class="col-sm">
        <div class="d-flex justify-content-sm-end gap-2">
       		<a class="btn btn-soft-info waves-effect" id="showAll">전체보기</a>
            <div class="search-box ms-2">
                <input type="text" id="seachCon" class="form-control" placeholder="검색 내용을 입력하세요" value="${wikiScon}" >
                <i class="ri-search-line search-icon"></i>
            </div>
      		<a class="btn btn-soft-info waves-effect" id="seachJob">검색</a>
        </div>
    </div>
</div>
	<c:if test="${wikiPm.roleId=='R01'}">
	<div class="row mt-3">
		<div class="col-sm">
			 <div class="d-flex justify-content-sm-end gap-2">
				<a type="button" id="insertWiki" class="btn btn-ghost-primary waves-effect waves-light"> <i
					class="ri-add-line align-bottom me-1"></i> 작성하기
				</a>
			</div>
		</div>
	</div>
	</c:if>
	<div class="col-xl-12 mt-2">
		<div class="card">
			<div style="display:none" id="insertPage"><jsp:include page="../wiki/wikiInsert.jsp"></jsp:include></div>
			
			<!-- end card header -->

			<form:form action="/wiki/wikiUpdate" id="frmupdate" method="post" modelAttribute="wikiVO">
				<c:forEach var="wikiList" items="${wikiListVO}" varStatus="stat">
					<input id="wikiListwikiNo${stat.index}" type="hidden" value="${wikiList.wikiNo}" />
						<div class="card-body">
							<div class="live-preview">
								<div class="list-group">
									<div class="d-flex mb-2 align-items-center">
										<div class="flex-grow-1 ms-3">
											<p name="ttl" id="Ttl${wikiList.wikiNo}" class="list-title fs-16 mb-1">${wikiList.wikiTtl}</p>
											<p id="wikiTtl${wikiList.wikiNo}" name="listwikiTtl" style="display: none">
												<input type="text"  class="form-control form-control-user" id="TtlWiki${stat.index}" value="${wikiList.wikiTtl}"/>
											</p>
										</div>
									</div>
									<div id="content${wikiList.wikiNo}" name="content"
										class="list-text mb-0">${wikiList.wikiCn}</div>
								</div>
								
								<div id="cnUpdate${wikiList.wikiNo}" name="cnUpdate" style="display: none"  class="text-end">
									<div id="editor${stat.index}" >${wikiList.wikiCn}</div>
									<br/>
	<%-- 								<div name="wikiCn" id="hidCn${stat.index}"></div> --%>
									<input id="updSubmit${stat.index}" type="button" value="등록" class="btn btn-outline-success waves-effect waves-light" onclick="btnClick(${stat.index});"/> 
									<input type="button" value="취소" name="cancel" class="btn btn-outline-danger waves-effect waves-light"/>
								</div>
							</div>
							<c:if test="${wikiPm.roleId=='R01'}">
							<div class="text-end">
								<button name="edit" type="button" id="${wikiList.wikiNo}" class="btn btn-outline-info waves-effect waves-light">수정</button>
								<button name="delete" type="button" id="delete${wikiList.wikiNo}" class="btn btn-outline-danger waves-effect waves-light" onclick="wikiDelete(${stat.index});">삭제 </button>
							</div>
							</c:if>
						</div>
						<div class="border border-dashed"></div>
					</c:forEach>
				<input id="hidCn" type="hidden" name="wikiCn" />
				<input id="wikiNo" type="hidden" name="wikiNo" />
				<input id="wikiTtlUp" type="hidden" name="wikiTtl" />
			</form:form>

		</div>
		<!-- end card-body -->
	</div>
	<!-- end card -->
</div>
<!-- end col -->
<!-- 이것도 pm만 -->





<script type="text/javascript">

	$('#insertWiki').on('click',function(){
		$('#insertPage').show();
		$('#insertWiki').hide();
	})
	$('#cancelInsert').on('click',function(){
		$('#insertWiki').show();
		$('#insertPage').hide();
	})
	
function btnClick(idx){
	
//	alert("i : " + idx);
	var checkcheck = $("#editor"+idx).find('p').text();
	var wikiNo = $("#wikiListwikiNo"+idx).val();
	var TtlWiki = $("#TtlWiki"+idx).val();

	if(checkcheck==""||TtlWiki==""){
		Swal.fire({
            text: '내용은 필수 입력값입니다.',
            imageUrl: '/resources/image/alertLogo.png',
            imageHeight: 25,
            confirmButtonClass: 'btn btn-outline-info w-xs mb-2',
            buttonsStyling: false,
            showCloseButton: true
      	})
	}else{
		$('#hidCn').val(checkcheck);
		$('#wikiNo').val(wikiNo);
		$('#wikiTtlUp').val(TtlWiki);
		
		var form = $("#frmupdate");
		form.submit();
	}
	
}//
	$(function(){
		
		/* 위키내용 검색 */
		$("#seachJob").on("click",function(){
			var cont = $("#seachCon").val();
			location.href = "/wiki/wikiList?cont="+cont+"&projId=<%=projId%>";
			
		});
		
		$('[name="content"]').each(function(){
			
 			var content = $(this).html();
 			console.log("content : " + content);
 			$(this).html(content.replace("${wikiScon}", "<span style='background:yellow;font-size:120%;'>${wikiScon}</span>"));
 			
		})
			

		/* 전체보기 */
		$("#showAll").on("click",function(){
			location.href = "/wiki/wikiList?cont=&projId=<%=projId%>";
		});
		
		//수정 editor
		var cnt = '${wikiListVO[0].cnt}';
		console.log('cnt : ' + cnt);
		
		const Editor = toastui.Editor;
	    for(var i = 0; i<cnt; i++){
	    		const editor = new Editor({
				el: document.querySelector('#editor'+i),
				height: '300px',
				initialEditType: 'wysiwyg',
				previewStyle: 'vertical'
			});
	 	 } //editor가 나오게
	    
/* 	    for(var i = 0; i<cnt; i++){
	    	//수정 확인버튼 누르면 editor안에 내용 hidCn value값으로 바꿔주고 보내기
			$('#updSubmit'+i).on('click',function(){
				
				//console.log("wikiCn : " + wikiCn)
				//var check = $('#hidCn'+i).html(wikiCn);
				//$('#editor'+i ).text(wikiCn);
				alert("i : " + i);
				var check = $("#editor0").find('p').text();
				console.log(check);
				$('#hidCn0').val(check);
				
			}); 
	    } */
		
		
		$('[name="edit"]').on("click",function(e){

			
			console.log($(e.target).attr('id'));
			
			let varId = $(e.target).attr('id');

			$('#Ttl'+varId).hide(); //제목 나와
			$('#wikiTtl'+varId).show(); //제목 나와
			$('#content'+varId).hide(); //위키 설명 숨기고
			$('#cnUpdate'+varId).show(); // 수정창 열기
			$('#'+varId).hide(); //수정 버튼도 없애기
			$('#delete'+varId).hide(); //수정 버튼도 없애기
		});//#eidt
		
		$('[name="cancel"]').on("click",function(){
			$('[name="ttl"]').show(); //제목 숨겨
			$('[name="listwikiTtl"]').hide(); //제목 숨겨
			$('[name="content"]').show(); //위키 설명 숨기고
			$('[name="cnUpdate"]').hide(); // 수정창 열기
			$('[name="edit"]').show(); //수정 버튼도 없애기
			$('[name="delete"]').show(); //수정 버튼도 없애기
	
		})//#cancel
				
		
	})//end
	
	function wikiDelete(idx){
		var wikiListwikiNo = $('#wikiListwikiNo'+idx).val();
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
	        	location.href = "/wiki/wikiDelete?wikiNo="+wikiListwikiNo;
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

