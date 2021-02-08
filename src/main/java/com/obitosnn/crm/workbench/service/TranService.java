package com.obitosnn.crm.workbench.service;


import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.workbench.domain.Tran;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 11:45
 */
public interface TranService {

    boolean saveTran(Tran tran, String customerName) throws FailToSaveException ;

}
