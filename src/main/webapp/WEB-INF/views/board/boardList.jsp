<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	int projId = (int) session.getAttribute("projId");
	int pmemCd = (int) session.getAttribute("pmemCd");
	String pmemGrp = (String) session.getAttribute("grp");
%>
<!-- pmemGrp사용을 위해 변환!!! -->
<c:set var="pmemGrp" value="<%=pmemGrp%>"></c:set>
<c:set var="projId" value="<%=projId%>"></c:set>

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
	                    	<a href="javascript: location.href='/project/projMain/${projId}/${pmemGrp}';">
	                    		<i class="ri-home-2-fill"></i>
	                    	</a>
	                    </li>
	                    <li class="breadcrumb-item active">${pmemGrp}</li>
		                <li class="breadcrumb-item active" onclick="javascript:location.href='/board/boardList?brdHead=${param.brdHead}&projId=${projId}&pmemGrp=${pmemGrp}'" style="cursor: pointer">
			                <c:if test="${param.brdHead=='1'}">
								자유게시판
							</c:if>
							<c:if test="${param.brdHead=='2'}">
								헬프데스크
							</c:if>
		                </li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
<!-- end page title -->
<div>
	<div class="row g-4 mb-2">
		<div class="col-sm-auto">
			<div class="d-flex justify-content-sm-end gap-2">
				<a class="btn btn-soft-info waves-effect waves-light"
					id="showAll">전체보기</a>
				<div class="search-box ms-2">
					<input type="text" id="seachCon" class="form-control"
						placeholder="검색하기"> <i
						class="ri-search-line search-icon"></i>
				</div>
				<a class="btn btn-soft-info waves-effect waves-light"
					id="seachJob">검색</a>
			</div>
		</div>
		<div class="col-sm">
			<div class="d-flex justify-content-sm-end">
				<div class="d-flex justify-content-sm-end gap-2">
					<a href='/board/boardWrite?projId=${projId }&pmemGrp=${pmemGrp}'
						class="btn btn-ghost-primary waves-effect waves-light"> <i
						class="ri-add-line align-bottom me-1"></i> 작성하기
					</a>
				</div>
			</div>
		</div>
	</div>
	<table class="table table-borderless table-nowrap">
	    <thead>
	        <tr>
	            <th scope="col">번호</th>
	            <th scope="col">제목</th>
	            <th scope="col">작성자</th>
	            <th scope="col">작성일</th>
	            <th scope="col">조회수</th>
	        </tr>
	    </thead>
	    <tbody>
	   	 	<c:forEach var="boardList" items="${boardVOList}" varStatus="stat">
	        <tr>
	            <td scope="row">${boardList.rnum}</td>
	            <td>${boardList.brdTtl}</td>
	            <td>${boardList.profNm}</td>
	            <td><fmt:formatDate value="${boardList.brdDy}" pattern="yyyy.MM.dd" /></td>
	            <td>${boardList.brdInq}</td>
	            <td><a href="/board/boardDetail?brdNo=${boardList.brdNo}&projId=${boardList.projId}&pmemGrp=${pmemGrp}" class="link-info">View More</a></td>
	        </tr>
	        </c:forEach>
    		<c:if test="${empty boardVOList}">
    			<td colspan=5 style="text-align:center;">게시글이 존재하지 않습니다.</td>
    		</c:if>
	    </tbody>
	</table>
	
    		<c:if test="${!empty boardVOList}">
					<!-- pagination -->
				<div class="row g-0 text-center text-sm-start align-items-center mb-4">
                     <ul class="pagination pagination-separated justify-content-center justify-content-sm mb-sm-0" id="pageUl">
                         <li class="page-item <c:if test='${list.startPage<6 }'>disabled</c:if>" id="prevBtn">
                             <a href="/board/boardList?brdHead=${boardVOList[0].brdHead}&projId=${projId}&pmemGrp=${grp}?currentPage=${list.startPage-5 }" class="page-link">Previous</a>
                         </li>
		<c:forEach var="pNo" begin="${list.startPage }" end="${list.endPage }" step="1">
                          <li class="page-item <c:if test='${list.currentPage eq pNo}'>active</c:if>">
                              <a href="/board/boardList?brdHead=${boardVOList[0].brdHead}&projId=${projId}&pmemGrp=${grp}?currentPage=${pNo }" class="page-link">${pNo}</a>
                          </li>
		</c:forEach>
                         <li class="page-item <c:if test='${list.endPage>=list.totalPages }'>disabled</c:if>" id="nextBtn">
                             <a href="/board/boardList?brdHead=${boardVOList[0].brdHead}&projId=${projId}&pmemGrp=${grp}?currentPage=${list.startPage+5 }" class="page-link">Next</a>
                         </li>
                     </ul>
                </div>
    		</c:if>
</div>


