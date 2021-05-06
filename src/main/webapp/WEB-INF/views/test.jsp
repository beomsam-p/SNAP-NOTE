<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 제이쿼리 --%>
<script src="/static/assets/js/jQuery.js"></script>

<script>
$(function(){

	//파일을 가져온다	
	var imageLoader = document.getElementById('file');
	
	//파일  업로드 이벤트 
	imageLoader.addEventListener('change', handleImage, false);
	

	//업로드 이벤트 정의
	function handleImage(e){
		//-------------------------------이미지 이름 얻기-----------------------------//
		var filePath = e.target.value;
		var filePathSplit = filePath.split('\\');
		var filePathLength = filePathSplit.length;
		var fileName = filePathSplit[filePathLength-1];
		//-------------------------------이미지 이름 얻기-----------------------------//
		
		//파일리더 생성
		var reader = new FileReader();
		
		reader.readAsDataURL(e.target.files[0]);
		
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
		    	
		    	//최대 너비 /높이 설정
				var MAX_WIDTH = 2000;
				var MAX_HEIGHT = 3000;
				
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
		     	//-------------------------------------//데이터세팅------------------------------//
		        
		     	
		        
		        //--------------------------------------ajax------------------------------//
		        //ajax로 업로드 컨트롤러에 요청
				$.ajax({
		            type: "POST",
		            enctype: 'multipart/form-data',
		            url: "/convImgToTxt",
		            data: data,
		            processData: false,
		            contentType: false,
		            cache: false,
		            success: function (data) {
		            	var uploadUrl = data.uploadUrl;
		            	
		            	$.ajax({
		                    type: "POST",
		                    url: "/convImgToTxt",
		                    data: {"imageUrl" : uploadUrl},
		                    success: function (data) {
		                    	//common.loding(false);
		        				console.log(data);
		                    	alert("전환 성공");
		                    },
		                    error: function (e) {
		                    	common.loding(false);
		                        alert("전환 실패");
		                    }
		                });
		            	
		            },
		            error: function (e) {
		            	common.loding(false);
						
		                alert("업로드에 실패했어요. 관리자에게 문의 부탁드립니다.");
		            }
		        });
				//--------------------------------------//ajax------------------------------//
				
		    }//이미지로드 end
		    
		    
		}//파일 로드 end
		
	}//업로드 이벤트 정의
	
});

</script>
<p id="p">Select me: <i>italic</i> and <b>bold</b></p>

Cloned: <span id="cloned"></span>
<br>
As text: <span id="astext"></span>

<script>
  document.onselectionchange = function() {
    let selection = document.getSelection();

    cloned.innerHTML = astext.innerHTML = "";

    // Clone DOM nodes from ranges (we support multiselect here)
    for (let i = 0; i < selection.rangeCount; i++) {
      cloned.append(selection.getRangeAt(i).cloneContents());
    }

    // Get as text
    astext.innerHTML += selection;
  };
</script>
<%-- <script type="text/javascript">
    window.onload = function(){
        var canvas = document.getElementById("canvas");
        if(canvas.getContext){
            var draw = canvas.getContext("2d");
            
            var img = new Image();
            img.src = "images/testimage.jpg";
            img.onload = function(){
                //이미지의 원하는 부분만 잘라서 그리기
                //drawImage(이미지객체, 
                //        이미지의 왼위 부분x, 이미지의 왼위 부분y, 이미지의 원하는 가로크기, 이미지의 원하는 세로크기,
                //        사각형 부분x, 사각형 부분y, 가로크기, 세로크기)
                //draw.drawImage(img, 100,100, 300,300, 50,50, 250,300);
                
                //전체 이미지 그리기
                //drawImage(이미지객체, 사각형 왼위 x, 사각형 왼위 y, 가로크기, 세로크기)
                draw.drawImage(img, 50,50, 250,300);
            }
        }
    }
    </script>


 --%>
 
 <label>Image File:</label><br/>
<input type="file" id="file" name="file"/>
<canvas id="imageCanvas" style="display:none;"></canvas>
 
<%--  <canvas id="canvas" width="300px" height="400px"></canvas>

<div style="margin-top:50px">

    <input id="imageFile" type="file">

</div>

<div style="margin-top:50px">

    <input type="button" value="Resize Image" onclick="ResizeImage()"/>

</div>

<div style="margin-top:50px">

    <img src="" id="output">

</div>

 --%>

