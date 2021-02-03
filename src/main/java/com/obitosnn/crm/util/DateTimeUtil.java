package com.obitosnn.crm.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {

	private DateTimeUtil(){}
	
	public static String getSysTime(){
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Date date = new Date();
		String dateStr = sdf.format(date);

		return dateStr;
		
	}

	public static String getDate() {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		return format.format(new Date());
	}
	
}
