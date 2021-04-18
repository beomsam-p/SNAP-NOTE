<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
//유효성 자원
var emailRule=/([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
var pwdRule = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
var nickRule = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

//체크 자원
var chkDupId = false;
var chkEmailAuth = false;


//특수문자 제거 함수
function removeSpecialChar(nick){
	
	if(nickRule.test(nick.value)){
		nick.value = nick.value.replace(nickRule,"");
	}
}

$(function(){
	
	//타이머 자원
	var t;
	var total=180;
	var _timer = $("#timer");
	var interval;
	
	
	
	//백그라운드 이미지 변경
	$.backstretch([
		"/static/assets/img/backgrounds/2.jpg"
		, "/static/assets/img/backgrounds/3.jpg"
		, "/static/assets/img/backgrounds/1.jpg"
	], {duration: 5000, fade: 750});
	
	
	//타이머함수
	function timer (){
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
	
	
	//메일 보내기 버튼 클릭
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
				common.loding(false);
				common.showModal('SNAP NOTE 회원가입','에러발생 :<br>'+error);
			}
		});
	});
	
	//인증번호확인버튼 클릭
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
					clearInterval(interval)
					_timer.hide();
					chkEmailAuth=true;
				}else{
					common.showModal("SNAP NOTE 회원가입","인증번호가 틀렸습니다.<br> 다시 입력해주세요.")
				}
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.showModal('SNAP NOTE 회원가입','에러발생 :<br>'+error);
			}
		});
	});
	
	//아이디 중복 확인 버튼 클릭
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
					$("#email").attr("readonly",true);
					chkDupId = true;
				}
				else{
					common.showModal('SNAP NOTE 회원가입','이미 가입한 이메일 입니다.<br> 이메일을 확인해주세요.');
				}
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.showModal('SNAP NOTE 회원가입','에러발생 :<br>'+error);
			}
		});
	});
	
	// 가입하기 버튼 클릭
	$("#btnJoin").on("click",function(){
		if(!chkDupId){
			common.showModal("SNAP NOTE 회원가입","아이디 중복확인을 해주세요.");
			return;
		}
		
		if(!chkEmailAuth){
			common.showModal("SNAP NOTE 회원가입","이메일 인증을 해주세요.");
			return;
		}
		 
		var email = $("#email");
		var pwd =  $("#pwd");
		var pwdConfirm =  $("#pwdConfirm");
		var nick = $("#nick");
		
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
		
		if(pwd.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","비밀번호를 입력해주세요.");
			pwd.focus();
			return
		}
		
		if(pwd.val().trim().length < 8 ){
			common.showModal("SNAP NOTE 회원가입","비밀번호룰 8자리 이상 입력해 주세요.");
			pwd.focus();
			return
		}
		

		if(!pwdRule.test(pwd.val().trim())){
			common.showModal("SNAP NOTE 회원가입","비밀번호는 8자 이상이어야 하며, 숫자/대문자/소문자/특수문자를 모두 포함해야 합니다.");
			pwd.focus();
			return
		}
		
		
		if(pwdConfirm.val().trim() == ""){
			common.showModal("SNAP NOTE 회원가입","비밀번호 확인을 입력해주세요.");
			pwdConfirm.focus();
			return
		}
		
		if(pwd.val().trim() != pwdConfirm.val().trim()){
			common.showModal("SNAP NOTE 회원가입","비밀번호와 비밀번호확인이 일치하지 않습니다.");
			pwd.focus();
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
				common.loding(false);
				common.showModal('SNAP NOTE 회원가입','에러발생 :<br>'+error);
			}
		});
	});
});
</script>

<div class="wrap"> 	
	<div class="login-form mt50">
		<div class="avatar">
				<img alt="HTML" src="/static/assets/ico/join.png">
		</div>
	    <form action="/member/loginProc" method="post">
	        <h2 class="text-center"><b>회원가입</b></h2>   
	        <div  class="form-group">
				<label for="email">아이디(이메일)</label>
				<br>
	        	<input type="email" id="email" class="form-control" name="email" placeholder="아이디를 입력하세요." maxlength="100" >
	        	
	        	<input type="text" id="certificationNumber" class="form-control" name="certificationNumber" style="display: none;" placeholder="인증번호를 입력하세요." >
	        	<span id="timer"></span>	
	       		<a id='btnDuplication'  href="javascript:void(0);" class="btn btn-join btn-lg btn-block mt10">아이디 중복확인</a>
	       	 	<a id='btnEmainSend'  style="display: none;" href="javascript:void(0);" class="btn btn-join btn-lg btn-block mt10">메일발송</a>
	       	 	<a id='btnCertificationNumber' style="display: none;" href="javascript:void(0);" class="btn btn-join btn-lg btn-block mt10">인증번호 확인</a>
	        </div>
	        
			<div class="form-group mt10">
				<label for="pwd">비밀번호</label>
	            <input type="password" id="pwd" class="form-control" name="pwd" placeholder="비밀번호를 입력하세요." maxlength="20">
	        </div>    
	        <div class="form-group">
	       		<label for="pwdConfirm">비밀번호 확인</label>
	            <input type="password" id="pwdConfirm" class="form-control" name="pwdConfirm" placeholder="비밀번호확인을 입력하세요."  maxlength="20">
	        </div>    
	        <div class="form-group">
				<label for="nick">닉네임</label>
	            <input type="text" id="nick" class="form-control" name="nick" placeholder="닉네임을 입력하세요" maxlength="10" onkeyup="removeSpecialChar(this);">
	        </div>        
	        <div class="form-group">
				<a id="btnJoin" class="btn btn-login btn-lg btn-block">가입하기</a>
            	<a onclick="location.href='/member/loginForm';" class="btn btn-join btn-lg btn-block mt10">취소</a>
	        </div>
	    </form>
	    <div class="form-group">
			<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
		</div>
		<c:import url="/WEB-INF/views/member/Modal.jsp"></c:import>	
	</div>
</div>


<script src="/static/assets/js/jquery.backstretch.min.js"></script>
