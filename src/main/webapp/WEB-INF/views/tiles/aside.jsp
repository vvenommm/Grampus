<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en" data-layout="twocolumn" data-sidebar="light" data-sidebar-size="lg" data-sidebar-image="none">

 
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript">  

	
<%
int projId = 0;
if(session.getAttribute("projId") != null){
	projId = (int)session.getAttribute("projId");
}
String grp = "";
if(session.getAttribute("grp") != null){
	grp = (String)session.getAttribute("grp");
}
%>

var projId = <%=projId%>;
var grp = "<%=grp%>";

		$.ajax({
			url : "/project/subList",
			contentType : "application/json;charset=utf-8",
			type : "post",
			success : function(res){
				console.log(res);
			
				//참여 중인 프로젝트가 없을 때
				if(res.length == 0){
					var str = `
								<a class="dropdown-item" href="/project/newProject" id="addProj1"><i class="ri-add-circle-line"></i> 프로젝트 개설하기</a>
							  `;
							  
					console.log(str);
			         $('#simplebarC').html(str);
			         
				}else if(res != null && projId > 0 && grp != null){//참여 중인 프로젝트가 있고 세션에 값이 저장 되어 있을 때
					var str = "";
						str += `<div class="btn-group p-1" style="width:230px;">`;
					$.each(res, function(i, v){
						if(projId == v.PROJID && grp == v.PMEMGRP){
							str += `<button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">` + v.PROJTTL + `</button>`;
						}
						
					});

						str += `
	                            <div class="dropdown-menu dropdownmenu-primary" style="width:230px;">
							   `;
					$.each(res, function(i, v){
						str += `
                                <a class="dropdown-item projttl" href="/project/projMain/`+ v.PROJID +`/` + v.PMEMGRP + `" data-projid="` + v.PROJID + `" data-pmemgrp="` + v.PMEMGRP + `">` + v.PROJTTL + `</a>
							   `;
					});

						str += `<div class="dropdown-divider" style="visibility: hidden;" id="divLine"></div>`;
						str += `<a class="dropdown-item" href="/project/newProject" style="visibility: hidden;" id="addProj2"><i class="ri-add-circle-line"></i> 프로젝트 개설하기</a>`;
						str += `</div></div><br />`;

					$.each(res, function(i, v){
						
						if(projId == v.PROJID && grp == v.PMEMGRP){
			                                
							str += `		
									<li class="nav-item">
										<a id="dashBoard" class="nav-link menu-link collapsed" href="/project/projMain/` + v.PROJID + `/` + v.PMEMGRP + `">
											<i class="ri-apps-2-line"></i> <span data-key="t-apps">대시보드</span>
										</a>
									</li>
			
									<li class="nav-item">
										<a class="nav-link menu-link collapsed" href="#sidebarLayout" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLayouts">
											<i class="ri-task-line"></i> <span data-key="t-layouts">일감</span>
										</a>
										<div class="collapse menu-dropdown" id="sidebarLayout">
											<ul class="nav nav-sm flex-column">
												<li class="nav-item">
													<a id="taskKanban" href="/task/kanbanMain/` + v.PROJID + `/` + v.PMEMGRP + `" class="nav-link" data-key="t-horizontal">칸반</a>
												</li>
												<li class="nav-item">
													<a id="taskGantt" href="/gantt/ganttMain/` + v.PROJID + `/` + v.PMEMGRP + `" class="nav-link" data-key="t-detached">간트</a>
													</li>
												<li class="nav-item">
													<a id="taskList" href="/task/taskMain/` + v.PROJID + `/` + v.PMEMGRP + `" class="nav-link" data-key="t-two-column">리스트</a>
												</li>
											</ul>
										</div></li>
									<!-- end Dashboard Menu -->
			
									<li class="nav-item">
										<a id="issue" class="nav-link menu-link collapsed" href="/issue/issueMain/` + v.PROJID + `/` + v.PMEMGRP + `">
											<i class="ri-error-warning-line"></i> <span data-key="t-apps">이슈</span>
										</a>
									</li>
			
									<li class="nav-item">
										<a id="notice" class="nav-link menu-link collapsed" href="/notice/noticeList/` + v.PROJID + `/` + v.PMEMGRP + `">
												<i class="ri-clipboard-line"></i> <span data-key="t-apps">공지사항</span>
										</a>
									</li>
			
									<li class="nav-item">
										<a id="doc" class="nav-link menu-link collapsed" href="/doc/docMain/` + v.PROJID + `/` + v.PMEMGRP + `">
											<i class="ri-folder-3-line"></i> <span data-key="t-apps">문서</span>
										</a>
									</li>
			
									<li class="nav-item">
										<a class="nav-link menu-link collapsed" href="#sidebarLayouts" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLayouts">
											<i class="ri-layout-3-line"></i> <span data-key="t-layouts">게시판</span>
										</a>
										<div class="collapse menu-dropdown" id="sidebarLayouts">
											<ul class="nav nav-sm flex-column">
												<li class="nav-item">
													<a id="helpDesk"href="/board/boardList?brdHead=2&projId=` + v.PROJID + `&pmemGrp=` + v.PMEMGRP + `" class="nav-link" data-key="t-horizontal">헬프데스크</a>
												</li>
												<li class="nav-item">
													<a id="freeBoard" href="/board/boardList?brdHead=1&projId=` + v.PROJID + `&pmemGrp=` + v.PMEMGRP + `" class="nav-link" data-key="t-detached">자유게시판</a>
												</li>
											</ul>
										</div>
									</li>
									<!-- end Dashboard Menu -->
			
									<li class="nav-item">
										<a class="nav-link menu-link collapsed" href="/wiki/wikiList?projId=` + v.PROJID + `" id="wiki">
											<i class=" ri-book-mark-line"></i> <span data-key="t-apps">위키</span>
										</a>
									</li>
			
									<li class="nav-item">
										<a class="nav-link menu-link collapsed" href="/calendar/myCalendar/` + v.PROJID + `/` + v.PMEMGRP + `" id="calenda">
											<i class="ri-calendar-line"></i> <span data-key="t-apps">달력</span>
										</a>
									</li>
			                        <div class="dropdown-divider"></div>
			                        <a class="dropdown-item" href="/project/newProject"><i class="ri-add-circle-line"></i> 프로젝트 개설하기</a>
								   `;
						}
					});
					
					$('#simplebarC').html(str);
				}else{//참여 중인 프로젝트가 있지만 세션에는 저장된 값이 없을 때
					var str = `
								<div class="btn-group p-1" style="width:230px;">
			                        <button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="ttl">프로젝트를 선택해주세요.</button>
			                        <div class="dropdown-menu dropdownmenu-primary" style="width:230px;">
			                  `;
			            $.each(res, function(i, v){
		                  str += `
		                                <a class="dropdown-item projttl" href="/project/projMain/` + v.PROJID + `/` + v.PMEMGRP + `" data-projid="` + v.PROJID + `" data-pmemgrp="` + v.PMEMGRP + `">` + v.PROJTTL + `</a>
			            	`;
			            })
			                    
			              str += `      <div class="dropdown-divider"></div>
			                            <a class="dropdown-item" href="/project/newProject"><i class="ri-add-circle-line"></i> 프로젝트 개설하기</a>
			                        </div>
			                    </div>
								<br />
								<div id="box" style="visibility: hidden;">
								<li class="nav-item">
									<a id="dashBoard" class="nav-link menu-link collapsed" href="">
										<i class="ri-apps-2-line"></i> <span data-key="t-apps">대시보드</span>
									</a>
								</li>
			
								<li class="nav-item">
									<a class="nav-link menu-link collapsed" href="#sidebarLayout" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLayouts">
										<i class="ri-task-line"></i> <span data-key="t-layouts">일감</span>
									</a>
									<div class="collapse menu-dropdown" id="sidebarLayout">
										<ul class="nav nav-sm flex-column">
											<li class="nav-item">
												<a id="taskKanban" href="#" class="nav-link" data-key="t-horizontal">칸반</a>
											</li>
											<li class="nav-item">
												<a id="taskGantt" href="#" class="nav-link" data-key="t-detached">간트</a>
												</li>
											<li class="nav-item">
												<a id="taskList" href="#" class="nav-link" data-key="t-two-column">리스트</a>
											</li>
										</ul>
									</div></li>
								<!-- end Dashboard Menu -->
			
								<li class="nav-item">
									<a id="issue" class="nav-link menu-link collapsed" href="#">
										<i class="ri-error-warning-line"></i> <span data-key="t-apps">이슈</span>
									</a>
								</li>
			
								<li class="nav-item">
									<a id="notice" class="nav-link menu-link collapsed" href="#">
											<i class="ri-clipboard-line"></i> <span data-key="t-apps">공지사항</span>
									</a>
								</li>
			
								<li class="nav-item">
									<a id="doc" class="nav-link menu-link collapsed" href="#">
										<i class="ri-folder-3-line"></i> <span data-key="t-apps">문서</span>
									</a>
								</li>
			
								<li class="nav-item">
									<a class="nav-link menu-link collapsed" href="#sidebarLayouts" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLayouts">
										<i class="ri-layout-3-line"></i> <span data-key="t-layouts">게시판</span>
									</a>
									<div class="collapse menu-dropdown" id="sidebarLayouts">
										<ul class="nav nav-sm flex-column">
											<li class="nav-item">
												<a id="helpDesk"href="#" class="nav-link" data-key="t-horizontal">헬프데스크</a>
											</li>
											<li class="nav-item">
												<a id="freeBoard" href="#" class="nav-link" data-key="t-detached">자유게시판</a>
											</li>
										</ul>
									</div>
								</li>
								<!-- end Dashboard Menu -->
			
								<li class="nav-item">
									<a class="nav-link menu-link collapsed" href="#" id="wiki">
										<i class=" ri-book-mark-line"></i> <span data-key="t-apps">위키</span>
									</a>
								</li>
			
								<li class="nav-item">
									<a class="nav-link menu-link collapsed" href="#" id="calenda">
										<i class="ri-calendar-line"></i> <span data-key="t-apps">달력</span>
									</a>
								</li>
							</div>
							  `;
					
					$('#simplebarC').html(str);
				}
			}
		});
	
	
