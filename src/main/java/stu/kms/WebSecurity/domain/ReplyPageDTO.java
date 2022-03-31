package stu.kms.WebSecurity.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ReplyPageDTO {
    private int replyCnt;
    private List<ReplyVO> list;
}
