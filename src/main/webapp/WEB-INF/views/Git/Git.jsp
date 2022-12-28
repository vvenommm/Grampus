<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/resources/js/jquery-3.6.0.js"></script>
<script>
$(function(){
//////////////////////
/* 저장소 파일목록 불러오기 */
$("#getContents").on("click",function(){
	$("#repolist").children().remove();
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	$.ajax({
	      type: "GET",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents/",
	      dataType: "json",
	      success: function (response) {
	    	  console.log(response)
	    	  var code = "";
	    	  $.each(response,function(i,v){
	    		  if(v.type == "dir"){
	    			  code += "<tr id='"+v.sha+"'>";
	                  code += "<td>"+v.type+"</td>";
	                  code += "<td id='getCon'><a href='#'>"+v.name+"</a></td>";
	                  code += "<td>"+v.size+"</td>";
	                  code += "<td></td>";
	                  code += "</tr>";
	    		  }else{
	    			  code += "<tr id='"+v.sha+"'>";
	                  code += "<td>"+v.type+"</td>";
	                  code += "<td><a href='"+v.download_url+"'>"+v.name+"</a></td>";
	                  code += "<td>"+v.size+"</td>";
	                  code += "<td><a href='#' id='delContents'>삭제하기</a></td>";
	                  code += "</tr>";
	    		  }
	    	  });
	    	  $("#repolist").append(code);
	      }
	});
});

////////////////////
/* 저장소 디렉토리 이동 */
var dirCount = 0;
var tName = "";
$(document).on("click","#getCon",function(){
	if($(this).find("a").text() == ".."){
		dirCount = dirCount-1;
	}else{
		dirCount = dirCount+1;
	}
	tName += "/"+$(this).find("a").text();
	$("#repolist").children().remove();
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	$.ajax({
	      type: "GET",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents"+tName,
	      dataType: "json",
	      success: function (response) {
	    	  console.log(response)
	    	  if(dirCount > 0){
	    		  var code = "<tr><td>dir</td><td id='getCon' colspan='4'><a href='#'>..</a></td></tr>";
	    	  }else{
	    		  var code = "";
	    		  tName = "";
	    	  }
	    	  $.each(response,function(i,v){
	    		  if(v.type == "dir"){
	    			  code += "<tr id='"+v.sha+"'>";
	                  code += "<td>"+v.type+"</td>";
	                  code += "<td id='getCon'><a href='#'>"+v.name+"</a></td>";
	                  code += "<td>"+v.size+"</td>";
	                  code += "<td></td>";
	                  code += "</tr>";
	    		  }else{
	    			  code += "<tr id='"+v.sha+"'>";
	                  code += "<td>"+v.type+"</td>";
	                  code += "<td><a href='"+v.download_url+"'>"+v.name+"</a></td>";
	                  code += "<td>"+v.size+"</td>";
	                  code += "<td><a href='#' id='delContents'>삭제하기</a></td>";
	                  code += "</tr>";
	    		  }
	    	  });
	    	  $("#repolist").append(code);
	      }
	});
});

///////////////////////
/* 저장소에 파일 업로드 */
$("#commitCon").on("click",function(){
	var uPath = $("#userPath").val().replace(/\s/gi, "");
	var uFile = $("#userFile")[0].files[0];
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	var file = new FileReader();
	file.readAsText(uFile);
	file.onload = function(){
		var tFile = file.result;
		var eFile = btoa(unescape(encodeURIComponent(tFile)))
		var gdt = {message:"UPLOAD "+uFile.name,committer:{name:"세션이름",email:'세션아이디'},content:eFile}
		$.ajax({
		      type: "PUT",
		      headers: {
		        Authorization: "Basic " + auth,
		      },
		      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents"+uPath+"/"+uFile.name,
		      data:JSON.stringify(gdt),
		      dataType: "json",
		      contentType:"application/json; charset=utf-8",
		      success: function (response) {
				  console.log(response)
				  alert("업로드 완료");
				  $("#userFile").val("");
		      }
		});
	}
});

///////////////////////
/* 저장소 파일 삭제 */
$(document).on("click","#delContents",function(){
	var ftr = $(this).closest("tr");
	var fSha = $(this).closest("tr").attr("id");
	var fName = $(this).closest("tr").find("td").eq(1).find("a").text();
	console.log(fSha)
	console.log(fName)
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	var gdt = {message:"DELETE "+fName,committer:{name:"세션이름",email:'세션아이디'},sha:fSha}
	$.ajax({
	      type: "DELETE",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/contents/"+fName,
	      data:JSON.stringify(gdt),
	      dataType: "json",
	      contentType:"application/json; charset=utf-8",
	      success: function (response) {
			  console.log(response)
			  ftr.remove();
			  alert("삭제 완료")
	      }
	});
});


////////////////////////
/* 커밋내역 출력 */
$("#crecon").on("click",function(){
	$("#comlist").children().remove();
	var uToken = $("#userToken").val();
	var uId = $("#userId").val();
	var uRepo = $("#userRepo").val();
	var auth = btoa(unescape(encodeURIComponent(uToken)));
	$.ajax({
	      type: "GET",
	      headers: {
	        Authorization: "Basic " + auth,
	      },
	      url: "https://api.github.com/repos/"+uId+"/"+uRepo+"/commits",
	      dataType: "json",
	      success: function (response) {
			  console.log(response)
			  var code = "";
	    	  $.each(response,function(i,v){
	    		  code += "<tr>";
                  code += "<td>"+v.commit.author.name+"</td>";
                  code += "<td>"+v.commit.author.email+"</td>";
                  code += "<td>"+v.commit.author.date+"</td>";
                  code += "<td>"+v.commit.message+"</td>";
                  code += "</tr>";
	    	  });
	    	  $("#comlist").append(code);
	      }
	});
});

/////////////////////
/* 저장소 정보 값 비우기 */
$("#writeReset").on("click",function(){
	$("#userToken").val("");
	$("#userId").val("");
	$("#userRepo").val("");
});

});
</script>
</head>
<body>
<div class="card">
	<div class="card-body">
	    <div class="row g-4 mb-3">
	       <div class="col-sm">
	           <div class="d-flex justify-content-sm-start gap-2">
	        		<button type="button" id="gitInfo" class="btn btn-outline-info waves-effect waves-light" data-bs-toggle="modal" data-bs-target="#gitInfoModal">저장소 정보</button>
	           		<button type="button" id="getContents" class="btn btn-outline-success waves-effect waves-light">저장소 가져오기</button>
	           		<button type="button" id="crecon" class="btn btn-outline-success waves-effect waves-light">커밋내역 가져오기</button>
	           </div>
	       </div>
		</div>
	</div>
