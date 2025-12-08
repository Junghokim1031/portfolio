package org.zerock.controller;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/board")
@Log4j2
@AllArgsConstructor
public class BoardController {

	// 주입
	private BoardService service;

	private ReplyService replyService;
	// 게시판
	/*@GetMapping("/list")
	public void list(Model model) {
		model.addAttribute("list", service.getList());
	}*/
	
	//@GetMapping("/list")
	/*public void list(Criteria cri, Model model) {
		model.addAttribute("list", service.getList(cri));
	}*/
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		model.addAttribute("list", service.getList(cri));
		int total =service.getTotal(cri);
		log.info("List: " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}

	// 등록으로 가는 링크
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {
		File uploadPath = new File("C:\\upload", "temp");
		if (!uploadPath.exists()) {uploadPath.mkdirs();}
	}

	// 등록에서 갖고 온 자료를 처리 + InsertSelectKey에서 가지고 온 BNO를 제공함.
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("Register: " + board);

		service.register(board);

		// 등록된 글번호 (result)가 list.jsp로 전달됨.
		// 일반이 아니라 flashAttribute이기 때문에 url에 없으며 url 변경 시 삭제됨
		rttr.addFlashAttribute("result", board.getBno());

		return "redirect:/board/list"; // 목록으로 이동
	}

	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("bno " + bno);
		log.info("cri " + cri);
		model.addAttribute("board", service.get(bno));
		// @ModelAttribute automatically inserts it into model.addAttribute()
	}


	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}


	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if( replyService.removeAll(bno) >= 0) {
			if (service.remove(bno)) {
				deleteFiles(attachList);
				rttr.addFlashAttribute("result", "success");
			}
			
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	@GetMapping(value="/getAttachList", produces= MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList" + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files...................");
	    log.info(attachList);
	    
	    attachList.forEach(attach -> {
	    	try {        
	    		Path file  = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());
    			Files.deleteIfExists(file);
    			if(Files.probeContentType(file).startsWith("image")) {
	    			Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
	    			Files.delete(thumbNail);
    			}
	    	}catch(Exception e) {
	    		log.error("delete file error" + e.getMessage());
	    	}//end catch
		});//end forEach
	}// END OF DELETEFILES
}
