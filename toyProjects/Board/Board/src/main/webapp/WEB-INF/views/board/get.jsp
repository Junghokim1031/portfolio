<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp"%>

<!-- ====================================================================== -->
<!-- Styles                                                                 -->
<!-- ====================================================================== -->
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
    top:0;
    left:0;
    width:100%;
    height:100%;
    z-index: 1000;
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
  .reply-container {
    max-height: 300px;
    overflow-y: auto;
  }
</style>

<!-- ====================================================================== -->
<!-- Board header                                                           -->
<!-- ====================================================================== -->
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Board</h1>
  </div>
</div>

<!-- ====================================================================== -->
<!-- Main board content                                                     -->
<!-- ====================================================================== -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		<!-- Heading -->
			<div class="panel-heading">Read</div>
				<div class="panel-body">
					<!-- Fields -->
					<div class="form-group">
						<label>BNO</label>
						<input class="form-control" name="bno" value="<c:out value='${board.bno}'/>" readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title" value="<c:out value='${board.title}'/>" readonly="readonly">
					</div>

					<div class="form-group">
						<label>Content</label>
						<textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content}"/></textarea>
					</div>

					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" value="<c:out value='${board.writer}'/>" readonly="readonly">
					</div>

					<!-- Attachments -->
					<div class="panel panel-default">
						<div class="panel-heading">File Attachments</div>
						<div class="panel-body">
							<div class="uploadResult">
								<ul>
								</ul>
							</div>
						</div>
					</div>

					<!-- Buttons and hidden criteria -->
					<sec:authentication property="principal" var="loginUser"/>
					<sec:authorize access="isAuthenticated()">
						<c:if test="${loginUser.username eq board.writer}">
							<button id="modify" data-oper="modify" class="btn btn-default">수정</button>
							<button id="remove" data-oper="delete" class="btn btn-danger">제거</button>
						</c:if>
					</sec:authorize>
					<button id="list"   data-oper="list"   class="btn btn-info">게시판</button>

					<!-- 수정 시 필요한 자료 모음 -->
					<form id="operForm" action="/board/modify" method="get">
						<input type="hidden" name="bno"     value="<c:out value='${board.bno}'/>">
						<input type="hidden" name="type"    value="<c:out value='${cri.type}'/>">
						<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>">
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount"  value="${cri.amount}">
					</form>
			</div><!-- /.panel-body -->
		</div><!-- /.panel-heading -->
	</div><!-- /.col-lg-12 -->
</div><!-- /.row -->


<!-- ====================================================================== -->
<!-- Reply modal                                                            -->
<!-- ====================================================================== -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name="reply">
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<sec:authorize access="isAuthenticated()">
						<input class="form-control" name='replyer' value='<sec:authentication property="principal.username"/>' readonly="readonly">
					</sec:authorize>
					<sec:authorize access="isAnonymous()">
						<input class="form-control" name='replyer' value='' readonly="readonly">
					</sec:authorize>
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name="replyDate">
				</div>
			</div>
			<div class="modal-footer">
		        <button id="modalModBtn"    type="button" class="btn btn-warning">Modify</button>
		        <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
		        <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
		        <button id="modalCloseBtn"  type="button" class="btn btn-default">Close</button>
			</div>
		</div>
	</div>
</div>

<!-- ====================================================================== -->
<!-- Image pop-up                                                           -->
<!-- ====================================================================== -->
<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

<!-- ====================================================================== -->
<!-- Reply area                                                             -->
<!-- ====================================================================== -->
<div class="row">
	<div class="col-lg=12">
		<div class="panel panel-default">
			<div class="panel-heading">
			<i class="fa fa-comments fa-fw"></i> Reply
			<sec:authorize access="isAuthenticated()">
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
			</sec:authorize>
			</div>
			<div class="panel-body">
				<div class="reply-container">
					<ul class="chat"></ul>
				</div>
			</div>
			<div class="panel-footer">
				<span id="replyLoading" style="display:none;">Loading more replies...</span>
			</div>
		</div>
	</div>
</div>

