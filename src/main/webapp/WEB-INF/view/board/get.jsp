<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="../includes/header.jsp"%>

<%--principal 태그를 pinfo로 쉽게 조회하게 만들기--%>
<sec:authentication property="principal" var="pinfo"/>
<%--principal 태그를 pinfo로 쉽게 조회하게 만들기--%>


<%--헤더--%>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
</div>
<%--헤더--%>

<%--본문--%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">Board Read Page</div>

            <div class="panel-body">
                <div class="form-group">
                    <label>Bno</label>
                    <input class="form-control" name="bno" value="${board.bno}" readonly>
                </div>
                <div>
                    <label>Title</label>
                    <input class="form-control" name="title" value="${board.title}" readonly>
                </div>
                <div class="form-group">
                    <label>Text area</label>
                    <textarea class="form-control" rows="3" name="content" readonly>${board.content}</textarea>
                </div>
                <div class="form-group">
                    <label>Writer</label>
                    <input class="form-control" name="writer" value="${board.writer}" readonly>
                </div>

                <%--작성자만 변경버튼 활성화--%>
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${pinfo.username eq board.writer}">
                        <button data-oper="modify" class="btn btn-default">Modify</button>
                    </c:if>
                </sec:authorize>
                <%--작성자만 변경버튼 활성화--%>

                <button data-oper="list" class="btn btn-info">List</button>

                <form id="operForm" action="/board/modify" method="get">
                    <input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/>">
                    <input type="hidden" name="pageNum" value="<c:out value='${criteria.pageNum}'/>">
                    <input type="hidden" name="amount" value="<c:out value='${criteria.amount}'/>">
                    <input type="hidden" name="type" value="<c:out value='${criteria.type}'/>">
                    <input type="hidden" name="keyword" value="<c:out value='${criteria.keyword}'/>">
                </form>
            </div>
        </div>
    </div>
</div>
<%--본문--%>

<%--첨부파일--%>

<%--원본 이미지 표시--%>
<div class="bigPictureWrapper">
    <div class="bigPicture">

    </div>
</div>
<%--원본 이미지 표시--%>

<%--첨부파일 목록--%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">files</div>

            <div class="panel-body">
                <div class="uploadResult">
                    <ul>

                    </ul>
                </div>
            </div>

        </div>
    </div>
</div>
<%--첨부파일 목록--%>
<%--JavaScript--%>
<script>
    //첨부파일 목록 가져오기
    let bno = '<c:out value="${board.bno}"/>';
    $.getJSON("/board/getAttachList", {bno: bno}, function (arr) {
        console.log(arr);

        let fileCallPath
        let str = "";
        $(arr).each(function (i, attach) {
            if (attach.fileType) {
                fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

                str +=
                    "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>" +
                    "   <div>" +
                    "       <img src='/display?fileName=" + fileCallPath + "'>" +
                    "   </div>" +
                    "</li>"
            } else {
                fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);

                str +=
                    "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>" +
                    "   <div>" +
                    "       <span>" + attach.fileName + "</span><br/>" +
                    "       <img src='/resources/img/attach.png'>" +
                    "   </div>" +
                    "</li>"
            }
        });
        $(".uploadResult ul").html(str);
    });
    //첨부파일 목록 가져오기

    //첨부파일 다운로드/원본보기
    $(".uploadResult").on("click", "li", function (e) {
        console.log("view image");

        let li_Obj = $(this);
        let path = encodeURIComponent(li_Obj.data("path") + "/" + li_Obj.data("uuid") + "_" + li_Obj.data("filename"));

        if (li_Obj.data("type")) {
            showImage(path.replace(new RegExp(/\\/g), "/"));
        } else {
            self.location = "/download?fileName=" + path;
        }
    });
    //첨부파일 다운로드/원본보기

    //이미지 원본보기 함수
    function showImage(fileCallPath) {
        alert(fileCallPath);

        $(".bigPictureWrapper").css("display","flex").show();

        $(".bigPicture")
            .html("<img src='/display?fileName=" + fileCallPath + "'>")//UploadController.display()호출
            .animate({width: '100%', height: '100%'}, 1000);
    }
    //이미지 원본보기 함수

    //원본 이미지 닫기
    $(".bigPictureWrapper").on("click", function (e) {
        $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
        setTimeout(function () {
            $(".bigPictureWrapper").hide();
        }, 1000);
    });
