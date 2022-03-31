package stu.kms.WebSecurity.mapper;

import org.apache.ibatis.annotations.Mapper;
import stu.kms.WebSecurity.domain.BoardAttachVO;

import java.util.List;

@Mapper
public interface BoardAttachMapper {

    void insert(BoardAttachVO vo);

    void delete(String uuid);

    List<BoardAttachVO> findByBno(Long bno);

    void deleteAll(Long bno);

    List<BoardAttachVO> getOldFiles();
}
