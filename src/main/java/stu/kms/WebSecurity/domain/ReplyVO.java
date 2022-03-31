package stu.kms.WebSecurity.domain;

import lombok.Data;

import java.util.Date;

@Data
public class ReplyVO {
    private long rno;
    private long bno;

    private String reply;
    private String replyer;

    private Date replyDate;
    private Date updateDate;
}
