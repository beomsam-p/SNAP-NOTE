<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	var id = $('#id');
	var pwd = $('#pwd');
	var loginForm= $('#loginForm');

	$.backstretch([
		"/static/assets/img/backgrounds/2.jpg"
		, "/static/assets/img/backgrounds/3.jpg"
		, "/static/assets/img/backgrounds/1.jpg"
	], {duration: 5000, fade: 750});


	
	
	$('#btnLogin').on('click', function(e) {
		location.href="/member/join";
	});
  
}) ;
</script>


<div class="login-form">
    <form id="loginForm" action="/member/loginProc" method="post">
		<div class="avatar">
			<img alt="HTML" src="/static/assets/ico/user.png">
		</div>
        <h2 class="text-center">SNAP NOTE LOGIN</h2>   
        <div class="form-group">
        	<input type="text" class="form-control" id="id" name="id" placeholder="아이디" required="required">
        </div>
		<div class="form-group">
            <input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호" required="required">
        </div>        
        <div class="form-group">
            <button type="submit" class="btn btn-login btn-lg btn-block">로그인</button>
            <a href="/member/joinForm" class="btn btn-join btn-lg btn-block">회원가입</a>
        </div>
		<div class="clearfix">
            <label class="pull-left checkbox-inline"><input type="checkbox">아이디 저장</label>
            <a href="javascript:void(0);" class="findPwd pull-right">비밀번호 찾기</a>
        </div>
    </form>
   
</div>

<script src="/static/assets/js/jquery.backstretch.min.js"></script>
<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>