﻿<!-- Copyright (C), pukka Tech. Co., Ltd. -->
<!-- Author:mxr -->
<!-- CreateAt:20110815 -->
<!-- FileName:play_ControlChannelListTv.jsp -->

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page errorPage="ShowException.jsp" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="com.huawei.iptvmw.epg.bean.info.UserProfile" %>
<%@ page import="com.huawei.iptvmw.util.StringDateUtil" %>
<%@ page import="com.huawei.iptvmw.epg.util.*" %>
<%@ page import="java.util.*" %>
<%@ include file = "datajsp/SubStringFunction.jsp"%>
<%@ include file="datajsp/codepage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
</head>
<%
String channelID = request.getParameter("CHANNELID");
int isfromgat = request.getParameter("isfromgat")==null?0:Integer.parseInt(request.getParameter("isfromgat"));
String channelNum = request.getParameter("CHANNELNUM");
String comeType = request.getParameter("COMEFROMFLAG");
String issubed = request.getParameter("ISSUB");//hxt	
MetaData metaData = new MetaData(request);
ServiceHelp serviceHelp = new ServiceHelp(request);								  
int listSizeStr = 0;                                     //频道个数
int currChanIndex = -1;                                  //当前频道索引 初始值为-1
//调用接口获得频道列表，旧方式
//ArrayList recChanList = metaData.getChannelListInfo();

//下面分开分别为计算高清和标清的总和
ArrayList result=new ArrayList();
ArrayList result1=new ArrayList();
ArrayList recChanList=new ArrayList();
ArrayList channel1=new ArrayList();


if(isfromgat==0){
  result = metaData.getChanListByTypeId(gaoqingzhibocode,-1,0);//高清直播CODE

  result1 = metaData.getChanListByTypeId(biaoqingzhibocode,-1,0);//标清直播CODE
  recChanList=(ArrayList)result.get(1);
  channel1=(ArrayList)result1.get(1);
  recChanList.addAll(channel1);//得到所有的
}
else{
//    result = metaData.getChanListByTypeId("11428190265518160439",-1,0);//高清直播CODE
	 result = metaData.getChanListByTypeId("10000100000000090000000000031288",-1,0);
    recChanList=(ArrayList)result.get(1);
}

/*********************************
* Time:20130827 16:41
* Author:ZSZ
* description:增加判断调整频道列表显示顺序
*
*********************************/
ArrayList newrecChanList = new ArrayList();
ArrayList tmpchannel=new ArrayList();
ArrayList s=new ArrayList();
int channelid = 0;
for(int j=recChanList.size()-1;j>=0;j--)
{
    HashMap map = (HashMap)recChanList.get(j);
	channelid = Integer.parseInt(map.get("CHANNELINDEX").toString());
	if(channelid >= 1201 && channelid <= 1301)
	{
		 s.add(map);
		 tmpchannel.add(0,recChanList.get(j));	
	}
}
for(int k=0;k<s.size();k++)
{
    recChanList.remove(s.get(k));	
}
newrecChanList.addAll(tmpchannel);
newrecChanList.addAll(recChanList);


