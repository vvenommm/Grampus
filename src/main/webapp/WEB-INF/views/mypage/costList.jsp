<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
<script src="https://unpkg.com/boxicons@2.1.2/dist/boxicons.js"></script>
<!-- Boxicons CSS -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>



    <!-- start page title -->
  <div class="row">
      <div class="col-12">
          <div class="page-title-box d-sm-flex align-items-center justify-content-between">
			  <a href="javascript:location.href='/main/myMain'"><i class="bx bx-left-arrow-circle"></i></a>
              <div class="page-title-right">
                  <ol class="breadcrumb m-0">
                      <li class="breadcrumb-item">내 대시보드</li>
                      <li class="breadcrumb-item active">정산</li>
                  </ol>
              </div>

          </div>
      </div>
  </div>
  <c:if test="${costVOList[0].thisMonth==null}">
	 <div class="row justify-content-center">
	    <div class="col-md-8 col-lg-6 col-xl-5">
	            <div class="card-body p-4 text-center">
	                <div class="avatar-lg mx-auto mt-2">
	                    <div class="avatar-title bg-light text-danger display-3 rounded-circle">
	                        <i class="ri-inbox-unarchive-line"></i>
	                    </div>
	                </div>
	                <div class="mt-4 pt-2">
	                    <h4>정산 내역이 없습니다.</h4>
	                </div>
	            </div>
	            <!-- end card body -->
	    </div>
	</div>
  </c:if>
  
  <!-- end page title -->
  <c:if test="${costVOList[0].thisMonth!=null}">
<div class="col-xl">
   <div class="table-responsive">
       <button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true" id="ttl">${costVOList[0].thisMonth} 월 정산</button>
       <div class="dropdown-menu dropdownmenu-primary" style="width: 230px; position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate3d(0px, 44px, 0px);" data-popper-placement="bottom-start">
              <a class="dropdown-item projttl" href="#" data-projid="181" data-pmemgrp="전체">${costVOList[0].lastMonth} 월 정산</a>
              <a class="dropdown-item projttl" href="#" data-projid="181" data-pmemgrp="전체">${costVOList[0].llastMonth} 월 정산</a>
       </div>

			<table class="table table-hover align-middle table-nowrap mb-0">
           <thead>
               <tr>
                   <th scope="col" style="width: 25px;">
                        <div class="form-check">
<!--                             <input class="form-check-input" type="checkbox" id="checkAll" value="option1"> -->
                        </div>
                    </th>
                    <th scope="col">프로젝트 명</th>
                    <th scope="col" style="text-align:right;">내보수</th>
                    <th scope="col" style="text-align:right;">월급</th>
                    <th scope="col" style="text-align:right;">역할</th>
                    <th scope="col" style="text-align:right;">등급</th>
                    <th scope="col" style="text-align:center;">다운로드</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach var="costList" items="${costVOList}" varStatus="stat">
            	<td id="projSdy${stat.index}" style="display:none"><fmt:formatDate value="${costList.projSdy}" pattern="yyyy.MM.dd" /></td>
			    <td id="projEdy${stat.index}" style="display:none"><fmt:formatDate value="${costList.projEdy}" pattern="yyyy.MM.dd" /></td>
			    <td id="projGigan${stat.index}" style="display:none">${costList.projGigan}일</td>
                <td style="display:none"><input id="memNm${stat.index}" type="hidden" value="${costList.memNm}"/></td>
                <tr>
                    <th scope="row">
                        <div class="form-check">
