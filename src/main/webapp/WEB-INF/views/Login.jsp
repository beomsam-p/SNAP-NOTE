<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
  $(document).ready(function() {
     
    }) ;
  </script>

<!-- CSS -->
<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
<link rel="stylesheet" href="/static/assets/font-awesome/css/font-awesome.min.css">
<link rel="stylesheet" href="/static/assets/css/form-elements.css">
<link rel="stylesheet" href="/static/assets/css/style.css">

<!-- Favicon and touch icons -->
<link rel="shortcut icon" href="assets/ico/favicon.png">
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="/static/assets/ico/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="/static/assets/ico/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="/static/assets/ico/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="/static/assets/ico/apple-touch-icon-57-precomposed.png">


<!-- Top content -->
<div class="top-content">
	<div class="inner-bg">
		<div class="container">
			<div class="row">
				<div style="background-color: #008080; opacity: 0.8" class="col-sm-6 col-sm-offset-3 text">
					<h1><strong>SnapShot Note</strong></h1>
						<div class="description">
						<p>
							<strong>언제, 어디서든, 간단하게 문서를 스냅하세요! <br> 문장 속에서 단어를 체계적으로 익히세요.<br>기억에 남는 영단어 학습 도우미 SnapShot Note</strong>
						</p>
					</div>
				</div>
			</div>
			<div class="row">
				<div style=" opacity: 0.95"class="col-sm-6 col-sm-offset-3 form-box">
					<div class="form-top">
						<div class="form-top-left">
							<h3>Swipe Note Login</h3>
							<p>계정과 비밀번호를 입력하세요.</p>
						</div>
						<div class="form-top-right">
							<i class="fa fa-lock"></i>
						</div>
					</div>
					<div class="form-bottom">
						<form role="form" action="" method="post" class="login-form">
							<div class="form-group">
								<label class="sr-only" for="form-username">EMAIL</label>
								<input type="text" name="form-username" placeholder="이메일" class="form-username form-control" id="form-username">
							</div>
							<div class="form-group">
								<label class="sr-only" for="form-password">Password</label>
								<input type="password" name="form-password" placeholder="비밀번호" class="form-password form-control" id="form-password">
							</div>
							<button type="submit" class="btn">Sign in!</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<script src="/static/assets/js/jquery.backstretch.min.js"></script>
<script src="/static/assets/js/scripts.js"></script>