$(document).on('click', '.projttl', function(){
	$('#ttl').html("");
	
	var projId = $(this).attr('data-projid');
	var grp = $(this).attr('data-pmemgrp');
	var projTtl = $(this).html();
	console.log(projId, grp, projTtl);
	
	$('#dashBoard').attr('href', '/project/projMain/' + projId + '/' + grp);
	$('#taskKanban').attr('href', '/task/kanbanMain/' + projId + '/' + grp);
	$('#taskGantt').attr('href', '/gantt/ganttMain/' + projId + '/' + grp);
	$('#taskList').attr('href', '/task/taskMain/' + projId + '/' + grp);
	$('#issue').attr('href', '/issue/issueMain/' + projId + '/' + grp);
	$('#notice').attr('href', '/notice/noticeList/' + projId + '/' + grp);
	$('#doc').attr('href', '/doc/docMain/' + projId + '/' + grp);
	$('#helpDesk').attr('href', '/board/boardList?brdHead=2&projId=' + projId + '&pmemGrp=' + grp);
	$('#freeBoard').attr('href', '/board/boardList?brdHead=1&projId=' + projId + '&pmemGrp=' + grp);
	$('#wiki').attr('href', '/wiki/wikiList?projId=' + projId);
	$('#calenda').attr('href', '/calendar/myCalendar/' + projId + '/' + grp);
	
	$('#box').attr('style', 'visibility:visible');
	$('#ttl').html(projTtl);
}) 
</script>



