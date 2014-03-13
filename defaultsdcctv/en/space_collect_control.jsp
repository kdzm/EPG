<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="datajsp/space_collect_data.jsp"%>
<%@ include file="datajsp/codepage.jsp"%>
<html>
<head>
<script language="javascript" type="text/javascript" src="../js/pagecontrol.js"></script>
<script language="javascript" type="text/javascript">

var pagesize=7;
var pos=0; 

var popList;//层对象集合
var delPop;//删除操作层
var delFailPop;//删除失败层
var delSuPop;//删除成功层
var area0;
var area1;
var area2;
var area3;
var area4;
var area5;
var collentNum=0;

var delContentObject;//删除对象
var pagedel;

var isDel=false;///是否弹出删除对话框
var delSuccFlag=0;///是否删除成功

var pagecount=<%=pagecount%>;
var pagesize=7;
var pos=0; 


//初始化收藏数组
function initCollentList(){  
    
    pos=jscurpage * pagesize - pagesize;
	collentList=new Array(); 
	
	for(var i=pos;i<(pos+pagesize)&& i<favList.length;i++)
	{
		collentList.push(favList[i]);
	}
}

//加载主数据
function loadBody() {
	refreshServerTime();
    initCollentList();
	//构建菜单区域
    area0 = AreaCreator(4, 1, new Array(-1, -1, -1, 1), "area0_list_", "className:link", "className:link");
    area0.setstaystyle("className:listli current", 3);

    area0.doms[0].mylink="space_collect.jsp?areaid=0&indexid=0";
    area0.doms[1].mylink="space_bookmarks.jsp?areaid=0&indexid=1";
    area0.doms[2].mylink="space_consumer_records.jsp?areaid=0&indexid=2";
    area0.setfocuscircle(0);
    //end
   
   
   //构建收藏列表区域
   area1 = AreaCreator(7, 1, new Array(-1,0, -1, 2), "area1_list_", "className:linkonboder", "className:linkoffboder");
   area1.setcrossturnpage();
   area1.stablemoveindex=new Array(-1,-1,-1,"0-0,1-1,2-2,3-3,4-4,5-5,6-6");
   
   area1.asyngetdata=function()
   {  
      area2.curpage=area1.curpage;
	  jscurpage=area2.curpage;
	  area1.lockin=true;
	  area2.lockin=true;
	  initCollentList();
	  showCollectDel(collentList,pagecount);
	  area1.lockin=false;
	  area2.lockin=false;
   }
   area1.datanum = collentList.length;
   //end
   
   //构建删除列表区域
   area2 = AreaCreator(7, 1, new Array(-1,1, -1, -1), "area2_list_", "className:onboder", "className:offboder");
   area2.setcrossturnpage();
   area2.stablemoveindex=new Array("0-0,1-1,2-2,3-3,4-4,5-5,6-6",-1,-1,-1);
   
   area2.asyngetdata=function()
   {  
      area1.curpage=area2.curpage;
	  jscurpage=area2.curpage;
	  area2.lockin=true;
	  initCollentList();
	  showCollectDel(collentList,pagecount);
	  area2.lockin=false;
	  area1.lockin=false;
   }
    area2.datanum = collentList.length;
    //end

    popList=new Array();
	
	//构建删除操作层
    area3=AreaCreator(1,2,new Array(-1,-1,-1,-1),"area3_list_","className:link onboder","className:link offboder");
    delPop=new Popup("area3_list",new Array(area3),0,0);
	///开始执行删除操作
	area3.doms[0].domOkEvent=function()
	{   
	   area1.lockin=true; //加锁防止焦点的移
	   area2.lockin=true;
	   pagedel.popups[0].closeme();
	   pageobj=null;
	   delFavFun();
	}
	area3.doms[1].domOkEvent=function()
	{
	   pagedel.popups[0].closeme();
	};
	//end
	
	//构建删除成功层
	area4=AreaCreator(1,1,new Array(-1,-1,-1,-1),"area4_list_","className:link onboder","className:link offboder");
	delSuPop=new Popup("area4_list",new Array(area4),0,0);
	area4.doms[0].domOkEvent=delSuFun;
	//end
	
	//构建删除失败层
    area5=AreaCreator(1,1,new Array(-1,-1,-1,-1),"area5_list_","className:link onboder","className:link offboder");
	delFailPop=new Popup("area5_list",new Array(area5),0,0);
	area5.doms[0].domOkEvent=delFailFun;
	
	
	popList[0]=delPop;
	popList[1]=delSuPop;
	popList[2]=delFailPop;
	
	
	pageobj = new PageObj(areaid, indexid, new Array(area0, area1,area2),popList);
	pageobj.goBackEvent=function()
	{
	  
	}
	if(parseInt(jscurpage)==0)
	{  
		pagecount=1;
		jscurpage=1;
		collentNum=0;
	
	}
	else{
	  collentNum=favList.length;
	}
	area1.curpage=jscurpage;
	area2.curpage=jscurpage;
	
    showCollectDel(collentList,pagecount);
	pagedel=pageobj;
	
	
}



