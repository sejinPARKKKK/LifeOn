<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

</head>

<style type="text/css">
body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
  flex-direction: column;
  justify-content: space-between;
}

.body-container {
  width: 70%; 
  padding: 30px;
  background-color: #fff;
  border: 1px solid #ccc; 
  border-radius: 10px; 
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); 
  margin: 0 auto; 
}

.box-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: rgba(0, 0, 0, 0.1);
}
.header {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 20px;
}

.section {
  margin-bottom: 20px;
}

.label {
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 8px;
  display: block;
}

/* 인풋박스, 드롭다운, 날짜 선택 */
.input-box,
.dropdown,
.date-picker {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  font-size: 14px;
}


.input-box::placeholder,
.dropdown::placeholder {
  color: #888;
}

.button-group {
  display: flex;
  justify-content: space-between;
}

.button {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  font-size: 14px;
  cursor: pointer;
}

.button.cancel {
  background-color: #f0f0f0;
  color: #333;
}

.button.submit {
  background-color: #007bff;
  color: #fff;
}

.calendar-icon {
  position: absolute;
  right: 12px; 
  top: 20%; 
  font-size: 20px;
  color: #222;
  cursor: pointer;

}

main {
  flex: 1;
  display: flex;
  justify-content: center; 
  align-items: center; 
  padding-top: 50px; 
  padding-bottom: 50px; 
}
</style>
<script type="text/javascript">
function check() {
    const f = document.boardForm;
    let str;
	
    str = f.subject.value.trim();
    if( !str ) {
        alert('제목을 입력하세요. ');
        f.subject.focus();
        return false;
    }

    str = f.content.value.trim();
    if( !str || str === '<p><br></p>') {
        alert('내용을 입력하세요. ');
        f.content.focus();
        return false;
    }

    f.action =  '${pageContext.request.contextPath}/city/meeting/${mode}';
    f.submit();
 
}

</script>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 66px;" action="${pageContext.request.contextPath}/city/main/${bdtype}/write/${bdtype}">
    <div class="container">
    	<div class="body-container">
        <h2> 모임 등록 </h2>
        
		<hr>
		<form name="meetingForm" method="post" enctype="multipart/form-data">
            <h4>📌 모임 정보 입력</h4>
            
        <div class="section">
            <label class="label" for="meeting-date">날짜/시간</label>
             <div class="date-picker-container">
       			 <input type="date" name="mdate" id="mdate"  class="date-picker" value="${dto.mdate}">
    		</div>
        </div>
        
        <div class="section">
                <label for="label">카테고리</label>
                <select id="bigCategory" name="cbn" class="dropdown" required onchange="categoryCheck();">
                     < <option value="0" selected>카테고리를 선택하세요</option>
                     <c:forEach var="category" items="${Category}">
				        <option value="${category.cbn}" ${category.cbn == dto.cbn ? 'selected' : ''}>${category.cbc}</option>
				    </c:forEach>
                </select>
            </div>
            
            <div class="section">
            <label class="label" for="status">모집 상태</label>
             <c:choose>
		        <c:when test="${mode == 'write'}">
		            <!-- 새 글 작성일 때는 모집 중으로 고정 -->
		            <input type="hidden" name="ies" value="모집 중">
		            <input type="text" class="input-box" value="모집 중" readonly>
		        </c:when>
		        <c:otherwise>
		            <select id="status" class="dropdown" name="ies">
	                <option value="모집 중" ${dto.ies == '모집 중' ? 'selected' : ''}>모집 중</option>
	                <option value="모집 종료" ${dto.ies == '모집 종료' ? 'selected' : ''}>모집 종료</option>
	            </select>
        </c:otherwise>
    </c:choose>