<!-- ========== App Menu ========== -->
<div class="app-menu navbar-menu">
	<!-- LOGO -->
	<div class="navbar-brand-box">
		<br />
		<h2>
			<a href="/main"> <span class="logo-sm"> <img
					src="/resources/image/grampusLogo.png" alt="" height="28">
			</span> &nbsp;GRAMPUS
			</a>
		</h2>
		<br />
		<button type="button"
			class="btn btn-sm p-0 fs-20 header-item float-end btn-vertical-sm-hover"
			id="vertical-hover">
			<i class="ri-record-circle-line"></i>
		</button>
	</div>

	<!-- -- -->
	<div id="scrollbar" data-simplebar="init" class="h-100">
		<div class="simplebar-wrapper" style="margin: 0px;">
			<div class="simplebar-height-auto-observer-wrapper">
				<div class="simplebar-height-auto-observer"></div>
			</div>
			<div class="simplebar-mask">
				<div class="simplebar-offset" style="right: 0px; bottom: 0px;">
					<div class="simplebar-content-wrapper" tabindex="0" role="region"
						aria-label="scrollable content"
						style="height: 100%; overflow: hidden scroll;">
						<div class="simplebar-content" style="padding: 0px;">
							<div class="container-fluid">

								<div id="two-column-menu"></div>
								<ul class="navbar-nav" id="navbar-nav" data-simplebar="init">
									<div class="simplebar-wrapper" style="margin: 0px;">
										<div class="simplebar-height-auto-observer-wrapper">
											<div class="simplebar-height-auto-observer"></div>
										</div>
										<div class="simplebar-mask">
											<div class="simplebar-offset"
												style="right: 0px; bottom: 0px;">
												<div class="simplebar-content-wrapper" tabindex="0"
													role="region" aria-label="scrollable content"
													style="height: auto; overflow: hidden;">
													<div class="simplebar-content" style="padding: 0px;" id="simplebarC">
														
														
														
														
														
														
													</div>
												</div>
											</div>
										</div>
										<div class="simplebar-placeholder"
											style="width: 249px; height: 827px;"></div>
									</div>
									<div class="simplebar-track simplebar-horizontal"
										style="visibility: hidden;">
										<div class="simplebar-scrollbar"
											style="width: 0px; display: none; transform: translate3d(0px, 0px, 0px);">
										</div>
									</div>
									<div class="simplebar-track simplebar-vertical"
										style="visibility: hidden;">
										<div class="simplebar-scrollbar"
											style="height: 0px; display: none;"></div>
									</div>
								</ul>
							</div>
							<!-- Sidebar -->
						</div>
					</div>
				</div>
			</div>
			<div class="simplebar-placeholder"
				style="width: auto; height: 827px;"></div>
		</div>
		<div class="simplebar-track simplebar-horizontal"
			style="visibility: hidden;">
			<div class="simplebar-scrollbar"
				style="width: 0px; display: none; transform: translate3d(0px, 0px, 0px);">
			</div>
		</div>
		<div class="simplebar-track simplebar-vertical"
			style="visibility: visible;">
			<div class="simplebar-scrollbar"
				style="height: 512px; transform: translate3d(0px, 0px, 0px); display: block;"></div>
		</div>
	</div>
</div>


<!-- ============================================================== -->