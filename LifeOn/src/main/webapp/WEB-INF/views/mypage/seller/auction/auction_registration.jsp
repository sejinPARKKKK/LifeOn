<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LifeOn</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/free.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/menu3.css" type="text/css">

    <style>
        .write-content {
            width: 800px;

        }

        .write-form {
            width: 100%;
        }

        .input-name {
            width: 200px;
            height: 30px;
        }

        .body_content {

            width: 850px;
            padding: 20px;
            margin: 80px 0px;
            border: 1px solid #e9e9e9;
            border-radius: 8px;
            display: inline-table;
        }

        .input-price {
            width: 100px;
            height: 25px;
        }

        .select-box-prize {
            text-align: left;
            display: flex;
            align-items: center;
            padding: 13px 0 8px 0;
            font-size: 18px;
        }

        .price-box-prize {
            text-align: left;
            display: flex;
            align-items: center;
            padding: 7px 0 8px 0;
            font-size: 18px;
        }

        .sell-select-box {
            width: 100px;
            height: 30px;
        }

        .box-color {
            border: 1px solid #cfcfcf;
            border-radius: 8px;
        }

        .input-date {
            width: 120px;
            height: 30px;
        }

        .hh-select-box {
            text-align: center;
            text-align-last: center;
            width: 50px;
            height: 30px;
        }

        .tt-select-box {
            text-align: center;
            text-align-last: center;
            width: 60px;
            height: 30px;
        }

        .select-box {
            width: 80px;
            height: 30px;
        }

        .filebox .upload-name2 {
            display: inline-block;
            width: 100%;
            height: 40px;
            padding: 0 10px;
            vertical-align: middle;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            color: #777;
            cursor: default;
        }

    </style>

    <script !src="">

        //  TODO  : 시간이 정시가 되면 분은 0이 나오고 시가 1증가 되어야하는데 변하지 않음
        document.addEventListener('DOMContentLoaded', function () {
            const now = new Date();
            const currentHour = now.getHours();
            const currentMinute = now.getMinutes();

            const stTT = document.getElementById('stTT');
            const stHH = document.getElementById('stHH');
            const stMM = document.getElementById('stMM');

            const edTT = document.getElementById('edTT');
            const edHH = document.getElementById('edHH');
            const edMM = document.getElementById('edMM');

            const startDateInput = document.querySelector('input[name="startDate"]');
            const endDateInput = document.querySelector('input[name="endDate"]');

            const today = new Date(now.getTime() - (now.getTimezoneOffset() * 60000)).toISOString().split('T')[0];

            startDateInput.setAttribute('min', today);
            endDateInput.setAttribute('min', today);

            if (currentHour >= 12) {
                stTT.querySelector('option[value="am"]').disabled = true;
                edTT.querySelector('option[value="am"]').disabled = true;
            }


            stTT.value = currentHour >= 12 ? 'pm' : 'am';
            edTT.value = currentHour >= 12 ? 'pm' : 'am';

            stHH.value = currentHour % 12 || 12;
            stMM.value = (Math.ceil(currentMinute / 5) * 5) % 60 + 5;
            console.log(stMM.value);
            // TODO : 시간이 정시가 되면 분은 0이 나오고 시가 1증가 되어야하는데 변하지 않음

            // let stDate = new Date(dateSt + 'T' + dateStHH + ':' + dateStMM + ':00');
            //
            // const currentHour = now.getHours();
            // const currentMinute = now.getMinutes();

            // if (stMM === '0') {
            //     stHH.value = (parseInt(stHH.value, 10) + 1) % 12 || 12;
            //     if (stHH.value === 12) {
            //         stTT.value = stTT.value === 'am' ? 'pm' : 'am';
            //     }
            // }
            //
            edHH.value = currentHour % 12 || 12;
            edMM.value = (Math.ceil(currentMinute / 5) * 5) % 60 + 10;
            //
            // //let edDate = new Date(dateEd + 'T' + dateEdHH + ':' + dateEdMM + ':00');
            //
            // if (edMM === '0') {
            //     edHH.value = (parseInt(edHH.value, 10) + 1) % 12 || 12;
            //     if (edHH.value === 12) {
            //         edTT.value = edTT.value === 'am' ? 'pm' : 'am';
            //     }
            // }


            stTT.addEventListener('change', function () {
                updateOptions('st',stTT, stHH, stMM, startDateInput);
            });
            stHH.addEventListener('change', function () {
                updateOptions('st',stTT, stHH, stMM, startDateInput);
            });

            edTT.addEventListener('change', function () {
                updateOptions('ed',edTT, edHH, edMM, endDateInput);
            });
            edHH.addEventListener('change', function () {
                updateOptions('ed',edTT, edHH, edMM, endDateInput);
            });

            startDateInput.addEventListener('change', function () {
                updateOptions('st',stTT, stHH, stMM, startDateInput);
            });

            endDateInput.addEventListener('change', function () {
                updateOptions('ed',edTT, edHH, edMM, endDateInput);
            });

            updateOptions('st',stTT, stHH, stMM, startDateInput);
            updateOptions('ed',edTT, edHH, edMM, endDateInput);

            function updateOptions(re,timeSelect, hourSelect, minuteSelect, dateInput) {
                const selectedTT = timeSelect.value;
                let selectedDate = new Date(dateInput.min);
                if (dateInput.value) {
                    selectedDate = new Date(dateInput.value);
                }
                const isToday = selectedDate.toDateString() === new Date().toDateString();


                Array.from(hourSelect.options).forEach(option => {
                    let hour = parseInt(option.value, 10);

                    hour = selectedTT ==='pm' ? hour + 12 : hour;

                    if (isToday && (hour < currentHour)) {
                        option.disabled = true;
                    } else {
                        option.disabled = false;
                    }
                });

                let curMin  = re === 'st' ? currentMinute+5 : currentMinute+10;
                curMin = curMin >= 55 ? curMin - 60 : curMin;

                Array.from(minuteSelect.options).forEach(option => {
                    const minute = parseInt(option.value, 10);
                    let  hour = parseInt(hourSelect.value, 10);
                    hour = selectedTT ==='pm' ? hour + 12 : hour;
                    console.log(minute, ' 현재 :',curMin);
                    if (isToday &&  (hour === currentHour) && minute < curMin) {
                        option.disabled = true;
                    } else {
                        option.disabled = false;
                    }
                });

                if (!isToday) {
                    timeSelect.querySelector('option[value="am"]').disabled = false;
                }
            }



        });

    //    TODO selectBox 가 업데이트(수정)로 넘어올시 안에 데이터를 넣는 함수가 필요


    </script>


