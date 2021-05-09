common = function(){};

/** 모달 보이기
 * param	title	모달 제목
 * param	content	모달 내용
 */
common.showModal = function(title, content){
	//제목 설정
	$("#modalTitle").html(title);
	
	//내용설정
	$("#modalContent").html(content);
	
	//모달 노출
	$("#modal").modal();
}

/** 로딩 dim 제어
 * param	on	true : loding dim 보이기 
 *				false :  loding dim 감추기
 */
common.loding = function(on){
	//on에 따라 dim 보이기 / 감추기
	if(on){
		$(".loding").show();
	}else{
		$(".loding").hide();
	}
}

/** 쿠키 생성
 * param	name	쿠키 이름
 * param	value	쿠키 값
 * param	exp		만료시간
 */
common.setCookie = function(name, value, exp) {
  var date = new Date();
  date.setTime(date.getTime() + exp*24*60*60*1000);
  document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
}

/** 쿠키 값 얻기
 * param	name	쿠키 이름
 */
common.getCookie= function(name) {
  var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
  return value? value[2] : null;
}

/** 쿠키 삭제
 * param	name	쿠키 이름
 */
common.deleteCookie= function(name) {
  document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

