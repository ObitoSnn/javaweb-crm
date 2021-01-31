package com.obitosnn.crm.web.listener;

import com.obitosnn.crm.settings.domain.DicValue;
import com.obitosnn.crm.settings.service.DicService;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import java.util.List;
import java.util.Map;

/**
 * 将数据字典存入服务器内存中(全局作用域ServletContext)，解决数据字典存储问题
 *
 * @Author ObitoSnn
 * @Date 2021/1/31 19:52
 */
public class SysInitListener extends ContextLoaderListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        //spring容器创建成功之后调用给方法
        ServletContext servletContext = event.getServletContext();
        WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
        DicService dicService = (DicService) ctx.getBean("dicServiceImpl");

        Map<String, List<DicValue>> map = dicService.getDicValueMap();
        for (String key : map.keySet()) {
            servletContext.setAttribute(key, map.get(key));
        }
    }

}
