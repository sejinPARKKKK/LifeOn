package com.sp.app.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.admin.service.VisitorLogService;
import com.sp.app.model.Member;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.CoolSmsService;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberController {
	private final MemberService service;
	private final CoolSmsService coolSmsService;

	

	@GetMapping("login")
	public String login() {
		return "member/login";
				
	}

	
	@PostMapping("login")
	public String loginSubmit(@RequestParam(name = "id") String id,
			@RequestParam(name = "pwd") String pwd,
			Model model, HttpSession session) throws Exception {
		
		service.updateLastLogin(id);
		Member dto = service.loginMember(id);
		if(dto == null || !pwd.equals(dto.getPwd())) {
			model.addAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "member/login"; //모달로 처리하니까 생각 다시해봐
		}
		
		/* 빌더로 정보 저장 하는 경우
		SessionInfo info = SessionInfo.builder()
				.id(dto.getId())
				.nickName(dto.getNickName())
				.grade(dto.getGrade())
				.build();
		*/	
		
		SessionInfo info = new SessionInfo();
		info.setId(dto.getId());
		info.setNickName(dto.getNickName());
		info.setGrade(dto.getGrade());
		info.setNum(dto.getNum());
		info.setLast_login(dto.getLast_login());
		info.setProfile_image(dto.getProfile_image());
	
		session.setMaxInactiveInterval(60 * 60); // 세션 유지시간 60분
		session.setAttribute("member", info);
		
		
		// 로그인 이전 주소로 이동
		String uri = (String) session.getAttribute("preLoginURI");
		session.removeAttribute("preLoginURI");
		if (uri == null) {
			uri = "redirect:/";
		} else {
			uri = "redirect:" + uri;
		}

		return uri;	
	}
	
	//로그아웃
	@GetMapping("logout")
	public String logout(HttpSession session) {
		
		session.removeAttribute("member");
		session.invalidate();
		return "redirect:/";
	}
	
	//회원가입
	@GetMapping("join")
	public String memberForm(Model model) {
		model.addAttribute("mode", "join");
		
		return "member/member";
	}
	
	@PostMapping("join")
	public String memberSubmit(@RequestParam(value = "profileImageFile", required = false) MultipartFile file,
			Member dto,
			final RedirectAttributes reAttr,
			Model model,
			HttpServletRequest req,
			HttpSession session) {
		try {
			String profileImagePath = null;
			
			if (file != null && !file.isEmpty()) {
	
			    String uploadDir = session.getServletContext().getRealPath("/uploads/profile");
			    File dir = new File(uploadDir);
			    if (!dir.exists()) dir.mkdirs(); // 디렉토리 없으면 생성

			    // 파일중복없애자
			    String extension = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
			    String fileName = UUID.randomUUID().toString() + System.currentTimeMillis()+extension;
			    File saveFile = new File(uploadDir, fileName);
			    file.transferTo(saveFile);

			    profileImagePath = "/uploads/profile/" + fileName;
			}

			
			dto.setProfile_image((profileImagePath != null) ? profileImagePath : "/dist/images/basicpro.png");

	        
	        System.out.println("파일 업로드 완료 - 저장된 경로: " + profileImagePath);
	        System.out.println("DTO에 저장된 profile_image: " + dto.getProfile_image());
	        
			service.insertMember(dto);
			
			
			
			StringBuilder sb = new StringBuilder();
			sb.append(dto.getName() + "님의 회원 가입이 정상적으로 처리되었습니다.<br>");
			sb.append("메인화면으로 이동하여 로그인 하시기 바랍니다.<br>");			
			
			reAttr.addFlashAttribute("message", sb.toString());
			reAttr.addFlashAttribute("title", "회원 가입");

			return "redirect:/member/complete";			
			
		} catch (Exception e) {
			model.addAttribute("mode", "join");
			model.addAttribute("message", "회원가입이 실패했습니다.");
		}
		
		
		
		return "member/member";
	}
	
	//성공했을경우
	@GetMapping("complete")
	public String complete(@ModelAttribute("message") String message) throws Exception {

		// 컴플릿 페이지(complete.jsp)의 출력되는 message와 title는 RedirectAttributes 값이다.
		// F5를 눌러 새로 고침을 하면 null이 된다.

		if (message == null || message.length() == 0) { // F5를 누른 경우
			return "redirect:/";
		}

		return "member/complete";
	}	
	
	@GetMapping("pwd")
	public String pwdForm(@RequestParam(name="mode", required = false) String mode,
			Model model) {
		if(mode == null) {
			model.addAttribute("mode", "update"); //정보수정
		} else {
			model.addAttribute("mode", "retire"); //회원탈퇴
		}
		
		return "member/pwd";
	}
	
	@PostMapping("pwd")
	public String pwdSubmit(@RequestParam(name = "pwd") String pwd,
			@RequestParam(name = "mode") String mode,
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {
		
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		try {
			Member dto = Objects.requireNonNull(service.findById(info.getId()));
			
			if(! dto.getPwd().equals(pwd)) { // 패스워드 일치하지 않을경우 !! 횟수제한처리할거면 여기서
				model.addAttribute(mode, "mode");
				model.addAttribute("message", "패스워드가 일치하지 않습니다.");
				return "member/pwd";
			}
			
			if(mode.equals("retire")) { //회원탈퇴 처리
				
				//그 회원관련 게시판 등 자료 삭제 처리 보류
				
				Map<String, Object> map = new HashMap<>();
				map.put("num", info.getNum());
				service.deleteMember(map);
				session.removeAttribute("member");
				session.invalidate();
				
				StringBuilder sb = new StringBuilder();
				sb.append(dto.getId() + "님의 회원 탈퇴 처리가 정상적으로 처리되었습니다.<br>");
				sb.append("메인화면으로 이동 하시기 바랍니다.<br>");

				reAttr.addFlashAttribute("title", "회원 탈퇴");
				reAttr.addFlashAttribute("message", sb.toString());

				return "redirect:/member/complete";					
			}
			
			//회원정보수정
			model.addAttribute("dto", dto);
			model.addAttribute("mode", "update");
			
			System.out.println("Updating member with num: " + dto.getNum());

			return "member/member";			
		
		} catch (NullPointerException e) {
			session.invalidate();
		} catch (Exception e) {
		}
		
		return "redirect:/";
	}
	
	//회원정보수정
	@PostMapping("update")
	public String updateSubmit(@RequestParam(value = "profileImageFile", required = false) MultipartFile file,
			Member dto,
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {
		
		StringBuilder sb = new StringBuilder();
		try {
			
	        String profileImagePath = dto.getProfile_image();
	        String uploadDir = session.getServletContext().getRealPath("/uploads/profile");
	        
	        // 기존 파일 존재시
	        if (file != null && !file.isEmpty()) {
	
	            if (profileImagePath != null && !profileImagePath.equals("/dist/images/basicpro.png")) {
	                File existingFile = new File(session.getServletContext().getRealPath(profileImagePath));

	                if (existingFile.exists()) {
	                    existingFile.delete();  // 기존 파일 삭제
	                }
	            }

	            // 새 이미지 저장 271줄이 확장자 가져오는거임
	            String extension = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
	            String fileName = UUID.randomUUID().toString() + System.currentTimeMillis() + extension;
	            File saveFile = new File(uploadDir, fileName);
	            file.transferTo(saveFile);  // 파일 업로드

	            profileImagePath = "/uploads/profile/" + fileName;
	        } 
	        
	        dto.setProfile_image((profileImagePath != null) ? profileImagePath : "/dist/images/basicpro.png");
	        
			service.updateMember(dto);
			
			sb.append(dto.getId() + "님의 회원정보가 정상적으로 변경되었습니다.<br>");
			sb.append("메인화면으로 이동 하시기 바랍니다.<br>");
			
		} catch (Exception e) {
			sb.append(dto.getName() + "님의 회원정보 변경이 실패했습니다.<br>");
			sb.append("잠시후 다시 변경 하시기 바랍니다.<br>");
			sb.append("오류 메시지: " + e.getMessage() + "<br>"); // 예외 메시지 출력
			e.printStackTrace();
		}
		
		reAttr.addFlashAttribute("title", "회원 정보 수정");
		reAttr.addFlashAttribute("message", sb.toString());
		return "redirect:/member/complete";
	}
	
	
	//아이디 중복검사
	@ResponseBody
	@PostMapping("idCheck")
	public Map<String, ?> idCheck(@RequestParam(name="id") String id) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String p = "false";
		try {
			Member dto = service.findById(id);
			if(dto == null) {
				p = "true";
			}
		} catch (Exception e) {
		}
		
		model.put("passed", p);
		
		return model;
	}
	
	//닉네임 중복검사
	@ResponseBody
	@PostMapping("nickNameCheck")
	public Map<String, ?> nickNameCheck(@RequestParam(name="nickName") String nickName) throws Exception{
		Map<String, Object> model = new HashMap<>();
		
		String p = "false";
		try {
			Member dto = service.findByNickName(nickName);
			if(dto == null) {
				p = "true";
			}
		} catch (Exception e) {
		}
		
		model.put("passed", p);
		
		return model;
	}
	
	
	
	//인증번호 전송 api
	@ResponseBody
	@PostMapping("sendAuthCode")
	public Map<String, Object> sendAuthCode(@RequestParam(value ="tel") String tel, HttpSession session){
		Map<String, Object> model = new HashMap<>();
		
		Random random = new Random();
		String authCode  = String.format("%06d", random.nextInt(1000000));
		
		try {
			session.setAttribute("tel", tel);
			session.setAttribute("authCode", authCode );
			LocalDateTime expireTime = LocalDateTime.now().plusMinutes(5);
	        session.setAttribute("authExpireTime", expireTime);
	        
	        //자바스크립트에서 인식가능하게 utc 문자열?
	        String formattedExpireTime = expireTime.atZone(ZoneId.systemDefault()).toInstant().toString(); 
	        
			String message = "[LifeOn]인증번호 : " + authCode;
			coolSmsService.sendSms(tel, message);
			
			
			model.put("success", true);
			model.put("message", "인증번호가 전송되었습니다");
		    model.put("expireTime", formattedExpireTime);	
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("message", "인증번호 전송에 실패했습니다.");
		}
		
		return model;
	}

	
	
	//아이디찾기
	@GetMapping("idFind")
	public String idFindForm() {
		return "member/idFind";
	}
	
	//아이디찾기 (휴대폰 번호 비교)
	@ResponseBody
	@PostMapping("idFind")
	public Map<String, ?> idFindSubmit(@RequestParam(name= "tel") String tel) throws Exception {
		Map<String, Object> model = new HashMap<>();
		String p = "false";
		try {
			String tel1 = tel.substring(0, 3);
			String tel2 = tel.substring(3, 7);
			String tel3 = tel.substring(7);
			Member dto = service.findByTel(tel1, tel2, tel3);
			if(dto != null) {
				p = "true";
			}
		} catch (Exception e) {
		}
		
		model.put("telchecked", p);
		
		return model;
	}
	
	//인증번호 확인(아이디찾기)
	@PostMapping("authCodeCheckId")
	public String authCodeCheckId(@RequestParam("authCode") String inputCode, 
			HttpSession session, 
			RedirectAttributes redirectAttributes) {
	    
	    String code = (String) session.getAttribute("authCode");
	    LocalDateTime expireTime = (LocalDateTime) session.getAttribute("authExpireTime");

	    // 인증번호 만료 또는 세션 없음
	    if (code == null || expireTime == null || LocalDateTime.now().isAfter(expireTime)) {
	        redirectAttributes.addFlashAttribute("message", "인증번호가 만료되었습니다. 다시 요청해주세요.");
	        return "redirect:/member/idFind";
	    }

	    // 입력한 인증번호 검증
	    if (code.equals(inputCode)) {

	        String tel = (String) session.getAttribute("tel");
	        if (tel != null) {
	            String tel1 = tel.substring(0, 3);
	            String tel2 = tel.substring(3, 7);
	            String tel3 = tel.substring(7);
	            Member dto = service.findByTel(tel1, tel2, tel3);

	            if (dto != null) {
	                session.setAttribute("id", dto.getId());
	                return "redirect:/member/idFindComplete"; 
	            }
	        }
	    }

	    redirectAttributes.addFlashAttribute("message", "인증번호가 틀렸습니다. 처음부터 다시하세요");
	    return "redirect:/member/idFind";
	}

	//아이디찾기성공
	@GetMapping("idFindComplete")
	public String idFindComplete() {
		return "member/idFindComplete";
	}
	
	
	
	
	
	//비밀번호찾기
	@GetMapping("pwdFind")
	public String pwdFind() {
		return "member/pwdFind";
	}
	
	//비밀번호 찾기 (아이디랑 번호 다 비교해봐야됨) -> 아이디 찾고 그 아이디의 번호랑 입력받은 번호가 같으면 같은사람!!
	@ResponseBody
	@PostMapping("pwdFind")
	public Map<String, ?> pwdFindSubmit(@RequestParam(name = "id") String id,
			@RequestParam(name = "tel") String tel ) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String p = "false";
		long num = 0;
		try {
			Member dto = service.findById(id);
			if(dto == null) {
				p = "fuck"; //일치하는 아이디 없을때 처리할 로직
			}
			String tel1 = tel.substring(0,3);
			String tel2 = tel.substring(3,7);
			String tel3 = tel.substring(7);
			
			if(dto.getTel1().equals(tel1) && dto.getTel2().equals(tel2) && dto.getTel3().equals(tel3)) {
				p = "true";
				num = dto.getNum();
			}
			
		} catch (Exception e) {
		}
		
		model.put("checking", p);
		model.put("num", num); //나중에 비밀번호 재설정시 필요
		return model;
	}

	//인증번호 확인(비밀번호재설정)
	@PostMapping("authCodeCheckPwd")
	public String authCodeCheckPwd(@RequestParam(name = "authCode") String inputCode,
			@RequestParam(name = "num") long num,
			HttpSession session,
			Model model,
			RedirectAttributes redirectAttributes) {
		
		String code = (String) session.getAttribute("authCode");
		LocalDateTime expireTime = (LocalDateTime) session.getAttribute("authExpireTime");
		
		if(code == null || expireTime == null || LocalDateTime.now().isAfter(expireTime)) {
			redirectAttributes.addFlashAttribute("message","인증번호가 만료되었습니다. 다시 요청해주세요");
			return "redirect:/member/pwdFind";
		}
		
		//인증번호 검증(맞으면 pwdSet으로)
		if(code.equals(inputCode)) {
			model.addAttribute("num", num); 
			return "member/pwdSet";
		}
		
		redirectAttributes.addFlashAttribute("message", "인증번호가 틀렸습니다. 처음부터 다시하세요");
		return "redirect:/member/pwdFind";
		
	}
	
	
	//비밀번호재설정
	@PostMapping("pwdSet")
	public String pwdSet(Member dto) {
		
		try {
			service.updateMemberTel(dto);
		} catch (Exception e) {
		}
		
		return "member/pwdSetComplete";
	}
	
	@GetMapping("pwdSetComplete")
	public String aa() {
		return "member/pwdSetComplete";
	}
}
