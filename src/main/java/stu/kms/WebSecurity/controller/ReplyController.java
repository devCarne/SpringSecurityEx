package stu.kms.WebSecurity.controller;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import stu.kms.WebSecurity.domain.Criteria;
import stu.kms.WebSecurity.domain.ReplyPageDTO;
import stu.kms.WebSecurity.domain.ReplyVO;
import stu.kms.WebSecurity.service.ReplyService;


@RequestMapping("/replies/")
@RestController
@AllArgsConstructor
@Slf4j
public class ReplyController {

    private ReplyService service;

    @PreAuthorize("isAuthenticated()")
    @PostMapping(value = "/new", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
        log.info("ReplyVO : " + vo);

        int insertCount = service.register(vo);
        log.info("Reply INSERT COUNT : " + insertCount);

        return insertCount == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @GetMapping(value = "/pages/{bno}/{page}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ReplyPageDTO> getList(@PathVariable("bno") Long bno, @PathVariable("page") int page) {
        Criteria criteria = new Criteria(page, 10);
        log.info(criteria.toString());
        log.info("get Reply List bno : " + bno);

        return new ResponseEntity<>(service.getListPage(criteria, bno), HttpStatus.OK);
    }

    @GetMapping(value = "/{rno}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
        log.info("get... : " + rno);
        return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
    }

    @PreAuthorize("principal.username == #vo.replyer")
    @DeleteMapping(value = "/{rno}")
    public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
        log.info("remove... : " + rno);
        return service.remove(rno) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PreAuthorize("principal.username == #vo.replyer")
    @RequestMapping(
            method = {RequestMethod.PUT, RequestMethod.PATCH},
            value = "/{rno}",
            consumes = "application/json",
            produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> modify(@PathVariable("rno") Long rno, @RequestBody ReplyVO vo) {
        vo.setRno(rno);
        log.info("rno : " + rno);
        log.info("modify..." + vo);
        return service.modify(vo) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