</div>		
<div class="card">
	<div class="card-body">		
	    <div class="row g-4 mb-3">
	       <div class="col-lg-4">
	       		<label for="userPath" class="form-label">파일 저장 경로 (폴더 생성 및 경로는 /로 구분)</label>
           		<input class="form-control" id="userPath" type="text" placeholder="/exfolder/exfolder" />
	       </div>
		</div>
	    <div class="row g-4 mb-3">
	       <div class="col-lg-6">
           		<input class="form-control" id="userFile" type="file" />
	       </div>
	       <div class="col-lg-4">
           		<button type="button" id="commitCon" class="btn btn-outline-primary waves-effect waves-light">파일 업로드</button>
	       </div>
		</div>
	</div>
</div>
<div class="container-fluid">
	<div class="row">
	    <div class="col-xl-12">
	        <div class="card">
	            <div class="card-header align-items-center d-flex">
	                <h4 class="card-title mb-0 flex-grow-1">저장소</h4>
	            </div><!-- end card header -->
	            <div class="card-body">
	                <div class="table-responsive table-card">
	                    <table class="table table-borderless table-hover table-nowrap align-middle mb-0">
	                        <thead class="table-light">
	                            <tr class="text-muted">
	                                <th scope="col" style="width: 20%;">형식</th>
	                                <th scope="col" style="width: 40%;">이름</th>
	                                <th scope="col" style="width: 25%;">크기 (Byte)</th>
	                                <th scope="col" style="width: 15%;">삭제하기</th>
	                            </tr>
	                        </thead>
	                        <tbody id="repolist">
	                        </tbody><!-- end tbody -->
	                    </table><!-- end table -->
	                </div><!-- end table responsive -->
	            </div><!-- end card body -->
	        </div><!-- end card -->
	    </div><!-- end col -->
	</div><!-- end row -->
	<div class="row">
	    <div class="col-xl-12">
	        <div class="card">
	            <div class="card-header align-items-center d-flex">
	                <h4 class="card-title mb-0 flex-grow-1">커밋내역</h4>
	            </div><!-- end card header -->
	            <div class="card-body">
	                <div class="table-responsive table-card">
	                    <table class="table table-borderless table-hover table-nowrap align-middle mb-0">
	                        <thead class="table-light">
	                            <tr class="text-muted">
	                                <th scope="col" style="width: 15%;">이름</th>
	                                <th scope="col" style="width: 30%;">이메일</th>
	                                <th scope="col" style="width: 15%;">날짜</th>
	                                <th scope="col" style="width: 40%;">메세지</th>
	                            </tr>
	                        </thead>
	                        <tbody id="comlist">
	                        </tbody><!-- end tbody -->
	                    </table><!-- end table -->
	                </div><!-- end table responsive -->
	            </div><!-- end card body -->
	        </div><!-- end card -->
	    </div><!-- end col -->
	</div><!-- end row -->
</div>
<div class="modal fade" id="gitInfoModal" tabindex="-1" aria-labelledby="gitInfoModal" style="display: none;" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">저장소 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                   <div class="row g-3">
                       <div class="col-xxl-12">
                           <div>
                               <label for="firstName" class="form-label">토큰</label>
                               <input type="text" class="form-control" id="userToken" value="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" placeholder="토큰값" />
                           </div>
                       </div>
                       <!--end col-->
                       <div class="col-xxl-6">
                           <div>
                               <label for="userId" class="form-label">아이디</label>
                               <input type="text" class="form-control" id="userId" value="gbl1234" placeholder="아이디" />
                           </div>
                       </div>
                       <!--end col-->
                       <div class="col-xxl-6">
                           <div>
                               <label for="userRepo" class="form-label">저장소이름</label>
                               <input type="text" class="form-control" id="userRepo" value="gptest" placeholder="저장소 이름" />
                           </div>
                       </div>
                       <!--end col-->
                       <div class="col-lg-12">
                           <div class="hstack gap-2 justify-content-end">
                               <button type="button" class="btn btn-outline-danger waves-effect waves-light" data-bs-dismiss="modal">닫기</button>
                               <button type="reset" id="writeReset" class="btn btn-outline-primary waves-effect waves-light">작성값 비우기</button>
                           </div>
                       </div>
                       <!--end col-->
                   </div>
                   <!--end row-->
            </div>
        </div>
    </div>
</div>
</body>
</html>