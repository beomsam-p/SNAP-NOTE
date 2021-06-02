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

common.toast = function (text){
	const toast = $('#toast');  
	
	toast.text(text);
	
	var width =  toast.css("width");
	
	toast.css("marginLeft" , -parseInt(width)/2);
	
	
	toast.stop().fadeIn();
  
	setTimeout(function () {
		toast.stop().fadeOut();	
    }, 1700);

} 

common.resizeImg = function(file, MAX_WIDTH, MAX_HEIGHT, fileName, callback){
		//파일리더 생성
		var reader = new FileReader();
		
		reader.readAsDataURL(file);
		
		//파일이 로드될경우
		reader.onload = function(event){
		    
			//이미지 객체 생성
			var img = new Image();
			
			//이미지객체에 로드된 이미지를 세팅
			img.src = event.target.result;
			
			
			//이미지  로드
		    img.onload = function(){
		    	//------------------------------- 파일 크기 변경-----------------------------//
		    	//캔버스를 가져온다
		    	var canvas = document.createElement("canvas")
		    	
		    	//캔버스를 2d로 지정한다.
		    	var ctx = canvas.getContext('2d');
		    	
		    	//로드해온 이미지를 캔버스에 채운다.
		    	canvas.width = img.width;
		    	canvas.height = img.height;
		    	ctx.drawImage(img,0,0);
		    	
				
				//입력한 이미지의 높이 / 너비 얻기
				var width = img.width;
				var height = img.height;
				
				//이미지너비가 이미지 놆이 보다 큰경우
				if(width > height)
				{
					//최대 너비보다 이미지 너비가 넓으면
				    if(width > MAX_WIDTH)
				    {
				    	//최대 너비와 너비의 비율로 높이를 줄인다.
				        height *= MAX_WIDTH / width;
				    	
				    	//너비는 최대 너비로 설정
				        width = MAX_WIDTH;
				    }
				}
				//이미지 높이가 이미지 너비보다 큰경우
				else
				{
					//최대 높이보다 이미지 높이가 크면
				    if (height > MAX_HEIGHT)
				    {
				    	//최대 너비와 이미지 너비의 비율로 너비를 줄인다.
				        width *= MAX_HEIGHT / height;
				    	
				    	//높이는 최대 높이로 한다.
				        height = MAX_HEIGHT;
				    }
				}
				
				//설정한 너비와 높이로 캔버스를 설정한다.
				canvas.width = width;
				canvas.height = height;
				
				
				// canvas에 변경된 크기의 이미지를 다시 그려줍니다.
				ctx = canvas.getContext("2d");
				ctx.drawImage(img, 0, 0, width, height);
				//------------------------------- //파일 크기 변경-----------------------------//
				
				
				//-------------------------------------데이터세팅------------------------------//
				//캔버스를 전송가능 데이터로 변경
				const imgBase64 = canvas.toDataURL('image/jpeg', 'image/octet-stream');
				const decodImg = atob(imgBase64.split(',')[1]);

				//데이터를 array에 담음
				var array = [];
				for (let i = 0; i < decodImg .length; i++) 
				{
					array.push(decodImg .charCodeAt(i));
				}
				
				//blob만들어서 form에 추가			
				const file = new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
		        var data = new FormData();
		        data.append('file', file, fileName);
				
				//데이터를 받아 처리할 콜백함수
				callback(data);
				
		     	//-------------------------------------//데이터세팅------------------------------//
		    }
		}
}


common.hasScrollBar = function (target){
    return ($(target).prop("scrollHeight") == 0 && $(target).prop("clientHeight") == 0)
            || ($(target).prop("scrollHeight") > $(target).prop("clientHeight"));
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


common.isMobile = function() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}
