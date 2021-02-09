package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.CustomerDao;
import com.obitosnn.crm.workbench.dao.TranDao;
import com.obitosnn.crm.workbench.dao.TranHistoryDao;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.domain.Tran;
import com.obitosnn.crm.workbench.domain.TranHistory;
import com.obitosnn.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 11:45
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;
    @Autowired
    private CustomerDao customerDao;

    @Override
    public boolean saveTran(Tran tran, String customerName) throws FailToSaveException {
        Customer customer = customerDao.selectByName(customerName);
        if (customer == null) {
            //创建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setDescription(tran.getDescription());
            Integer insertCustomerCount = customerDao.insert(customer);
            if (insertCustomerCount.compareTo(1) != 0) {
                throw new FailToSaveException("保存客户失败");
            }
        }
        tran.setCustomerId(customer.getId());
        Integer insertTranCount = tranDao.insert(tran);
        if (insertTranCount.compareTo(1) != 0) {
            throw new FailToSaveException("保存交易失败");
        }
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setTranId(tran.getId());
        Integer insertTranHistoryCount = tranHistoryDao.insert(tranHistory);
        if (insertTranHistoryCount.compareTo(1) != 0) {
            throw new FailToSaveException("保存交易历史失败");
        }
        return true;
    }

    @Override
    public PageVo<Tran> getTranPageVo(Map<String, Object> map) {
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize =  Integer.parseInt((String) map.get("pageSize"));
        PageHelper.startPage(pageNo, pageSize);
        List<Tran> aList = tranDao.selectTranListForPageVo(map);
        PageVo<Tran> pageVo = new PageVo<>();
        Long total = tranDao.selectTranTotalForPageVo(map);
        pageVo.setTotal(total);
        pageVo.setDataList(aList);
        return pageVo;
    }

    @Override
    public Tran getTranById(String id) {
        return tranDao.selectTranById(id);
    }

    @Override
    public Tran getActivityIdAndContactsIdByTranId(String id) {
        return tranDao.selectTranForActivityIdAndContactsId(id);
    }

    @Override
    public boolean updateTran(Tran tran, String customerName, String editBy) throws FailToSaveException, FailToUpdateException {
        Customer customer = customerDao.selectByName(customerName);
        if (customer == null) {
            //创建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(editBy);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setDescription(tran.getDescription());
            Integer insertCustomerCount = customerDao.insert(customer);
            if (insertCustomerCount.compareTo(1) != 0) {
                throw new FailToSaveException("保存客户失败");
            }
        }
        tran.setCustomerId(customer.getId());
        tran.setEditBy(editBy);
        tran.setEditTime(DateTimeUtil.getSysTime());
        Integer updateTranCount = tranDao.updateById(tran);
        if (updateTranCount.compareTo(1) != 0) {
            throw new FailToUpdateException("修改交易失败");
        }
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(editBy);
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setTranId(tran.getId());
        Integer insertTranHistoryCount = tranHistoryDao.insert(tranHistory);
        if (insertTranHistoryCount.compareTo(1) != 0) {
            throw new FailToSaveException("保存交易历史失败");
        }
        return true;
    }

    @Override
    public boolean deleteTranById(String id) throws FailToDeleteException {
        Integer count = tranDao.deleteById(id);
        if (count.compareTo(1) != 0) {
            throw new FailToDeleteException("删除交易失败");
        }
        return true;
    }

}
