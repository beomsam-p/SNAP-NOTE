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

	$("#selectEamil").change(function(){
		$(this).val();
	});
  
}) ;
</script>


<div class="login-form" style="width: 380px;">
    <form action="/member/loginProc" method="post">
		<div class="avatar">
			<img alt="HTML" src="/static/assets/ico/join.png">
		</div>
        <h2 class="text-center">회원가입</h2>   
        <div  class="form-inline " role="group">
			<label for="email">아이디(이메일)</label>
			<br>
        	<input type="email" id="email" class="form-control" name="email" placeholder="아이디를 입력하세요." required="required">
        	@
        	<select name="emailEnd" class="form-control" id="selectEamil">
        		<option id="init" value="">선택하기</option>
        		<option id="naver" value="@naver.com">naver.com</option>
        		<option id="gmail" value="@gmail.com">gmail.com</option>
        		<option id="nate" value="@nate.com" >nate.com</option>
        		<option id="hanmail" value="@hanmail.net">hanmail.net</option>
        		<option id="self" value="직접입력">직접입력</option>
        	</select>
        </div>
        
		<div class="form-group mt10">
			<label for="pwd">비밀번호</label>
            <input type="password" id="pwd" class="form-control" name="pwd" placeholder="비밀번호를 입력하세요." required="required">
        </div>    
        <div class="form-group">
       		<label for="pwdConfirm">비밀번호 확인</label>
            <input type="password" id="pwdConfirm" class="form-control" name="pwdConfirm" placeholder="비밀번호확인을 입력하세요." required="required">
        </div>    
        <div class="form-group">
			<label for="nick">닉네임</label>
            <input type="password" id="nick" class="form-control" name="nick" placeholder="닉네임을 입력하세요" required="required">
        </div>        
        <div class="form-group">
           <button type="submit" class="btn btn-login btn-lg btn-block">가입하기</button>
        </div>
    </form>
   
</div>

<script src="/static/assets/js/jquery.backstretch.min.js"></script>
<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>