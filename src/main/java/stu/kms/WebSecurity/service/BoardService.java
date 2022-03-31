package stu.kms.WebSecurity.service;

import stu.kms.WebSecurity.domain.BoardAttachVO;
import stu.kms.WebSecurity.domain.BoardVO;
import stu.kms.WebSecurity.domain.Criteria;

import java.util.List;

public interface BoardService {

    void register(BoardVO board);

    BoardVO get(Long bno);

    boolean modify(BoardVO board);

    boolean remove(Long bno);

    public int getTotal(Criteria criteria);

    List<BoardVO> getList(Criteria criteria);

    List<BoardAttachVO> getAttachList(Long bno);
}
