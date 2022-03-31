package stu.kms.WebSecurity.service;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import stu.kms.WebSecurity.domain.Criteria;
import stu.kms.WebSecurity.domain.ReplyPageDTO;
import stu.kms.WebSecurity.domain.ReplyVO;
import stu.kms.WebSecurity.mapper.BoardMapper;
import stu.kms.WebSecurity.mapper.ReplyMapper;

import java.util.List;

@Service
@AllArgsConstructor
@Slf4j
public class ReplyServiceImpl implements ReplyService{

    @Setter(onMethod_ = {@Autowired})
    private ReplyMapper mapper;

    @Setter(onMethod_ = {@Autowired})
    private BoardMapper boardMapper;

    @Transactional
    @Override
    public int register(ReplyVO vo) {
        log.info("register..." + vo);

        boardMapper.updateReplyCnt(vo.getBno(), 1);
        return mapper.insert(vo);
    }

    @Override
    public ReplyVO get(Long rno) {
        log.info("get..." + rno);
        return mapper.read(rno);
    }

    @Override
    public int modify(ReplyVO vo) {
        log.info("modify..." + vo);
        return mapper.update(vo);
    }

    @Transactional
    @Override
    public int remove(Long rno) {
        log.info("remove..." + rno);

        ReplyVO reply = mapper.read(rno);
        boardMapper.updateReplyCnt(reply.getBno(), -1);

        return mapper.delete(rno);
    }

    @Override
    public List<ReplyVO> getList(Criteria criteria, Long bno) {
        log.info("get replies from a board..." + bno);
        return mapper.getListWithPaging(criteria, bno);
    }

    @Override
    public ReplyPageDTO getListPage(Criteria criteria, Long bno) {
        return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(criteria, bno));
    }
}
