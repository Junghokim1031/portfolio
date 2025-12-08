<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp"%>
	<style>
	.uploadResult {
		width: 100%;
		height: 150px;
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
	
	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header">BOARD</h1>
	    </div>
	    <!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="panel panel-default">
	            <div class="panel-heading">
	                REGISTER
	            </div><!-- /.panel-heading -->
                <div class="panel-body">
                    <form role="form" action="/board/register" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> 
                    	<div class="form-group">
							<label>제목</label>
							<input class="form-control" name="title">
						</div>
						
						<div class="form-group">
							<label>내용</label>
							<textarea class="form-control" rows="3" name="content"></textarea>
						</div>
						
						<div class="form-group">
							<label>작가</label>
							<input class="form-control" name='writer' 
								value='<sec:authentication property="principal.username"/>' readonly="readonly">
						</div>
						
						<!-- IMAGE RELATED -->
						<div class="row">
							<div class="col-lg-12">
								<div class="panel panel-default">
									<div class="panel-heading">File Attach</div>
									<!-- /.panel-heading -->
									<div class="panel-body">
										<div class="form-group uploadDiv">
											<input type="file" name='uploadFile' multiple>
								        </div>
										<div class='uploadResult'>
										파일을 여기에 끌어다 놓우세요.
											<ul>
											
											</ul>
										</div>
									</div><!--  end panel-body -->
								</div><!--  end panel-body -->
							</div><!-- end panel -->
						</div><!-- /.row -->
						<button type="submit" class="btn btn-default">등록</button>
						<button type="reset" class="btn btn-default">리셋</button>
					</form>
				</div><!-- /.panel-body -->
			</div>
		</div>
	</div>

	
	
	<script>
	//==================================================
	// DOCUMENT READY
	//==================================================
	$(document).ready(function(){
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		//===========================================
		//Submit button CLICK
		var formObj = $("form[role='form']");
		$("button[type='submit']").on("click", function(e){
			e.preventDefault();
			console.log("Submit clicked");
			var str ="";
			$(".uploadResult ul li").each(function(i,obj){
				var jobj = $(obj);
				console.dir(jobj);
				console.log("------------------");
				console.log(jobj.data("filename"));
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
			}); // END of $(".uploadResult ul li").each
			console.log(str);
		    formObj.append(str).submit();
		}); // END of $("button[type='submit']")
		//===========================================
		
		//===========================================
		// ATTACHMENT UPLOAD
		$("input[type='file']").change(function(e){
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			for(var i=0; i<files.length; i++){
				if(!checkExtension(files[i].name, files[i].size)){ return false; }
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				beforeSend: function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data: formData,
				type: 'POST',
				dataType: 'json',
				success: function(result){
					console.log(result);
					showUploadResult(result);
				}
			});// END of AJAX
		}); // END of $("input[type='file']").change
		//===========================================
			
		//===========================================
		// DELETE ATTACHMENT
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			var targetLi = $(this).closest("li");
			$.ajax({
			  url: '/deleteFile',
			  data: {fileName: targetFile, type:type},
			  beforeSend: function(xhr) {
		          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		      },
			  dataType:'text',
			  type: 'POST',
			    success: function(result){
			       alert(result);
			       targetLi.remove();
			     }
			}); //$.ajax
		}); //$(".uploadResult")
		//===========================================
			
			
		/* 파일드래그시 새창으로 열리는 것 방지 *****************************/
		$(".uploadResult").on("dragenter dragover",function(e){
			e.preventDefault();
		});
		/* 파일을 드롭할 때 새탭으로 열리는 것을 방지하고 파일업로드 *******************/
		$(".uploadResult").on("drop",function(e){
			e.preventDefault();
			
			var formData = new FormData();	//폼태그 역할을 하는 객체	
			//drop했을 때 파일목록 구하기
			var files=e.originalEvent.dataTransfer.files;	
		    
		    for(var i = 0; i < files.length; i++){
		      if(!checkExtension(files[i].name, files[i].size) ){ //확장자.파일사이즈 체크
		        return false;
		      }
		      formData.append("uploadFile", files[i]);					      
		    }
		    
		    $.ajax({
				url: '/uploadAjaxAction',
				processData: false, // 파일업로드시 필요
				contentType: false, // 파일업로드시 필요
				beforeSend: function(xhr) { // csrf적용
				     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data:formData,
				type: 'POST',
				dataType:'json',
				success: function(result){
					console.log(result); 
					showUploadResult(result); //업로드 결과 처리 함수
				}
			}); //$.ajax
		});
	}); // END of (document).ready
		
		
	//==================================================
	// HELPER FUNCTION
	//==================================================
	/* Checking for File Extensions */
	function checkExtension(fileName, fileSize){
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5MB
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}// END of checkExtension
	
	function showUploadResult(uploadResultArr){
		if(!uploadResultArr || uploadResultArr.length == 0) { return 0; }
		
		var uploadUL = $(".uploadResult ul");
		var str = "";
		
		$(uploadResultArr).each(function(i,obj){
			if(obj.image){
				var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
				str += "<li data-path='"+obj.uploadPath+"'";
				str +=" data-uuid='"+ obj.uuid + "' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
				str +=" ><div>";
				str += "<span> "+ obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' "
				str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str +="</li>";
			}else{
				var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
			    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
			      
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
				str += "<span> "+ obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
				str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'>";
				str += "</div>";
				str +="</li>";
			}
		});
		uploadUL.append(str);
	}
	

	</script>
<%@include file="../includes/footer.jsp"%>
        