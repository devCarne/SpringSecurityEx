<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="../includes/header.jsp"%>

<sec:authentication property="principal" var="pinfo"/>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
</div>

<%--게시물 변경--%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">Board Modify Page</div>

            <div class="panel-body">

                <form role="form" action="/board/modify" method="post">
                    <div class="form-group">
                        <label>Bno</label>
                        <input class="form-control" name="bno" value="${board.bno}" readonly>
                    </div>
                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name="title" value="${board.title}">
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name="content">${board.content}</textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name="writer" value="${board.writer}">
                    </div>
                    <div class="form-group">
                        <label>RegDate</label>
                        <input class="form-control" name="regDate"
                               value="<fmt:formatDate value='${board.regDate}' pattern='yyyy/MM/dd'/>" readonly>
                    </div>
                    <div class="form-group">
                        <label>UpdateDate</label>
                        <input class="form-control" name="updateDate"
                               value="<fmt:formatDate value='${board.updateDate}' pattern='yyyy/MM/dd'/>" readonly>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <input type="hidden" name="pageNum" value="<c:out value='${criteria.pageNum}'/>">
                    <input type="hidden" name="amount" value="<c:out value='${criteria.amount}'/>">
                    <input type="hidden" name="type" value="<c:out value='${criteria.type}'/>">
                    <input type="hidden" name="keyword" value="<c:out value='${criteria.keyword}'/>">

                    <sec:authorize access="isAuthenticated()">
                        <c:if test="${pinfo.username eq board.writer}">
                            <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                            <button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
                        </c:if>
                    </sec:authorize>

                    <button type="submit" data-oper="list" class="btn btn-info">List</button>
                </form>

            </div>
        </div>
    </div>
</div>

<%--게시물 변경 JavaScript--%>
<script>
    $(document).ready(function () {

        //변경 버튼 클릭 시 폼 내용 변경 후 전송
        let formObj = $("form");

        $("button").on("click", function (e) {

            e.preventDefault();

            let operation = $(this).data("oper");
            console.log(operation)

            if (operation === "remove") {
                formObj.attr("action", "/board/remove");
            } else if (operation === "list") {
                formObj.attr("action", "/board/list").attr("method", "get");
                let pageNumTag = $("input[name='pageNum']").clone();
                let amountTag = $("input[name='amount']").clone();
                let typeTag = $("input[name='type']").clone();
                let keywordTag = $("input[name='keyword']").clone();

                formObj.empty();
                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(typeTag);
                formObj.append(keywordTag);
            } else if (operation === "modify") {
                let str = "";

                $(".uploadResult ul li").each(function (i, obj) {
                    let jObj = $(obj);
                    console.dir(jObj);

                    str +=
                        "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jObj.data("filename") + "'>" +
                        "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jObj.data("uuid") + "'>" +
                        "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jObj.data("path") + "'>" +
                        "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jObj.data("type") + "'>";
                });
                formObj.append(str).submit();
            }
            formObj.submit();
        });
        //변경 버튼 클릭 시 폼 내용 변경 후 전송
    });
</script>
<%--게시물 변경 javaScript--%>
<%--게시물 변경--%>

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

            <div class="panel-heading">Files</div>

            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple="multiple">
                </div>

                <div class="uploadResult">
                    <ul>

                    </ul>
                </div>
            </div>

        </div>
    </div>
</div>
<%--첨부파일 목록--%>

<%--첨부파일 JavaScript--%>
<script>
    $(document).ready(function () {
        let csrfHeaderName = "${_csrf.headerName}";
        let csrfTokenValue = "${_csrf.token}"

        let bno = "<c:out value='${board.bno}'/>";

        //첨부파일 조회
        $.getJSON("/board/getAttachList", {bno: bno}, function (arr) {
            //Callback
            console.log(arr)

            let fileCallPath
            let str = "";

            $(arr).each(function (i, attach) {
                if (attach.fileType) {
                    fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

                    str +=
                        "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>" +
                        "       <div>" +
                        "           <span>" + attach.fileName + "</span>" +
                        "           <button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'>" +
                        "               <i class='fa fa-times'></i>" +
                        "           </button><br/>" +
                        "           <img src='/display?fileName=" + fileCallPath + "'>" +
                        "       </div>" +
                        "   </li>";
                } else {
                    fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);

                    str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>" +
                        "       <div>" +
                        "           <span>" + attach.fileName + "</span>" +
                        "           <button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'>" +
                        "               <i class='fa fa-times'></i>" +
                        "           </button><br/>" +
                        "           <img src='/resources/img/attach.png'>" +
                        "       </div>" +
                        "   </li>";
                }
            });
            $(".uploadResult ul").html(str);
        });
        //Callback
        //첨부파일 조회

        // X 클릭 시 화면에서만 삭제(뒤로가기 문제 등 해결)
        $(".uploadResult").on("click", "button", function () {
            if (confirm("파일을 삭제할까요?")) {
                $(this).closest("li").remove();
            }
        });
        // X 클릭 시 화면에서만 삭제(뒤로가기 문제 등 해결)

        //파일 추가 업로드
        //파일 사이즈, 확장자 체크
        const regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        const maxSize = 5242880; //5MB

        function checkExtension(fileName, fileSize) {
            if (fileSize >= maxSize) {
                alert("파일 사이즈 초과");
                return false;
            }
            if (regex.test(fileName)) {
                alert("업로드 할 수 없는 파일 형식(확장자)입니다.")
                return false;
            }
            return true;
        }
        //파일 사이즈, 확장자 체크

        //업로드 Ajax
        $("input[type='file']").change(function (e) {
            let formData = new FormData;
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;

            for (var i = 0; i < files.length; i++) {
                if (!checkExtension(files[i].name, files[i].size)) {
                    return false
                }
                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url: "/uploadAjaxAction",
                processData: false,
                contentType: false,
                data: formData,
                dataType: 'json',
                type: 'POST',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                },
                success: function (result) {
                    console.log(result);
                    showUploadResult(result);
                }
            });
        });
        //업로드 Ajax

        //업로드된 파일 출력
        function showUploadResult(uploadResultArr) {
            if(!uploadResultArr || uploadResultArr.length === 0) return;

            let uploadUL = $(".uploadResult ul");
            let fileCallPath;
            let str = "";

            $(uploadResultArr).each(function (i, obj) {
                if (obj.image) {
                    fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>" +
                        "       <div>" +
                        "           <span>" + obj.fileName + "</span>" +
                        "           <button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'>" +
                        "               <i class='fa fa-times'></i>" +
                        "           </button><br>" +
                        "           <img src='/display?fileName=" + fileCallPath + "'>" +
                        "       </div>" +
                        "   </li>"

                } else {
                    fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);

                    let fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>" +
                        "       <div>" +
                        "           <span>" + obj.fileName + "</span>" +
                        "           <button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'>" +
                        "               <i class='fa fa-times'></i>" +
                        "           </button><br>" +
                        "           <img src='/resources/img/attach.png'>" +
                        "       </div>" +
                        "   </li>";
                }
            });
            uploadUL.append(str)
        }
        //업로드된 파일 출력
        //파일 추가 업로드
    });
</script>
<%--첨부파일 JavaScript--%>

<%--첨부파일 CSS--%>
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
<%--첨부파일 CSS--%>
<%@include file="../includes/footer.jsp"%>

