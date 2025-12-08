<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<style>
	.uploadResult {
	  width:100%;
	  background-color: gray;
	}
	.uploadResult ul{
	  display:flex;
	  flex-flow: row;
	  justify-content: center;
	  align-items: center;
	}
	.uploadResult ul li {
	  list-style: none;
	  padding: 10px;
	  align-content: center;
	  text-align: center;
	}
	.uploadResult ul li img{
	  width: 100px;
	}
	.uploadResult ul li span {
	  color:white;
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
	  background:rgba(255,255,255,0.5);
	}
	.bigPicture {
	  position: relative;
	  display:flex;
	  justify-content: center;
	  align-items: center;
	}
	
	.bigPicture img {
	  width:600px;
	}
</style>

 	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Board</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					MODIFY
				</div>
				
				<!-- /.panel-heading -->
				<div class="panel-body">
					<form role="form" action="/board/modify" method="post">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount" value="${cri.amount}">
						<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
						<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'/>
					
					
						<!-- BNO -->
						<div class="form-group">
							<label>BNO</label> 
							<input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
						</div>
						
						<!-- Title -->
						<div class="form-group">
							<label>Title</label> 
							<input class="form-control" name='title' value='<c:out value="${board.title}"/>' >
						</div>
		
						<!-- Content -->
						<div class="form-group">
							<label>Content</label>
							<textarea class="form-control" rows="3" name='content'><c:out value="${board.content}" /></textarea>
						</div>
						
						<!-- Writer -->
						<div class="form-group">
							<label>Writer</label> 
							<input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
						</div>
		<style>
				.uploadResult {
				  width:100%;
				  background-color: gray;
				}
				.uploadResult ul{
				  display:flex;
				  flex-flow: row;
				  justify-content: center;
				  align-items: center;
				}
				.uploadResult ul li {
				  list-style: none;
				  padding: 10px;
				  align-content: center;
				  text-align: center;
				}
				.uploadResult ul li img{
				  width: 100px;
				}
				.uploadResult ul li span {
				  color:white;
				}

				.bigPictureWrapper {
				  position: fixed;
				  display: none;
				  justify-content: center;
				  align-items: center;
				  top:0 !important;
				  left:0 !important;
				  width:100%;
				  height:100%;
				  z-index: 1000 !important;
				  background:rgba(0,0,0,0.7);
				}
				
				
				.bigPicture {
				  position: relative;
				  display:flex;
				  justify-content: center;
				  align-items: center;
				}
				
				.bigPicture img {
				  width:600px;
				}
			
			</style>
			
					<!-- 첨부파일목록 -->
					<div class="panel panel-default">
						<div class="panel-heading">File Attach</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
							<div class="form-group uploadDiv">
								<input type="file" name='uploadFile' multiple>
					        </div>
							<div class='uploadResult'>
								<ul>
								
								</ul>
							</div>
						</div><!--  end panel-body -->
					</div><!--  end panel-body -->
																
						<button type="submit" data-oper='modify' class="btn btn-default">수정</button>
						<button type="submit" data-oper='remove' class="btn btn-danger">제거</button>
						<button type="submit" data-oper='list' class="btn btn-info">게시판</button>
					</form>
				</div>
				<!-- /.panel-body -->
				
			</div>
			<!-- /.panel -->
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	
<!-- 첨부파일  -------------------------------------------------------------------------------------------->
            
            <!-- 원본이미지를 크게 출력하는 영역 -->
            <div class='bigPictureWrapper'>
			  <div class='bigPicture'>
			  </div>
			</div>
			


	<script>
	$(document).ready(function(){
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		var bno = '<c:out value="${board.bno}"/>';
		
		
		// GET ATTACHMENT LIST
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
			console.log(arr);
			var str = "";
			// For each file in array, insert it into the correct box with append
			$(arr).each(function(i, attach){
				//image type
				if(attach.fileType){
					var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
					str +=" data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
					str += "<span> "+ attach.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str +="</li>";
				}else{
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
					str += "data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
					str += "<span> "+ attach.fileName+"</span><br/>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
					str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str +="</li>";
				}
			});
			$(".uploadResult ul").html(str);
		});
		
		/* MAIN BUTTONS */
		var formObj = $("form");
		$('button').on("click", function(e){
			/* MINI Init */
			e.preventDefault();
			var operation = $(this).data("oper");
			
			// DELETE
			if(operation === 'remove'){
				formObj.attr("action", "/board/remove");
			}else if(operation === 'list'){
				formObj.attr("action","/board/list").attr("method","get");
				let pageNumTag = $("input[name='pageNum']").clone();
				let amountTag = $("input[name='amount']").clone();
				let keywordTag = $("input[name='keyword']").clone();
				let typeTag = $("input[name='type']").clone();
				formObj.empty();
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
				formObj.submit();
			}else if(operation === 'modify'){
					var str = "";
					$(".uploadResult ul li").each(function(i, obj){
						var jobj = $(obj);
						console.dir(jobj);
						str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
					});
			        formObj.append(str).submit();
			}
		});
		
		//ERASE ATTACHMENT from screen
		// If I click on the button (X), ask, then delete
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			if(confirm("Remove this file? ")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});  
		
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
	});  // END OF (document).ready
	
	
	/*==================================================================================================================
	 *==================================================================================================================
	 * HELPER FUNCTIONS
	 *==================================================================================================================
	 *==================================================================================================================*/
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
					str += "<li data-path='"+obj.uploadPath+"'"+ " data-uuid='"+ obj.uuid + "' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'" + " >"
						+		"<div>";
					str += 			"<span> "+ obj.fileName+"</span>";
					str += 			"<button type='button' data-file=\'"+fileCallPath+"\' "+ "data-type='image' class='btn btn-warning btn-circle'>"
						+				"<i class='fa fa-times'></i>"
						+			"</button><br>";
					str += 			"<img src='/display?fileName="+fileCallPath+"'>";
					str += 		"</div>";
					str +=	"</li>";
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