package stu.kms.WebSecurity.controller;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import stu.kms.WebSecurity.domain.BoardAttachVO;
import stu.kms.WebSecurity.domain.BoardVO;
import stu.kms.WebSecurity.domain.Criteria;
import stu.kms.WebSecurity.domain.PageDTO;
import stu.kms.WebSecurity.service.BoardService;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@AllArgsConstructor
@Slf4j
@RequestMapping("/board/*")
public class BoardController {

    private BoardService service;

    @GetMapping("/list")
    public void list(Criteria criteria, Model model) {
        log.info("list : " + criteria);
        model.addAttribute("list", service.getList(criteria));
        model.addAttribute("pageMaker", new PageDTO(criteria, service.getTotal(criteria)));
    }

    @GetMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public void register() {

    }

    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public String register(BoardVO board, RedirectAttributes redirectAttributes) {
        log.info("register : " + board);
        service.register(board);
        redirectAttributes.addFlashAttribute("result", board.getBno());
        return "redirect:/board/list";
    }

    @GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno, @ModelAttribute("criteria") Criteria criteria, Model model) {
        log.info("/get or modify");
        model.addAttribute("board", service.get(bno));
    }

    @GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
        log.info("getAttachList" + bno);
        return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
    }

    @PreAuthorize("principal.username == #board.writer")
    @PostMapping("/modify")
    public String modify(BoardVO board, Criteria criteria, RedirectAttributes redirectAttributes) {
        log.info("modify : " + board);
        if (service.modify(board)) {
            redirectAttributes.addFlashAttribute("result", "success");
        }
        return "redirect:/board/list" + criteria.getListLink();
    }

    @PreAuthorize("principal.username == #writer")
    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, Criteria criteria, RedirectAttributes redirectAttributes, String writer) {
        log.info("remove " + bno);

        List<BoardAttachVO> attachList = service.getAttachList(bno);

        if (service.remove(bno)) {
            deleteFiles(attachList);

            redirectAttributes.addFlashAttribute("result", "success");
        }
//        redirectAttributes.addAttribute("pageNum", criteria.getPageNum());
//        redirectAttributes.addAttribute("amount", criteria.getAmount());
//        redirectAttributes.addAttribute("type", criteria.getType());
//        redirectAttributes.addAttribute("keyword", criteria.getKeyword());

//        return "redirect:/board/list";
        return "redirect:/board/list" + criteria.getListLink();
    }

    private void deleteFiles(List<BoardAttachVO> attachList) {

        if (attachList == null || attachList.size() == 0) return;

        attachList.forEach(attach ->{
            try {
                Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
                Files.deleteIfExists(file);

                if (Files.probeContentType(file).startsWith("image")) {
                    Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
                    Files.delete(thumbNail);
                }
            } catch (Exception e) {
                log.error("delete file error" + e.getMessage());
            }
        });
    }
}
