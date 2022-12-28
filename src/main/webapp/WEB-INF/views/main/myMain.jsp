<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.3.3/echarts.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-stacked100@1.0.0"></script>


<div class="row">
    <div class="col-xxl-5">
        <div class="card card-height-100">
            <div class="card-header align-items-center d-flex">
                <h4 class="card-title mb-0 flex-grow-1">포트폴리오</h4>
            </div><!-- end cardheader -->
            <div class="card-body">
            	<div class="row">
   					<div class="col">
   						<br />
		           		<div>
							<p id="memPhoto" style="text-align:center;"><img alt="${memberVO.memPhoto}" src="/resources/image/${memberVO.memPhoto}" class="image avatar-xs" style="width:180px;height:220px;"></p>
							<p style="text-align:center; font-size:120%;"><span class="badge badge-outline-dark">${memberVO.memNm}</span></p>
							<input id="memPhotoUpdate" type="file" name="file" class="form-control form-control-sm" style="display:none;"/> 
						</div>
   					</div>
   					<div class="col">
   						<br />
						<div class="table-responsive">
				    		<input type="hidden" name="memNo" value="${memberVO.memNo}" />
					        <table class="table table-borderless" id="table">
					            <tbody>
					                <tr>
					                    <th class="ps-0 icon-wrapper icon-container" scope="row"><i class="ri-mail-line"></i></i></th>
					                    <td class="text-muted" >${memberVO.memId}
					                    	<input style="display:none" id="mId" type="text" name="memId" value="${memberVO.memId}" />
					                    </td>
					                </tr>
					                
					                <tr>
					                    <th class="ps-0" scope="row"><i class="ri-briefcase-2-line"></i>  </th> 
					                    <td class="text-muted">
					                    	<p id="rcareer"> ${resumeVO.rsmCareer} </p>
					                    </td>
					                </tr>
					                <tr>
					                    <th class="ps-0" scope="row"><i class="ri-ball-pen-fill"></i> </th>
					                    <td class="text-muted">
					                    	<p id="rjob"> ${resumeVO.rsmJob} </p>
					                    </td>
					                </tr>
					                <c:forEach var="licenseList2" items="${licenseVOList2}" varStatus="stat">
					                	<tr>
					                		<th class="ps-0" scope="row"><i class="ri-profile-line"></i></th>
					                		<td class="text-muted"><p>${licenseList2.liceNm}</p></td>
					                	</tr>
					                </c:forEach>
				               </tbody>
			                </table>
						</div>
   					</div>
 				</div>
            </div><!-- end card body -->
        </div><!-- end card -->
    </div><!-- end col -->

    <div class="col-xxl-7">
        <div class="card">
            <div class="card-header align-items-center d-flex">
                <h4 class="card-title mb-0 flex-grow-1">참여 현황</h4>
            </div><!-- end card header -->
            <div class="card-body">
                <div id="heatMap"></div>
            </div><!-- end cardbody -->
        </div><!-- end card -->
    </div><!-- end col -->
</div><!-- end row -->


<div class="row">	
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/task/todayTaskList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">오늘까지 일감</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${todayTaskVOList[0].cnt}">${todayTaskVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-danger rounded-circle fs-2">
									<i class="ri-alarm-warning-line" ></i>
								</span>
							</div>
				
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/task/mypageTaskList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">내 일감</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${taskVOList[0].cnt}">${taskVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-info rounded-circle fs-2">
									<i class="ri-file-edit-line"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/task/endTaskList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">지난 일감</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${endTaskVOList[0].cnt}">0</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-info rounded-circle fs-2">
									<i class="ri-timer-line"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
</div><!-- end row -->


<div class="row">	
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/project/projingList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">진행 프로젝트</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${projectVOList.cnt}">${projectVOList.cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0" >
								<span class="avatar-title bg-soft-info rounded-circle fs-2">
									<i class="ri-folder-5-line"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
    </div><!-- end col -->
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/project/inviteProjectList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">초대 프로젝트</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${projectInviteVOList[0].cnt}">${projectInviteVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-warning rounded-circle fs-2">
									<i class="ri-folder-add-line"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/project/projEndList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">마감 프로젝트</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${projectEndVOList[0].cnt}">${projectEndVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-info rounded-circle fs-2">
									<i class="ri-folder-zip-line"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
</div><!-- end row -->

<div class="row">	
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/bookMarkList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">공고북마크</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${jovVOList[0].cnt}">${jovVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-info rounded-circle fs-2">
									<i class="ri-bookmark-3-fill"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/applicant/jobApplicantList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">공고 지원함</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${applicantVOList[0].cnt}">${applicantVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-info rounded-circle fs-2">
									<i class="ri-inbox-unarchive-line"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
	<div class="col-xxl-4">
		<div class="card card-animate" style="height:100px;">
			<a href="javascript:location.href='/cost/costList?memNo=${memberVO.memNo}'">
				<div class="card-body">
					<div class="d-flex justify-content-between">
						<div>
							<p class="fw-semibold text-muted mb-0">정산</p>
							<h2 class="mt-4 ff-secondary fw-semibold">
								<span class="counter-value"
									data-target="${costVOList[0].cnt}">${costVOList[0].cnt}</span>
							</h2>
						</div>
						<div>
							<div class="avatar-sm flex-shrink-0">
								<span class="avatar-title bg-soft-success rounded-circle fs-2">
									<i class="ri-exchange-dollar-fill"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<!-- end card body -->
			</a>
		</div>
		<!-- end card-->
    </div><!-- end col -->
</div><!-- end row -->


<script>


//////////////////////////////// 히스토리 차트 ////////////////////////////////////////
let datas = new Array(12);
for(var i=0; i<datas.length; i++){
	datas[i] = [];
}
let myvalue;
<c:forEach items="${myHisList}" var="list">
	myvalue = { "x" : "${list.myhisdate}", "y" : ${list.hiscnt} };
	datas[ ${list.hisdatemy} -1].push(myvalue) ;
</c:forEach>
// console.log("datas", datas);

var options = {
		   series: [
		 {
		   name: '1',
		   data: datas[0]
		 },
		 {
		   name: '2',
		   data: datas[1]
		 },
		 {
		   name: '3',
		   data: datas[2]
		 },
		 {
		   name: '4',
		   data: datas[3]
		 },
		 {
		   name: '5',
		   data: datas[4]
		 },
		 {
		   name: '6',
		   data: datas[5]
		 },
		 {
		   name: '7',
		   data: datas[6]
		 },
		 {
		   name: '8',
		   data: datas[7]
		 },
		 {
		   name: '9',
		   data: datas[8]
		 },
		 {
		   name: '10',
		   data: datas[9]
		 },
		 {
		   name: '11',
		   data: datas[10]
		 },
		 {
		   name: '12',
		   data: datas[11]
		 }
		 ],
	   chart: {
	   type: 'heatmap',
	   height : 280,
	   //다운로드 햄버거 없애는 코드
	   toolbar: {
		      show: true,
		      tools:{
		        download:false // <== line to add
		      }
		    },
	},
	dataLabels: {
	  enabled: false
	},
	colors: ["#299cdb"],
	};
	
	var chart = new ApexCharts(document.querySelector("#heatMap"), options);
	chart.render();

</script>

