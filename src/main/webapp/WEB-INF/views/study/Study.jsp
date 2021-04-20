<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	//메뉴리스트
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
						$("#divCateBox").html(data);
					}
					
				},
				
				error : function(jqXHR,status,error){
					common.loding(false);
					common.showModal('SNAP NOTE','에러발생 :<br>'+error);
				}
			});
	
	//메뉴닫기
	$("#btnBack").on("click",function(){
		location.href="/";
	});
});
</script>



<div id="menuList" class="menuList">
	<div class="btn-close">
		<span id="btnBack" class="glyphicon glyphicon-chevron-left btn-back"></span>
		<span class="top-txt">
			노트 정리함
		</span>
	</div>
	
	<div class="menu-box">
		<div class="profile-box">
			<div class="profile-img">
			</div>
		</div>
		
		<div class="nick-box">
			<div class="nick-txt">${nick}</div>
		</div>
		<hr class="hr2px">
		<div id="divCateBox" class="cate-box" >
		</div>
			
	</div>
</div>

