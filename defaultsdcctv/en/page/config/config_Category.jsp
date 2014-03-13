<!-- 文件名：config_Category.jsp -->
<!-- 描  述：首页配置文件 -->
<!-- 修改人：zhanglingjun -->
<!-- 修改时间：2010-07-31 -->
<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="ShowException.jsp"%>
<%@ include file="config_native.jsp"%>
<%!
	//首页左侧增值业务的父栏目编号
	final static String PARENTID = "00000100000000090000000000001041";
	//首页海报配置
	final static String VOD_CATEGORY_POSTER="00000100000000090000000000001203";
%>

<script>	 	
	//存储页面焦点url [0-5]为功能按键 
	var tempurllist = new Array();
	//频道
	tempurllist[0] = "chan_RecordList.jsp?ISFIRST=1";
	//点播
	tempurllist[1] = "vod_Category.jsp";
	//回放
	//tempurllist[2] = "tvod_progBillByTimePeriod.jsp";
	tempurllist[2] = "tvod_progBillByRepertoire.jsp";
	//应用
	//tempurllist[3] = "self_AppList.jsp";
	//本地
	//tempurllist[4] = "self_Native.jsp";
	tempurllist[4] = "<%=LOCAL_VODINFO%>";
	//套餐
	//tempurllist[5] = "self_KindIntro.jsp";
	//tempurllist[5] = "vod_HotFilmList.jsp";
</script>