listSizeStr = newrecChanList.size();//频道个数//20130827修改排序把高清频道放前面
TreeMap chanNumMap = new TreeMap();//存储频道号以及对应的频道信息的有序map
HashMap chanInfo = new HashMap();
for(int i=0; i<listSizeStr; i++)
{
	chanInfo = (HashMap)newrecChanList.get(i);//20130827修改排序把高清频道放前面
	Integer chanIndex = (Integer)chanInfo.get("CHANNELINDEX");//频道顺序号
	//chanNumMap.put(chanIndex, chanInfo);
	chanNumMap.put(i, chanInfo);//20130827修改排序把高清频道放前面
}	    	
int[] chanIds = new int[listSizeStr];//频道ID数组
String[] chanCode = new String[listSizeStr];
String[] chanNames = new String[listSizeStr];//频道名称数组
int[] chanNums = new int[listSizeStr];//频道号数组, 播放时使用
int[] isSub = new int[listSizeStr];//频道授权数组
boolean[] isControlled = new boolean[listSizeStr];//是否受控级别 (true:受控  false:不受控)
int[] pltvStatus = new int[listSizeStr];//频道激活时移状态(时移状态: 1激活 0去激活)
String[] chanUrls = new String[listSizeStr];//授权通过的URL链接
String[] isSubPreview = new String[listSizeStr];
//int[] isOrder = new int[listSizeStr];
int realSize = 0;
Iterator iter = chanNumMap.keySet().iterator();
int tmpchannelNum=Integer.parseInt(channelNum)+1000;//为找到焦点而修改，因为下发的减了1000，但是平台接口没有减去1000
while(iter.hasNext())
{
	Integer key = (Integer)iter.next();
	chanInfo = (HashMap)chanNumMap.get(key);
	//过滤高清
	/*20110815临时屏蔽掉,如果需要过滤时开启
	String SupportHD = (String)session.getAttribute("SupportHD");
	if("0".equals(SupportHD))
	{
		Integer iDEFINITION = (Integer)chanInfo.get("DEFINITION");
		if(iDEFINITION != null)
		{
			int DEFINITION = iDEFINITION.intValue();
			//2为标清，1为高清
			if(1==DEFINITION )
			{
				continue;
			}
		}
	}
	*/
	String chanName = (String)chanInfo.get("CHANNELNAME");
	chanNames[realSize] = subStringFunction(chanName,1,130);
        isSub[realSize] = ((Integer)chanInfo.get("ISSUBSCRIBED")).intValue();   //hxt
	System.out.println("CHANINFO===="+chanInfo);
	System.out.println("ISSUB?=="+ isSub[realSize]);
	chanIds[realSize] = ((Integer)chanInfo.get("CHANNELID")).intValue();
	chanCode[realSize] = "";//(String)chanInfo.get("CODE");
	chanNums[realSize] = ((Integer)chanInfo.get("CHANNELINDEX")).intValue();// System.out.println("channelnume"+chanNums[realSize]+"channelissub"+isSub[realSize]);//采用的CHANNELINDEX来装载播放号
	//System.out.println("CHANNELINDEX:"+((Integer)chanInfo.get("CHANNELINDEX")).intValue());
	if(null != channelID && !"null".equals(channelID))
	{
		if(channelID.equals(String.valueOf(chanIds[realSize]))){
			currChanIndex = realSize;
		}
	}else{
	        //channelNum.equals(String.valueOf(chanNums[realSize]))
		if(tmpchannelNum==chanNums[realSize]){		
			currChanIndex = realSize;
		}
	}
//	isSub[realSize] = 1;// ((Integer)chanInfo.get("ChannelPurchased")).intValue();
	pltvStatus[realSize] = ((Integer)chanInfo.get("PLTVSTATUS")).intValue();
	isControlled[realSize] = serviceHelp.isControlledOrLocked(true,false,EPGConstants.CONTENTTYPE_CHANNEL_VIDEO,chanIds[realSize]);//是否受控
	isSubPreview[realSize] = "";//(String)chanInfo.get("PreviewEnableHWCTC");
	realSize++;
}
//判断频道是否加锁
int[] isLock = new int[realSize];
ArrayList lockInfo = serviceHelp.getLockList();
if(lockInfo != null && lockInfo.size() > 1)
{
	lockInfo = (ArrayList)lockInfo.get(1);
	for(int i=0; i<lockInfo.size(); i++)
	{
		HashMap tmpMap = (HashMap)lockInfo.get(i);
		int lockId = Integer.parseInt((String)tmpMap.get("PROG_ID"));
		int lockType = ((Integer)tmpMap.get("PROG_TYPE")).intValue();
		if(lockType == EPGConstants.CONTENTTYPE_CHANNEL)
		{
			for(int j=0; j<realSize; j++)
			{
				if(lockId == chanIds[j]){
					isLock[j] = 1 ; 
					break;
				}
			}
		 }
	}
}
%>
<script language="javascript">	
function getInt(num)
{
	num = num + "";
	var i = num.indexOf(".");
	var currpage = num.substring(0,i);
	return parseInt(currpage,10);
}
var tempChannelNum;
</script>
<%  
for(int i=0; i<realSize; i++)
{
%>
	<script>
	parent.channelIds[<%=i%>] = '<%=chanIds[i]%>';
	parent.channelNames[<%=i%>] = '<%=chanNames[i]%>';
	tempChannelNum = <%=chanNums[i]%>;
       // var channelissub=<%=isSub[i]%>;   //hxt
	
        parent.channelNums[<%=i%>] = tempChannelNum-1000;//20120412修改,播放使用值
	tempChannelNum=tempChannelNum-1000;
	if(tempChannelNum<10){
		tempChannelNum = "00"+tempChannelNum;
	}else if(tempChannelNum > 9 && tempChannelNum < 100){
		tempChannelNum = "0"+tempChannelNum;
	}
	parent.channelNumsShow[<%=i%>] = tempChannelNum;
	parent.isSub[<%=i%>] = '<%=isSub[i]%>';
	parent.pltvStatus[<%=i%>] = '<%=pltvStatus[i]%>';
	parent.channelUrls[<%=i%>] = '<%=chanUrls[i]%>';
	parent.isLock[<%=i%>] = '<%=isLock[i]%>';
	parent.isControlled[<%=i%>] = '<%=isControlled[i]%>';
	parent.channelCode[<%=i%>] = '<%=chanCode[i]%>';
	parent.isSubPreview[<%=i%>] = '<%=isSubPreview[i]%>'; 
	</script>		
<%        
 }
%>
<script>
var currIndex = '<%=currChanIndex%>';//当前的下标
var comeType = '<%=comeType%>';//直播来源 3表示页面快捷键
parent.currChannelIndex = currIndex;
parent.chanListFocus = currIndex;
parent.totalChannel = '<%=realSize-1%>';
var totalPage = '<%= Math.round(realSize/(float)13 + 0.4999f)%>';//总共多少页
parent.totalListPages = totalPage;
//当前是第几页
if(currIndex % 13 == 0){
	parent.currListPage = currIndex / 13;
}else{
	parent.currListPage = getInt(currIndex / 13);
}
parent.init_page();
parent.showInfo();//MITIEPG数据
parent.getDataFlag = "true";
if (typeof(iPanel) != 'undefined')
{
	iPanel.focusWidth = "4";
	iPanel.defaultFocusColor = "#FCFF05";
}
//频道或数字键进入 且 已定购  直接播放
//ZTE
if (comeType != 0 && 3 != parent.isSub[currIndex])
{      var isSubsingle = <%=issubed%>; //hxt alert(parent.isSub[currIndex]+"-------------"+currIndex+"eeee"+isSubsingle);
        if(isSubsingle==1)  {parent.isSub[currIndex]=1;}//hxt
	parent.joinChannel(parent.currChannelNum);
//	return;
}else{
//开机进直播、预览 需验证
parent.authtication(currIndex);
if("false" == parent.lockPlay){
//return;
}
else{parent.joinChannel(parent.currChannelNum);}
}
</script>
</html>
