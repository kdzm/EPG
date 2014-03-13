<%
/*********************
* fileName:play_ControlChannelName.jsp
* Time:20130905 9:45
* Author:ZSZ
* description:����Ƶ��������ʾ
*********************/
%>

<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ include file = "datajsp/SubStringFunction.jsp"%>

<%
	//Ƶ������
	int listSizeStr = 0; 
	//��ǰƵ������ ��ʼֵΪ-1
    int currChanIndex = -1; 
	//�洢Ƶ�����Լ���Ӧ��Ƶ����Ϣ������map
	TreeMap chanNumMap = new TreeMap();
	//�洢Ƶ�����������Ϣ
	HashMap chanInfo = new HashMap();
	

	MetaData nameData = new MetaData(request);

	//���ýӿڻ��Ƶ���б�
	/*********20130912 10:25 ZSZ ����code�쳣����*********/ 
	List HDChannelList = new ArrayList();
	List SDChannelList = new ArrayList();
	List tempHDList = new ArrayList();
	List tempSDList = new ArrayList();
	try{
		HDChannelList = nameData.getChanListByTypeId("00000100000000090000000000015840",-1,0);
		//HDChannelList = nameData.getChanListByTypeId("0000010000000009000000000001584",-1,0);�����������
		tempHDList = (ArrayList)HDChannelList.get(1);
	}catch(Exception e){

	}
	try{
		SDChannelList = nameData.getChanListByTypeId("00000100000000090000000000015842",-1,0);
		//SDChannelList = nameData.getChanListByTypeId("0000010000000009000000000001584",-1,0);�����������
		tempSDList = (ArrayList)SDChannelList.get(1);
	}catch(Exception e){

	}
	/*********20130912 10:25 ZSZ ����code�쳣����*********/ 

	//�õ��߱����б�
	ArrayList tempList = new ArrayList();
	tempList.addAll(tempHDList);
	tempList.addAll(tempSDList);

	//�õ��߱�������
	listSizeStr = tempList.size();

	//Ƶ��������,
	int[] chanNums = new int[listSizeStr];
	//Ƶ����������
	String[] chanNames = new String[listSizeStr];

	for(int i=0; i<listSizeStr; i++){
		chanInfo = (HashMap)tempList.get(i);//20130827�޸�����Ѹ���Ƶ����ǰ��
		Integer chanIndex = (Integer)chanInfo.get("CHANNELINDEX");//Ƶ��˳���
		//chanNumMap.put(chanIndex, chanInfo);
		chanNumMap.put(i, chanInfo);//20130827�޸�����Ѹ���Ƶ����ǰ��
	}	    
	
	Iterator it = chanNumMap.keySet().iterator();
	int realSize = 0;
	while(it.hasNext()){
		Integer key = (Integer)it.next();
		chanInfo = (HashMap)chanNumMap.get(key);
		//Ƶ������
		String chanName = (String)chanInfo.get("CHANNELNAME");
		chanNames[realSize] = subStringFunction(chanName,1,130);
		chanNums[realSize] = (((Integer)chanInfo.get("CHANNELINDEX")).intValue())-1000;	//����ʾͬ��Ƶ���ż���1000
		realSize++;
	}
%>
	<script>
	var showchannelNames = new Array();
	var showchannelNums = new Array();
	</script>
<%
	for(int i=0; i<realSize; i++){
%>
	<script>
	showchannelNames[<%=i%>] = '<%=chanNames[i]%>';
	showchannelNums[<%=i%>] = <%=chanNums[i]%>;
	</script>		
<%        
 }
%>
