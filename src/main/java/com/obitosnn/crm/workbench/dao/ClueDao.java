package com.obitosnn.crm.workbench.dao;


import com.obitosnn.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {

    Integer insertClue(Clue clue);

    Long selectTotal(Map<String, Object> map);

    List<Clue> selectAllClueByMap(Map<String, Object> map);

    Clue selectClueDetailById(String id);

    Clue selectClueById(String id);

    Integer deleteClueByIds(String[] ids);

    Integer updateClueById(Clue clue);

    Integer deleteClueById(String id);

}