<!--                         value="option1" 이건 체크 되는거 -->
<%--                             <input class="form-check-input" type="checkbox" id="inlineCheckbox${stat.index}" name="inlineCheckbox" value="option1"> --%>
                        </div>
                    </th>
                    <td id="projTtl${stat.index}"><a href="#" data-bs-toggle="modal" data-bs-target="#costModal" onclick="btnClick(${stat.index});">
                    	${costList.projTtl} | ${costList.pmemGrp}</a></td>
                    <td id="mycost${stat.index}" style="text-align:right;">${costList.mycost} 원</td>
                    <td id="month${stat.index}" style="text-align:right;">${costList.month} 원</td>
                    <td id="grade${stat.index}" style="text-align:right;">${costList.grade}</td>
                    <td id="costLv${stat.index}" style="text-align:right;">${costList.costLv}</td>
                    <td style="text-align:center;"><a href="#"onclick="excelDown(${stat.index});"><i class="ri-download-2-line fs-17 lh-1 align-middle"></i></a></td>
                </tr>
               </c:forEach> 
               <tr><td></td><td>합계 : </td><td style="text-align:right;">${costVOList[0].sum} 원</td><td style="text-align:right;">${costVOList[0].monthSum} 원</td><td></td><td></td><td></td></tr>
            </tbody>
        </table>
    </div>
</div>

<div class="main-content" style="display:none">
	<div class="main-content-inner">
		<div class="page-content">
			<table id="table">
				<caption>프로젝트 정산 명세서</caption>
				<thead>
					<tr>
						<th>프로젝트 명 | 팀</th>
						<th id="tprojTtl"></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>프로젝트 시작일</th>
						<td id="tprojSdy"></td>
					</tr>
					<tr>
						<th>프로젝트 종료일</th>
						<td id="tprojEdy"></td>
					</tr>
					<tr>
						<th>프로젝트 기간</th>
						<td id="tprojGigan"></td>
					</tr>
					<tr>
						<th>내보수</th>
						<td id="tprojMycost"></td>
					</tr>
					<tr>
						<th>월급</th>
						<td id="tprojMonth"></td>
					</tr>
					<tr>
						<th>역할</th>
						<td id="tprojRole"></td>
					</tr>
					<tr>
						<th>등급</th>
						<td id="tprojGrade"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<button type="button"  id="clickFnExcel" onclick="fnExcelReport('table','정산');">Excel
			Download</button>
	</div>
</div>



<!-- 정산내역 모달창 -->
<div class="modal fade bs-example-modal-lg" id="costModal" tabindex="-1"
	aria-labelledby="myLargeModalLabel" aria-modal="true" role="dialog"
	style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<table class="main" width="100%" cellpadding="0" cellspacing="0"
					itemprop="action" itemscope=""
					itemtype="http://schema.org/ConfirmAction"
					style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; margin: 0; border: none;">
					<tbody>
						<tr
							style="font-family: 'Roboto', sans-serif; font-size: 14px; margin: 0;">
							<td class="content-wrap"
								style="font-family: 'Roboto', sans-serif; box-sizing: border-box; color: #495057; font-size: 14px; vertical-align: top; margin: 0; padding: 30px; box-shadow: 0 3px 15px rgba(30, 32, 37, .06);; border-radius: 7px; background-color: #fff;"
								valign="top">
								<meta itemprop="name" content="Confirm Email"
									style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
									<tbody>
										<tr
											style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
											<td class="content-block"
												style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 24px; vertical-align: top; margin: 0; padding: 0 0 10px; text-align: center;"
												valign="top">
												<h4
													style="font-family: 'Roboto', sans-serif; margin-bottom: 10px; font-weight: 600;">프로젝트
													정산 내역</h4>
											</td>
										</tr>
										<tr
											style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
											<td class="content-block"
												style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 12px;"
												valign="top">
												<h5
													style="font-family: 'Roboto', sans-serif; margin-bottom: 3px;"
													id="memNm">님</h5>
												<p
													style="font-family: 'Roboto', sans-serif; margin-bottom: 8px; color: #878a99;">정산
													내역을 보여드립니다.</p>
											</td>
										</tr>
										<tr
											style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
											<td class="content-block"
												style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 18px;"
												valign="top">
												<table style="width: 100%;">
													<tbody>
														<tr style="text-align: left;">
															<th style="padding: 5px;">
																<p
																	style="color: #878a99; font-size: 13px; margin-bottom: 2px; font-weight: 400;">프로젝트
																	시작 일자</p>
																<p id="projSdy"></p>
															</th>
															<th style="padding: 5px;">
																<p
																	style="color: #878a99; font-size: 13px; margin-bottom: 2px; font-weight: 400;">프로젝트
																	마감 일자</p>
																<p id="projEdy"></p>
															</th>
															<th style="padding: 5px;">
																<p
																	style="color: #878a99; font-size: 13px; margin-bottom: 2px; font-weight: 400;">프로젝트
																	기간</p>
																<p id="projGigan"></p>
															</th>
														</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr
											style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
											<td class="content-block"
												style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 12px;"
												valign="top">
												<table style="width: 100%;" cellspacing="0" cellpadding="0">
													<thead style="text-align: left;">
														<tr>
															<th
																style="padding: 8px; border-bottom: 1px solid #e9ebec;">프로젝트
																명</th>
															<th
																style="padding: 8px; border-bottom: 1px solid #e9ebec;">정산금액</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td style="padding: 8px; font-size: 13px;">
																<p
																	style="margin-bottom: 2px; font-size: 13px; color: #878a99;"
																	id="projTtl"></p>
															</td>
															<td style="padding: 8px; font-size: 13px;" id="mycost">
															</td>
														</tr>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0);"
					class="btn btn-link link-success fw-medium" data-bs-dismiss="modal"><i
					class="ri-close-line me-1 align-middle"></i> Close</a>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>


