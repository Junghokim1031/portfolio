<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

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
                            List
                            <select id="amountSize" name="amountSize" style="display:inline-block;">
                            	<option value="">--</option>
                            	<option value="5">5</option>
                            	<option value="10">10</option>
                            	<option value="15">15</option>
                            	<option value="20">20</option>                            	
                            </select>
                            <!-- Combo box here send data to actionform amount and submit it -->
                            <!-- Don't forget to add a javascript for it. just change pagenum to amount and stuff -->
                            <button id='regBtn' type="button" class="btn btn-primary btn-xs pull-right">New</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table width="100%" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
										<th>#번호</th>
										<th>제목</th>
										<th>작성자</th>
										<th>작성일</th>
										<th>수정일</th>
									</tr>
                                </thead>
                                
                                	<c:forEach items="${list}" var="board">
										<tr>
											<td><c:out value="${board.bno}" /></td>
											<%-- <td>
												<a href='/board/get?bno=<c:out value="${board.bno}"/>'><c:out value="${board.title}"/></a>
											</td> --%>
				
											<td>
												<a class='move' href='<c:out value="${board.bno}"/>'>
													<c:out value="${board.title}" />
													<c:if test="${board.replyCnt > 0}">
														 [<c:out value="${board.replyCnt }"/>]
													</c:if>
												</a>
											</td>
				
											<td><c:out value="${board.writer}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd"
													value="${board.regdate}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd"
													value="${board.updateDate}" /></td>
										</tr>
									</c:forEach>                               
                                
                                </table>
                                <!-- 검색 ------------------------------->  
                                
                                <div class="row">
	                                <div class="col-lg-12">
	                                	<form id ="searchForm" action="/board/list" method="get" >
	                                		<select name="type" style="height: 34px;line-height: 34px;">
	                                			<%-- <option value="" <c:if test="${pageMaker.cri.type == null}">selected</c:if>>--</option> --%>
												<option value="T" <c:if test="${pageMaker.cri.type == 'T'}">selected</c:if>>제목</option>
												<option value="C" <c:if test="${pageMaker.cri.type == 'C'}">selected</c:if>>내용</option>
												<option value="W" <c:if test="${pageMaker.cri.type == 'W'}">selected</c:if>>작성자</option>
												<option value="TC" <c:if test="${pageMaker.cri.type == 'TC'}">selected</c:if>>제목 & 내용</option>
												<option value="TW" <c:if test="${pageMaker.cri.type == 'TW'}">selected</c:if>>제목 & 작성자</option>
												<option value="TWC" <c:if test="${pageMaker.cri.type == 'TWC'}">selected</c:if>>제목, 내용, & 작성자</option>
	                                		</select>
                                			<input type="text" name="keyword"  style="height: 34px;line-height: 34px;" value='<c:out value="${pageMaker.cri.keyword}"/>'/>
                                			<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"/>'/>
											<input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}"/>'/>
											<button class='btn btn-default'>Search</button>
	                                	</form>
	                                </div>
                                </div>
                                <!-- page 번호 출력 ------------------------------->
                                <div class='pull-right'>
									<ul class="pagination">				
										<c:if test="${pageMaker.prev}">
											<li class="paginate_button previous"><a
												href="${pageMaker.startPage -1}">Previous</a></li>
										</c:if>
				
										<c:forEach var="num" begin="${pageMaker.startPage}"
											end="${pageMaker.endPage}">
											<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "active":""} ">
												<a href="${num}">${num}</a>
											</li>
										</c:forEach>
				
										<c:if test="${pageMaker.next}">
											<li class="paginate_button next"><a
												href="${pageMaker.endPage +1 }">Next</a></li>
										</c:if>					
									</ul>
								</div>
								<!-- page 번호 출력.end -->


								<!-- page번호를 클릭 했을 때 필요한 parameter 전달 -->
								<form id="actionForm" action="/board/list" method="get">
									<input type='hidden' name='type' value='<c:out value="${pageMaker.cri.type}"/>'>
									<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'/>
									<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
									<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
								</form>   
								
                            <!-- Modal ------------------------------------------------------------------------------------->
							<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
								aria-labelledby="myModalLabel" aria-hidden="true">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal"
												aria-hidden="true">&times;</button>
											<h4 class="modal-title" id="myModalLabel">notice</h4>
										</div>
										<div class="modal-body">처리가 완료되었습니다.</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default"
												data-dismiss="modal">Close</button>											
										</div>
									</div>
									<!-- /.modal-content -->
								</div>
								<!-- /.modal-dialog -->
							</div>
							<!-- /.modal -->
                            
                            
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
            
        <script>
       	$(document).ready(function(){
       		//등록후 글번호 출력
       		var result = '<c:out value="${result}"/>';

			checkModal(result);
			function checkModal(result) {
				if(result===''){
					return;
				}
				if (parseInt(result) > 0) {
					$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
				}

				$("#myModal").modal("show");
			}
       		
       		//등록화면으로 이동
   			$("#regBtn").on("click", function() {
				self.location = "/board/register";
			});
   			
       		//페이지번호 클릭시 목록으로 이동
       		var actionForm=$("#searchForm");
       		$(".paginate_button a").on("click",function(e){
       			e.preventDefault(); // 다른페이지로 넘어가는 것 일단 방지.
       			actionForm.find("input[name='pageNum']").val($(this).attr("href")); // hidden tag pageNum에 클릭한 페이지번호 저장
       			actionForm.submit(); //전송
       		});
       		
       		$("#amountSize").on("change",function(e){
       			e.preventDefault(); // 다른페이지로 넘어가는 것 일단 방지.
       			actionForm.find("input[name='amount']").val($(this).val()); // hidden tag pageNum에 클릭한 페이지번호 저장
       			actionForm.submit(); //전송
       		});
       		
       		//제목 클릭 시 상세보기로 이동. 필요한 parameter 모두 전달.
       		$(".move").on("click",function(e){
       			e.preventDefault();
       			actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
       			actionForm.attr("action","/board/get");
       			actionForm.submit();
       		});
       		
       		$("#searchForm button").on("click", function(e){
       			e.preventDefault();
       			if(!actionForm.find("input[name='keyword']").val()){
       				alert("Insert Keyword");
       				actionForm.find("input[name='keyword']").focus();
       				return false;
       			}
       			actionForm.find("input[name='pageNum']").val("1");
       			actionForm.submit();
       		});
       	}); //END of $(document).ready
        </script>    
        
        <%@include file="../includes/footer.jsp"%>
        
    