package stu.kms.WebSecurity.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import stu.kms.WebSecurity.domain.Criteria;
import stu.kms.WebSecurity.domain.ReplyVO;

import java.util.List;

@Mapper
public interface ReplyMapper {

    int insert(ReplyVO vo);

    ReplyVO read(Long rno);

    int delete(Long rno);

    int update(ReplyVO vo);

    List<ReplyVO> getListWithPaging(@Param("criteria")Criteria criteria, @Param("bno") Long bno);

    int getCountByBno(Long bno);
}
