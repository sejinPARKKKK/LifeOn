<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 상품 스크립트문  --%>
<%-- 카테고리 이동후 클릭시 실행 안됨 --%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/auction_main_prize.css" type="text/css">

<script>
    function tagMove(event) {
        // 모든 tag-line 요소에서 select-line 클래스를 제거합니다.
        document.querySelectorAll('.tag-line').forEach(tag => {
            tag.classList.remove('select-line');
        });

        // 클릭한 요소에 select-line 클래스를 추가합니다.
        event.target.classList.add('select-line');

        // 클릭한 탭의 텍스트를 가져옵니다.
        const selectedTab = event.target.textContent.trim();

        // 모든 상품 카드를 가져옵니다.
        const prizeCards = document.querySelectorAll('.prize-card');

        // 선택된 탭에 따라 상품을 필터링합니다.
        prizeCards.forEach(card => {
            // 카드의 상태를 가져옵니다.
            const status = card.querySelector('.prize-status').textContent.trim();

            if (selectedTab === '전체') {
                // '전체' 탭이 선택된 경우 모든 상품을 표시합니다.
                card.style.display = 'flex';
            } else if (selectedTab === '진행전 상품' && status === '진행전') {
                // '진행전 상품' 탭이 선택되고 상태가 '진행전'인 경우 표시합니다.
                card.style.display = 'flex';
            } else if (selectedTab === '진행중 상품' && status === '진행중') {
                // '진행중 상품' 탭이 선택되고 상태가 '진행중'인 경우 표시합니다.
                card.style.display = 'flex';
            } else {
                // 그 외의 경우 숨깁니다.
                card.style.display = 'none';
            }
        });

        // 필터링 후 표시되는 상품이 없는 경우 메시지를 표시합니다.
        const visibleCards = document.querySelectorAll('.prize-card[style="display: flex;"]');
        const emptyMessage = document.getElementById('empty-message');

        if (visibleCards.length === 0) {
            // 표시할 상품이 없는 경우
            if (!emptyMessage) {
                // 메시지 요소가 없으면 생성합니다.
                const message = document.createElement('div');
                message.id = 'empty-message';
                message.className = 'empty-message';
                message.textContent = '해당 상태의 상품이 없습니다.';
                document.querySelector('.prize-container').appendChild(message);
            } else {
                // 메시지 요소가 있으면 표시합니다.
                emptyMessage.style.display = 'block';
            }
        } else if (emptyMessage) {
            // 표시할 상품이 있고 메시지 요소가 있으면 숨깁니다.
            emptyMessage.style.display = 'none';
        }
    }

    // 페이지 로드 시 초기 필터링을 적용합니다.
    document.addEventListener('DOMContentLoaded', function() {
        // 각 tag-line 요소에 이벤트 리스너를 추가합니다.
        document.querySelectorAll('.tag-line').forEach(tag => {
            tag.addEventListener('click', tagMove);
        });

        // 선택된 탭을 찾아 초기 필터링을 적용합니다.
        const selectedTab = document.querySelector('.tag-line.select-line');
        if (selectedTab) {
            // 선택된 탭이 있으면 클릭 이벤트를 시뮬레이션합니다.
            const event = { target: selectedTab };
            tagMove(event);
        }
    });

    $(function () {
        $('.prize-card').each(function (index, element) {
            let stDate = $(element).data('stdate');
            let edDate = $(element).data('eddate');
            let prName = $(element).data('prname');
            let now = new Date();
            let austDay = new Date(stDate);
            let stRemainingTime = new Date(stDate) - now;
            let edRemainingTime = new Date(edDate) - now;

            if (stRemainingTime > 0) {
                $(element).find('.time-container').countdown({
                    until: austDay,
                    format: 'dHMS',
                    layout: '<span class="time-content">오픈시간</span>' +
                        '<span class="time">{dn}일 {hn}시간 {mn}분 {sn}초</span>'
                });
            } else if (edRemainingTime > 0) {
                austDay = new Date(edDate);
                $(element).find('.time-container').countdown({
                    until: austDay,
                    format: 'dHMS',
                    layout: '<span class="time-content">마감시간</span>' +
                        '<span class="time">{dn}일 {hn}시간 {mn}분 {sn}초</span>'
                });
            }
        });
    });

    //  상품 상세페이지로 이동
    function prizeMove(num) {
        location.href = "${pageContext.request.contextPath}/auction/prizeDetail?pnum=" + num;
    }
</script>

<div class="auction-content">
    <div class="auction-tabs">
        <div class="tag-line select-line" onclick="tagMove(event)">전체</div>
        <div class="tag-line" onclick="tagMove(event)">진행전 상품</div>
        <div class="tag-line" onclick="tagMove(event)">진행중 상품</div>
    </div>

    <div class="prize-container">
        <c:forEach var="in" items="${category.prizeList}">
            <c:forEach var="out" items="${in}">
                <div class="prize-card"
                     data-stdate="${out.stDate}"
                     data-prname="${out.prName}"
                     data-eddate="${out.edDate}"
                     onclick="prizeMove(${out.pnum})">
                    <img src="${pageContext.request.contextPath}/uploads/seller/${out.thumbnail}"
                         alt="${out.prName}"
                         class="prize-image">
                    <div class="prize-content">
                        <h3 class="prize-name">${out.prName}</h3>

                        <div class="prize-price-label">
                            <c:if test="${out.prStatus == '진행중'}">현재가</c:if>
                            <c:if test="${out.prStatus == '진행전'}">시작가</c:if>
                            <c:if test="${out.prStatus == '마감'}">낙찰가</c:if>
                        </div>

                        <div class="prize-price">
                            <fmt:formatNumber value="${out.price}" type="currency" currencySymbol="₩"/>원
                            <span class="prize-status
                                  ${out.prStatus == '진행중' ? 'active' : ''}
                                  ${out.prStatus == '진행전' ? 'pending' : ''}
                                  ${out.prStatus == '마감' ? 'closed' : ''}">
                                    ${out.prStatus}
                            </span>
                        </div>

                        <div class="time-container"></div>

                        <div class="prize-footer">
                            <span>판매자: ${out.sellerName}</span>
                            <span>거래방식: ${out.tradeType}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:forEach>
    </div>
</div>