</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<script type="text/javascript">

    function check() {
        const f = document.freeForm;
        let str;
        const now = new Date();
        const currentHour = now.getHours();
        const currentMinute = now.getMinutes();

        let dateSt = f.startDate.value.trim();
        let dateStHH = f.startDateHH.value.trim();
        let dateStMM = f.startDateMM.value.trim();

        let dateEd = f.endDate.value.trim();
        let dateEdHH = f.endDateHH.value.trim();
        let dateEdMM = f.endDateMM.value.trim();

        let stTT = f.startDateTime.value.trim();
        let edTT = f.endDateTime.value.trim();

        if (stTT ==='pm' && dateStHH < 12) {
            dateStHH = parseInt(dateStHH) + 12;
        }

        if (edTT ==='pm' && dateEdHH < 12) {
            dateEdHH = parseInt(dateEdHH) + 12;
        }


        let stDate = new Date(dateSt + 'T' + dateStHH + ':' + dateStMM + ':00');
        let edDate = new Date(dateEd + 'T' + dateEdHH + ':' + dateEdMM + ':00');

        str = f.prName.value.trim();
        if (!str) {
            alert('이름을 입력하세요.');
            f.prName.focus();
            return false;
        }


        if (!dateSt) {
            alert('시작일을 입력하세요.');
            f.startDate.focus();
            return false;
        } else if (stDate < now) {
            alert('시작일은 오늘 이후로 입력하세요.');
            f.startDate.focus();
            return false;
        }

        let hh = f.startDateHH.value.trim();
        str = f.startDateMM.value.trim();
        if (hh < (currentHour % 12 || 12) || (hh === (currentHour % 12 || 12) && str < Math.ceil(currentMinute / 5) * 5 + 5)) {
            alert('시작분은 현재시간보다 10분 이후로 선택하세요.');
            f.startDateMM.focus();
            return false;
        }

        str = f.endDate.value.trim();
        if (!dateEd) {
            alert('종료일을 입력하세요.');
            f.endDate.focus();
            return false;
        } else if (edDate < now) {
            alert('종료일은 오늘 이후로 입력하세요.');
            f.endDate.focus();
            return false;
        }

        if (edDate <= stDate) {
            alert('종료일은 시작일보다 늦거나 같을수 없습니다.');
            f.endDate.focus();
            return false;
        }



        str = f.prPrice.value.trim();
        if (!str) {
            alert('가격을 입력하세요.');
            f.prPrice.focus();
            return false;
        }

        str = f.mainCategory.value.trim();
        if (str === 'none') {
            alert('대분류를 선택하세요.');
            f.mainCategory.focus();
            return false;
        }

        str = f.subCategory.value.trim();
        if (str === 'none') {
            alert('소분류를 선택하세요.');
            f.subCategory.focus();
            return false;
        }

        str = f.content.value.trim();
        if (!str || str === '<p><br></p>') {
            alert('내용을 입력하세요.');
            f.content.focus();
            return false;
        }

        // str = f.thumbnailFile.value.trim();
        // if (!str) {
        //     alert('대표이미지를 선택하세요.');
        //     return false;
        // }
        //
        // str = f.selectFile.value.trim();
        // if (!str) {
        //     alert('상품이미지를 선택하세요.');
        //     return false;
        // }

        f.action = '${pageContext.request.contextPath}/mypage/seller/${mode}';
        f.submit();
    }

