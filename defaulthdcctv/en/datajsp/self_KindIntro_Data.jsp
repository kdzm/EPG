<!-- �ļ�����self_KindIntro_Data.jsp -->
<!-- ��  �����ײ�ҳ�����ݲ� -->
<!-- �޸��ˣ�zhanghui -->
<!-- �޸�ʱ�䣺2010-8-9-->
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%
	TurnPage turnPage = new TurnPage(request);
	turnPage.addUrl();
	String type=request.getParameter("ECTYPE");
	int itype = 0;
	try
	{
		itype=Integer.parseInt(type);
	}
	catch(Exception e)
	{
		
	}
%>

