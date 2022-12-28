<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>

<c:if test="${paymentVOHistory.payNo==null}">
	<div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6 col-xl-5">
                            <div class="card-body p-4 text-center">
                                <div class="avatar-lg mx-auto mt-2">
                                    <div class="avatar-title bg-light text-success display-3 rounded-circle">
                                        <i class="ri-bank-card-2-line"></i>
                                    </div>
                                </div>
                                <div class="mt-4 pt-2">
                                    <h4>결제한 상품이 없습니다</h4>
                                    <div class="mt-4">
                                        <a href="javascript:location.href='/plan'" class="btn btn-soft-success">플랜변경</a>
                                    </div>
                                </div>
                            </div>
                            <!-- end card body -->
                    </div>
                </div>
</c:if>

<c:if test="${paymentVOHistory.payNo!=null}">
<div class="content" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;">
    <table class="main" width="100%" cellpadding="0" cellspacing="0" itemprop="action" itemscope="" itemtype="http://schema.org/ConfirmAction" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; margin: 0; border: none;">
        <tbody><tr style="font-family: 'Roboto', sans-serif; font-size: 14px; margin: 0;">
            <td class="content-wrap" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; color: #495057; font-size: 14px; vertical-align: top; margin: 0;padding: 30px; box-shadow: 0 3px 15px rgba(30,32,37,.06); ;border-radius: 7px; background-color: #fff;" valign="top">
                <meta itemprop="name" content="Confirm Email" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
                <table width="100%" cellpadding="0" cellspacing="0" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
                    <tbody><tr style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="content-block" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 24px; vertical-align: top; margin: 0; padding: 0 0 10px; text-align: center;" valign="top">
                            <h4 style="font-family: 'Roboto', sans-serif; margin-bottom: 10px; font-weight: 600;">Plan Payment invoice</h4>
                        </td>
                    </tr>
                    <tr style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="content-block" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 12px;" valign="top">
                            <h5 style="font-family: 'Roboto', sans-serif; margin-bottom: 3px;">${paymentVOHistory.memNm} 님</h5>
                            <p style="font-family: 'Roboto', sans-serif; margin-bottom: 8px; color: #878a99;">결제 내역을 보여드립니다.</p>
                        </td>
                    </tr>
                    <tr style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="content-block" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 18px;" valign="top">
                            <table style="width:100%;">
                                <tbody>
                                    <tr style="text-align: left;">
                                        <th style="padding: 5px;">
                                            <p style="color: #878a99; font-size: 13px; margin-bottom: 2px; font-weight: 400;">결제번호</p>
                                            <span>${paymentVOHistory.payNo}</span>
                                        </th>
                                        <th style="padding: 5px;">
                                            <p style="color: #878a99; font-size: 13px; margin-bottom: 2px; font-weight: 400;">결제 일자</p>
                                            <span><fmt:formatDate value="${paymentVOHistory.paySdy}" pattern="yyyy.MM.dd" /></span>
                                        </th>
                                        <th style="padding: 5px;">
                                            <p style="color: #878a99; font-size: 13px; margin-bottom: 2px; font-weight: 400;">결제 방법</p>
                                            <span>${paymentVOHistory.payMethod}</span>
                                        </th>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="content-block" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 12px;" valign="top">
                            <h6 style="font-family: 'Roboto', sans-serif; font-size: 15px; text-decoration-line: underline;margin-bottom: 15px;">결제 내역 : </h6>
                            <table style="width:100%;" cellspacing="0" cellpadding="0">
                                <thead style="text-align: left;">
                                    <tr><th style="padding: 8px;border-bottom: 1px solid #e9ebec;">플랜명</th>
                                    <th style="padding: 8px;border-bottom: 1px solid #e9ebec;">프로젝트 아이디</th>
                                    <th style="padding: 8px;border-bottom: 1px solid #e9ebec;">플랜 가격</th>
                                </tr></thead>
                                <tbody>
                                    <tr>
                                        <td style="padding: 8px; font-size: 13px;">
                                            <h6 style="margin-bottom: 2px; font-size: 14px;">
											 	<c:if test="${paymentVOHistory.planTtl=='PLUS'}"><span class="badge badge bg-success">plus</span></c:if>
												<c:if test="${paymentVOHistory.planTtl=='PREMIUM'}"><span class="badge badge bg-warning">premium</span></c:if>
											</h6>
                                            <p style="margin-bottom: 2px; font-size: 13px; color: #878a99;">
											 	<c:if test="${paymentVOHistory.planTtl=='PLUS'}">프로젝트 인원 무제한, 프로젝트 공고 등록</c:if>
												<c:if test="${paymentVOHistory.planTtl=='PREMIUM'}">프로젝트 인원 무제한, 프로젝트 공고 등록, 프로젝트 기한 무제한</c:if>
											</p>
                                        </td>
                                        <td style="padding: 8px; font-size: 13px;">
                                            ${paymentVOHistory.projId}
                                        </td>
                                        <td style="padding: 8px; font-size: 13px;">
                                            ${paymentVOHistory.planPrice}
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding: 8px; font-size: 13px; text-align: end;border-top: 1px solid #e9ebec;">
                                            	공급가액
                                        </td>
                                        <th style="padding: 8px; font-size: 13px;border-top: 1px solid #e9ebec;">
                                            <c:if test="${paymentVOHistory.planTtl=='PLUS'}">￦91</c:if>
											<c:if test="${paymentVOHistory.planTtl=='PREMIUM'}">￦9,089</c:if>
                                        </th>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding: 8px; font-size: 13px; text-align: end;">
                                            	부가세
                                        </td>
                                        <th style="padding: 8px; font-size: 13px;">
                                            <c:if test="${paymentVOHistory.planTtl=='PLUS'}">￦9</c:if>
											<c:if test="${paymentVOHistory.planTtl=='PREMIUM'}">￦901</c:if>
                                        </th>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding: 8px; font-size: 13px; text-align: end;border-top: 1px solid #e9ebec;">
                                            	합계
                                        </td>
                                        <th style="padding: 8px; font-size: 13px;border-top: 1px solid #e9ebec;">
                                            ${paymentVOHistory.planPrice}
                                        </th>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody></table>
            </td>
        </tr>
    </tbody></table>

    <div style="margin-top: 32px; text-align: center;">
        <a href="#" itemprop="url" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: .8125rem; color: #FFF; text-decoration: none; font-weight: 400; text-align: center; cursor: pointer; display: inline-block; border-radius: .25rem; text-transform: capitalize; background-color: #405189; margin: 0; border-color: #405189; border-style: solid; border-width: 1px; padding: .5rem .9rem;">다운로드</a>
        <a href="javascript:location.href='/plan'" itemprop="url" style="font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: .8125rem; color: #FFF; text-decoration: none; font-weight: 400; text-align: center; cursor: pointer; display: inline-block; border-radius: .25rem; text-transform: capitalize; background-color: #0ab39c; margin: 0; border-color: #0ab39c; border-style: solid; border-width: 1px; padding: .5rem .9rem;">플랜 변경</a>
    </div>
</div>
</c:if>