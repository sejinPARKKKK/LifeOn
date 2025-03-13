package com.sp.app.image;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sp.app.common.StorageService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/image/*")
public class ImageController {
	private final StorageService storageService;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		this.uploadPath = storageService.getRealPath("/uploads/image");
	}
	
	// HTML 5 upload
	@RequestMapping(value = "html5Upload", method = {RequestMethod.GET, RequestMethod.POST})
	public void html5Upload(HttpServletRequest req,
			HttpServletResponse resp) throws Exception {
			
			try {
			    String cp = req.getContextPath();
			    
			    String strUrl = "";
			    if(!"OPTIONS".equals(req.getMethod().toUpperCase())) {
			    	String filename = req.getHeader("file-name");
			    	
			    	InputStream is = req.getInputStream();
			    	String saveFilename = storageService.uploadFileToServer(is, filename, uploadPath);
			    	
					strUrl += "&bNewLine=true"; 
	                strUrl += "&sFileName=" + saveFilename;
	                // strUrl += "&sWidth=600";
	                strUrl += "&sFileURL=" + cp + "/uploads/image/" + saveFilename;
			    }
				
				PrintWriter out = resp.getWriter();
				out.print(strUrl);
			} catch (IOException e) {
				e.printStackTrace();
			}
	}

	// HTML 5을 지원하지 않는 브라우저
	@RequestMapping(value = "generalUpload", method = {RequestMethod.GET, RequestMethod.POST})
	public String generalUpload(Image image,
			HttpServletRequest req) throws Exception {
		
			String strUrl = image.getCallback() + "?callback_func=" + image.getCallback_func();
			boolean flag = false;
			try {
				String cp = req.getContextPath();
				
			    String saveFilename = storageService.uploadFileToServer(image.getFiledata(), uploadPath);
			    
			    if(saveFilename != null) {
			    	strUrl += "&bNewLine=true"; 
			    	strUrl += "&sFileName=" + saveFilename;
	                // strUrl += "&sWidth=600";
	                strUrl += "&sFileURL=" + cp + "/uploads/image/" + saveFilename;
	                
	                flag = true;
			    }
				
			} catch (Exception e) {
				e.printStackTrace();
			}

			if(! flag) {
				strUrl += "&errstr=error";
			}
			
			return "redirect:" + strUrl;
	}
}
