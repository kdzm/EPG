<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelpHWCTC" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="com.huawei.iptvmw.epg.bean.info.UserProfile"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGConstants"%>
<%@ page import="com.huawei.iptvmw.epg.util.EPGUtil"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ include file="util_getPosterPaths.jsp"%>
<%@ include file="code.jsp"%>
<script>
var isFirstFlag;
var jsonList;
var contentTotal;
<%
	MetaData metadata = new MetaData(request);
	int contentTotal=0;
	int toptype = request.getParameter("topid")==null?0:Integer.parseInt(request.getParameter("topid"));
	int start = request.getParameter("start")==null?0:Integer.parseInt(request.getParameter("start"));
	int curentpage = request.getParameter("curentpage")==null?1:Integer.parseInt(request.getParameter("curentpage"));
	int isFirstFlag = request.getParameter("isFirstFlag")==null?0:Integer.parseInt(request.getParameter("isFirstFlag"));
	ArrayList resultList = new ArrayList();
	if(toptype == 0){
		resultList = metadata.getVodListByTypeId(dongzuo,9,start);
		}else if(toptype == 1){
			resultList = metadata.getVodListByTypeId(xiju,9,start);
			}else if(toptype == 2){
				resultList = metadata.getVodListByTypeId(aiqing,9,start);
				}else if(toptype == 3){
					resultList = metadata.getVodListByTypeId(jingsong,9,start);
					}else{
						resultList = metadata.getVodListByTypeId(qita,9,start);
						}
	JSONArray jsonList = null;
	
	if(resultList != null && resultList.size() > 1 && ((ArrayList)resultList.get(1)).size() > 0){
		ArrayList tempList = new ArrayList();
		ArrayList vodList = (ArrayList)resultList.get(1);
		
		HashMap temp = (HashMap)resultList.get(0);
		contentTotal = ((Integer)temp.get("COUNTTOTAL")).intValue();
		System.out.print(vodList.size());
		for(int i=0;i<vodList.size();i++){
			HashMap mapx = (HashMap)vodList.get(i);
			HashMap tempMap = new HashMap();
			String tmpvodid = mapx.get("VODID").toString();
            int pid = Integer.parseInt(tmpvodid);
			String tmpvodname = mapx.get("VODNAME").toString();
			tempMap.put("VODID",tmpvodid);	
			tempMap.put("VODNAME",tmpvodname);	
			HashMap detailMap = (HashMap)metadata.getVodDetailInfo(Integer.parseInt(tmpvodid));
			String isSitcom = detailMap.get("ISSITCOM").toString();
			tempMap.put("ISSITCOM",isSitcom);
			HashMap posterMap = (HashMap)(detailMap.get("POSTERPATHS"));

			if(posterMap!=null){
				//0.缩略图1.海报2.剧照3.图标4.标题图5.广告图6.草图7.背景9.频道图99.其他
				String picUrl = getPosterPath(posterMap,"images/demopic/pic-173X231.jpg","1",request);
				tempMap.put("PICURL",picUrl);	
		        }
		     tempList.add(tempMap);
	       }
		
		jsonList = JSONArray.fromObject(tempList);
		}
		
%>
isFirstFlag = <%=isFirstFlag%>;//0:第一次进入此页面，1:后面通过IFrame刷新数据的标识。
jsonList = <%=jsonList%>;
contentTotal = <%=contentTotal%>;
if(isFirstFlag == 1){
	window.parent.binddata(jsonList);
		}
</script>