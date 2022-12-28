<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.3.3/echarts.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-stacked100@1.0.0"></script>


<script type="text/javascript">
$(function(){


	
	//이력서 수정 누르면 안에 <div id=myPage 다 사라지고 비밀번호 입력하게 나옴!
	$('#myPageUpdate').on('click',function(){
		$('#myPageUpdate').hide();//수정버튼 사라져
		$('#rjob').hide();
		$('#rcareer').hide();
		$('#job').show();
		$('#career').show();
		$('#rcheck').show();
		$('#rcancel').show();
		$('#liceList').hide();//원래 자격증 리스트 사라지기
		$('#liceNm').show(); // 자격증 추가 버튼 나오기
		
	});
	
	//이력서 수정 취소 누르면
	$('#rcancel').on('click',function(){
		$('#myPageUpdate').show();//수정버튼 다시 보여
		$('#rjob').show();
		$('#rcareer').show();
		$('#job').hide();
		$('#career').hide();
		$('#rcheck').hide();
		$('#rcancel').hide();
		$('#liceList').show();//원래 자격증 리스트 다시 보여
		$('#liceNm').hide();//자격증 추가 삭제 버튼 사라져
		$('[name="edit"]').hide();//프로필 리스트 수정 버튼 사라짐
	});
	
	
	
	//비밀번호 확인에서 입력 눌렀을 때 비밀번호 일치하면 수정할 수 있는 화면 나오게 변환
	$('#pwCheck').on('click',function(){
// 		alert("gg")
		let pwId = '${memberVO.memPw}';
		console.log("pwId : " + pwId);
		let pwCheckId = $('#pwId').val();
		console.log("pwCheckId : " + pwCheckId);
		
		//비밀번호 다르면 색상변경(이건 나중에 다시 확인)
		if(pwId != $('#pwId').val()){
			$('#ppcheck').text('비밀번호를 확인하세요').css("color","red")
		}
		
		if(pwId == pwCheckId){
			//페이지 이동
			$(location).attr("href"," /mypage/pwChange")
		}
		
	});
	
	$('#chCancel').on('click',function(){
		$('#pwId').val("");
		$('#ppcheck').text("");
	})
		

	

});

</script>

<style>
	.parent{
		display : flex;
	}
	.child{
		width : 40%;
	}

</style>



<!-- ------------------------- -->


<div class="row" style="position: relative;">
    <div class="col-lg-12">
        <div>
            <!-- Tab panes -->
            <div class="tab-content text-muted">
                <div class="tab-pane active" id="overview-tab" role="tabpanel">
                    <div class="row">
                        <div class="col-xxl-6">
	                                <div id="includeMemInfo">
										<jsp:include page="../mypage/memInfo.jsp"></jsp:include>
									</div>
                        </div>
                        <!--end col-->
                        <div class="col-xxl-6">
                                    <div id="includeProfileList">
										<jsp:include page="../mypage/profileList.jsp"></jsp:include>
									</div>
                        </div>
                        <!--end col-->
                    </div>
                    <!--end row-->
                </div>
               
                <!--end tab-pane-->
            </div>
            <!--end tab-content-->
        </div>
    </div>
    <!--end col-->
</div>
<!--end row-->


<div class="row">
	<div class="col-xxl-4">
		<div class="card">
			<div class="card-header align-items-center d-flex">
				<h4 class="card-title mb-0 flex-grow-1">
					프로젝트
					<button type="button" class="btn btn-soft-primary btn-sm"
						data-bs-toggle="modal" data-bs-target="#projModal"
						style="float: right;">더보기</button>
				</h4>
			</div>
			<!-- end card header -->
			<div class="card-body">
				<canvas id="stacked"></canvas>
			</div>
			<!-- end cardbody -->
		</div>
		<!-- end card -->
	</div>
	<div class="col-xxl-4">
		<div class="card">
			<div class="card-header align-items-center d-flex">
				<h4 class="card-title mb-0 flex-grow-1">
					일감
					<button type="button" class="btn btn-soft-primary btn-sm"
						data-bs-toggle="modal" data-bs-target="#taskModal"
						style="float: right;">더보기</button>
				</h4>
			</div>
			<!-- end card-header -->
			<div class="card-body">
				<canvas id="doughnut"></canvas>
			</div>
			<!-- end card body -->
		</div>
		<!-- end card -->
	</div>
	<div class="col-xxl-4">
		<div class="card">
			<div class="card-header align-items-center d-flex">
				<h4 class="card-title mb-0 flex-grow-1">역할
					<button type="button" class="btn btn-soft-primary btn-sm"
						data-bs-toggle="modal" data-bs-target="#roleModal"
						style="float: right;">더보기</button>
				</h4>
			</div>
			<!-- end card-header -->

			<div class="card-body">
				<canvas id="myChart"></canvas>
			</div>
			<!-- end card body -->
		</div>
		<!-- end card -->
	</div>
