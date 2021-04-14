<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	$.backstretch([
		"/static/assets/img/backgrounds/2.jpg"
		, "/static/assets/img/backgrounds/3.jpg"
		, "/static/assets/img/backgrounds/1.jpg"
	], {duration: 5000, fade: 750});

	var t;
	var total=180;
	var _timer = $("#timer");
	var interval;
	timer = function (){
		interval = setInterval(function(){ 
				t = Math.floor( total / 60 );
				s = total - ( t * 60 );
				total = total - 1;
				var strTime = "";
				if(s<10){
					strTime = "0"+t+":0"+s;
				}else{
					strTime = "0"+t+":"+s;
				}
				_timer.text(strTime);
				if(total==0){
					location.reload();
				}
			}, 1000);
	}
	
	var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	
	$("#btnEmainSend").on("click",function(){
		var nick = $("#nick");
		
		var email = $("#email");
		
		
		if(email.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","이메일을 입력해주세요.");
			email.focus();
			return
		}
		
		if(!emailRule.test(email.val().trim())){
			common.showModal("SNAP NOTE 회원가입","이메일 형식에 맞게 입력해주세요.");
			email.focus();
			return
		}
		
		$.ajax({
			url : "/email/sendJoinMail",     
			data : {"nick" : nick.val(), "email" : email.val()},    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				common.loding(false);
				
				if(data != null && data.result == "00"){
					common.showModal("SNAP NOTE 회원가입","인증메일이 발송되었습니다.<br> 인증번호를 입력해주세요.")
					$("#btnEmainSend").hide();
					$("#btnCertificationNumber").show();
					$("#certificationNumber").show();
					timer();
				}
			},
			
			error : function(jqXHR,status,error){
			}
		});
	});
	
	
	$("#btnCertificationNumber").on("click",function(){
		var certificationNumber = $("#certificationNumber").val();
		
		$.ajax({
			url : "/email/chkCertificationNumber",     
			data : {"certificationNumber" : certificationNumber},    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				common.loding(false);
				if(data != null && data.result == "00"){
					common.showModal("SNAP NOTE 회원가입","이메일 인증에 성공하였습니다.")
					$("#btnCertificationNumber").hide();
					$("#certificationNumber").attr("readonly",true);
					$("#email").attr("readonly",true);
					clearInterval(interval)
					_timer.hide();
				}else{
					common.showModal("SNAP NOTE 회원가입","인증번호가 틀렸습니다.<br> 다시 입력해주세요.")
				}
			},
			error : function(jqXHR,status,error){
			}
		});
	});
	
	
	$("#btnDuplication").on("click",function(){
		var email = $("#email");
		
		if(email.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","이메일을 입력해주세요.");
			email.focus();
			return
		}
		
		if(!emailRule.test(email.val().trim())){
			common.showModal("SNAP NOTE 회원가입","이메일 형식에 맞게 입력해주세요.");
			email.focus();
			return
		}
		
		
		$.ajax({
			url : "/member/chkDuplicate",     
			data : {  "email" : email.val()},    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				common.loding(false);
				
				if(data != null && data.result == 0){
					common.showModal('SNAP NOTE 회원가입','중복확인이 완료되었습니다.<br> 이메일 인증을 진행해주세요');
					$("#btnDuplication").hide();
					$("#btnEmainSend").show();
				}
				else{
					common.showModal('SNAP NOTE 회원가입','이미 가입한 이메일 입니다.<br> 이메일을 확인해주세요.');
				}
			},
			error : function(jqXHR,status,error){
			    // 실패 콜백 함수 
			}
		});
	});
	
	$("#btnJoin").on("click",function(){
		var email = $("#email");
		var pwd =  $("#pwd");
		var pwdConfirm =  $("#pwdConfirm");
		var nick = $("#nick");
		
		if(pwd.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","비밀번호를 입력해주세요.");
			pwd.focus();
			return
		}
		
		if(pwdConfirm.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","비밀번호 확인을 입력해주세요.");
			pwdConfirm.focus();
			return
		}
		
		if(nick.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","닉네임을 입력해주세요.");
			nick.focus();
			return
		}
		
		$.ajax({
			url : "/member/joinProc",     
			data : {  "email" : email.val()
					, "nick" : nick.val()
					, "pwd" : pwd.val() },    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				common.loding(false);
				
				if(data != null && data.result == "00"){
					common.showModal('SNAP NOTE 회원가입','회원가입이 완료되었습니다.<br> 지금바로 SNAP NOTE를 통해 영어문장을 학습해보세요!<a href="/" class="btn btn-join btn-lg btn-block mt10">로그인하러 가기</a>');
					$(".modal-footer").hide();
				}
				else{
					location.href = "/";
				}
			},
			error : function(jqXHR,status,error){
			    // 실패 콜백 함수 
			}
		});
	});
});
</script>

<div class="wap"> 	
	<div class="login-form" style="width: 380px;">
		<div class="avatar">
				<img alt="HTML" src="/static/assets/ico/join.png">
		</div>
	    <form action="/member/loginProc" method="post">
	        <h2 class="text-center">회원가입</h2>   
	        <div  class="form-group">
				<label for="email">아이디(이메일)</label>
				<br>
	        	<input type="email" id="email" class="form-control" name="email" placeholder="아이디를 입력하세요." >
	        	
	        	<input type="text" id="certificationNumber" class="form-control" name="certificationNumber" style="display: none;" placeholder="인증번호를 입력하세요." >
	        	<span id="timer"></span>	
	       		<a id='btnDuplication'  href="javascript:void(0);" class="btn btn-join btn-lg btn-block mt10">아이디 중복확인</a>
	       	 	<a id='btnEmainSend'  style="display: none;" href="javascript:void(0);" class="btn btn-join btn-lg btn-block mt10">메일발송</a>
	       	 	<a id='btnCertificationNumber' style="display: none;" href="javascript:void(0);" class="btn btn-join btn-lg btn-block mt10">인증번호 확인</a>
	        </div>
	        
			<div class="form-group mt10">
				<label for="pwd">비밀번호</label>
	            <input type="password" id="pwd" class="form-control" name="pwd" placeholder="비밀번호를 입력하세요.">
	        </div>    
	        <div class="form-group">
	       		<label for="pwdConfirm">비밀번호 확인</label>
	            <input type="password" id="pwdConfirm" class="form-control" name="pwdConfirm" placeholder="비밀번호확인을 입력하세요.">
	        </div>    
	        <div class="form-group">
				<label for="nick">닉네임</label>
	            <input type="text" id="nick" class="form-control" name="nick" placeholder="닉네임을 입력하세요">
	        </div>        
	        <div class="form-group">
	           <a id="btnJoin" class="btn btn-login btn-lg btn-block">가입하기</a>
	        </div>
	    </form>
	    <div class="form-group">
			<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
		</div>
		<c:import url="/WEB-INF/views/member/Modal.jsp"></c:import>	
	</div>
</div>


<script src="/static/assets/js/jquery.backstretch.min.js"></script>
