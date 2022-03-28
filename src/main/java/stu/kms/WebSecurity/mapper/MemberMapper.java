package stu.kms.WebSecurity.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import stu.kms.WebSecurity.domain.MemberVO;

@Mapper
@Repository
public interface MemberMapper {

    MemberVO read(String userid);
}
