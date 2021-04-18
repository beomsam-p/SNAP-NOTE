<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	
	//마이페이지 이동
	$("#btnMenuMyPage").on("click",function(){
		location.herf="/mypage/mypage"
	});
	
	//문장등록 페이지 이동
	$("#btnMenuRegSentence").on("click",function(){
		
	});
	
	
});
</script>
<div class="row bot-nav">
	<div class="col-xs-4 height100">
 		<div class="menuBtn">
			<span  id="btnMenuList" class="glyphicon glyphicon-th-list gi-1_5x mr10"></span>
		</div>
	</div>
	<div class="col-xs-4 height100">
	 	<div class="menuBtn">
			<span id="btnMenuMyPage" class="glyphicon glyphicon-user gi-1_5x mr10"></span>
		</div>
	</div>
	<div class="col-xs-4 height100">
	 	<div class="menuBtn">
			<span id="btnMenuRegSentence" class="glyphicon glyphicon-pencil gi-1_5x mr10"></span>
		</div>
	</div>
</div>

