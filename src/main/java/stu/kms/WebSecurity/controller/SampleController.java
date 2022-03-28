package stu.kms.WebSecurity.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/sample")
@Slf4j
public class SampleController {

    @GetMapping("/all")
    public void doAll() {
        log.info("all");
    }

    @GetMapping("/member")
    public void doMember() {
        log.info("member");
    }

    @GetMapping("/admin")
    public void doAdmin() {
        log.info("admin");
    }


}
