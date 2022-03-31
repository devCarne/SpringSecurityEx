<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../includes/header.jsp"%>
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
        align-items: center;
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
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Register</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Register</div>
            <div class="panel-body">
                <form role="form" action="/board/register" method="post">
                    <div class="form-group">
                        <label>Title</label> <input class="form-control" name="title">
                    </div>
                    <div class="form-group">
                        <label>Text area</label> <textarea class="form-control" rows="3" name="content"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label> <input class="form-control" name="writer" value="<sec:authentication property="principal.username"/>" readonly>
                    </div>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <button type="submit" class="btn btn-default">Submit Button</button>
                    <button type="reset" class="btn btn-default">Reset Button</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">File Attach</div>

            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple>
                </div>

                <div class="uploadResult">
                    <ul>

                    </ul>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    $(document).ready(function () {

        //Submit Button의 기본 동작을 막고 업로드 파일 정보 전달
        let formObj = $('form[role="form"]');

        $('button[type="submit"]').on("click", function (e) {
            e.preventDefault();

            let str = "";

            $(".uploadResult ul li").each(function (i, obj) {
                let jObj = $(obj);

                str +=
                    "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jObj.data("filename") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jObj.data("uuid") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jObj.data("path") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jObj.data("type") + "'>";
            });
            formObj.append(str).submit();
        });
        //Submit Button의 기본 동작 막기

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
        //csrf 변수 생성
        let csrfHeaderName = "${_csrf.headerName}";
        let csrfTokenValue = "${_csrf.token}";

        $("input[type='file']").change(function (e) {
            let formData = new FormData;
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;

            for (let i = 0; i < files.length; i++) {
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
                    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)
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

        //파일 삭제
        $(".uploadResult").on("click", "button", function (e) {
            let targetFile = $(this).data("file");
            let type = $(this).data("type");
            let targetLI = $(this).closest("li");

            $.ajax({
                url:'/deleteFile',
                data: {fileName: targetFile, type: type},
                dataType: 'text',
                type: 'POST',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                },
                success: function (result) {
                    alert(result);
                    targetLI.remove();
                },
            })
        });
        //파일 삭제
    });
</script>
<%@include file="../includes/footer.jsp"%>