//显示收藏列表
function showCollectDel(data,count){		 
	 area1.setpageturndata(data.length,parseInt(count));
	 if(collentNum!=0)
	 {
	   area2.setpageturndata(data.length,parseInt(count));
	 }
	 
	 for(var i=0;i<area1.doms.length;i++)
	 {
		 if(i<data.length)
		 {   
		     area1.doms[i].contentdom=$("area1_txt_"+i);
			 area1.doms[i].setcontent("",data[i].progName,30);
			 area1.doms[i].mylink="";
			 area1.doms[i].domOkEvent=function()
			 {  
				 OkFun();
			 }
			 if(collentNum!=0){
				 $('area2_list_'+i).style.visibility = "block";
				 area2.doms[i].mylink="";
				 area2.doms[i].domOkEvent=function()
				 {  
					 delFun();
				 }
			 }
		 }
		 else{
			 area1.doms[i].contentdom=$("area1_txt_"+i);
			 area1.doms[i].updatecontent("");
			 $('area2_list_'+i).style.display = "none";
			 
		 }
	 }
	 
	 area1.lockin=false;
	 area2.lockin=false;
	 $("pageArea").innerHTML="<span class=\"current\">"+area1.curpage+"</span>/"+pagecount;
}
 
	 
//弹出删除对话框
function OkFun()
{   
    window.location.href="vod_turnpager.jsp?vodid="+collentList[pageobj.getfocusindex()].progId +"&returnurl="+escape("space_collect.jsp?curpage="+area2.curpage+"&areaid=2&indexid="+pageobj.getfocusindex());
}

//弹出删除对话框
function delFun(){
	delContentObject=collentList[pageobj.getfocusindex()];
	pageobj.popups[0].showme();
	isDel=true;
}

	 
function  delSuFun(){
    delSuPop.closeme();
	setDelDefault();
	window.location.href="space_collect.jsp?curpage="+area2.curpage+"&indexid="+pageobj.getfocusindex()+"&areaid=2";
}

function  delFailFun(){
    delFailPop.closeme();
	setDelDefault();
	window.location.href="space_collect.jsp?curpage="+area2.curpage+"&indexid="+pageobj.getfocusindex()+"&areaid=2";
}

//删除操作函数
function delFavFun()
{
   var delUrl = "datajsp/space_collectDel_iframedata.jsp?PROGID="+delContentObject.progId+"&PROGTYPE="+delContentObject.progType;
   alert(delUrl);
   getAJAXData(delUrl,delFav);
   delSuccFlag=false;
   function delFav(succ){
	 if(parseInt(succ) == 1)
	 { 
	   pagedel.popups[1].closetime=5;
	   pagedel.popups[1].showme();
	   delSuccFlag=true;
	 }
	 else
	 { 
		pagedel.popups[2].closetime=5;
		pagedel.popups[2].showme();
		delSuccFlag=false;
	 }
  }
}

//恢复默认值 
function setDelDefault()
{
   delSuccFlag=false;
   delContentObject=null;
   area2.lockin=false; 
   area1.lockin=false; 
   isDel=false;
   pageobj=pagedel;
}
</script>
</head>
</html>