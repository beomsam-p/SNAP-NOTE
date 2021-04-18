<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- 모바일우선 --%>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>SnapShot Note</title>

<%-- 제이쿼리 --%>
<script  src="https://code.jquery.com/jquery-3.6.0.min.js"  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="  crossorigin="anonymous"></script>

<%--부트스트랩자바스크립트 --%>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<%-- 부트스트랩 CSS --%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<%-- 부가적인 테마 --%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<%-- style --%>
<link rel="stylesheet" type="text/css" href="/static/assets/css/style.css">

<%-- 공용스크립트 --%>
<script src="/static/assets/js/common.js?ver=1.0.0"></script>
</head>
<body>
<script type="text/javascript">
$(function(){
	 var exception = new URLSearchParams(location.search).get("exception")
	//비로그인 상태처리
	if(exception=="nologin"){
		common.showModal('SNAP NOTE ERROR',"로그인 후 사용 해주세요");
	}
});
</script>
	
		
<c:if test="${LEFTMENU eq 'hide'}" var="result">
	<%-- 내용 --%>
	<jsp:include page="/WEB-INF/views/${content}"/>
</c:if>

<c:if test="${!result}" var="result"> 
	<div class="container-fluid height100">
		<div class="row height100">
			<div class="col-md-3 height100 ">
				<%-- 좌메뉴
					<jsp:include page="/WEB-INF/views/template/leftMenu"/>
				 --%>
			</div>
			<div class="col-md-9 height100">
				<jsp:include page="/WEB-INF/views/${content}"/>
			</div>
		</div>	
	</div>
</c:if>
		
	




<%-- 모바일용 바텀 네비
<jsp:include page="/WEB-INF/views/template/botNavi"/>
 --%>
 
<%-- 푸터
<jsp:include page="/WEB-INF/views/template/footer"/>
 --%>

<div class="loding"></div>
</body>
</html>