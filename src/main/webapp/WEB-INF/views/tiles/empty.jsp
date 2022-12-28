<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<!doctype html>
<html lang="en" data-layout="none" data-sidebar="none" data-sidebar-size="none" data-sidebar-image="none">
 
<head>

    <meta charset="utf-8" />
    <title>GRAMPUS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="Premium Multipurpose Admin & Dashboard Template" name="description" />
    <meta content="Themesbrand" name="author" />
    <!-- App favicon -->
    <link rel="shortcut icon" href="/resources/image/grampusLogo.png">

    <!-- jsvectormap css -->
    <link href="/resources/velzon/dist/assets/libs/jsvectormap/css/jsvectormap.min.css" rel="stylesheet" type="text/css" />

    <!--Swiper slider css-->
    <link href="/resources/velzon/dist/assets/libs/swiper/swiper-bundle.min.css" rel="stylesheet" type="text/css" />

    <!-- Layout config Js -->
    <script src="/resources/velzon/dist/assets/js/layout.js"></script>
    <!-- Bootstrap Css -->
    <link href="/resources/velzon/dist/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <!-- Icons Css -->
    <link href="/resources/velzon/dist/assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <!-- App Css-->
    <link href="/resources/velzon/dist/assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <!-- custom Css-->
    <link href="/resources/velzon/dist/assets/css/custom.min.css" rel="stylesheet" type="text/css" />

	<!-- 나눔스퀘어 폰트  -->
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
	
	<!-- Sweet Alert css-->
	<link href="/resources/velzon/dist/assets/libs/sweetalert2/sweetalert2.min.css" rel="stylesheet" type="text/css" />
	
	<!--Swiper slider css-->
    <link href="/resources/velzon/dist/assets/libs/swiper/swiper-bundle.min.css" rel="stylesheet" type="text/css" />

</head>
<style>
	body{
/*   		font-family: 'NanumSquareLight';   */
		font-family: "NanumSquare";
/* 		font-family: 'NanumSquareBold'; */
/* 		font-family: 'NanumSquareExtraBold'; */
/* 		font-family: 'NanumSquareAcb'; */
/* 		font-family: 'NanumSquareAceb'; */
/* 		font-family: 'NanumSquareAcl'; */
/* 		font-family: 'NanumSquareAcr'; */

		background : none;
	}
</style>
<body>

    <!-- Begin page -->
    <div id="layout-wrapper">
		<!-- =========================== begin::Header ==========================================-->
        <tiles:insertAttribute name="header" />
        <!-- =========================== end::Header ==========================================-->


        <!-- ========== App Menu ========== -->
		<!-- =========================== begin::Aside =========================== -->
		<!-- 다크모드 전환 해주는 div 절대 삭제하면 안됨!!! -->
		 <div class="app-menu navbar-menu" style="display:none;">
 		</div>
        <!-- =========================== end::Aside =========================== -->
		
        <!-- Left Sidebar End -->
        <!-- Vertical Overlay-->
        <div class="vertical-overlay"></div>

        <!-- ============================================================== -->
        <!-- Start right Content here -->
        <!-- ============================================================== -->
        <div class="main-content" style="margin-left:0px;">
<!--             <div class="page-content"> -->
				<!-- =========================== begin::Content =========================== -->
                <tiles:insertAttribute name="body" />
                <!-- =========================== end::Content =========================== -->
<!--             </div> -->
            <!-- End Page-content -->

            <!-- =========================== begin::Footer =========================== -->
            <tiles:insertAttribute name="footer" />
            <!-- =========================== end::Footer =========================== -->
        </div>
        <!-- end main content-->

    </div>
    <!-- END layout-wrapper -->



    <!--start back-to-top-->
    <button onclick="topFunction()" class="btn btn-primary btn-icon" id="back-to-top" style="bottom: 20px;">
        <i class="ri-arrow-up-line"></i>
    </button>

    <!-- JAVASCRIPT -->
    <script src="/resources/velzon/dist/assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/resources/velzon/dist/assets/libs/simplebar/simplebar.min.js"></script>
    <script src="/resources/velzon/dist/assets/libs/node-waves/waves.min.js"></script>
    <script src="/resources/velzon/dist/assets/libs/feather-icons/feather.min.js"></script>
    <script src="/resources/velzon/dist/assets/js/pages/plugins/lord-icon-2.1.0.js"></script>
    <script src="/resources/velzon/dist/assets/js/plugins.js"></script>

    <!-- apexcharts -->
    <script src="/resources/velzon/dist/assets/libs/apexcharts/apexcharts.min.js"></script>

    <!-- Vector map-->
    <script src="/resources/velzon/dist/assets/libs/jsvectormap/js/jsvectormap.min.js"></script>
    <script src="/resources/velzon/dist/assets/libs/jsvectormap/maps/world-merc.js"></script>

    <!--Swiper slider js-->
    <script src="/resources/velzon/dist/assets/libs/swiper/swiper-bundle.min.js"></script>

    <!-- Dashboard init -->
    <script src="/resources/velzon/dist/assets/js/pages/dashboard-ecommerce.init.js"></script>

    <!-- App js -->
    <script src="/resources/velzon/dist/assets/js/app.js"></script>
    
    <!-- Sweet Alerts js -->
	<script src="/resources/velzon/dist/assets/libs/sweetalert2/sweetalert2.min.js"></script>
	<!-- Sweet alert init js-->
	<script src="/resources/velzon/dist/assets/js/pages/sweetalerts.init.js"></script>
	
	<!--Swiper slider js-->
    <script src="/resources/velzon/dist/assets/libs/swiper/swiper-bundle.min.js"></script>

    <!-- swiper.init js -->
    <script src="/resources/velzon/dist/assets/js/pages/swiper.init.js"></script>
	
</body>

</html>