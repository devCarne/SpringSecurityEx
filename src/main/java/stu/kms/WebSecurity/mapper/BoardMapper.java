package stu.kms.WebSecurity.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import stu.kms.WebSecurity.domain.BoardVO;
import stu.kms.WebSecurity.domain.Criteria;

import java.util.List;

@Mapper
public interface BoardMapper {

    int getTotalCount(Criteria criteria);

    List<BoardVO> getList();

    List<BoardVO> getListWithPaging(Criteria criteria);

    void insert(BoardVO board);

    void insertSelectKey(BoardVO board);

    BoardVO read(Long bno);

    int delete(Long bno);

    int update(BoardVO board);

    void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
