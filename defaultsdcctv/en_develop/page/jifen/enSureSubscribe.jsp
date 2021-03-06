﻿<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelpHWCTC" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGConstants" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGErrorCode" %>
<%
    String pageName = "errorinfo.jsp";
	//要播放影片的id
	JSONObject resultjson = null;
	HashMap resultMap = new HashMap();
	ServiceHelpHWCTC serviceHelpHWCTC = new ServiceHelpHWCTC(request);
    int sProgId = Integer.parseInt(request.getParameter("PROGID")); 
	//电视剧父集ID
	String fatherSeriesId = "-2";
	int sFatherSeriesId = Integer.parseInt(fatherSeriesId);
    int sContentType = Integer.parseInt(request.getParameter("CONTENTTYPE"));
    int sBusinessType = Integer.parseInt(request.getParameter("BUSINESSTYPE"));
//	int sProductId = Integer.parseInt(request.getParameter("PRODUCTID"));
 //       System.out.println("productId=="+sProductId);
//      String productId = String.valueOf(sProductId);
        String productId = request.getParameter("PRODUCTID");
	String serviceId = "";
	serviceId = request.getParameter("SERVICEID"); 
	int prodCont = Integer.parseInt(EPGConstants.SUBSCRIPTION_NOTCONTINUEABLE);
	HashMap orderfilm = null;
	System.out.println("productId=="+productId+"|id=="+ request.getParameter("PRODUCTID"));
	orderfilm = serviceHelpHWCTC.subscribeHWCTC(productId, serviceId, 0,sContentType,sProgId,sBusinessType,sFatherSeriesId,2);
	//System.out.println("productId:"+productId+";serviceId:"+serviceId+";prodCont:"+prodCont+";sContentType:"+sContentType+";sProgId:"+sProgId+";sBusinessType:"+sBusinessType+";sFatherSeriesId:"+sFatherSeriesId);
	System.out.println("OrderFilm=="+orderfilm);
    int ret_code = ((Integer)orderfilm.get(EPGConstants.KEY_RETCODE)).intValue();
	String playurl = "index.jsp";
	//订购成功
    if(ret_code == EPGErrorCode.SUBSCRIPTION_SUCCESSED)
    {    
	     pageName=playurl;
	}else{
			if(ret_code == 209)//政企用户不允许订购按次产品
		{
				pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=162";
		} 
		//该用户不支持在线订购
        else if(ret_code == 202)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=151";
        }
		//203 = TEMPLATE_DELETE_FAILED产品将下线，不支持订购
        else if(ret_code == 203)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=122";
        }
		else if(ret_code == EPGErrorCode.SUBSCRIPTION_NETWORKERROR)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=92";
        }
		else if(ret_code == EPGErrorCode.SUBSCRIPTION_FAILED_ALREADYORDER)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=101";
        }
        else if(ret_code == 104)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=101";
        }
		else if(ret_code == 100)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=137";
        }
		else if(ret_code == 101)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=138";
        }
		else if(ret_code == 102)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=139";
        }
		else if(ret_code == 103)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=140";
        }
		else if(ret_code == 105)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=141";
        }
		else if(ret_code == 106)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=142";
        }
		else if(ret_code == 107)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=143";
        }
		else if(ret_code == 108)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=144";
        }
		else if(ret_code == 109)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=145";
        }
		else if(ret_code == 204)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=146";
        }
		else if(ret_code == 205)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=147";
        }
		else if(ret_code == 206)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=148";
        }
		else if(ret_code == 207)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=149";
        }
		else if(ret_code == 208)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=150";
        }
		else if(ret_code == 0x07030001)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=36";
        }
		else if(ret_code ==0x07030100)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=155";
        }
		else if(ret_code ==0x07030200)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=160";
        }
		else if(ret_code ==0x07030300)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=161";
        }
		else if(ret_code ==0x04010004)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=157";
        }
		else if(ret_code ==0x04010899)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=158";
        }
		else if(ret_code ==0x04020888)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=145";
        }
		else if(ret_code ==0x07000005)
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=159";
        }
		else if(ret_code ==210)
		{
			//用户积分点数不够
			pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=166";
		}
		else if(ret_code ==211)
		{
			//产品不支持积分订购
			pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=167";
		}
		else if(ret_code ==212)
		{
			//积分订购处理失败
			pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=168";
		}
		else if(ret_code ==213)
		{
			//不允许退订积分订购的产品
			pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=169";
		}
		else if(ret_code ==215)
		{
			//不允许用积分续订产品
			pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=170";
		}
		else if(ret_code ==400)
		{
			//BSS限呼的一个问题
			pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=171";
		}
        else
        {
        	pageName = pageName+"?ERROR_TYPE=2&ERROR_ID=36";
        }
      System.out.println("PAGENAME======="+pageName);
%>
       <jsp:forward page="<%= pageName %>"/>
<%		
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>二次确定订购页-深圳IP电视高清专区EPG3.0</title>
<meta name="page-view-size" content="1280*720" />
<script type="text/javascript">
 </script>
</head>
<body>
	
    
    
</body>
</html>
