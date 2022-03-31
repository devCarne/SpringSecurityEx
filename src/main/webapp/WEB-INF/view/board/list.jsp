<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp"%>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Tables</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                Board List Page
                <button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
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
                            <td>${board.bno}</td><!--target="_blank"-->
                            <td><a class="move" href="<c:out value='${board.bno}'/>">
                                <c:out value="${board.title}"/>
                                <b>
                                    [<c:out value="${board.replyCnt}"/>]
                                </b></a>
                            </td>
                            <td>${board.writer}</td>
                            <td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                    </c:forEach>
                </table>
                <!-- /.table-responsive -->

                <!-- search -->
                <div class="row">
                    <div class="col-lg-12">
                        <form id="searchForm" action="/board/list" method="get">
                            <select name="type">
                                <option value=""
                                    <c:out value="${pageMaker.criteria.type == null?'selected':''}"/>>--</option>
                                <option value="T"
                                    <c:out value="${pageMaker.criteria.type == 'T'?'selected':''}"/>>제목</option>
                                <option value="C"
                                    <c:out value="${pageMaker.criteria.type == 'C'?'selected':''}"/>>내용</option>
                                <option value="W"
                                    <c:out value="${pageMaker.criteria.type == 'W'?'selected':''}"/>>작성자</option>
                                <option value="TC"
                                    <c:out value="${pageMaker.criteria.type == 'TC'?'selected':''}"/>>제목 or 내용</option>
                                <option value="TW"
                                    <c:out value="${pageMaker.criteria.type == 'TW'?'selected':''}"/>>제목 or 작성자</option>
                                <option value="TWC"
                                    <c:out value="${pageMaker.criteria.type == 'TWC'?'selected':''}"/>>제목 or 내용 or 작성자</option>
                            </select>
                            <input type="text" name="keyword" value="<c:out value='${pageMaker.criteria.keyword}'/>">
                            <input type="hidden" name="pageNum" value="${pageMaker.criteria.pageNum}">
                            <input type="hidden" name="amount" value="${pageMaker.criteria.amount}">
                            <button class="btn btn-default">Search</button>
                        </form>
                    </div>
                </div>
                <!-- search end-->

                <!-- paging -->
                <div class="pull-right">
                    <ul class="pagination">
                        <c:if test="${pageMaker.prev}">
                            <li class="paginate_button previous"><a href="${pageMaker.startPage - 1}">Previous</a></li>
                        </c:if>
                        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                            <li class="paginate_button ${pageMaker.criteria.pageNum == num? 'active':''}">
                                <a href="${num}">${num}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${pageMaker.next}">
                            <li class="paginate_button next"><a href="${pageMaker.endPage + 1}">Next</a></li>
                        </c:if>
                    </ul>
                </div>
                <form id="actionForm" action="/board/list" method="get">
                    <input type="hidden" name="pageNum" value="${pageMaker.criteria.pageNum}">
                    <input type="hidden" name="amount" value="${pageMaker.criteria.amount}">
                    <input type="hidden" name="type" value="<c:out value='${pageMaker.criteria.type}'/>">
                    <input type="hidden" name="keyword" value="<c:out value='${pageMaker.criteria.keyword}'/>">
                </form>

                <!-- end paging -->
                <!-- modal -->
                <div class="modal fade" id="myModal"
                     tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                </button>
                                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                            </div>
                            <div class="modal-body">처리가 완료되었습니다.</div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- modal end -->
            </div>
        </div>
    </div>
</div>
<%@include file="../includes/footer.jsp"%>

<script>
    $(document).ready(function () {
        //모달창 표현
        var result = '<c:out value="${result}"/>';
        checkModal(result);
        history.replaceState({},null,null);

        //모달창 표현 함수
        function checkModal(result) {
            if (result === '' || history.state) {
                return;
            }
            if (parseInt(result) > 0) {
                $(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.");
            }
            $("#myModal").modal("show");
        }

        //등록 버튼 처리
        $("#regBtn").on("click", function () {
            self.location = "/board/register";
        });

        //게시물 조회 실제 처리
        $(".move").on("click", function (e) {
            e.preventDefault();
            actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
            actionForm.attr("action", "/board/get");
            actionForm.submit();
        });

        //검색 버튼 페이징 처리
        var searchForm = $("#searchForm");

        $("#searchForm button").on("click", function (e) {
            if (!searchForm.find("option:selected").val()) {
                alert("검색 옵션을 선택하세요.");
                return false;
            }

            if (!searchForm.find("input[name='keyword']").val()) {
                alert("키워드를 입력하세요.");
                return false;
            }

            searchForm.find("input[name='pageNum']").val("1");
            e.preventDefault();
            searchForm.submit();
        });

        //페이지 이동 처리
        var actionForm = $("#actionForm");
        $(".paginate_button a").on("click", function (e) {
            e.preventDefault();
            //뒤로가기 문제 해결
            e.stopPropagation();
            actionForm.attr("action", "/board/list");

            actionForm.find("input[name='pageNum']").val($(this).attr("href"));
            actionForm.submit();
        });


    });
</script>