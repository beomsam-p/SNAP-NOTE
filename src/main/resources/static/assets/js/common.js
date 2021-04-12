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