<!-- 그래표 -->
<div class="row">
<div class="col-xl-6">
	<div class="card">
		<div class="card-header">
			<h4 class="card-title mb-0">프로젝트별 수입</h4>
		</div>
		<!-- end card header -->

			<div class="card-body">
			            <canvas id="doughnut" class="chartjs-chart" data-colors='["--vz-primary", "--vz-light"]'></canvas>
			</div>
		</div>
		<!-- end card-body -->
	</div>
	<!-- end card -->


<!-- 월별 -->
	<div class="col-xl-6">
		<div class="card">
			<div class="card-header">
				<h4 class="card-title mb-0">월별 수입</h4>
			</div>
			<!-- end card header -->

			<div class="card-body">
<%-- 				<canvas id="myChart" width="506" height="505" style="display: block; box-sizing: border-box; height: 336.667px; width: 337.333px;"></canvas> --%>
			     <canvas id="myChart"></canvas>
			</div>
			<!-- end card-body -->
		<!-- end card -->
	</div>
</div>
</div>
</c:if>
<script type="text/javascript">
function btnClick(idx){
	//alert("i : " + idx);
	var memNm = $("#memNm"+idx).val();
	var projSdy = $("#projSdy"+idx).text();
	var projEdy = $("#projEdy"+idx).text();
	var projGigan = $("#projGigan"+idx).text();
	var projTtl = $("#projTtl"+idx).text();
	var mycost = $("#mycost"+idx).text();
	
	//alert("memNm : " + memNm);
	//alert("projSdy : " + projSdy);
	//alert("projGigan : " + projGigan);
	
	$('#memNm').text(memNm);
	$('#projSdy').text(projSdy);
	$('#projEdy').text(projEdy);
	$('#projGigan').text(projGigan);
	$('#projTtl').text(projTtl);
	$('#mycost').text(mycost);
	

}
//전체선택 전체해제
$(function(){
	$('#checkAll').change(function(){
		if($('#checkAll').is(":checked")){
			$('input[id^="inlineCheckbox"]').each((index, item) => {
				$(item).prop("checked",true);
			})
		}else{
			$('input[id^="inlineCheckbox"]').each((index, item) => {
				$(item).prop("checked",false);
			})
		}
	});
	
////////////////////////////////도넛 차트 ////////////////////////////////////////
	var context2 = document.getElementById('doughnut').getContext('2d');
	var projTtlList = [];
	var mycostList = new Array();
	
	<c:forEach items="${costVOList}" var="list">
		projTtlList.push("${list.projTtl}");
		mycostList.push("${list.pcp}");
	</c:forEach>
	console.log("mycostList : " + mycostList)
//	var backgroundColorList = new Array();
	

	const data2 = {
			labels : projTtlList,
			datasets : [{
				label : '프로젝트별 수입',
				data : mycostList,
				backgroundColor : [ 
					'rgba(255, 99, 132, 0.5)',
	                'rgba(54, 162, 235, 0.5)',
	                'rgba(255, 206, 86, 0.5)',
	                'rgba(75, 192, 192, 0.5)',
	                'rgba(153, 102, 255, 0.5)',
	                'rgba(255, 159, 64, 0.5)'
				]
			}]
	}

	const config2 = {
		    type: 'doughnut',
		    data: data2,
		    options: {}
		  };
		  
	var myChart = new Chart(
			document.getElementById('doughnut'),
		    config2
	);
	////////////////////////////////도넛 차트 ////////////////////////////////////////
	
	
	////////////////////////////////막대 차트 ////////////////////////////////////////
	//프로젝트가 마감이 아니면 나타나기
	
	// 차트를 그럴 영역을 dom요소로 가져온다.
	var chartArea = document.getElementById('myChart').getContext('2d');
	// 차트를 생성한다. 
	var myChart = new Chart(chartArea, {
	    // ①차트의 종류(String)
	    type: 'bar',
	    // ②차트의 데이터(Object)
	    data: {
	        // ③x축에 들어갈 이름들(Array)
	        labels: [${costVOList[0].llastMonth}, ${costVOList[0].lastMonth}, ${costVOList[0].thisMonth}],
	        // ④실제 차트에 표시할 데이터들(Array), dataset객체들을 담고 있다.
	        datasets: [{
	            // ⑤dataset의 이름(String)
	            label: '단위 : 100만원',
	            // ⑥dataset값(Array)
	            data: [${llastCost}, ${lastCost}, ${thisCost}],
	            // ⑦dataset의 배경색(rgba값을 String으로 표현)
	            backgroundColor: [
	                'rgba(255, 99, 132, 0.5)',
	                'rgba(255, 206, 86, 0.5)',
	                'rgba(75, 192, 192, 0.5)'
	            ],
	            // ⑧dataset의 선 색(rgba값을 String으로 표현)
	            // ⑨dataset의 선 두께(Number)
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
});
	////////////////////////////////막대 차트 ////////////////////////////////////////

function fnExcelReport(id, title) {    
	var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';    
	tab_text = tab_text + '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
	tab_text = tab_text + '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
	tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
	tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
	tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
	tab_text = tab_text + "<table border='1px'>";
	var exportTable = $('#' + id).clone();
	exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
	tab_text = tab_text + exportTable.html();
	tab_text = tab_text + '</table></body></html>';
	var data_type = 'data:application/vnd.ms-excel';
	var ua = window.navigator.userAgent;
	var msie = ua.indexOf("MSIE ");
	var fileName = title + '.xls';
	//Explorer 환경에서 다운로드
	if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
		if (window.navigator.msSaveBlob) {
			var blob = new Blob([tab_text], {
				type: "application/csv;charset=utf-8;"
			});
			navigator.msSaveBlob(blob, fileName);
			}
		} else {
			var blob2 = new Blob([tab_text], {
				type: "application/csv;charset=utf-8;"
			});
			var filename = fileName;
			var elem = window.document.createElement('a');
			elem.href = window.URL.createObjectURL(blob2);
			elem.download = filename;
			document.body.appendChild(elem);
			elem.click();
			document.body.removeChild(elem);
	}
}

function excelDown(idx){
	var memNm = $("#memNm"+idx).val();
	var projSdy = $("#projSdy"+idx).text();
	var projEdy = $("#projEdy"+idx).text();
	var projGigan = $("#projGigan"+idx).text();
	var projTtl = $("#projTtl"+idx).text();
	var mycost = $("#mycost"+idx).text();
	var month = $("#month"+idx).text();
	var grade = $("#grade"+idx).text();
	var costLv = $("#costLv"+idx).text();
	
	$('#tprojTtl').text(projTtl);
	$('#tprojSdy').text(projSdy);
	$('#tprojEdy').text(projEdy);
	$('#tprojGigan').text(projGigan);
	$('#tprojMycost').text(mycost);
	$('#tprojMonth').text(month);
	$('#tprojRole').text(grade);
	$('#tprojGrade').text(costLv);

	$('#clickFnExcel').click();
}

</script>
