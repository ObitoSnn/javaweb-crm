package com.obitosnn.crm.settings.service;

import com.obitosnn.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:59
 */
public interface DicService {

    Map<String, List<DicValue>> getDicValueMap();

}
