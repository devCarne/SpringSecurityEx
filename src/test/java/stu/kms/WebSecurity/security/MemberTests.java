package stu.kms.WebSecurity.security;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;

@SpringBootTest
public class MemberTests {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private DataSource dataSource;

    @Test
    public void testInsertMember() {
        String sql = "insert into tbl_member (userid, userpw, username) values (?,?,?)";

        for (int i = 0; i < 100; i++) {
            Connection connection = null;
            PreparedStatement pstmt = null;

            try {
                connection = dataSource.getConnection();
                pstmt = connection.prepareStatement(sql);

                pstmt.setString(2, passwordEncoder.encode("pw" + i));

                if (i < 80) {
                    pstmt.setString(1, "user" + i);
                    pstmt.setString(3, "일반사용자" + i);
                } else if (i < 90) {
                    pstmt.setString(1, "manager" + i);
                    pstmt.setString(3, "운영자" + i);
                } else {
                    pstmt.setString(1, "admin" + i);
                    pstmt.setString(3, "관리자" + i);
                }

                pstmt.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if(pstmt != null) try {pstmt.close();} catch (Exception ignored) {}
                if(connection != null) try {connection.close();} catch (Exception ignored) {}
            }
        }
    }

    @Test
    public void testInsertAuth() {
        String sql = "insert into TBL_MEMBER_AUTH (userid, auth) values (?,?)";

        for (int i = 0; i < 100; i++) {
            Connection connection = null;
            PreparedStatement pstmt = null;

            try {
                connection = dataSource.getConnection();
                pstmt = connection.prepareStatement(sql);

                if (i < 80) {
                    pstmt.setString(1, "user" + i);
                    pstmt.setString(2, "ROLE_USER");
                } else if (i < 90) {
                    pstmt.setString(1, "manager" + i);
                    pstmt.setString(2, "ROLE_MANAGER");
                } else {
                    pstmt.setString(1, "admin" + i);
                    pstmt.setString(2, "ROLE_ADMIN");
                }

                pstmt.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if(pstmt != null) try {pstmt.close();} catch (Exception ignored) {}
                if(connection != null) try {connection.close();} catch (Exception ignored) {}
            }
        }
    }
}
