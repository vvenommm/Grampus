<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.3.3/echarts.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-stacked100@1.0.0"></script>
<link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@mdi/font@5.x/css/materialdesignicons.min.css" rel="stylesheet">
<!-- 나눔스퀘어 폰트  -->
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
<script src="/resources/js/jquery-3.6.0.js"></script>

<style>
	.parent{
		display : flex;
	}
	.child{
		width : 40%;
	}

	header{
 		font-family: 'NanumSquare';
 		display: none;
	}
	#alertDiv {
		width: 20%;
	    position: fixed;
	    left: 60%;
	    top: 5%;
	    transform: translate(100%, 0);
	    overflow: hidden;
	    opacity: 0;
	    visibility: hidden;
	    transition: opacity .5s, visibility .5s, transform .5s;
	    z-index: 10000;
	}
	#alertDiv.alertShow {
	    opacity: 1;
	    visibility: visible;
	    transform: translate(90%, 0)
	}
	footer{
		display:none;
	}
	
</style>


<!-- ------------------------- -->

<div class="container-fluid">  
<br /><br />
<h3 class="text-center">포트폴리오</h3>
<div class="row" style="position: relative;">
    <div class="col-lg-12">
        <div>
            <!-- Tab panes -->
            <div class="tab-content text-muted">
                <div class="tab-pane active" id="overview-tab" role="tabpanel">
                    <div class="row">
                        <div class="col-xxl-6">
	                                <div id="includeMemInfo">
										<jsp:include page="../views/mypage/memInfo.jsp"></jsp:include> 
									</div>
                        </div>
                        <!--end col-->
                        <div class="col-xxl-6">
                                    <div id="includeProfileList">
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

<!-- 역할 모달 -->
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
</div>


<script>
//////////////////////////////// 역할 차트 ////////////////////////////////////////
//맡았던  역할
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

