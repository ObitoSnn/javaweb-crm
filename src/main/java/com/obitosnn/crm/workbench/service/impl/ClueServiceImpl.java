package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.ClueDao;
import com.obitosnn.crm.workbench.domain.Clue;
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

    @Override
    public boolean saveClue(Clue clue) throws FailToSaveException {
        String nextContactTime = clue.getNextContactTime();
        if (nextContactTime.compareTo(DateTimeUtil.getDate()) < 0) {
            throw new FailToSaveException("填写的时间非法");
        }
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

}
