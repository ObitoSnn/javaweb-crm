package com.obitosnn.crm.workbench.dao;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:55
 */
public interface ActivityRemarkDao {

    Integer selectByIds(String[] ids);

    Integer deleteByIds(String[] ids);

}
