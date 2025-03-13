package com.sp.app.common;

public abstract class PaginateUtil {
	/**
	 * 전체 페이지수를 구하는 메소드
	 * 
	 * @param dataCount		총 데이터 개수
	 * @param size			한 화면에 출력할 데이터 개수
	 * @return				총 페이지 수
	 */
	public int pageCount(int dataCount, int size) {
		if(dataCount <= 0) {
			return 0;
		}
	
		return dataCount / size + (dataCount % size > 0 ? 1 : 0);
	}
    
    protected String createLinkUrl(String url, int page, String label) {
        return "<a href='" + url + "page=" + page + "' class='page-link'>" + label + "</a>";
    }

    protected String createLinkClick(String methodName, int page, String label) {
        return "<a onclick='" + methodName + "(" + page + ");' class='page-link'>" + label + "</a>";
    }
    
	public abstract String paging(int current_page, int total_page, String list_url);
    public abstract String pagingMethod(int current_page, int total_page, String methodName);
    
	public abstract String pagingUrl(int current_page, int total_page, String list_url);
	public abstract String pagingFunc(int current_page, int total_page, String methodName);
}
