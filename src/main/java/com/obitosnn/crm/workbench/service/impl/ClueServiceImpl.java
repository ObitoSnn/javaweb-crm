package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.*;
import com.obitosnn.crm.workbench.domain.*;
import com.obitosnn.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:11
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueDao clueDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public boolean saveClue(Clue clue) throws FailToSaveException {
        Integer count = clueDao.insertClue(clue);
        if (count != 1) {
            throw new FailToSaveException("线索保存失败");
        }
        return true;
    }

    @Override
    public PageVo<Clue> getCluePageVo(Map<String, Object> map) {
        PageVo<Clue> pageVo = new PageVo<Clue>();
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize = Integer.parseInt((String) map.get("pageSize"));
        PageHelper.startPage(pageNo, pageSize);
        List<Clue> dataList = clueDao.selectAllClueByMap(map);
        pageVo.setDataList(dataList);
        Long total = clueDao.selectTotal(map);
        pageVo.setTotal(total);
        return pageVo;
    }

    @Override
    public Clue getClueDetailById(String id) {
        return clueDao.selectClueDetailById(id);
    }

    @Override
    public Clue getClueById(String id) {
        return clueDao.selectClueById(id);
    }

    @Override
    public boolean deleteClueByIds(String[] ids) throws FailToDeleteException {
        Integer count = clueDao.deleteClueByIds(ids);
        if (count.compareTo(ids.length) != 0) {
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public boolean updateClueById(Clue clue) throws FailToUpdateException {
        Integer count = clueDao.updateClueById(clue);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("更新失败");
        }
        return true;
    }

    @Override
    public boolean deleteCarByCarId(String carId) throws FailToUpdateException {
        Integer count = clueActivityRelationDao.deleteClueActivityRelationById(carId);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("解除关联失败");
        }
        return true;
    }

    @Override
    public boolean saveCarByClueIdAndActivityIds(String cid, String[] aids) throws FailToSaveException {
        Integer count = 0;
        for (String aid : aids) {
            String carId = UUIDUtil.getUUID();
            clueActivityRelationDao.insertCarByClueIdAndActivityId(carId, cid, aid);
            count++;
        }

        if (count.compareTo(aids.length) != 0) {
            throw new FailToSaveException("关联市场活动失败");
        }
        return true;
    }

    @Override
    public boolean saveClueRemark(ClueRemark clueRemark) throws FailToSaveException {
        Integer count = clueRemarkDao.insertClueRemark(clueRemark);
        if (count.compareTo(1) != 0) {
            throw new FailToSaveException("保存备注失败");
        }
        return true;
    }

    @Override
    public ClueRemark getClueRemarkById(String id) {
        return clueRemarkDao.selectClueRemarkById(id);
    }

    @Override
    public List<ClueRemark> getClueRemarkListByClueId(String id) {
        return clueRemarkDao.selectClueRemarkListByClueId(id);
    }

    @Override
    public boolean updateClueRemark(ClueRemark clueRemark) throws FailToUpdateException {
        Integer count = clueRemarkDao.updateClueRemarkById(clueRemark);
        if (count != 1) {
            throw new FailToUpdateException("备注修改失败");
        }
        return true;
    }

    @Override
    public boolean deleteClueRemarkById(String id) throws FailToDeleteException {
        Integer count = clueRemarkDao.deleteClueRemarkById(id);
        if (count != 1) {
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public boolean convert(String clueId, Tran tran, String createBy) throws Exception {
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        //返回的clue没有 createBy，createTime，editBy，editTime
        Clue clue = clueDao.selectClueById(clueId);
        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        String company = clue.getCompany();
        Customer customer = customerDao.selectByName(company);
        if (customer == null) {
            //客户不存在
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(company);
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());
            Integer customerCount = customerDao.insert(customer);
            if (customerCount.compareTo(1) != 0) {
                throw new FailToSaveException("客户保存失败");
            }
        }
        //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        Integer contactsCount = contactsDao.insert(contacts);
        if (contactsCount.compareTo(1) != 0) {
            throw new FailToSaveException("联系人保存失败");
        }
        //(4) 线索备注转换到客户备注以及联系人备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.selectClueRemarkListByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkList) {
            String noteContent = clueRemark.getNoteContent();
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(DateTimeUtil.getSysTime());
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());
            Integer customerRemarkCount = customerRemarkDao.insert(customerRemark);
            if (customerRemarkCount.compareTo(1) != 0) {
                throw new FailToSaveException("客户备注保存失败");
            }
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contacts.getId());
            Integer contactsRemarkCount = contactsRemarkDao.insert(contactsRemark);
            if (contactsRemarkCount.compareTo(1) != 0) {
                throw new FailToSaveException("联系人备注保存失败");
            }
        }
        //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.selectListByClueId(clueId);
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            String activityId = clueActivityRelation.getActivityId();
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contacts.getId());
            Integer contactsActivityRelationCount = contactsActivityRelationDao.insert(contactsActivityRelation);
            if (contactsActivityRelationCount.compareTo(1) != 0) {
                throw new FailToSaveException("联系人和市场活动的关联关系保存失败");
            }
        }
        //(6) 如果有创建交易需求，创建一条交易
        if (tran.getId() != null) {
            //创建了交易
            tran.setOwner(clue.getOwner());
            tran.setCustomerId(customer.getId());
            tran.setSource(clue.getSource());
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(createBy);
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());
            tran.setNextContactTime(clue.getNextContactTime());
            Integer tranCount = tranDao.insert(tran);
            if (tranCount.compareTo(1) != 0) {
                throw new FailToSaveException("交易保存失败");
            }

            //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(DateTimeUtil.getSysTime());
            tranHistory.setTranId(tran.getId());
            Integer tranHistoryCount = tranHistoryDao.insert(tranHistory);
            if (tranHistoryCount.compareTo(1) != 0) {
                throw new FailToSaveException("交易历史保存失败");
            }
        }
        //(8) 删除线索备注
        for (ClueRemark clueRemark : clueRemarkList) {
            Integer deleteClueRemarkCount = clueRemarkDao.deleteClueRemarkById(clueRemark.getId());
            if (deleteClueRemarkCount.compareTo(1) != 0) {
                throw new FailToDeleteException("删除线索备注失败");
            }
        }
        //(9) 删除线索和市场活动的关系
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            String carId = clueActivityRelation.getId();
            Integer deleteCarCount = clueActivityRelationDao.deleteClueActivityRelationById(carId);
            if (deleteCarCount.compareTo(1) != 0) {
                throw new FailToDeleteException("删除线索和市场活动关联关系失败");
            }
        }
        //(10) 删除线索
        Integer deleteClueCount = clueDao.deleteClueById(clueId);
        if (deleteClueCount.compareTo(1) != 0) {
            throw new FailToDeleteException("删除线索失败");
        }
        return true;
    }

}
