/*
 	dataCount : 전체 데이터 개수
 	pageSize : 한 페이지의 데이터 개수
 */
function pageCount(dataCount, pageSize) {
	let result = 0;
	
	try {
		dataCount = Number(dataCount);
		pageSize = Number(pageSize);
		
		if(dataCount <= 0) {
	        return 0;
	    }

		// result = Math.ceil(dataCount / pageSize);
		result = Math.floor(dataCount / pageSize) + (dataCount % pageSize > 0 ? 1 : 0);
	} catch (e) {
	}
	
	return result;
}

/*
	current_page : 화면에 표시할 페이지
	total_page : 전체 페이지 수
	url : 링크를 설정할 url
*/
function pagingUrl(current_page, total_page, url) {
	let result = '';
	
    let numPerBlock = 10;
    let currentPageSetup;
    let n, page;
    
    try {
    	current_page = Number(current_page);
    	total_page = Number(total_page);
		
        if(current_page < 1 || total_page < current_page) { return ''; }
        
        url += url.includes('?') ? '&' : '?';
        
        currentPageSetup = Math.floor(current_page / numPerBlock) * numPerBlock;
        if(current_page%numPerBlock === 0) {
            currentPageSetup = currentPageSetup - numPerBlock;
        }
        
        result = '<ul class="pagination justify-content-center">';
        // 처음페이지, 이전(10페이지 전)
        n = current_page - numPerBlock;
        if(total_page > numPerBlock && currentPageSetup > 0) {
        	result += '<li class="page-item"><a class="page-link" href="' + url + 'page=1" aria-label="First"><i class="bi bi-chevron-bar-left"></i></a></li>';
        	result += '<li class="page-item"><a class="page-link" href="' + url + 'page=' + n + '" aria-label="Previous"><i class="bi bi-chevron-double-left"></i></a></li>';
        }
        
        page = currentPageSetup + 1;
        while(page <= total_page && page <= (currentPageSetup + numPerBlock)) {
            if(page === current_page) {
            	result += '<li class="page-item active"><span class="page-link">' + page + '</span></li>';
            } else {
            	result += '<li class="page-item"><a class="page-link" href="' + url + 'page=' + page + '">' + page + '</a></li>';
            }
            page++;
        }
        
        // 다음(10페이지 후), 마지막페이지
        n = current_page + numPerBlock;
        if(n > total_page){ n = total_page; }
        if(total_page - currentPageSetup > numPerBlock) {
        	result += '<li class="page-item"><a class="page-link" href="' + url + 'page=' + n + '" aria-label="Next"><i class="bi bi-chevron-double-right"></i></a></li>';
        	result += '<li class="page-item"><a class="page-link" href="' + url + 'page=' + total_page + '" aria-label="Last"><i class="bi bi-chevron-bar-right"></i></a></li>';
        }
        result += '</ul>';

	} catch (e) {
	}
	
	return result;
}

/*
	current_page : 화면에 표시할 페이지
	total_page : 전체 페이지 수
	methodName : 호출할 메소드 명
*/
function pagingMethod(current_page, total_page, methodName) {
	let result = '';
	
    let numPerBlock = 10;
    let currentPageSetup;
    let n, page;
    
    try {
    	current_page = Number(current_page);
    	total_page = Number(total_page);

        if(current_page < 1 || total_page < 1) { return ''; }
        
        currentPageSetup = Math.floor(current_page / numPerBlock) * numPerBlock;
        if(current_page%numPerBlock === 0) {
            currentPageSetup = currentPageSetup-numPerBlock;
        }
        
        result = '<ul class="pagination justify-content-center">';
        // 처음페이지, 이전(10페이지 전)
        n = current_page - numPerBlock;
        if(total_page > numPerBlock && currentPageSetup > 0) {
        	result += '<li class="page-item"><a class="page-link" onclick="' + methodName + '(1);" aria-label="First"><i class="bi bi-chevron-bar-left"></i></a></li>';
        	result += '<li class="page-item"><a class="page-link" onclick="' + methodName + '(' + n + ');" aria-label="Previous"><i class="bi bi-chevron-double-left"></i></a></li>';
        }
        
        page = currentPageSetup + 1;
        while(page <= total_page && page <= (currentPageSetup + numPerBlock)) {
            if(page === current_page) {
            	result += '<li class="page-item active"><span class="page-link">' + page + '</span></li>';            	
            } else {
            	result += '<li class="page-item page-item"><a class="page-link" onclick="' + methodName + '(' + page + ');">' + page + '</a></li>';
            }
            
            page++;
        }
        
        // 다음(10페이지 후), 마지막페이지
        n = current_page + numPerBlock;
        if(n > total_page){ n = total_page; }
        if(total_page - currentPageSetup > numPerBlock) {
        	result += '<li class="page-item"><a class="page-link" onclick="' + methodName + '(' + n + ');" aria-label="Next"><i class="bi bi-chevron-double-right"></i></a></li>';
        	result += '<li class="page-item"><a class="page-link" onclick="' + methodName + '(' + total_page + ');" aria-label="Last"><i class="bi bi-chevron-bar-right"></i></a></li>';
        }
        result += '</ul>';
    	
	} catch (e) {
	}
    
    return result;
}
