<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	//메뉴리스트
	$("#btnMenuList").on("click",function(){
		$("#menuList").show();
		
		$.ajax({
			url : "/study/searchMenuList",     
			method : "POST",        
			dataType : "html",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				common.loding(false);
				if(data != null ){
					$("#divCateBox").append(data);
				}
				
				if();
			},
			
			error : function(jqXHR,status,error){
				common.loding(false);
				common.showModal('SNAP NOTE','에러발생 :<br>'+error);
			}
		});
	});
	
	//메뉴닫기
	$("#btnClose").on("click",function(){
		$("#menuList").hide();
	});
});
</script>



<div id="menuList" class="menuList">
	<div class="btn-close">
		<span id="btnClose" class="glyphicon glyphicon-remove"></span>
	</div>
	
	<div class="menu-box">
		<div class="profile-box">
			<div class="profile-img">
			</div>
		</div>
		
		<div class="nick-box">
			<div class="nick-txt">${nick}</div>
		</div>
		
		<div id="divCateBox" class="cate-box" >
		</div>
			
	</div>
</div>

