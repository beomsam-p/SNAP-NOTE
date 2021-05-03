<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	//뒤로가기
	$("#btnBack").on("click",function(){
		location.href="/";
	});
	
	//todo: 웹버전일 때 버튼 지우기
	if(false){
		$("#btnCameraToText").hide();	
	}
	
	$("#btnFileToText").on("click",function(){
		$("#file").click();
	});
	
	$("#file").on("change",function(){
		common.loding(true);
		
		var form = $('#form')[0];

	    // Create an FormData object 
        var data = new FormData(form);
		
		$.ajax({
            type: "POST",
            enctype: 'multipart/form-data',
            url: "/upload",
            data: data,
            processData: false,
            contentType: false,
            cache: false,
            success: function (data) {
            	var uploadUrl = data.uploadUrl;
            	console.log(uploadUrl);
            	$.ajax({
                    type: "POST",
                    url: "/convImgToTxt",
                    data: {"imageUrl" : uploadUrl},
                    success: function (data) {
                    	common.loding(false);
        				console.log(data);
                    	alert("전환 성공");
                    },
                    error: function (e) {
                    	common.loding(false);
                        alert("전환 실패");
                    }
                });
            	
            },
            error: function (e) {
            	common.loding(false);
				
                alert("업로드에 실패했어요. 관리자에게 문의 부탁드립니다.");
            }
        });
	
	});
	
});
</script>
<form action="/upload" enctype="multipart/form-data" method="post" id="form">
	<input type="file" id="file" name="file" style="display: none;">
</form>
<div id="sentenceList" class="sentenceList">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">문장 등록</span>
		</div>
		
	</div>
	<div class="sentence-wrap">
		<div id="divbtnGroup" class="sentence-btn-wrap">
			<div id="btnFileToText" class="sentence-btn-float">사진으로 문장 등록</div>
			<div id="btnCameraToText"  class="sentence-btn-float">카메라로 문장 등록</div>
		</div>
	
		<div class="sentence-box">
			<input type="text" >
		</div>
	</div>
</div>