</script>
<%--JavaScript--%>
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
        align-content: center;
        text-align: center;
    }

    .uploadResult ul li img {
        width: 100px;
    }

    .uploadResult ul li span {
        color: white;
    }

    .bigPictureWrapper {
        position: absolute;
        display: none;
        justify-content: center;
        align-content: center;
        top: 0;
        width: 100%;
        height: 100%;
        z-index: 100;
        background: rgba(255, 255, 255, 0.7);
    }

    .bigPicture {
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .bigPicture img {
        width: 600px;
    }
</style>
<%--첨부파일--%>

<!-- comment -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply

                <%--로그인한 사용자만 댓글 추가 버튼 활성화--%>
                <sec:authorize access="isAuthenticated()">
                    <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
                </sec:authorize>
                <%--로그인한 사용자만 댓글 추가 버튼 활성화--%>

            </div>

            <div class="panel-body">
                <ul class="chat">
                </ul>
            </div>

            <div class="panel-footer">
            </div>

        </div>
    </div>
</div>

<%@include file="../includes/footer.jsp"%>

<!-- comment modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">$times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>

            <div class="modal-body">
                <div class="form-group">
                    <label>Reply</label>
                    <input class="form-control" name="reply" value="New Reply!!!">
                </div>
                <div class="form-group">
                    <label>Replyer</label>
                    <input class="form-control" name="replyer" value="replyer" readonly>
                </div>
                <div class="form-group">
                    <label>Reply Date</label>
                    <input class="form-control" name="replyDate" value="">
                </div>
            </div>

            <div class="modal-footer">
                <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
                <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button id="modalClassBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/reply.js"></script>
<script>
    $(document).ready(function () {
        var bnoValue = "<c:out value='${board.bno}'/>";
        var replyUL = $(".chat");
        var pageNum = 1;
        var replyPageFooter = $(".panel-footer");

        showList(1);

        //댓글 목록 표시 함수
        function showList(page) {
            replyService.getList(
                {
                    bno: bnoValue,
                    page: page || 1
                },
                function (replyCnt, list) {
                    //새로운 댓글 추가 시 -1페이지를 호출하여 마지막 페이지로 이동하도록 하는 처리.
                    if (page === -1) {
                        pageNum = Math.ceil(replyCnt / 10.0);
                        showList(pageNum);
                        return;
                    }

                    var str = "";

                    // if (list == null || list.length === 0) {
                    //     return;
                    // }

                    for (var i = 0, len = list.length || 0; i < len; i++) {
                        str +=
                            "<li class='left clearfix' data-rno='" + list[i].rno + "'>" +
                            "   <div>" +
                            "       <div class='header'>" +
                            "           <strong class='primary-font'>[" + list[i].rno + "] " + list[i].replyer + "</strong>" +
                            "           <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>" +
                            "       </div>" +
                            "       <p>" + list[i].reply + "</p>" +
                            "   </div>" +
                            "</li>";
                    }
                    replyUL.html(str);

                    showReplayPage(replyCnt);
                });
        }
        //댓글 목록 표시 함수

        //댓글 페이징 함수
        function showReplayPage(replyCnt) {
            var endNum = Math.ceil(pageNum / 10.0) * 10;
            var startNum = endNum - 9;

            var prev = startNum !== 1;
            var next = false;

            if (endNum * 10 >= replyCnt) {
                endNum = Math.ceil(replyCnt / 10.0);
            }

            if (endNum * 10 < replyCnt) {
                next = true;
            }

            var str = "<ul class='pagination pull-right'>";

            if (prev) {
                str += "<li class='page-item'>" +
                    "       <a class='page-link' href='" + (startNum - 1) + "'>previous</a>" +
                    "   <li>";
            }

            for (var i = startNum; i <= endNum; i++) {
                var active = pageNum === i ? "active" : "";

                str += "<li class='page-item " + active + "'>" +
                    "       <a class='page-link' href='" + i + "'>" + i + "</a>" +
                    "   <li>"
            }

            if (next) {
                str += "<li class='page-item'>" +
                    "       <a class='page-link' href='" + (endNum + 1) + "'>Next</a>" +
                    "   <li>";
            }

            str += "</ul></div>";

            console.log(str);

            replyPageFooter.html(str);
        }
        //댓글 페이징 함수

        //댓글 페이지 클릭 이벤트
        replyPageFooter.on("click", "li a", function (e) {
            e.preventDefault();
            pageNum = $(this).attr("href");
            showList(pageNum);
        });
        //댓글 페이지 클릭 이벤트


        //댓글 입력 모달
        let modal = $(".modal");
        let modalInputReply = modal.find("input[name='reply']");
        let modalInputReplyer = modal.find("input[name='replyer']");
        let modalInputReplyDate = modal.find("input[name='replyDate']");

        let modalModBtn = $("#modalModBtn");
        let modalRemoveBtn = $("#modalRemoveBtn");
        let modalRegisterBtn = $("#modalRegisterBtn");

        let replyer = null;
        <sec:authorize access="isAuthenticated()">
            replyer = "<sec:authentication property='principal.username'/>"
        </sec:authorize>

        let csrfHeaderName = "${_csrf.headerName}";
        let csrfTokenValue = "${_csrf.token}";

        $("#addReplyBtn").on("click", function (e) {
            modal.find("input").val("");
            modal.find("input[name='replyer']").val(replyer);
            modalInputReplyDate.closest("div").hide();
            modal.find("button[id !='modalCloseBtn']").hide();

            modalRegisterBtn.show();
            $(".modal").modal("show");
        });

        //ajax 시 csrf 정보를 담도록 세팅 변경
        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
        });

        //reply register
        modalRegisterBtn.on("click", function (e) {
            var reply = {
                reply : modalInputReply.val(),
                replyer : modalInputReplyer.val(),
                bno : bnoValue
            };
            replyService.add(reply, function (result) {
                alert(result);

                modal.find("input").val("");
                modal.modal("hide");

                showList(-1);
            });
        });

        //reply manage modal
        $(".chat").on("click", "li", function (e) {
            var rno = $(this).data("rno");
            replyService.get(rno, function (reply) {
                modalInputReply.val(reply.reply);
                modalInputReplyer.val(reply.replyer).attr("readonly","readonly");
                modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
                modal.data("rno", reply.rno);

                modal.find("button[id !='modalCloseBtn']").hide();
                modalModBtn.show();
                modalRemoveBtn.show();

                $(".modal").modal("show");
            });
        });

        //reply modify
        modalModBtn.on("click", function (e) {
            var reply = {
                rno : modal.data("rno"),
                reply : modalInputReply.val(),
                replyer : modalInputReplyer.val()
            }

            if (!replyer) {
                alert("댓글을 수정하려면 로그인하세요.");
                modal.modal("hide");
                return;
            }

            replyService.update(reply, function (result) {
                alert(result);
                modal.modal("hide");
                showList(pageNum);
            });
        });

        //reply delete
        modalRemoveBtn.on("click", function (e) {
            var rno = modal.data("rno");

            if (!replyer) {
                alert("댓글을 삭제하려면 로그인하세요.");
                modal.modal("hide");
                return;
            }

            let originalReplyer = modalInputReplyer.val();

            if (replyer !== originalReplyer) {
                alert("자신이 등록한 댓글만 삭제 가능합니다.");
                modal.modal("hide");
                return;
            }

            replyService.remove(rno, originalReplyer, function (result) {
                alert(result);
                modal.modal("hide");
                showList(pageNum);
            });
        });
    });

</script>
<script>
    $(document).ready(function () {

        //게시물 수정창 버튼 처리
        var operForm = $("#operForm");

        $("button[data-oper='modify']").on("click", function () {
            operForm.attr("action", "/board/modify").submit();
        });

        $("button[data-oper='list']").on("click", function () {
            operForm.find("#bno").remove();
            operForm.attr("action", "/board/list")
            operForm.submit();
        });
        //게시물 수정 창 버튼 처리
    });
</script>