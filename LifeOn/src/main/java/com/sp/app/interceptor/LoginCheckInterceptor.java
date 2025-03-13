package com.sp.app.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.sp.app.model.SessionInfo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.List;

/*
  - HandlerInterceptor
    : 컨트롤러가 요청하기 전과 후에
      반복적인 기능을 수행할수 있도록 하기 위한 인터페이스
*/
@Slf4j
public class LoginCheckInterceptor implements HandlerInterceptor {

	// 로그인이 필요 없는 URL 목록
	private static final List<String> EXCLUDE_URLS = Arrays.asList(
			"/auction","/market/together/main"
	);

	/*
       - 클라이언트 요청이 컨트롤러에 도착하기 전에 호출
       - false 를 리턴하면 HandlerInterceptor
         또는 컨트롤러를 실행하지 않고 요청을 종료
    */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		boolean result = true;

		try {
			String uri = request.getRequestURI();
			// 요청 URI가 제외 목록에 있는지 확인
			if (EXCLUDE_URLS.stream().anyMatch(uri::startsWith)) {
				return true;
			}

			HttpSession session = request.getSession();
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			String cp = request.getContextPath();
			String qs = request.getQueryString();

			if (info == null) {
				// 로그인 되어 있지 않은 경우
				result = false;

				if (isAjaxRequest(request)) {
					response.sendError(401);
				} else {
					if (uri.indexOf(cp) == 0) {
						uri = uri.substring(request.getContextPath().length());
					}

					if (qs != null) {
						uri += "?" + qs;
					}

					session.setAttribute("preLoginURI", uri);
					response.sendRedirect(cp + "/member/login");
				}

			} else {
                /*
                // 로그인 된 경우
                if(uri.indexOf("admin") != -1 && info.getGrade() == 0) {
                    result = false;

                    response.sendRedirect(cp + "/member/noAuthorized");
                }
                */

			}

		} catch (Exception e) {
			log.info("preHandle : ", e);
		}

		return result;
	}

	/*
     - 컨트롤러가 요청을 처리한 후에 호출
     - 컨트롤러 실행중 예외가 발생하면 실행하지 않음
     */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
						   ModelAndView modelAndView) throws Exception {
	}

	/*
     - 클라이언트의 요청을 처리한 후,
       뷰를 통해 클라이언트에 응답을 전송한 뒤에 실행
     - 컨트롤러 처리 중 또는 뷰를 생성하는 과정에서 예외가 발생해도 실행
     */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

	// AJAX 요청인지 확인하기 위한 메소드
	private boolean isAjaxRequest(HttpServletRequest req) {
		// AJAX 요청을 할때 header에 AJAX라는 이름으로 true를 전송
		String header = req.getHeader("AJAX");

		return header != null && header.equals("true");
	}

}