</div>

        <div class="section">
            <label class="label" for="location">지역</label>
            <select id="loca" class="dropdown" name="loca">
            <option value="" disabled selected>지역을 선택하세요</option>
                <option value="금천구" ${dto.loca == "금천구" ? "selected" : ""}>금천구</option>
                <option value="관악구" ${dto.loca == "관악구" ? "selected" : ""}>관악구</option>
                <option value="구로구" ${dto.loca == "구로구" ? "selected" : ""}>구로구</option>
                <option value="강서구" ${dto.loca == "강서구" ? "selected" : ""}>강서구</option>
                <option value="강북구" ${dto.loca == "강북구" ? "selected" : ""}>강북구</option>
                <option value="강남구" ${dto.loca == "강남구" ? "selected" : ""}>강남구</option>
                <option value="강동구" ${dto.loca == "강동구" ? "selected" : ""}>강동구</option>
                <option value="광진구" ${dto.loca == "광진구" ? "selected" : ""}>광진구</option>
                <option value="노원구" ${dto.loca == "노원구" ? "selected" : ""}>노원구</option>
                <option value="도봉구" ${dto.loca == "도봉구" ? "selected" : ""}>도봉구</option>
                <option value="동작구" ${dto.loca == "동작구" ? "selected" : ""}>동작구</option>
                <option value="동대문구" ${dto.loca == "동대문구" ? "selected" : ""}>동대문구</option>
                <option value="마포구" ${dto.loca == "마포구" ? "selected" : ""}>마포구</option>
                <option value="서초구" ${dto.loca == "서초구" ? "selected" : ""}>서초구</option>
                <option value="송파구" ${dto.loca == "송파구" ? "selected" : ""}>송파구</option>
                <option value="성동구" ${dto.loca == "성동구" ? "selected" : ""}>성동구</option>
                <option value="성북구" ${dto.loca == "성북구" ? "selected" : ""}>성북구</option>
                <option value="서대문구" ${dto.loca == "서대문구" ? "selected" : ""}>서대문구</option>
                <option value="양천구" ${dto.loca == "양천구" ? "selected" : ""}>양천구</option>
                <option value="영등포구" ${dto.loca == "영등포구" ? "selected" : ""}>영등포구</option>
                <option value="용산구" ${dto.loca == "용산구" ? "selected" : ""}>용산구</option>
                <option value="종로구" ${dto.loca == "종로구" ? "selected" : ""}>종로구</option>
                <option value="중구" ${dto.loca == "중구" ? "selected" : ""}>중구</option>
                <option value="중랑구" ${dto.loca == "중랑구" ? "selected" : ""}>중랑구</option>
            </select>
        </div>

        <div class="section">
            <label class="label" for="detail-location">상세 장소</label>
            <input type="text" id="detail-location" class="input-box" name="loca_d" value="${dto.loca_d}"  placeholder="상세 장소를 입력하세요" onclick="daumPostcode();">
        </div>
        

        <div class="section">
            <label class="label" for="age">연령대</label>
            <select id="age" class="dropdown" name="age">
                <option value="" disabled selected>연령대를 선택하세요</option>
                <option value="나이 무관" ${dto.age == "나이 무관" ? "selected" : ""}>나이 무관</option>
                <option value="20대" ${dto.age == "20대" ? "selected" : ""}>20대</option>
                <option value="30대" ${dto.age == "30대" ? "selected" : ""}>30대</option>
                <option value="40대" ${dto.age == "40대" ? "selected" : ""}>40대</option>
                <option value="50대" ${dto.age == "50대" ? "selected" : ""}>50대</option>
                <option value="60대 이상" ${dto.age == "60대 이상" ? "selected" : ""}>60대 이상</option>

            </select>
        </div>

        <div class="section">
            <label class="label" for="gender">성별</label>
            <select id="gender" class="dropdown" name="gender">
                <option value="성별무관" selected>성별 무관</option>
				<option value="남자" ${dto.gender == "남자" ? "selected" : ""}>남자</option>
				<option value="여자" ${dto.gender == "여자" ? "selected" : ""}>여자</option>
            </select>
        </div>

        <div class="section">
            <label class="label" for="participants">모집 인원</label>
            <select id="person_c" class="dropdown" name="person_c">
                <option value="" disabled selected>모집 인원을 선택하세요</option>
                 <option value="1~5명" ${dto.person_c == "1~5명" ? "selected" : ""}>1~5명</option>
                 <option value="6~10명" ${dto.person_c == "6~10명" ? "selected" : ""}>6~10명</option>
                 <option value="10명 이상" ${dto.person_c == "10명 이상" ? "selected" : ""}>10명 이상</option>
            </select>
        </div>

        <div class="section">
            <label class="label" for="title">제목</label>
            <input type="text" id="subject" class="input-box" name="subject" placeholder="제목을 입력하세요" value="${dto.subject}">
        </div>

        <div class="section">
            <label class="label" for="description">내용</label>
            <textarea id="content" class="input-box" name="content" rows="4" placeholder="모임에 대해 소개해주세요.">${dto.content}</textarea>
        </div>

        <div class="button-group">
            <button class="button cancel" onclick="location.href='${pageContext.request.contextPath}/city/meeting/main';">${mode == "update" ? "수정취소" : "등록취소"}&nbsp;</button>
            <button class="button submit" onclick="button submit">${mode == "update" ? "수정완료" : "등록완료"}&nbsp;<i class="bi bi-check2"></i></button>
       
			<c:if test="${mode == 'update'}">
				<input type="hidden" name="num" value="${dto.num}">
				<input type="hidden" name="psnum" value="${dto.psnum}">
				<input type="hidden" name="page" value="${page}">
			</c:if>
		</div>
    </form>
    </div>
  </div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script> 
<script>
window.addEventListener('DOMContentLoaded', () => {
	const dateELS = document.querySelectorAll('form input[type=date]');
	dateELS.forEach( inputEL => inputEL.addEventListener('keydown', e => e.preventDefault()) );
});

</script>

</body>
</html>