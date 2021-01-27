package com.obitosnn.crm.vo;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/27 13:30
 */
public class PageVo<T> {
    private Long total;//总记录数
    private List<T> dataList;//传给页面的数据

    public PageVo() {
    }

    public PageVo(Long total, List<T> dataList) {
        this.total = total;
        this.dataList = dataList;
    }

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    @Override
    public String toString() {
        return "PageVo{" +
                "total=" + total +
                ", dataList=" + dataList +
                '}';
    }
}
