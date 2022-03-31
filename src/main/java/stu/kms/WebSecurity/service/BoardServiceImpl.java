package stu.kms.WebSecurity.service;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import stu.kms.WebSecurity.domain.BoardAttachVO;
import stu.kms.WebSecurity.domain.BoardVO;
import stu.kms.WebSecurity.domain.Criteria;
import stu.kms.WebSecurity.mapper.BoardAttachMapper;
import stu.kms.WebSecurity.mapper.BoardMapper;

import java.util.List;

@Slf4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{

    @Setter(onMethod_ = @Autowired)
    private BoardMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private BoardAttachMapper attachMapper;

    @Transactional
    @Override
    public void register(BoardVO board) {
        log.info("register ... " + board);
        mapper.insertSelectKey(board);

        if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
            return;
        }

        board.getAttachList().forEach(attach -> {
            attach.setBno(board.getBno());
            attachMapper.insert(attach);
        });
    }

    @Override
    public BoardVO get(Long bno) {
        log.info("get..." + bno);
        return mapper.read(bno);
    }

    @Transactional
    @Override
    public boolean modify(BoardVO board) {
        log.info("modify..." + board);

        attachMapper.deleteAll(board.getBno());

        boolean modifyResult = mapper.update(board) == 1;

        if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
            for (BoardAttachVO attach : board.getAttachList()) {
                attach.setBno(board.getBno());
                attachMapper.insert(attach);
            }
        }
        return modifyResult;
    }

    @Transactional
    @Override
    public boolean remove(Long bno) {
        log.info("remove..." + bno);

        attachMapper.deleteAll(bno);

        return mapper.delete(bno) == 1;
    }

    @Override
    public int getTotal(Criteria criteria) {
        log.info("get total count");
        return mapper.getTotalCount(criteria);
    }

    @Override
    public List<BoardVO> getList(Criteria criteria) {
        log.info("getList with Criteria..." + criteria);
        return mapper.getListWithPaging(criteria);
    }

    @Override
    public List<BoardAttachVO> getAttachList(Long bno) {
        log.info("get Attach list by bno..." + bno);
        return attachMapper.findByBno(bno);
    }
}