<!-- ====================================================================== -->
<!-- Scripts                                                                -->
<!-- ====================================================================== -->
<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
$(document).ready(function(){
	
	/* -------------------- csrf Token related Codes --------------------*/
	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
	
	/* -------------------- common vars -------------------- */
	var bnoValue   = '<c:out value="${board.bno}"/>';
	var operForm   = $("#operForm");
	var pageNum    = 1;
	var replyPageFooter = $(".panel-footer");
	var loadingReplies = false;
	var lastPageReached = false;
	
	/* -------------------- reply modal vars -------------------- */
	var modal              = $(".modal");
	var modalInputReply    = modal.find("input[name='reply']");
	var modalInputReplyer  = modal.find("input[name='replyer']");
	var modalInputReplyDate= modal.find("input[name='replyDate']");
	var modalModBtn        = $("#modalModBtn");
	var modalRemoveBtn     = $("#modalRemoveBtn");
	var modalRegisterBtn   = $("#modalRegisterBtn");
	var replyUL            = $(".chat");
	
	/* -------------------- loginUser -------------------- */
	<sec:authorize access="isAuthenticated()">
		var loginUser = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	<sec:authorize access="isAnonymous()">
		var loginUser = '';
	</sec:authorize>

	
	/* -------------------- init -------------------- */
	showList(pageNum);
	
	/* -------------------- form buttons -------------------- */
	$("button[data-oper='modify']").on("click", function(){
	  operForm.attr("action", "/board/modify").submit();
	});
	
	$("button[data-oper='list']").on("click", function(){
	  operForm.find("#bno").remove();
	  operForm.attr("action", "/board/list");
	  operForm.submit();
	});

	$("#remove").on("click", function(e){
	  e.preventDefault();
	  var postData = {
	    bno: "${board.bno}",
	    pageNum: "${cri.pageNum}",
	    amount: "${cri.amount}",
	    type: "${cri.type}",
	    keyword: "${cri.keyword}"
	  };
	  $.post("/board/remove", postData, function(){
	    var redirectUrl = "/board/list?pageNum=" + encodeURIComponent(postData.pageNum)
	                    + "&amount=" + encodeURIComponent(postData.amount)
	                    + "&type="   + encodeURIComponent(postData.type)
	                    + "&keyword="+ encodeURIComponent(postData.keyword);
	    window.location.href = redirectUrl;
	  });
	});

  /* -------------------- show reply list -------------------- */
  function showList(page){
    console.log("show list " + page);
    pageNum = page || 1;

    replyService.getList({bno:bnoValue, page: pageNum}, function(replyCnt, list){
      if (!list || list.length === 0) {
        lastPageReached = true;
        replyUL.html("");
        return;
      }

      var str = "";
      for (var i = 0, len = list.length || 0; i < len; i++) {
        str += "<li style='cursor:pointer' class='left clearfix' data-rno='" + list[i].rno +"'>"
             + "  <div>"
             + "    <div class='header'>"
             + "      <strong class='primary-font'>[" + list[i].rno +"] " + list[i].replyer + "</strong>"
             + "      <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>"
             + "    </div>"
             + "    <p>" + list[i].reply + "</p>"
             + "  </div>"
             + "</li>";
      }
      replyUL.html(str);
      replyPageFooter.html("");
    });
  }// END of showList 

  /* -------------------- OPEN REPLY MODAL -------------------- */
  $("#addReplyBtn").on("click", function(){
    modal.find("input[name='reply']").val("");
    modal.find("input[name='replyer']").val(loginUser);
    modalInputReplyDate.closest("div").hide();
    modal.find("button[id !='modalCloseBtn']").hide();
    modalRegisterBtn.show();
    modal.modal("show");
  });

  /* ------------- Register a new reply ------------- */
  modalRegisterBtn.on("click", function(){
    var reply = {
      reply:   modalInputReply.val(),
      replyer: modalInputReplyer.val(),
      bno:     bnoValue
    };
    $.ajax({
      type: 'post',
      url: '/replies/new',
      data: JSON.stringify(reply),
      contentType: "application/json; charset=utf-8",
      success: function(result){
        alert(result);
        modal.find("input").val("");
        modal.modal("hide");
        showList(1);
      }
    });
  });

  $("#modalCloseBtn").on("click", function(){ modal.modal('hide'); });

  /* -------------------- reply click (edit/remove) -------------------- */
  replyUL.on("click","li", function(){
    var rno = $(this).data("rno");
    replyService.get(rno, function(reply){
      modalInputReply.val(reply.reply);
      modalInputReplyer.val(reply.replyer);
      modalInputReplyDate
        .val(replyService.displayTime(reply.replyDate))
        .attr("readonly","readonly");
      modal.data("rno", reply.rno);

      modal.find("button[id !='modalCloseBtn']").hide();
      modalModBtn.show();
      modalRemoveBtn.show();
      if(loginUser != reply.replyer){
    	  modalModBtn.hide();
    	  modalRemoveBtn.hide();
      }else{
    	  modalModBtn.show();
    	  modalRemoveBtn.show();	  
      }

      modal.modal("show");
    });
  });


  
  modalModBtn.on("click", function(){
    var reply = { 
   		rno: modal.data("rno"), 
   		reply: modalInputReply.val(),
   		replyer: modalInputReplyer.val()
    };
    replyService.update(reply, function(result){
      alert(result);
      modal.modal("hide");
      showList(pageNum);
    });
  });

  modalRemoveBtn.on("click", function(){
    var rno = modal.data("rno");
    replyService.remove(rno, function(result){
      alert(result);
      modal.modal("hide");
      showList(pageNum);
    });
  });

  /* -------------------- hover highlight -------------------- */
  replyUL.on("mouseover","li", function(){ $(this).css("background-color","lightgray"); });
  replyUL.on("mouseleave","li", function(){ $(this).css("background-color",""); });

  /* -------------------- attachments -------------------- */
  $.getJSON("/board/getAttachList", {bno:bnoValue}, function(arr){
    var str = "";
    $(arr).each(function(i, attach){
      if(attach.fileType){
        var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
        str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid
             + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>"
             +   "<div><img src='/display?fileName=" + fileCallPath + "'></div>"
             + "</li>";
      } else{
        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid
             + "' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >"
             +   "<div><span>"+ attach.fileName+"</span><br/>"
             +   "<img src='/resources/img/attach.png'></div>"
             + "</li>";
      }
    });
    $(".uploadResult ul").html(str);
  });

  $(".uploadResult").on("click","li", function(){
    var liObj = $(this);
    var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
    if(liObj.data("type")){
      showImage(path.replace(new RegExp(/\\/g),"/"));
    }else {
      self.location ="/download?fileName="+path;
    }
  });

  $(".bigPictureWrapper").on("click", function(){
    $(".bigPicture").animate({width:'0%', height: '0%'}, 1000, function(){
      $(".bigPictureWrapper").hide().css({width:'100%', height:'100%'});
    });
  });

  /* -------------------- infinite scroll for replies -------------------- */
  $(".reply-container").on("scroll", function() {
    if (loadingReplies || lastPageReached) {
      return;
    }
    var container = $(this);
    var scrollTop  = container.scrollTop();
    var containerH = container.height();
    var contentH   = container[0].scrollHeight;

    if (scrollTop + containerH >= contentH - 50) {
      loadingReplies = true;
      $("#replyLoading").show();

      var nextPage = parseInt(pageNum, 10) + 1;
      replyService.getList({bno:bnoValue, page: nextPage}, function(replyCnt, list) {
        if (!list || list.length === 0) {
          lastPageReached = true;
          $("#replyLoading").hide();
          return;
        }
        var str = "";
        for (var i = 0, len = list.length || 0; i < len; i++) {
          str += "<li style='cursor:pointer' class='left clearfix' data-rno='" + list[i].rno +"'>"
               + "  <div>"
               + "    <div class='header'>"
               + "      <strong class='primary-font'>[" + list[i].rno +"] " + list[i].replyer + "</strong>"
               + "      <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>"
               + "    </div>"
               + "    <p>" + list[i].reply + "</p>"
               + "  </div>"
               + "</li>";
        }
        replyUL.append(str);
        pageNum = nextPage;
        loadingReplies = false;
        $("#replyLoading").hide();
      });
    }
  });

  
	/* AJAX SEND */
	$(document).ajaxSend(function(e, xhr, options) { 
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
	}); 
}); // document.ready end

/* ===================================================================== */
/* helper functions                                                      */
/* ===================================================================== */
function showImage(fileCallPath){
  $(".bigPictureWrapper").css("display","flex").show();
  $(".bigPicture")
    .html("<img src='/display?fileName="+fileCallPath+"' >")
    .animate({width:'100%', height: '100%'}, 1000);
}
</script>

<%@include file="../includes/footer.jsp"%>
