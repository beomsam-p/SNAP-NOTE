<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	
	//아이디 저장을 했을 경우 쿠키에서 얻어오기
	var saveIdVal = common.getCookie("saveId");
	
	//저장된 아이디 쿠키가 있을 경우에 세팅
	if(saveIdVal!=null){
		$("#saveId").attr("checked",true);
		$("#id").val(saveIdVal);
	}
	
	//배경 화면 세팅
	$.backstretch([
		"/static/assets/img/backgrounds/2.jpg"
		, "/static/assets/img/backgrounds/3.jpg"
		, "/static/assets/img/backgrounds/1.jpg"
	], {duration: 5000, fade: 750});

	//로그인 버튼 클릭
	$('#btnLogin').on('click', function(e) {
		var id = $('#id');
		var pwd = $('#pwd');
		var saveId=$('[name="saveId"]:checked').val();

		if(id.val().trim()==""){
			common.showModal('SNAP NOTE 로그인',"아이디를 입력해주세요.");
			id.focus();
			return;
		}
		
		if(pwd.val().trim()==""){
			common.showModal('SNAP NOTE 로그인',"비밀번호를 입력해주세요.");
			pwd.focus();
			return;
		}
		
		
		$.ajax({
			url : "/member/loginProc",     
			data : {"id" : id.val(), "pwd" : pwd.val(),"saveId":saveId },    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				console.log(data);
				common.loding(false);
				
				if(data != null && data.result == "00"){
					location.href="/study/study"
				}
				else{
					common.showModal('SNAP NOTE 로그인',data.errorMsg);
				}
			},
			error : function(jqXHR,status,error){
				common.showModal('SNAP NOTE 로그인','에러발생 :<br>'+error);
			}
		});
	});
	
	//비밀번호 인풋에서 엔터 눌렀을 경우 이벤트 발생
	$("#pwd").on("keyup",function(e){
		if(e.keyCode == 13){
			$('#btnLogin').click();	
		}
	})
	
	//회원가입 버튼 클릭 시 페이지 이동
	$('#btnJoin').on('click', function(e) {
		location.href="/member/joinForm";
	});
}) ;
</script>
<div class="wrap"> 
	<div class="login-form">
		<div class="avatar">
			<img alt="HTML" src="/static/assets/ico/user.png">
		</div>
		<form>
			<h2 class="text-center">SNAP NOTE LOGIN</h2>   
			<div class="form-group">
				<input type="text" class="form-control" id="id" name="id" placeholder="아이디" >
			</div>
			<div class="form-group">
				<input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호" >
			</div>        
			<div class="form-group">
				<a id="btnLogin" class="btn btn-login btn-lg btn-block">로그인</a>
				<a id="btnJoin" class="btn btn-join btn-lg btn-block">회원가입</a>
			</div>
			<div class="clearfix">
				<label class="pull-left checkbox-inline"><input type="checkbox" id="saveId" name="saveId" value="saveId">아이디 저장</label>
				<a href="javascript:void(0);" class="findPwd pull-right">비밀번호 찾기</a>
			</div>
		</form>
		<c:import url="/WEB-INF/views/member/Modal.jsp"></c:import>	
		<div class="form-group">
			<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
		</div>
	</div>
</div>

<script src="/static/assets/js/jquery.backstretch.min.js"></script>
