<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach items="${list}" var="menu">
	<div style="	
			margin-top : 30px;
			margin-left: ${50*menu.lvl}px;
			background: #f3f3f3;
			padding : 5px 15px 5px 15px ;
			border-radius: 10px;
			font-weight: bold;
			color: #262626;"
		data-foler="${menu.forder_yn}">
		<div class="cate-tit">${menu.title}</div>
		<div class="cate-desc">${menu.descript}</div>
	</div>
</c:forEach>