</div>



<!-- 프로젝트 모달 -->
<div class="modal fade" id="projModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="exampleModalScrollableTitle">프로젝트</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body">
            	<div class="live-preview">
                    <div class="table-responsive">
                        <table class="table table-borderless align-middle table-nowrap mb-0">
                            <thead>
                                <tr>
                                    <th scope="col">프로젝트 명</th>
                                    <th scope="col">시작일</th>
                                    <th scope="col">종료일</th>
                                    <th scope="col">상태</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<c:forEach var="projList" items="${projList}" varStatus="stat">
	                                <tr>
	                                    <th>${projList.projTtl }</th>
	                                    <td><fmt:formatDate value="${projList.projSdy }" pattern="yyyy.MM.dd" /></td>
	                                    <td><fmt:formatDate value="${projList.projEdy }" pattern="yyyy.MM.dd" /></td>
							            <c:choose>
							            	<c:when test="${projList.projStts == '마감'}">
									            <td><span class="badge badge-soft-danger">${projList.projStts}</span></td>
							            	</c:when>
							            	<c:otherwise>
									            <td><span class="badge badge-soft-success">${projList.projStts}</span></td>
							            	</c:otherwise>
							            </c:choose>
	                                </tr>
	                             </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->


<!-- 일감 모달 -->
<div class="modal fade" id="taskModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="exampleModalScrollableTitle">일감</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body">
            	<div class="live-preview">
                    <div class="table-responsive">
                        <table class="table table-borderless align-middle table-nowrap mb-0">
                            <thead>
                                <tr>
	                                <th scope="col">일감번호(#)</th>
						            <th scope="col">우선순위</th>
						            <th scope="col">제목</th>
						            <th scope="col">상태</th>
						            <th scope="col">시작일</th>
						            <th scope="col">종료일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="list" items="${taskList}" varStatus="stat">
				        <tr>
				            <th scope="row"># ${list.taskNo}</th>
				            <c:choose>
					            <c:when test="${list.taskPriority =='긴급'}">
					            	<td><span class="badge badge-soft-danger">${list.taskPriority}</span></td>
					            </c:when>
					            <c:otherwise>
					            	<td><span class="badge badge-soft-success">${list.taskPriority}</span></td>
					            </c:otherwise>
				            </c:choose>
		            		<td>${list.taskTtl}</td>
				            <c:choose>
				            	<c:when test="${list.taskStts == '완료' or list.taskStts == '승인'}">
						            <td class="link-success">${list.taskStts}</td>
				            	</c:when>
				            	<c:when test="${list.taskStts == '반려'}">
						            <td class="link-danger">${list.taskStts}</td>
				            	</c:when>
				            	<c:otherwise>
						            <td class="link-warning">${list.taskStts}</td>
				            	</c:otherwise>
				            </c:choose>
				            <td>${list.taskSdy}</td>
				            <td>${list.taskEdy}</td>
		       			</tr>
				        </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- 직책 모달 -->
<div class="modal fade" id="roleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="exampleModalScrollableTitle">역할</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body">
            	<div class="live-preview">
                    <div class="table-responsive">
                        <table class="table table-borderless align-middle table-nowrap mb-0">
                            <thead>
                                <tr>
	                                <th scope="col">프로젝트 명</th>
						            <th scope="col">역할</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="list" items="${roleList}" varStatus="stat">
						        <tr>
						            <th scope="row">${list.projTtl}</th>
				            		<td>${list.roleNm}</td>
				            	<tr>
						        </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- 회원 비밀번호 변경 Modals -->
<!-- First modal dialog -->
<div class="modal fade" id="exampleModal" aria-hidden="true" aria-labelledby="..." tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
		   <div class="modal-header">
			    <h5 class="modal-title" id="exampleModalgridLabel">비밀번호 확인</h5>
			    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
            <div class="modal-body text-center p-5">
            <div>
                <input type="password" class="form-control" id="pwId" placeholder="비밀번호를 입력하세요">
            </div>
             <div id="ppcheck"></div>
                <div class="mt-4 pt-4">
                    <button id="pwCheck" class="btn btn-outline-primary waves-effect waves-light"><!--  onclick="location.href='/mypage/pwChange'" -->
                       		 확인
                    </button>
                    <button id="chCancel" type="button" class="btn btn-outline-danger waves-effect waves-light" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
//////////////////////////////// 직책 차트 ////////////////////////////////////////
//맡았던  직책
// 차트를 그럴 영역을 dom요소로 가져온다.
var chartArea = document.getElementById('myChart').getContext('2d');
// 차트를 생성한다. 
var myChart = new Chart(chartArea, {
    // ①차트의 종류(String)
    type: 'bar',
    // ②차트의 데이터(Object)
    data: {
        // ③x축에 들어갈 이름들(Array)
        labels: ['PM', 'PL', 'TA', 'AA', 'UA', 'DA'],
        // ④실제 차트에 표시할 데이터들(Array), dataset객체들을 담고 있다.
        datasets: [{
            // ⑤dataset의 이름(String)
            label: '역할 수',
            // ⑥dataset값(Array)
            data: [${myRole.pm},${myRole.pl},${myRole.ta},${myRole.aa},${myRole.ua},${myRole.da} ],
            // ⑦dataset의 배경색(rgba값을 String으로 표현)
            backgroundColor: [
                'rgba(255, 99, 132, 0.5)',
                'rgba(54, 162, 235, 0.5)',
                'rgba(255, 206, 86, 0.5)',
                'rgba(75, 192, 192, 0.5)',
                'rgba(153, 102, 255, 0.5)',
                'rgba(255, 159, 64, 0.5)'
            ],
            borderWidth: 1
        }]
    },
    // ⑩차트의 설정(Object)
    options: {
        // ⑪축에 관한 설정(Object)
        scales: {
            // ⑫y축에 대한 설정(Object)
            y: {
                // ⑬시작을 0부터 하게끔 설정(최소값이 0보다 크더라도)(boolean)
                beginAtZero: true
            }
        }
    }
});

////////////////////////////////일감 차트 ////////////////////////////////////////

Chart.register(ChartjsPluginStacked100.default);

new Chart(document.getElementById("doughnut"), {
  type: "bar",
  data: {
    labels: [""],
    datasets: [
      { label: "전체 일감", data: [${myTasks.allTask}], backgroundColor:  'rgba(255, 99, 132, 0.5)' },
      { label: "완료한 일감", data: [${myTasks.doneTask}], backgroundColor: 'rgba(54, 162, 235, 0.5)', },
    ],
  },
  options: {
    indexAxis: "y",
    plugins: {
      stacked100: { enable: true },
    },
  },
});
//////////////////////////////// 프로젝트 차트 ////////////////////////////////////////
Chart.register(ChartjsPluginStacked100.default);

new Chart(document.getElementById("stacked"), {
  type: "bar",
  data: {
    labels: [""],
    datasets: [
      { label: "진행 중인 프로젝트 개수", data: [${myProj.ingproject}], backgroundColor:  'rgba(75, 192, 192, 0.5' },
      { label: "종료된 프로젝트 개수", data: [${myProj.endproject}], backgroundColor: 'rgba(255, 206, 86, 0.5)', },
    ],
  },
  options: {
    indexAxis: "y",
    plugins: {
      stacked100: { enable: true },
    },
  },
});
</script>

