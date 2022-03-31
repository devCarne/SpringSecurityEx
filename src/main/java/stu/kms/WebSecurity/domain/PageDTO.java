package stu.kms.WebSecurity.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    private int startPage;
    private int endPage;
    private boolean prev;
    private boolean next;
    private int total;
    private Criteria criteria;

    public PageDTO(Criteria criteria, int total) {
        this.criteria = criteria;
        this.total = total;
        int realEnd = (int) (Math.ceil((total * 1.0) / criteria.getAmount()));

        this.endPage = (int) (Math.ceil(criteria.getPageNum() / 10.0)) * 10;
        this.startPage = this.endPage - 9;

        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }

        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;
    }
}
