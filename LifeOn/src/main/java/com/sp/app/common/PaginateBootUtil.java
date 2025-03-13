package com.sp.app.common;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

/*
  - @Primary
    : 빈(Bean) 자동으로 주입할 때 우선순위를 설정하는 역할
    : 동일한 타입의 여러 빈이 있을 경우, @Autowired로 자동 주입을 시도할 때 예외가 발생한다.
      이때 @Primary를 사용하면, 같은 타입의 여러 빈 중 우선적으로 사용될 빈을 명시할 수 있다.
*/
// 페이징(paging) 처리 : 부트스트랩 용
@Service(value = "paginateUtil")
@Primary
public class PaginateBootUtil extends PaginateUtil {
	/**
	 * 페이징(paging) 처리를 하는 메소드(GET 방식, a 태그를 이용하여 해당 페이지의 URL로 이동)
	 * 
	 * @param current_page	화면에 출력할 페이지 번호
	 * @param total_page	총 페이지 수
	 * @param list_url		페이지 번호에 link를 설정할 URL
	 * @return				페이징 처리 결과
	 */
	@Override
	public String paging(int current_page, int total_page, String list_url) {
		StringBuilder sb = new StringBuilder();

		int numPerBlock = 10;
		int currentPageSetup;
		int n, page;

		if (current_page < 1 || total_page < current_page) {
			return "";
		}

		list_url += list_url.contains("?") ? "&" : "?";

		// currentPageSetup : 표시할첫페이지-1
		currentPageSetup = (current_page / numPerBlock) * numPerBlock;
		if (current_page % numPerBlock == 0) {
			currentPageSetup = currentPageSetup - numPerBlock;
		}

		sb.append("<ul class='pagination justify-content-center'>");
		
		// 처음페이지
		if (current_page > 1) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, 1, "<i class='bi bi-chevron-bar-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-left'></i></a></li>");
		}
		
		// 이전(10페이지 전)
		n = current_page - numPerBlock;
		if (total_page > numPerBlock && currentPageSetup > 0) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, n, "<i class='bi bi-chevron-double-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-double-left'></i></a></li>");
		}

		// 바로가기
		page = currentPageSetup + 1;
		while (page <= total_page && page <= (currentPageSetup + numPerBlock)) {
			if (page == current_page) {
				sb.append("<li class='page-item active'><span class='page-link'>" + page + "</span></li>");
			} else {
				sb.append("<li class='page-item'>" + 
						createLinkUrl(list_url, page, String.valueOf(page)) + "</li>");
			}
			
			page++;
		}

		// 다음(10페이지 후)
		n = current_page + numPerBlock;
		if (n > total_page)
			n = total_page;
		if (total_page - currentPageSetup > numPerBlock) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, n, "<i class='bi bi-chevron-double-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-double-right'></i></a></li>");
		}
		
		// 마지막페이지
		if (current_page < total_page) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, total_page, "<i class='bi bi-chevron-bar-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-right'></i></a></li>");
		}

		sb.append("</ul>");

		return sb.toString();
	}

	/**
	 * javascript를 이용하여 페이징 처리를하는 메소드 : javascript의 지정한 함수(methodName)를 호출
	 * 
	 * @param current_page	화면에 출력할 페이지 번호
	 * @param total_page	총 페이지 수
	 * @param methodName	호출할 자바스크립트 함수명
	 * @return				페이징 처리 결과
	 */
	@Override
    public String pagingMethod(int current_page, int total_page, String methodName) {
		StringBuilder sb = new StringBuilder();

		int numPerBlock = 10; // 리스트에 나타낼 페이지 수
		int currentPageSetUp;
		int n, page;

		if (current_page < 1 || total_page < current_page) {
			return "";
		}

		// currentPageSetup : 표시할첫페이지-1
		currentPageSetUp = (current_page / numPerBlock) * numPerBlock;
		if (current_page % numPerBlock == 0) {
			currentPageSetUp = currentPageSetUp - numPerBlock;
		}

		sb.append("<ul class='pagination justify-content-center'>");

		// 처음페이지
		if (current_page > 1) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, 1, "<i class='bi bi-chevron-bar-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-left'></i></a></li>");
		}
		// 이전(10페이지 전)
		n = current_page - numPerBlock;
		if (total_page > numPerBlock && currentPageSetUp > 0) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, n, "<i class='bi bi-chevron-double-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link'  href='#' aria-disabled='true'><i class='bi bi-chevron-double-left'></i></a></li>");
		}

		// 바로가기 페이지 구현
		page = currentPageSetUp + 1;
		while (page <= total_page && page <= (currentPageSetUp + numPerBlock)) {
			if (page == current_page) {
				sb.append("<li class='page-item active'><span class='page-link' href='#'>" + page + "</span></li>");
			} else {
				sb.append("<li class='page-item'>" + 
						createLinkClick(methodName, page, String.valueOf(page)) + "</li>");
			}
			
			page++;
		}

		// 다음(10페이지 후)
		n = current_page + numPerBlock;
		if (n > total_page)
			n = total_page;
		if (total_page - currentPageSetUp > numPerBlock) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, n, "<i class='bi bi-chevron-double-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-double-right'></i></a></li>");
		}
		// 마지막 페이지
		if (current_page < total_page) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, total_page, "<i class='bi bi-chevron-bar-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-right'></i></a></li>");
		}

		sb.append("</ul>");

		return sb.toString();
    }
	
	// 화면에 표시할 페이지를 중앙에 출력
	@Override
	public String pagingUrl(int current_page, int total_page, String list_url) {
		StringBuilder sb = new StringBuilder();
		
		int numPerBlock = 10;
		int n, page;
		
		if(current_page < 1 || total_page < current_page) {
			return "";
		}
		
		list_url += list_url.contains("?") ? "&" : "?";
		
		page = 1; // 출력할 시작 페이지
		if(current_page > (numPerBlock / 2) + 1) {
			page = current_page - (numPerBlock / 2) ;
			
			n = total_page - page;
			if( n < numPerBlock ) {
				page = total_page - numPerBlock + 1;
			}
			
			if(page < 1) page = 1;
		}
		
		sb.append("<ul class='pagination justify-content-center'>");
		
		// 처음페이지
		if(page > 1) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, 1, "<i class='bi bi-chevron-bar-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-left'></i></a></li>");
		}

		// 이전(한페이지 전)
		n = current_page - 1;
		if(current_page > 1) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, n, "<i class='bi bi-chevron-double-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-double-left'></i></a></li>");
		}

		n = page;
		while(page <= total_page && page < n + numPerBlock) {
			if(page == current_page) {
				sb.append("<li class='page-item active'><span class='page-link'>" + page + "</span></li>");
			} else {
				sb.append("<li class='page-item'>" + 
						createLinkUrl(list_url, page, String.valueOf(page)) + "</li>");
			}
			
			page++;
		}

		// 다음(한페이지 다음)
		n = current_page + 1;
		if(current_page < total_page) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, n, "<i class='bi bi-chevron-double-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-double-right'></i></a></li>");
		}

		// 마지막페이지
		if(page <= total_page) {
			sb.append("<li class='page-item'>" + 
					createLinkUrl(list_url, total_page, "<i class='bi bi-chevron-bar-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-right'></i></a></li>");
		}
		
		sb.append("</ul>");
		
		return sb.toString();
	}

	// 화면에 표시할 페이지를 중앙에 출력 : javascript 함수 호출
	@Override
	public String pagingFunc(int current_page, int total_page, String methodName) {
		StringBuilder sb = new StringBuilder();
		
		int numPerBlock = 10;
		int n, page;
		
		if(current_page < 1 || total_page < current_page) {
			return "";
		}
		
		page = 1; // 출력할 시작 페이지
		if(current_page > (numPerBlock / 2) + 1) {
			page = current_page - (numPerBlock / 2) ;
			
			n = total_page - page;
			if( n < numPerBlock ) {
				page = total_page - numPerBlock + 1;
			}
			
			if(page < 1) page = 1;
		}
		
		sb.append("<ul class='pagination justify-content-center'>");
		
		// 처음페이지
		if(page > 1) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, 1, "<i class='bi bi-chevron-bar-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-left'></i></a></li>");
		}

		// 이전(한페이지 전)
		n = current_page - 1;
		if(current_page > 1) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, n, "<i class='bi bi-chevron-double-left'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link'  href='#' aria-disabled='true'><i class='bi bi-chevron-double-left'></i></a></li>");
		}

		n = page;
		while(page <= total_page && page < n + numPerBlock) {
			if(page == current_page) {
				sb.append("<li class='page-item active'><span class='page-link' href='#'>" + page + "</span></li>");
			} else {
				sb.append("<li class='page-item'>" + 
						createLinkClick(methodName, page, String.valueOf(page)) + "</li>");
			}
			
			page++;
		}

		// 다음(한페이지 다음)
		n = current_page + 1;
		if(current_page < total_page) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, n, "<i class='bi bi-chevron-double-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-double-right'></i></a></li>");
		}

		// 마지막페이지
		if(page <= total_page) {
			sb.append("<li class='page-item'>" + 
					createLinkClick(methodName, total_page, "<i class='bi bi-chevron-bar-right'></i>") + "</li>");
		} else {
			sb.append("<li class='page-item disabled'><a class='page-link' href='#' aria-disabled='true'><i class='bi bi-chevron-bar-right'></i></a></li>");
		}
		
		sb.append("</ul>");
		
		return sb.toString();
	}
}
