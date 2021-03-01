package com.obitosnn.crm.settings.service;

import com.obitosnn.crm.settings.domain.Dept;
import com.obitosnn.crm.vo.PageVo;

import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:45
 */
public interface DeptService {

    PageVo<Dept> getDeptPageVo(Map<String, Object> map);

}
