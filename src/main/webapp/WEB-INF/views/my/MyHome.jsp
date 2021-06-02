<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	//뒤로가기
	$("#btnBack").on("click",function(){
		history.back();
	});
	
	//logout
	$("#logout").on("click",function(){
		location.href='/member/logout';
	});
	
	//profile modify
	$("#profileModify").on("click",function(){
		$("#popProfileModify").show();
	});
	
	
	$("#btnPrifileModify").on("click",function(e){
		$("#file").click();
	});
	
	$("#file").on("change",function(e){
		var filePath = e.target.value;
		var filePathSplit = filePath.split('\\');
		var filePathLength = filePathSplit.length;
		var fileName = filePathSplit[filePathLength-1];
		var file = e.target.files[0];
				
		common.resizeImg(file, 500, 500, fileName, profileUploader);
	});
	
	function profileUploader(formData){
		return fetch('/profileImgUpload', {
				  method: 'POST',
				  body: formData,
				})
				.then((response) => response.json())
	  			.then((data) => {
	  				profileImgEditer(data.imageUrl)
	  			})
				.catch(error => {
				  console.log(error)
				});
			
			
	}
	
	function profileImgEditer(url){
		return fetch('/my/modifyProfileImg?url='+url)
			.then((response) => response.json())
			.then((data) => {
				if(data.result == '00'){
					$("#profileImg")
					.css({
						'background' : 'url("'+url+'")'
						,'background-repeat' : 'no-repeat'
						,'background-position' : 'center'
						,'background-size' : 'cover'
					});
					common.toast("이미지를 수정했어요");
				}else{
					common.toast("이미지 수정에 실패했어요.");
				}
			})
			.catch(error => {
			  console.log(error)
			});
	}
	
});
</script>
<input type="file" id="file" name="file" style="display: none;"  accept="image/*">
			
<div  class="move-cate-for-create" id="popProfileModify" style="display: none;" >
	<div id="btnPositionSelect" class="sentence-btn-full">프로필 수정</div>
	<div>
		<div class="move-cate-head-wrap">
			<div class="back-head modify-pop-tit-txt">
				<span onclick="$('#popProfileModify').hide();" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
			</div>
			<span class="top-back-txt modify-pop-tit-txt">프로필 수정</span>
		</div>
		<!-- 선택한 폴더 타이틀로 보여주기  -->
		<div class="move-cate-body">
		
			
		</div>
	</div>
</div>


<div class="my-home-list">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">마이 홈</span>
		</div>
	</div>
	<div class="my-home-bg" 
		 style="background-image: url('${userInfo.bgUrl}'); ">
	</div>
	<%--프로필 영역--%>
	<div class="profile-wrap">
		<div class="profile-area">
			<div id="profileImg" class="profile-img" style="background-image: url('${userInfo.profileUrl}');">
				<div class="btn-profile-modify">
					<span id="btnPrifileModify" class="glyphicon glyphicon-cog"></span>
				</div>
			</div>
			
			
		</div>
		<div class="profile-nick">${userInfo.nickname}</div>
		<%--개인정보 수정 영역--%>
		<div class="my-home-logout">
			<span id="profileModify">프로필 수정</span><span id='logout'> 로그아웃</span> 
		</div>
		<%--통계영역--%>
		<div class="my-home-statistics">
			<div>저장 단어 <br>${ myHomeInfo.saveWord}</div>
			<div>외운 단어 <br> ${myHomeInfo.hitWord}</div>
			<div>못 외운 단어 <br> ${myHomeInfo.noHitWord}</div>
			<div>저장 문장	 <br> ${myHomeInfo.saveSentence}</div>
		</div>
		
		
		
	</div>
</div>

<%--
2. 백그라운드 이미지도 변경버튼 달아주기
3. 백그라운드 이미지 클릭스  사진 팝업(카톡참고)
4. 프로필 사진 클릭시 사진팝업(카톡참고)
6. 로그아웃 기능, 프로필 수정팝업
--%>