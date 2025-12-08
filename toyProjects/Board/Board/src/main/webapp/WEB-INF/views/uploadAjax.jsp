<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Upload with Ajax (with Virus!)</title>
	
	<style>
		.uploadResult {
			width: 100%;
			background-color: gray;
		}
		
		.uploadResult ul {
			display: flex;
			flex-flow: row;
			justify-content: center;
			align-items: center;
		}
		
		.uploadResult ul li {
			list-style: none;
			padding: 10px;
		}
		
		.uploadResult ul li img {
			width: 100px;
		}
		
		span:hover{
			cursor: pointer;
		}
	</style>
	
	<style>
		.bigPictureWrapper {
		  position: absolute;
		  display: none;
		  justify-content: center;
		  align-items: center;
		  top:0%;
		  width:100%;
		  height:100%;
		  background-color: gray; 
		  z-index: 100;
		}
		
		.bigPicture {
		  position: relative;
		  display:flex;
		  justify-content: center;
		  align-items: center;
		}
	</style>
	
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script>
	$(document).ready(function(){
		$("#uploadBtn").on("click", function(e){
			var formData = new FormData();						//alternative to formTag
			var inputFile = $("input[name='uploadFile']");		//searching for <input type="file"> tag
			var files = inputFile[0].files;						//receiving the file list
			//console.log(files);
        	
			//add each file to formData
			for(var i=0; i< files.length; i++){
				if(!checkExtension(files[i].name, files[i].size)){ return false; }
				formData.append("uploadFile",files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false, 		//needed for file transfer
				contentType: false, 		//needed for file transfer
				data: formData,
				type: 'POST',
				dataType: 'JSON',
				success: function(result){
					console.log(result);
					showUploadedFile(result);
					var cloneObj = $(".uploadDiv").clone();
					$('.uploadDiv').html(cloneObj.html());
				},
				error: function(xhr, status, err){
					alert("Upload failed: " + status);
					console.log(xhr.responseText);
				}
			}); // End ajax
		}); // End $("#uploadBtn")
		
		
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000, function(){
				$(".bigPicture").hide().empty();
				$(".bigPictureWrapper").hide().css({width:'100%', height:'100%'}); // reset for next time
			});
		});
		
		$(".uploadResult").on("click","span",function(e){
    		var targetFile = $(this).data("file");
    		var type = $(this).data("type");
    		console.log(targetFile);
    		
    		$.ajax({
    			url:'/deleteFile',
    			data: {fileName: targetFile, type: type},
    			dataType: 'text',
    			type: 'POST',
    			success: function(result){
    				alert(result);
    			}
    		});
    	});
		
	}); //end $(document).ready(function(){
	
	
		
	/*=======================================================================================
	 * Helper Functions
	 *=======================================================================================*/
	function checkExtension(fileName, fileSize){
		/* Microsoft가 막는 모든 파일 종류 https://github.com/michalzobec/Security-Blocked-File-Extensions-Attachments   */
    	/* original - exe|sh|zip|alz */
    	var regex = new RegExp("(.*?)\.(com|exe|exe|sh|zip|alz|dll|ocx|ps1|ps1xml|ps2|ps2xml|psc1|psc2|msh|msh1|msh2|mshxml|msh1xml|msh2xml|js|jse|vbs|vb|vbe|cmd|bat|hta|inf|reg|pif|scr|cpl|scf|msc|pol|hlp|chm|ws|wsf|wsc|wsh|jar|rar|z|bz2|cab|gz|tar|ace|msi|msp|mst|msu|ppkg|bak|tmp|ost|pst|pkg|iso|img|vhd|vhdx|application|lock|lck|sln|cs|csproj|resx|config|resources|pdb|manifest|mp3|wma|doc|dot|wbk|xls|xlt|xlm|xla|ppt|pot|pps|ade|adp|mdb|cdb|mda|mdn|mdt|mdf|mde|ldb|wps|xlsb|xlam|xll|xlw|ppam)$");
    	var maxSize = 5*1024*1024; // 5MB
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	function showUploadedFile(uploadResultArr){
	    var uploadResult = $(".uploadResult ul"); // target the <ul>
		var str = "";
		$(uploadResultArr).each(function(i, obj){
			if(!obj.image){
				var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
			    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
			    str += "<li>"
			    	+		"<div>"
			    	+			"<a href='/download?fileName="+fileCallPath+"'>"
			    	+			"<img src='/resources/img/attach.png'><br>"+obj.fileName+"</a>"
			    	+			"<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"
			    	+  		"</div>"
			    	+  "</li>"
			}else{
			  var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
			  var originPath = obj.uploadPath+ "\\"+obj.uuid +"_"+obj.fileName;
			  originPath = originPath.replace(new RegExp(/\\/g),"/");
			  str   += 	"<li>"
			  		+		"<a href=\"javascript:showImage(\'" + originPath + "\')\">"
			        + 			"<img src='display?fileName=" + fileCallPath + "'>"
			  		+		"</a>"
			        + 		"<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span>"
			        + 	"</li>";
			}
		});

		uploadResult.append(str);
	}
	
	function showImage(fileCallPath){
		$(".bigPictureWrapper")
		  .css({display: "flex", width: "100%", height: "100%"})
		  .show();
		
		$(".bigPicture")
	    .css({display: "flex"}) // reset size
	    .html("<img src='/display?fileName=" + encodeURI(fileCallPath) + "'>")
	    .animate({width:'100%', height:'100%'}, 1000); // or skip animate here
	}
	 
	</script>
</head>
<body>
	<h1>Upload with Ajax</h1>
	
	<!-- 원본 이미지 출력 영역 -->
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>

	<!-- 썸내일목록 출력 영역 -->
	<div class='uploadResult'>
		<ul>

		</ul>
	</div>
	<button id='uploadBtn' type='button'>Upload</button>
</body>
</html>