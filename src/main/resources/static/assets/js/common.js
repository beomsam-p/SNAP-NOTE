common = function(){};

common.showModal = function(title, content){
	$("#modalTitle").html(title);
	$("#modalContent").html(content);
	$("#modal").modal();
}

common.loding = function(on){
	if(on){
		$(".loding").show();
	}else{
		$(".loding").hide();
	}
}

common.setCookie = function(name, value, exp) {
  var date = new Date();
  date.setTime(date.getTime() + exp*24*60*60*1000);
  document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
}

common.getCookie= function(name) {
  var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
  return value? value[2] : null;
}

common.deleteCookie= function(name) {
  document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}