</script>

<main class="min-vh-100">
    <jsp:include page="/WEB-INF/views/mypage/left.jsp"/>
    <div class="body-container" style="margin-left: 10%; margin-top: 50px;">
        <div class="body_content" style="margin-left: 20%; margin-top: 50px;">
            <div class="write-content">
                <div class="write-content" style="margin-top: 20px;">
                    <div style="text-align: left; font-size: 30px;">
                        상품등록창
                    </div>
                </div>
                <form name="freeForm" class="freeForm" method="post" enctype="multipart/form-data">
                    <div class="write-form">
                        <div class="form-row" style="text-align: left; display: flex; align-items: center;">
                            <span style="width: 128px; font-size: 20px;">상품이름 입력</span>
                            <span style="flex-grow: 1;">
                                <input type="text" name="prName" maxlength="100" class="input-name box-color"
                                       value="${prize.prName}">
                            </span>
                            <span style="font-size: 15px">
                                시작일 :
                                <label>
                                    <input type="date" name="startDate" class="input-date box-color"
                                           value="${prize.stDate}" placeholder="">
                                   <select name="startDateTime" id="stTT" class="tt-select-box box-color">
                                        <option value="am">&nbsp;오전</option>
                                        <option value="pm" selected>&nbsp;오후</option>
                                    </select>
                                    <select name="startDateHH" id="stHH" class="hh-select-box box-color">
                                        <c:forEach var="i" begin="1" end="12">
                                            <option value="${i}">${i}</option>
                                        </c:forEach>
                                    </select>시
                                    <select name="startDateMM" id="stMM" class="hh-select-box box-color">
                                        <c:forEach var="i" begin="0" end="50" step="5">
                                            <option value="${i}">${i}</option>
                                        </c:forEach>
                                    </select>분
                                </label>
                            </span>
                        </div>
                        <div class="select-box-prize">
                            <span style="padding-right: 10px;">
                                    <label>
                                        상품의 가격
                                        <input type="text" name="prPrice" maxlength="50" class="input-price box-color"
                                               value="${prize.price}">
                                    원
                                    </label>
                            </span>
                            <span style="font-size: 15px; padding-left: 190px;">
                                종료일 :
                                 <label>
                                    <input type="date" name="endDate" class="input-date box-color"
                                           value="${prize.edDate}">
                                    <select name="endDateTime" id="edTT" class="tt-select-box box-color">
                                        <option value="am">&nbsp;오전</option>
                                        <option value="pm" selected>&nbsp;오후</option>
                                    </select>
                                   <select name="endDateHH" id="edHH" class="hh-select-box box-color">
                                        <c:forEach var="i" begin="1" end="12">
                                            <option value="${i}">${i}</option>
                                        </c:forEach>
                                    </select>시
                                    <select name="endDateMM" id="edMM" class="hh-select-box box-color">
                                        <c:forEach var="i" begin="0" end="55" step="5">
                                            <option value="${i}">${i}</option>
                                        </c:forEach>
                                    </select>분
                                </label>
                            </span>
                        </div>
                        <div class="price-box-prize">
                            <span>
                                <span style="font-size: 14px;">
                                    거래유형
                                    <label>
                                        <select name="dealType" class="select-box box-color">
                                            <option value="none">&nbsp;선택</option>
                                            <option value="직거래">&nbsp;직거래</option>
                                            <option value="택배">&nbsp;택배</option>
                                        </select>
                                    </label>
                                </span>
                                 <span style="padding-left: 550px;">카테고리 분류</span>
                            </span>
                        </div>
                        <div class="" style="text-align: left;">
                            <span style="padding-top: 20px; font-size: 20px;">상품설명 작성</span>
                            <label style="padding-left: 420px; padding-bottom: 10px;">
                                대분류
                                <select id="mainCategory" name="mainCategory" class="select-box box-color"
                                        style="font-size: 14px">
                                    <option value="none">선택</option>
                                    <c:forEach var="big" items="${category.bigCategory}">
                                        <option value="${big.cbn}">${big.cbc}</option>
                                    </c:forEach>
                                </select>
                            </label>
                            <label>
                                소분류
                                <select id="subCategory" name="subCategory" class="select-box box-color"
                                        style="font-size: 14px">
                                    <option value="none">선택</option>
                                </select>
                            </label>
                            <span>
                                <textarea name="content" placeholder="내용을 작성해주세요." class="free-control"
                                          style="height: 200px;">${prize.prContent}</textarea>
                            </span>
                        </div>

                        <div class="" style="text-align: left">
                            <span>대표이미지</span>
                            <span>
                                <div class="filebox">
                                    <input class="upload-name2" value="대표이미지" placeholder="대표이미지" readonly="readonly">
                                    <label for="thumbnailImage">파일선택</label>
                                    <input type="file" id="thumbnailImage" name="thumbnailFile" required accept="image/*">
                                </div>
                            </span>
                        </div>
                        <div class="" style="text-align: left">
                            <span>상품이미지</span>
                            <span>
                                <div class="filebox">
                                    <input class="upload-name" value="상품이미지" placeholder="상품이미지" readonly="readonly">
                                    <label for="file">파일선택</label>
                                    <input type="file" id="file" name="selectFile" multiple accept="image/*">
                                </div>
                            </span>
                        </div>
                    <%-- TODO 파일 올렸을때 업데이트관련 수정 필요 --%>
                        <c:if test="${mode == 'update'}">
                            <c:forEach var="vo" items="${listFile}">
                                <div class="">
                                    <span>첨부된파일</span>
                                    <span>
                                        <p class="free-control">
                                            <span class="delete-file" data-fileNum="${vo.fnum}"><i
                                                    class="bi bi-trash"></i></span>
                                            ${vo.cpfname}
                                        </p>
                                    </span>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                    <table class="table table-borderless">
                        <tr>
                            <td class="text-center">
                                <button type="button" class="btn" onclick="check();">${mode=='update'?'수정완료':'등록완료'}&nbsp;<i
                                        class="bi bi-check2"></i></button>
                                <button type="button" class="btn"
                                        onclick="location.href='${pageContext.request.contextPath}/mypage/seller/info';">${mode=='update'?'수정취소':'등록취소'}&nbsp;<i
                                        class="bi bi-x"></i></button>

                                <c:if test="${mode == 'update'}">
                                    <input type="hidden" name="pnum" value="${prize.pnum}">
                                    <input type="hidden" name="page" value="${page}">
                                </c:if>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
    </div>

    <c:if test="${mode=='update'}">
        <script type="text/javascript">
            $('.delete-file').click(function () {
                if (!confirm('선택한 파일을 삭제 하시겠습니까 ? ')) {
                    return false;
                }

                let $tr = $(this).closest('tr');
                let fnum = $(this).attr('data-fileNum');
                let url = '${pageContext.request.contextPath}/lounge2/tip/deleteFile';

                $.ajaxSetup({
                    beforeSend: function (e) {
                        e.setRequestHeader('AJAX', true);
                    }
                });
                $.post(url, {fnum: fnum}, function (data) {
                    $($tr).remove();
                }, 'json').fail(function (jqXHR) {
                    console.log(jqXHR.responseText);
                });
            });
        </script>
    </c:if>


    <script type="text/javascript" src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js"
            charset="utf-8"></script>
    <script type="text/javascript">
        $("#file").on('change', function () {
            let fileCount = $("#file")[0].files.length;
            $(".upload-name").val(fileCount + "개 파일 선택됨");
        });

        $("#thumbnailImage").on('change', function () {
            let fileCount = $("#thumbnailImage")[0].files.length;
            $(".upload-name2").val(fileCount + "개 파일 선택됨");
        });


        const subcategories = {};
        // 예제 소분류 데이터
        <c:forEach var="small" items="${category.smallCategory}">
        if (!subcategories["${small.cbn}"]) {
            subcategories["${small.cbn}"] = [];
        }
        subcategories["${small.cbn}"].push({
            csn: "${small.csn}",
            csc: "${small.csc}"
        });
        </c:forEach>

        document.getElementById('mainCategory').addEventListener('change', function () {
            const mainCategoryId = this.value;
            const subCategorySelect = document.getElementById('subCategory');

            // 기존 옵션 제거
            subCategorySelect.innerHTML = '<option value="none">선택</option>';

            // 선택된 대분류에 따른 소분류 가져오기
            const selectedSubcategories = subcategories[mainCategoryId] || [];

            // 소분류 옵션 업데이트
            selectedSubcategories.forEach(subCategory => {
                const option = document.createElement('option');
                option.value = subCategory.csn;
                option.textContent = subCategory.csc;
                subCategorySelect.appendChild(option);
            });
        });
    </script>
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>