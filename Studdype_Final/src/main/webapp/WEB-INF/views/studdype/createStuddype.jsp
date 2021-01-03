<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ComunityHome</title>

<link rel="stylesheet" href="./resources/assets/css/bootstrap.min.css">
<link rel="stylesheet"
	href="./resources/assets/css/font-awesome.min.css">
<link rel="stylesheet"
	href="./resources/assets/css/owl.carousel.min.css">
<link rel="stylesheet" href="./resources/assets/css/modal-video.min.css">
<link rel="stylesheet" href="./resources/assets/css/animate.css">
<link rel="stylesheet" href="./resources/assets/css/normalize.css">
<link rel="stylesheet" href="./resources/css/style.css">
<link rel="stylesheet" href="./resources/assets/css/responsive.css">
<!-- <link rel="stylesheet" href="./resources/css/studdype/createStuddype.css"> -->
<link rel="stylesheet" href="./resources/css/studdype/header&footer.css">
<script src="./resources/assets/js/jquery.3.2.1.min.js"></script>
<script src="./resources/assets/js/popper.min.js"></script>
<script src="./resources/assets/js/bootstrap.min.js"></script>
<script src="./resources/assets/js/owl.carousel.min.js"></script>
<script src="./resources/assets/js/modal-video.js"></script>
<script src="./resources/assets/js/main.js"></script>

<script type="text/javascript">
	$(function() {
		$("#selectLocationGu option").hide();

		$("#selectLocationSi").change(function() {
			var selectSi = $("#selectLocationSi option:selected").val();

			$("#selectLocationGu option").hide();
			$("." + selectSi).show();

		});
	});
</script>
<style type="text/css">
.main-section {
	display: block;
	position: relative;
	width:60%;
	
	margin:0px auto;
}

#mem_name {
	clear:both;
	float: left;
	width: 45%;
}

#info {
	clear:both;
	float: right;
	width: 45%;
}

#locationsi {
	clear:both;
	float: left;
	width: 45%;
}

#locationgu {
	clear:both;
	float: right;
	width: 45%;
}

#btndiv {
	clear: both;
	text-align: center;
}

#btndiv button {
	right: 10%;
	margin: 3%;
	width: 30%;
	font-size: 20px;
}

#category {
	clear:both;
	float: left;
	width: 45%;
}

#maxcnt {
	clear:both;
	float: right;
	width: 45%;
}
#content {
	clear:both;
}
</style>
</head>
<body>
	<jsp:include page="../commond/studdypeHeader.jsp"></jsp:include>

	<!--main conternt 섹션-->
	<div class="main-section">
		<form method="post" enctype="multipart/form-data" action="">

			<div class="form-group">
				<label for="leader">대표사진 업로드</label> <input type="file"
					name="leader">
			</div>
			
			<div class="form-group" id="mem_name">
				<label>스터디 이름</label><input type="text" class="form-control" name="s_name" value=""placeholder="스터디 이름">
			</div>
			
			<div class="form-group" id="info">
				<label>스터디 한줄 소개</label><input type="text" class="form-control" name="s_info" value="" placeholder="스터디 한줄 소개">
			</div>

			<div id="locationsi">
				<label>스터디 지역(시)</label> <select class="form-control"
					name="selectLocationSi" id="selectLocationSi">
					<option>(시 단위)</option>
					<c:forEach var="locationsi" items="${sidtos}">
						<option value="${locationsi.si_no }">${locationsi.si_name }</option>
					</c:forEach>
				</select>
			</div>

			<div id="locationgu">
				<label>스터디 지역(구/군)</label> <select class="form-control"
					name="selectLocationGu" id="selectLocationGu">
					<option>(구/군 단위)</option>
					<c:forEach var="locationgu" items="${ gudtos}">
						<option class="${locationgu.si_no }" value="${locationgu.gu_no }">${locationgu.gu_name }</option>
					</c:forEach>
				</select>
			</div>

			<div id="category">
				<label>스터디 카테고리</label><select class="form-control" name="category">
					<option>카테고리 분류</option>
					<c:forEach var="category" items="${catedtos }">
						<option value="${category.cate_no }">${category.cate_name }</option>
					</c:forEach>
				</select>
			</div>

			<div class="form-group" id="maxcnt">
				<label for="s_maxcnt">스터디 최대 인원</label> <input type="text"
					class="form-control" name="s_maxcnt" value="">
			</div>
			
			<div id="content">
				<label>스터디 한줄 소개글</label>
				<textarea class="form-control" rows="10" cols="3" name="s_content" placeholder="스터디 상세 소개글"></textarea>
			</div>
						
			<div id="btndiv">
				<button type="submit" class="btn btn-default">스터디 생성</button>
			</div>
		</form>

	</div>

	<jsp:include page="../commond/studdypeFooter.jsp"></jsp:include>
</body>
</html>