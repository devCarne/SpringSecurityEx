package stu.kms.WebSecurity.mapper;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import stu.kms.WebSecurity.domain.MemberVO;

@SpringBootTest
@Slf4j
public class MemberMapperTest {

    @Autowired
    private MemberMapper mapper;

    @Test
    public void testRead() {
        MemberVO vo = mapper.read("admin90");
        log.info("vo : " + vo);

        vo.getAuthList().forEach(authVO -> log.info(String.valueOf(authVO)));
    }
}
