package stu.kms.WebSecurity.service;

import stu.kms.WebSecurity.domain.Criteria;
import stu.kms.WebSecurity.domain.ReplyPageDTO;
import stu.kms.WebSecurity.domain.ReplyVO;

import java.util.List;

public interface ReplyService {
    int register(ReplyVO vo);

    ReplyVO get(Long rno);

    int modify(ReplyVO vo);

    int remove(Long rno);

    List<ReplyVO> getList(Criteria criteria, Long bno);

    ReplyPageDTO getListPage(Criteria criteria, Long bno);
}
