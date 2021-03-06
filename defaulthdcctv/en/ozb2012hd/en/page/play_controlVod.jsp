﻿<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelpHWCTC" %>
<%@ page import="com.huawei.iptvmw.epg.facade.service.BookmarkImpl" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGConstants"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ include file = "keyboard/keydefine.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>vod播控页面</title>
<%
String progId = request.getParameter("PROGID"); //vod节目id
int iProgId = 0;	
String fatherId = request.getParameter("FATHERSERIESID");
String playType = request.getParameter("PLAYTYPE"); //播放类型
int iPlayType = 0;	
String beginTime = request.getParameter("BEGINTIME"); //节目播放开始时间
String vasBeginTime = request.getParameter("beginTime");
String productId = request.getParameter("PRODUCTID"); //订购产品id	
String serviceId = request.getParameter("SERVICEID"); //对应服务id	
String price = request.getParameter("ONECEPRICE"); //该产品对应价格	
String contentType = request.getParameter("CONTENTTYPE");
String vasFlag = request.getParameter("vasFlag"); //增值页面标志位
String backurl = request.getParameter("backurl"); //如果是从增值服务页面进入的返回url
String typeId = request.getParameter("TYPE_ID");//栏目ID
String isChildren = request.getParameter("isChildren");
String type=request.getParameter("ECTYPE");
int itype =0;	
if(type != null && type !="" && type != "null")
{	
	itype=Integer.parseInt(type);
}	
String playUrl = ""; //触发机顶盒播放地址
int iPlayBillId = 0; //节目单编号（可选参数），仅当progId是频道时有效，此处只是为满足接口	
String endTime = request.getParameter("ENDTIME");
if(endTime == null || endTime=="" || "".equals(endTime) || "undefined".equals(endTime))
{
	endTime = "20000"; //播放结束时间
}
boolean isSucess = true;
/*******************对获取参数进行异常处理 start*************************/
try
{
	iProgId = Integer.parseInt(progId);
	iPlayType = Integer.parseInt(playType);
}
catch(Exception e)
{
	iProgId = -1;
	iPlayType = -1;
	isSucess = false;
}
if(fatherId == null || "".equals(fatherId) || "null".equals(fatherId) || "undefined".equals(fatherId))
{
	fatherId = "-1";
}
if(beginTime == null || "".equals(beginTime)|| "null".equals(fatherId))
{
	beginTime = "0";
}
if(productId == null || "".equals(productId)|| "null".equals(fatherId))
{
	productId = "0";
}
if(serviceId == null || "".equals(serviceId)|| "null".equals(fatherId))
{
	serviceId = "0";
}
if(price == null || "".equals(price)|| "null".equals(fatherId))
{
	price = "0";
}
if(contentType == null || "".equals(contentType)|| "null".equals(fatherId))
{
	contentType =String.valueOf(EPGConstants.CONTENTTYPE_VOD);
}
String infoDisplay = "errorinfo.jsp?ERROR_TYPE=2&ERROR_ID=26&ECTYPE="+itype;

/*******************对获取参数进行异常处理 end*************************/
MetaData metaData = new MetaData(request);
ServiceHelpHWCTC serviceHelpHWCTC = new ServiceHelpHWCTC(request);
ServiceHelp serviceHelp = new ServiceHelp(request);
BookmarkImpl bookmarkImpl = new BookmarkImpl(request);//书签
int iShowDelayTime = 5000;
try
{
	String showDelayTime = serviceHelp.getMiniEPGDelay ();
	iShowDelayTime = Integer.parseInt(showDelayTime)* 1000;
}
catch(Exception e)
{
	iShowDelayTime = 8000;
}
/*************************获取播放url start**************************************/
if( "1".equals(vasFlag))//增值业务使用老接口
{
	playUrl = serviceHelp.getTriggerPlayUrl(iPlayType,iProgId,"0");
	playUrl = playUrl + "&playseek="+vasBeginTime+"-"+endTime;
}
else
{
	%>
	<script>
//alert("<%=iPlayType%>"+"/"+"<%=iProgId%>"+"/"+"<%=iPlayBillId%>"+"/"+"<%=beginTime%>"+"/"+"<%=endTime%>"+"/"+"<%=productId%>"+"/"+"<%=serviceId%>"+"/"+"<%=contentType%>");
    </script>
	<%
	playUrl = serviceHelpHWCTC.getTriggerPlayUrlHWCTC(iPlayType,iProgId,iPlayBillId,beginTime,endTime,productId,serviceId,contentType);
	%>
	<script>
		//alert("<%=playUrl%>");
    </script>
	<%
}

//连续剧子集书签焦点记忆
if(!fatherId.equals("-1"))
{
	bookmarkImpl.addSitcomItem(progId,fatherId);		
}
if(playUrl != null && playUrl.length() > 0)
{
	int tmpPosition = playUrl.indexOf("rtsp");
	if(-1 != tmpPosition)
	{
		playUrl = playUrl.substring(tmpPosition,playUrl.length());
	}
	else
	{
		isSucess = false;
	}
}	
/*************************获取播放url end**************************************/
		
TurnPage turnPage = new TurnPage(request);

String goBackUrl = turnPage.go(-1);

if(backurl != null && ! "".equals(backurl))
{
	goBackUrl = backurl;
}
if(!isSucess)
{
	response.sendRedirect(infoDisplay);
}
%>
<style>
.blueFont
{ font:"黑体";color:#33CCFF;font-size:24px; line-height:30px }
.whiteFont line-height:30px
{font:"黑体";color:#FFFFFF;font-size:24px; line-height:30px }
</style>
<script>
var _in_ajax = window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
function getAJAXData(url, successMethed) {
    if (url != undefined && url != null && url != "") {
        var temp = url.split("?"); url = temp[0];
        if (temp.length > 1) { url += "?" + encodeURI(temp[1]); }
    }
    _in_ajax.open("POST", url, false);
    _in_ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
    _in_ajax.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    _in_ajax.send(null);
	if (_in_ajax.readyState == 4){
			if (_in_ajax.status == 200) {
				 window.clearInterval(interval);
				 successMethed(_in_ajax.responseText); 			
			}else{
				getAJAXData(url, successMethed);
			}
		}
}
</script>

<script>
if (typeof(iPanel) != 'undefined')
{
iPanel.focusWidth = "4";
iPanel.defaultFocusColor = "#FCFF05";
}
var isChildren = "<%=isChildren%>";
var count=0;
var playStatFlag=0;
//页面加载前执行的数据转换与方法
//var playStatus = 0;
var itype="<%=itype%>";
var progId = '<%=iProgId%>'; //当前播放的vodid
var playType = '<%=iPlayType%>'; //播放的类型
var fatherId = '<%=fatherId%>'; //当前播放的vodid的父级id
var playUrl ='<%=playUrl%>';//触发机顶盒播放url
var beginTime = '<%=beginTime%>';
var endTime = '<%=endTime%>';
var isAssess = <%= iPlayType == EPGConstants.PLAYTYPE_ASSESS%>; //是否是片花播放
var isBookMark = <%= iPlayType == EPGConstants.PLAYTYPE_BOOKMARK%>; //是否为书签播放
var hideTime = <%=iShowDelayTime%>; //epg自动隐藏时间
var delayTime = 8000; //epg开机延时显示minepg时间
var dataIsOk = false; //数据是否准备结束
var goBackUrl = '<%=goBackUrl%>';
var succ=-1;//添加书签标记
var pk_interval_handle = null;//快进，快退进度条控制
/******************在iframe页面赋值的参数 start********************************/
var preProgId = "-1"; //连续剧子集上一集id
var preProgNum = "";
//下一集标清？
var preCanPlay = "2" ;
var nextCanPlay = "2" ;
var nextProgId = "-1" //连续剧子集下一集id
var preProgNum = "";

var vodName = "";//本vod的名字
var director = "";//导演
var actor = "";//演员
var introduce = "";//介绍信息
var sitNum = ""; //当前vod的集数
var currIndex;//当前集数下标
var mediaTime = 0;
var initMediaTime = 0;
var tempTime=0;
var timePerCell = 0;
var currCellCount = 0;
var seekStep = 1;//每次移动的百分比
var isSeeking = 0;
var tempCurrTime = 0;
var timeID_playByTime = 0;
var isJumpTime = 1;//跳转输入框是否显1默认显;
var playStat = "play";
var timeID_check = "";
var preInputValueHour = "";//上一次检测时，文本框中的值
var preInputValueMin = "";
/******************在iframe页面赋值的参数 end********************************/
var mediaStr = '[{mediaUrl:"'+ playUrl +'",';
mediaStr += 'mediaCode: "jsoncode1",';
mediaStr += 'mediaType:2,';
mediaStr += 'audioType:1,';
mediaStr += 'videoType:1,';
mediaStr += 'streamType:1,';
mediaStr += 'drmType:1,';
mediaStr += 'fingerPrint:0,';
mediaStr += 'copyProtection:1,';
mediaStr += 'allowTrickmode:1,';
mediaStr += 'startTime:0,';
mediaStr += 'endTime:20000,';
mediaStr += 'entryID:"jsonentry1"}]';

var mp = new MediaPlayer();//播放器对象

var typeId = "<%=typeId%>" ;
var timeID_jumpTime = "";
var showTimer = "";
var hideTimer = "";
var volume = 0;
// 隐藏bottomTimer的定时器
var bottomTimer = "";
var speed = 1;
var currTime = 0;
var jumpPos = 4;//焦点在进度条上面
var jumpDivIsShow = false;
var seekDivIsShow = false;
var volumeDivIsShow = false;
var voiceIsShow=false;//静音是否显示 false:没有显示
var t = 0;
/**
*初始化mediaPlay对象
*/
function initMediaPlay()
{
	var instanceId = mp.getNativePlayerInstanceID(); //读取本地的媒体播放实例的标识
	var playListFlag = 0; // 0：单媒体的播放模式 (默认值)，1: 播放列表的播放模式
	var videoDisplayMode = 1; // 1: 全屏显示2: 按宽度显示，3: 按高度显示
	var height = 0;
	var width = 0;
	var left = 0;
	var top = 0;
	var muteFlag = 0; //0: 设置为有声 (默认值) 1: 设置为静音
	var subtitleFlag = 0; //字幕显示 
	var videoAlpha = 0; //视频的透明度
	var cycleFlag = 0;
	var randomFlag = 0;
	var autoDelFlag = 0;
	var useNativeUIFlag = 1;
	mp.initMediaPlayer(instanceId,playListFlag,videoDisplayMode,height,width,left,top,muteFlag,useNativeUIFlag,subtitleFlag,videoAlpha,cycleFlag,randomFlag,autoDelFlag);
	mp.setSingleMedia(mediaStr); //设置媒体播放器播放媒体内容
	mp.setAllowTrickmodeFlag(0); //设置是否允许trick操作。 0:允许 1：不允许
	mp.setNativeUIFlag(0); //播放器是否显示缺省的Native UI，  0:允许 1：不允许
	mp.setAudioTrackUIFlag(1);//设置音轨的本地UI显示标志 0:不允许 1：允许
	mp.setMuteUIFlag(1); //设置静音的本地UI显示标志 0:不允许 1：允许
	mp.setAudioVolumeUIFlag(1);//设置音量调节本地UI的显示标志 0:不允许 1：允许
	mp.refreshVideoDisplay();
}

/**
*播放
*/
function play()
{
	if(isBookMark)
	{
	   //alert("有书签播放的时候beginTime="+beginTime+"endTime="+endTime);
		var type = 1;
		var speed = 1;
		mp.playByTime(type,beginTime,speed);
	}
	else
	{
		mp.playFromStart();
	}
}
/**
*进入页面后直接播放
*/
function start()
{	
	Authentication.CTCSetConfig("key_ctrl_ex","0");
	initMediaPlay();		
	play();
}

function unload()
{
	mp.stop();
}

function $(strId)
{
	return document.getElementById(strId);
}
var positionFlag = 0; //页面焦点位置标志
var lightImages = new Array();
var darkImages = new Array();
lightImages[0] = "images/playcontrol/playVod/bookmark1.gif";
lightImages[1] = "images/playcontrol/playVod/sure1.gif";
lightImages[2] = "images/playcontrol/playVod/cancel1.gif";
lightImages[3] = "images/playcontrol/playVod/preVod1.jpg";
lightImages[4] = "images/playcontrol/playVod/nextVod1.jpg";

darkImages[0] = "images/playcontrol/playVod/bookmark.gif";
darkImages[1] = "images/playcontrol/playVod/sure.gif";
darkImages[2] = "images/playcontrol/playVod/cancel.gif";
darkImages[3] = "images/playcontrol/playVod/preVod.jpg";
darkImages[4] = "images/playcontrol/playVod/nextVod.jpg";
	
document.onkeypress = keyEvent;

function keyEvent()
{
	var val = event.which ? event.which : event.keyCode;
	return keypress(val);
}
	
function keypress(keyval)
{
	switch(keyval)
	{
		case <%=KEY_UP%>:return pressKey_up();		
		case <%=KEY_DOWN%>:return pressKey_down();			
		case <%=KEY_LEFT%>:  return pressKey_left();		 
		case <%=KEY_RIGHT%>:return pressKey_right();			
		case <%=KEY_PAGEDOWN%>:return pressKey_pageDown();				
		case <%=KEY_PAGEUP%>:return pressKey_pageUp();
		case <%=KEY_PAUSE_PLAY%>:
		case <%=KEY_POS%>:
			  pauseOrPlay();return 0;
	    case <%=KEY_RETURN%>:pressKey_quit(); return 0; //退出时处理
		case <%=KEY_STOP%>:pressKey_Stop();return 0;
		case <%=KEY_VOL_UP%>:volumeUp();return false;
		case <%=KEY_VOL_DOWN%>:volumeDown();return false;
		case <%=KEY_FAST_FORWARD%>:fastForward();return false;
		case <%=KEY_FAST_REWIND%>:fastRewind();return false;
		case <%=KEY_IPTV_EVENT%>:goUtility();  break;
		case <%=KEY_MUTE%>:setMuteFlag();return false;
		case <%=KEY_BLUE%>:
		case <%=KEY_INFO%>:
			//window.location.href="space_collect.jsp";
			 pressOk(); return 0;
		case <%=KEY_TRACK%>:
		   changeAudio(); return 0;
		case <%=KEY_OK%>:	
		   // window.location.href="ajaxTest.jsp";
		   pressOk();return;
		//case 277:
		case  1109:
			mp.stop();window.location.href="dibbling.jsp";return 0;
		//case 276:
		case 1110:
			mp.stop();window.location.href="playback.jsp";return 0;
		//case 275:
		case 1108:
			mp.stop();window.location.href="channel.jsp";return 0;
		case 1111://通信
				return 0;
		  default:
				return videoControl(keyval);
	}
	return true;
}
/************************************************按键响应处理 start************************************************/

var voiceflag="";

function changeAudio()
{
    mp.switchAudioChannel();

	var audio = mp.getCurrentAudioChannel();

	if(audio=="0" || audio=="Left")
	{
	    audio=0;
	}
	else if(audio=="1" ||  audio=="Right")
	{
	    audio=1;	
	}
	else if(audio=="2" ||  audio=="JointStereo" || audio=="Stereo" )
	{
	    audio=2;	
	}
	clearTimeout(voiceflag);
	switch(audio)
	{
		case 0:
		$("voice").src="../images/play/leftvoice.png";
		break;
		case 1:
		$("voice").src="../images/play/rightvoice.png";
		break;
		case 2:
		$("voice").src="../images/play/centervoice.png";
		break;
		default:
		break;
	}
	voiceflag=setTimeout(function(){$("voice").src="../images/dot.gif";},5000);

}
function pressOk()
{	
	var totalTime = mp.getMediaDuration();
	var currTime = parseInt(mp.getCurrentPlayTime()) + parseInt(count*60);
	if(currTime<=0)
	{
		currTime=1;
	}
	if(!jumpDivIsShow)
	{	
		pressKey_info_Ok();
	}
	else if(jumpDivIsShow && jumpPos==4)
	{
		jumpDivIsShow=false;
		playByTime(currTime);
		$("seekDiv").style.display = "none";
		isSeeking = 0;
		speed = 1;
		seekDivIsShow =false;
	}
	return 0;
}
//静音设置
function setMuteFlag()
{
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow){return true;}
	clearTimeout(showTimer);showTimer = "";	
	clearTimeout(bottomTimer);bottomTimer = "";	
	voiceIsShow = true;
	if(minEpgIsShow){hideMinEpg();}
	var muteFlag = mp.getMuteFlag();
	if(muteFlag == 1){
		mp.setMuteFlag(0);
		if (mp.getNativeUIFlag() == 0 || mp.getMuteUIFlag() == 0)
		{
			$("voice").src="../images/play/muteoff.png";
			bottomTimer = setTimeout(hideMute, 5000);
		}
	}else{
		mp.setMuteFlag(1);
		if (mp.getNativeUIFlag() == 0 || mp.getMuteUIFlag() == 0)
		{
			$("voice").src="../images/play/muteon.png";
		}
	}
	if(volumeDivIsShow){hideBottom();}   
}
	
//暂停
function pauseOrPlay()
{	
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow){return ;	}
	else if(minEpgIsShow){hideMinEpg();	//如果miniEPG显示，则隐藏
	}		
	speed = 1;
	jumpDivIsShow = true; 
	displaySeekTable(0);//显示进度条及跳转框	
	$("jumpTimeDiv").style.display = "block";
	$("jumpTimeImg").style.display = "block";
	playStatFlag=1;
}
	
function volumeUp()
{
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow){return true;}
	clearTimeout(showTimer);showTimer = "";
	volumeDivIsShow = true;
	if(minEpgIsShow){hideMinEpg();}
	var muteFlag =  mp.getMuteFlag();
	if(muteFlag == 1){mp.setMuteFlag(0);}
	if(voiceIsShow){hideMute();}
	volume = mp.getVolume();
	volume += 5;
	if(volume >100){volume = 100;return;}
	mp.setVolume(volume);
	if (mp.getNativeUIFlag() == 0 || mp.getAudioVolumeUIFlag() == 0)
	{
		clearTimeout(bottomTimer);bottomTimer = "";
		genVolumeTable(volume);
		bottomTimer = setTimeout(hideBottom, 5000);
	}
}
//音量图片的隐藏
function hideBottom()
{	
	if(volumeDivIsShow == false)return;
	volumeDivIsShow = false;
	$("bottomframe").innerHTML = "";
}
//隐藏是否静音的图标	
function hideMute()
{
	$("voice").src="#";
	voiceIsShow=false;
}
	
	function genVolumeTable(volume)
    {
    	var tableDef = '<table width="980px" border="0" cellpadding="0" cellspacing="0"><tr>';
    	volume = parseInt(volume / 5);
  
    	for (i = 0; i < 40; i++)
    	{
    		if (i % 2 == 0)
    		{
    			tableDef += '<td width="20px" height="54px" bgcolor="transparent"></td>';
    		}
    		else
    		{
    			if ( i / 2 < volume)
    			{
    				tableDef += '<td width="20px" height="54px" bgcolor="#00ff00"></td>';
    			}
    			else
    			{
    				tableDef += '<td width="20px" height="54px" bgcolor="cccccc"></td>';
    			}
    		}
    	}

    	tableDef += '<td width="20px"></td><td width="40px"><img border="0" src="../images/play/volume.gif"></td><td width="40px" style="color:white;font-size:28">' + volume + '</td>';

    	tableDef += '</tr></table>';

    	$("bottomframe").innerHTML = tableDef;
    }
function volumeDown()
{
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow){return true;}
	clearTimeout(showTimer);showTimer = "";
	volumeDivIsShow = true;
	if(minEpgIsShow){hideMinEpg();}
	var muteFlag = mp.getMuteFlag();
	if(muteFlag == 1){mp.setMuteFlag(0);}
	if(voiceIsShow){hideMute();}
	volume = mp.getVolume();
	volume -= 5;
	if(volume < 0){volume = 0;return;}
	mp.setVolume(volume);
	if (mp.getNativeUIFlag() == 0 || mp.getAudioVolumeUIFlag() == 0)
	{
		clearTimeout(bottomTimer);
		bottomTimer = "";
		genVolumeTable(volume);
		bottomTimer = setTimeout(hideBottom, 5000);
	}
}
	
	//显示时间进度条
    function displaySeekTable(playFlag)
    {
	    mediaTime = mp.getMediaDuration();
        //有时机顶盒取出的vod总时长有问题，在这里重新获取。initMediaTime是初始化页面时取出的总片铿
        if(undefined == mediaTime || typeof(mediaTime) != "number" || mediaTime.length == 0 || 0 == mediaTime || initMediaTime != mediaTime)
        {
            mediaTime = mp.getMediaDuration();
			//计算移动一格的单元
			timePerCell = mediaTime / 100;
        }
        //isSeeking等于0时展示进度条及跳转框
        if(isSeeking == 0)
        {
			isSeeking = 1;
            currTime = mp.getCurrentPlayTime();
            processSeek(currTime);
            var fullTimeForShow = "";
            fullTimeForShow = convertTime();			
            $("fullTime").innerHTML = fullTimeForShow;
            $("statusImg").innerHTML = '<img border="0" src="../images/play/pause.png" width="40" height="40"/>';			
			$("seekDiv").style.display = "block"; //显示进度条
			//显示跳转框		   
			// $("jumpTimeHour").focus(); //给跳转框落焦点 20120315屏蔽
			jumpPos=4;
		    $("currentTime_progress").style.background="url(../images/play/chanMini_timePro.png)";
            //6秒后隐藏跳转输入框所在的div
            clearTimeout(timeID_jumpTime);
            timeID_jumpTime = "";
		    checkSeeking();//调用方法检测进度条及跳转框的状态
			if (playFlag != 1)
			{
            	pause();//暂停播放
				//playStatus= 0;
            }
			seekDivIsShow = true;
        }
        else
        {
			clearTimeout(timeID_check);//清空定时            timeID_check = "";
            resetPara_seek();//复位各参数
			// 如果切换到开头则不需要恢复播放，机顶盒会自动播放
			if (playFlag != 2 && playFlag != 3)
			{
				speed = 1;
            	resume();//恢复播放状态
            }
			seekDivIsShow = false;
			jumpDivIsShow = false;
            $('seekDiv').style.display = 'none';
			jumpPos = 0;	
        }
    }
	
	//跳转提示信息隐藏后，重置相关参数
    function resetPara_seek()
    {	
        clearTimeout(timeID_jumpTime);
        timeID_jumpTime = "";
        isSeeking = 0;
		jumpPos = 0;
        isJumpTime = 1;
        preInputValueHour = "";
	    preInputValueMin = "";
		jumpDivIsShow = true;
        $("jumpTimeDiv").style.display = "block";
        $("jumpTimeImg").style.display = "block";
	    $("jumpTimeHour").value = "";
        $("jumpTimeMin").value = "";
        $("timeError").innerHTML = "";//请输入时间！
        $("statusImg").innerHTML = '<img border="0" src="../images/play/pause.png" width="40" height="40"/>';
    }
function checkSeeking()
{       
	if(isSeeking == 0){clearTimeout(timeID_check);timeID_check = "";}
	else{
		//下面一行代码的作用：获取不到文本框中的值，动态刷新文本框所在div可以解决
		if(playStat != "fastrewind" && playStat != "fastforward")
		{
			$("statusImg").innerHTML = '<img border="0" src="../images/play/pause.png" width="40" height="40"/>';
		}
		var inputValueHour = $("jumpTimeHour").value;
		var inputValueMin = $("jumpTimeMin").value;
		if(2==inputValueHour.length && 0==jumpPos ){$("jumpTimeMin").focus();jumpPos=1;}
		if(2==inputValueMin.length && 1==jumpPos ){$("ensureJump").focus();jumpPos=2;}
		clearTimeout(timeID_check);timeID_check = setTimeout(checkSeeking,500);
		if(playStatFlag==0 && (playStat == "fastrewind" || playStat == "fastforward"))
		{	
			currTime = mp.getCurrentPlayTime();processSeek(currTime);
		}
		if(preInputValueHour != inputValueHour || preInputValueMin != inputValueMin)
		{               
			var tempTimeID = timeID_jumpTime;
			//6秒后隐藏跳转输入框所在的div
			clearTimeout(tempTimeID);
			tempTimeID = "";
			timeID_jumpTime = setTimeout(hideJumpTimeDiv,15000);
			preInputValueHour = inputValueHour;
			preInputValueMin = inputValueMin;
		}
	}
}
function playByTime(beginTime)
{
	if(isSeeking == 1)
	{
	//	beginTime = tempCurrTime;
	}
	var type = 1;
	var speed = 1;
	playStat = "play";
    currTime = mp.getCurrentPlayTime();
	//if(beginTime==0){beginTime=currTime;} //20120523
	mp.playByTime(type,beginTime,speed);
	mp.setVideoDisplayMode(1);
	mp.refreshVideoDisplay();
	count=0;
	jumpPos=0;
	$("currentTime_progress").style.background="url(../images/play/chanMini_lostTimePro.png)";	
	$("jumpTimeHour").focus();
}
	  function jumpToTime(_time)
    {
        timeForShow = 0;
        _time = parseInt(_time,10);
        
        playByTime(_time);
        processSeek(_time);
    }
	   function checkJumpTime(pHour, pMin)
    {        
        if(isEmpty(pHour))
        {
            return false;
        }
        else if(!isNum(pHour))
        {    
            return false;
        }
        
        if(isEmpty(pMin))
        {
            return false;
        }
        else if(!isNum(pMin))
        {
            return false;
        }
        
        else if(!isInMediaTime(pHour, pMin))
        { 
            return false;
        }
        else
        {
            return true;
        }
        
    }
		
    function isNum(s)
    {
        var nr1=s;
        var flg=0;
        var cmp="0123456789"
        var tst ="";
        
        for (var i=0;i<nr1.length;i++)
        {
            tst=nr1.substring(i,i+1)
            if (cmp.indexOf(tst)<0)
            {
                flg++;
            }
        }
        
        if (flg == 0)
        {
            return true;
        }
        else
        {
            return false;
        }    
    }

	 //判断是否在播放时长内
    function isInMediaTime(pHour, pMin)
    {
        pHour = pHour.replace(/^0*/, "");
        if(pHour == "")
        {
            pHour = "0";
        }
        pMin = pMin.replace(/^0*/, "");        
        if(pMin == "")
        {
            pMin = "0";
        }
        var alltime=pHour*3600+pMin*60
		return (alltime <= mediaTime);
	}
	
//定时选择按钮
function clickJumpBtn()
{
	var inputValueHour = $("jumpTimeHour").value;
	var inputValueMin = $("jumpTimeMin").value;
	_time = mp.getMediaDuration();
	if(isEmpty(inputValueHour)){inputValueHour="00";}
	if(isEmpty(inputValueMin)){ inputValueMin="00";}
	if(checkJumpTime(inputValueHour, inputValueMin))
	{
	    var hour = parseInt(inputValueHour,10);
	    var mins = parseInt(inputValueMin,10);
		var timeStamp =  hour*3600 + mins*60;
		clearTimeout(timeID_jumpTime);
		timeID_jumpTime = "";
		isJumpTime = 0;
		$("jumpTimeDiv").style.display = "none";
		$("jumpTimeImg").style.display = "none";
		$("jumpTimeHour").value = "";
		$("jumpTimeMin").value = "";
	    displaySeekTable(3);
		jumpToTime(timeStamp);
	}
	//校验不通过，提示用户时间输入不合理
	else
	{
		$("jumpTimeHour").value = "";
		$("jumpTimeMin").value = "";
		$("timeError").innerHTML = "时间输入不合理，请重新输入！&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		jumpPos = 0;
		preInputValueHour = "";
		preInputValueMin = "";
		$("jumpTimeHour").focus();
		//15秒后隐藏跳转输入框所在的div"
	   clearTimeout(timeID_jumpTime); timeID_jumpTime = ""; 
	   //timeID_jumpTime = setTimeout("hideJumpTimeDiv();",15000);
	}
	count=0;
}

  /**
 *隐藏跳转框所在的div
 */
function hideJumpTimeDiv()
{
	clearTimeout(timeID_jumpTime);
	timeID_jumpTime = "";
	preInputValueHour = "";
	preInputValueMin = "";
	jumpDivIsShow = false;
	var inputValueHour = $("jumpTimeHour").value;
	var inputValueMin = $("jumpTimeMin").value;

	//如果文本框中的值为空，隐藏div
	if(isEmpty(inputValueHour) || isEmpty(inputValueMin))
	{
		isJumpTime = 0;
		 $("jumpTimeHour").blur();
		 $("jumpTimeMin").blur();
		 $("jumpTimeDiv").style.display = "none";
		 $("jumpTimeImg").style.display = "none";
	}
	//如果文本框中有值则调用clickJumpBtn方法
	else
	{
		clickJumpBtn();
	}
	count=0;
	jumpPos=0;
	$("currentTime_progress").style.background="url(../images/play/chanMini_lostTimePro.png)";
	$("jumpTimeHour").focus();
}
	
function isEmpty(s)
{
	return ((s == undefined) || (s == "") || (s == null) || (s.length == 0));
}
 function convertTime(_time)
{
	if(undefined == _time || _time.length == 0)
	{
		_time = mp.getMediaDuration();
	}

	var returnTime = "";

	var time_second = "";
	var time_min = "";
	var time_hour = "";

	time_second = String(_time % 60);

	var tempIndex = -1;
	tempIndex = (String(_time / 60)).indexOf(".");
	if(tempIndex != -1)
	{
		time_min = (String(_time / 60)).substring(0,tempIndex);
		tempIndex = -1;
	}
	else
	{
		time_min = String(_time / 60);
	}

	tempIndex = (String(time_min / 60)).indexOf(".");
	if(tempIndex != -1)
	{
		time_hour = (String(time_min / 60)).substring(0,tempIndex);
		tempIndex = -1;
	}
	else
	{
		time_hour = String(time_min / 60);
	}

	time_min = String(time_min % 60);
	if("" == time_hour || 0 == time_hour)
	{
		time_hour = "00";
	}

	if("" == time_min || 0 == time_min)
	{
		time_min = "00";
	}

	if("" == time_second || 0 == time_second)
	{
		time_second = "00";
	}


	if(time_hour.length == 1)
	{
		time_hour = "0" + time_hour;
	}

	if(time_min.length == 1)
	{
		time_min = "0" + time_min;
	}

	if(time_second.length == 1)
	{
		time_second = "0" + time_second;
	}

	returnTime = time_hour + ":" + time_min + ":" + time_second;

	return returnTime;
}
	 
	 //时间进度控制
	 function processSeek(_currTime)
     {
        //如果入参时间为空，则取当前时长
        if(null == _currTime || _currTime.length == 0){ _currTime = mp.getCurrentPlayTime();}
        if(_currTime < 0){ _currTime = 0;}
		if(_currTime>mediaTime){ _currTime=mediaTime;}
        var tempIndex = -1;
        tempIndex = (String(_currTime / timePerCell)).indexOf(".");
        if(tempIndex != -1){ currCellCount = (String(_currTime / timePerCell)).substring(0,tempIndex);}
        else{  currCellCount = String(_currTime / timePerCell);}
        if (timePerCell == 0)
        {
            currCellCount  = 0;
        }
        if(currCellCount > 100)
        {
            currCellCount = 100;
        }
        if(currCellCount < 0)
        {
            currCellCount = 0;
        }
        $("seekPercent").innerHTML = currCellCount + "%";
   
        var currTimeDisplay = convertTime(_currTime);//将时间（单位：秒）转换成在页面中显示的格式（HH：MM?
	    if(currCellCount >= 100)
		{
			 $("td_0").style.width = 1000;	//990
			 $("td_1").style.width = 0; //10
		}
		else if(currCellCount<=0)
		{
			 $("td_0").style.width = 0;	//10
			 $("td_1").style.width = 1000;	//990
		}
		else
		{
			$("td_0").style.width = currCellCount * 10;
			$("td_1").style.width = 1000- currCellCount * 10;
		}
        $("currTimeShow").innerHTML = currTimeDisplay;
		$("td_0").bgColor =  "#DAA520";
		$("td_1").bgColor =  "#000080";
		$("currentTime_progress").style.left =132+currCellCount * 10;
    }
//快进
function fastForward()
{
	playStatFlag=0;
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow){return true;}
	if(minEpgIsShow){hideMinEpg();}
    if(isSeeking == 0)
	{	
		displaySeekTable(1);
		clearTimeout(timeID_jumpTime);
		timeID_jumpTime = "";
		isJumpTime = 0;
		$("jumpTimeDiv").style.display = "none";
		$("jumpTimeImg").style.display = "none";
	}
	//if(speed >= 32 && playStat == "fastforward"){displaySeekTable();return 0;}
	if(playStat == "fastrewind"||(speed >= 32 && playStat == "fastforward")) speed = 1;
	speed = speed * 2;
	playStat = "fastforward";
	mp.fastForward(speed);
	$("statusImg").innerHTML = '<img border="0" src="../images/play/fastForward.png" width="20" height="20"/>&nbsp;X'+speed;
}
	
//后退
function fastRewind()
{	
	playStatFlag=0;
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow){return;}
	if(minEpgIsShow){hideMinEpg();}

	if(isSeeking == 0)
	{
		displaySeekTable(1);
		clearTimeout(timeID_jumpTime);
		timeID_jumpTime = "";
		isJumpTime = 0;
		$("jumpTimeDiv").style.display = "none";
		$("jumpTimeImg").style.display = "none";
	}
	if (playStat == "fastforward"||(speed >= 32 && playStat == "fastrewind")) {speed = 1;}			
	speed = speed * 2;
	playStat = "fastrewind";				
	mp.fastRewind(-speed);				
	$("statusImg").innerHTML = '<img border="0" src="../images/play/fastRewind.png" width="20" height="20"/>&nbsp;X' + speed;
}
	
	function pressKey_up()
	{
		if(quitDivIsShow){mainPressKeyUp();}
		else if(oneKeySwitchJumpInfoIsShow){commonPressKeyUp();}
		else if(jumpToChannelInfoIsShow){commonPressKeyUp();}
		else if(jumpDivIsShow){
			//20120315修改屏蔽
			jumpPos=4;
			//$("currentTime").focus();
		    $("currentTime_progress").style.background="url(../images/play/chanMini_timePro.png)";
			return;
		}
		return false;
	}
	
	function pressKey_down()
	{
		if(quitDivIsShow)
		{
			mainPressKeyDown();
		}
		else if(oneKeySwitchJumpInfoIsShow)
		{
			commonPressKeyDown();
		}
		else if(jumpToChannelInfoIsShow)
		{
			commonPressKeyDown();
		}
		else if(jumpDivIsShow && jumpPos==4)
		{
			jumpPos=0;
			$("jumpTimeHour").focus();
			$("currentTime_progress").style.background="url(../images/play/chanMini_lostTimePro.png)";
			return;
		}
		return false;
	}

	function pressKey_left()
	{
		if(quitDivIsShow)
		{
			mainPressKeyLeft();
		}
		else if(finishedDivIsShow)
		{
			finishedPressKeyLeft();
		}
		else if(oneKeySwitchJumpInfoIsShow)
		{
			commonPressKeyLeft();
		}
		else if(jumpToChannelInfoIsShow)
		{
			commonPressKeyLeft();
		}
		else if(jumpDivIsShow)
		{ 
			jumpPressKeyLeft();
		}
		else
		{
            volumeDown();
			//fastRewind();
		}
		
		return false;
	}
	
	function pressKey_right()
	{		
		if(quitDivIsShow)
		{
			mainPressKeyRight();
		}
		else if(finishedDivIsShow)
		{
			finishedPressKeyRight();
		}
		else if(oneKeySwitchJumpInfoIsShow)
		{
			commonPressKeyRight();
		}
		else if(jumpToChannelInfoIsShow)
		{
			commonPressKeyRight();
		}
		else if(jumpDivIsShow)
		{
			jumpPressKeyRight();
		}
		else
		{
			volumeUp();
			//fastForward();
		}
		return false;
	}
	//暂停键后的方向键的操作
	function jumpPressKeyRight()
	{
		//说明：0:小时 1：分 2：确认 3：取消 4：进度
		if(jumpPos == 0){
			$("jumpTimeMin").focus();
			jumpPos++;
		}
		else if(jumpPos == 1){
			$("ensureJump").focus();
			jumpPos++;
		}
		else if(jumpPos==2){
		    $("cancelJump").focus();
			jumpPos++;	
		}
		else if(jumpPos==4){
			  var totalTime = parseInt(mp.getMediaDuration());
		      var currTime = parseInt(mp.getCurrentPlayTime());
			  count++;
			  currTime =currTime+parseInt(60*count);
			  if(currTime>=totalTime)
			  {
				currTime=totalTime;
				count--;
			  }
			  clearTimeout(timeID_jumpTime);
			  timeID_jumpTime = "";
			  isJumpTime = 0;
			 // alert(currTime);
			  processSeek(currTime);
		}
	}
	function jumpPressKeyLeft()
	{
		if(jumpPos == 1){
			$("jumpTimeHour").focus();
			jumpPos--;
		}
		else if(jumpPos == 2){
			$("jumpTimeMin").focus();
			jumpPos--;
		}
		else if(jumpPos==3){
		    $("ensureJump").focus();
			jumpPos--;
		}
		else if(jumpPos==4){
			var currTime = parseInt(mp.getCurrentPlayTime());
			count--;
			currTime = currTime+parseInt(count*60);
			if(currTime<=0){
			    currTime=0;
				count++;
			}
			clearTimeout(timeID_jumpTime);
			timeID_jumpTime = "";
			isJumpTime = 0;	
			//alert(currTime);
			processSeek(currTime);
		}
	}
	
	function finishedPressKeyLeft()
	{
		if(positionFlag == 4){
			clearTimeout(t);
			t = setTimeout("goNextProg()",3000);
			$("nextProg").focus();
			positionFlag = 3;
		}
	}
	function finishedPressKeyRight()
	{
		if(positionFlag == 3)
		{
			clearTimeout(t);
			t = setTimeout("goNextProg()",3000);
			$("finishedQuit").focus();
			positionFlag = 4;
		}
	}
	function showMinEpgByInfo()
	{
		if(!quitDivIsShow && !jumpToChannelInfoIsShow && !oneKeySwitchJumpInfoIsShow && !errorDivIsShow && !finishedDivIsShow)
		{
			if(!dataIsOk)//数据未准备好
			{
				return true;
			}
			if(minEpgIsShow)
			{
				hideMinEpg();
			}
			else
			{
				showMinEpg();
			}
			return true;
		}
	}
	function pressKey_info_Ok()
	{
		if(!quitDivIsShow && !jumpToChannelInfoIsShow && !oneKeySwitchJumpInfoIsShow && !errorDivIsShow &&!finishedDivIsShow)
		{
			if(!dataIsOk)//数据未准备好
			{
				return true;
			}
			if(minEpgIsShow)
			{
				hideMinEpg();
			}
			else
			{
				showMinEpg();
			}
		
			return true;
		}
		else if(quitDivIsShow)
		{	
			
		//	mainPressKeyOk();
			return true;
		}
		else if(jumpToChannelInfoIsShow)
		{
			commonPressKeyOk();
		}
		else if(oneKeySwitchJumpInfoIsShow)
		{	
		
			commonPressKeyOk();
		}
		
	}

	function mainPressKeyUp()
	{
		if(positionFlag == 2)
		{
			$("quit").focus();
			positionFlag = 0;
		}
	}
	
	function mainPressKeyDown()
	{
		if(positionFlag == 0 || positionFlag == 1)
		{
			if(isAssess)
			{
				return false;
			}
			positionFlag = 2;
			$("bookmark").focus();
		}
	}
	
	function mainPressKeyLeft()
	{
		if( positionFlag == 1)
		{	
			$("quit").focus();
			positionFlag--;
			return;
		}

	}
	
	function mainPressKeyRight()
	{
		if(positionFlag == 0)
		{
			positionFlag++;
			$("cancel").focus();
		}
	}

	function mainPressKeyOk()
	{
	
	}
	
//退出
function pressKey_quit()
{	
	//判断miniEPG数据是否取好，频道跳转层是否显示，一键跳转是否显示，退出层是否显示，结束提示层是否显示
	if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || quitDivIsShow || finishedDivIsShow){return;}
	if(minEpgIsShow){hideMinEpg();return;}
	else if(isSeeking == 1)
	{	
		//隐藏进度条和跳转框
		displaySeekTable(1);
		count=0;
		jumpPos=0;
		$("currentTime_progress").style.background="url(../images/play/chanMini_lostTimePro.png)";
		$("jumpTimeHour").focus();
	}else{
		hideAllDiv();//这一句话对性能有影响
		resetQuitDiv();//进入退出层时，重置退出层
		setTimeout(showQuitDiv,200) //显示退出层
		pause();
	}
}
	
	function pressKey_Stop()
	{
		//判断miniEPG数据是否取好，频道跳转层是否显示，一键跳转是否显示，退出层是否显示，结束提示层是否显示
		if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || quitDivIsShow || finishedDivIsShow)
		{
			return;
		}
		else
		{
			hideAllDiv();///这一句话对性能有影响
			pause();
			resetQuitDiv();//进入退出层时，重置退出层
			showQuitDiv(); //显示退出层
		}	
	}
	
	  
	function pressKey_pageUp()
	{
		if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow)
		{
			return false;
		}
		/*
		if(fatherId == -1)
		{
			goStart();
		}*/
		goStart();
		//goPreProg();
		hideAllDiv();
		return true;
	}
	
	function pressKey_pageDown()
	{	
		
		if(!dataIsOk || jumpToChannelInfoIsShow || oneKeySwitchJumpInfoIsShow || errorDivIsShow || quitDivIsShow || finishedDivIsShow)
		{
			return false;
		}
		goEnd();

		return false;
	}
	
	/**
	*机顶盒事件响应
	*/
	function goUtility()
    {	
        eval("eventJson = " + Utility.getEvent());
        var typeStr = eventJson.type;
        switch(typeStr)
        {	
            case "EVENT_MEDIA_ERROR":
                mediaError(eventJson);
                return false;
			case "EVENT_PLAYMODE_CHANGE":
				resumeMediaError(eventJson);
				break;		  	
            case "EVENT_MEDIA_END":
                finishedPlay();
                return false;
            case "EVENT_MEDIA_BEGINING":
				setTimeout("hideAllDiv();",200);
				speed = 1;
                break;
			case "EVENT_TVMS":
				 getTvms(eventJson);          	
            	 return false;
			case "EVENT_TVMS_ERROR":
				top.TVMS.closeMessage();
				top.TVMS.setKeyForSTB();
				return false;
            default :
                break;
        }
        return true;
    }
	
	function getTvms(eventJson)
	{
		top.TVMS.showMessage(eventJson);
	}
	
	/**
	*出现错误
	*/
	function mediaError(eventJson)
	{
		var type = eventJson.error_code;

		if(10 == type)
		{
			showMediaError();
		}
	}
	
	//显示错误提示
	function showMediaError()
	{
		hideAllDiv();
		hideOneKeySwitchJumpInfo();
		hideJumpToChannelInfo();
	//	setEPG();
		showErrorDiv();
	}
	
	//码流恢复事件响应
	function resumeMediaError(eventJson)
	{
        var type_new_play = eventJson.new_play_rate;
		var type_old_play = eventJson.old_play_rate;

		if(1 == type_new_play && 0 == type_old_play)
		{

				hideErrorDiv();
			
			resume(); 
		}
	}
	
/********************************************按键响应处理 end**************************************************************/

	/**
	*播放暂停
	*/
	function pause()
	{
		mp.pause();
	}
	/**
	*恢复播放
	*/
	function resume() 
	{
		mp.resume(); 
	}
	/**
	*一键到尾
	*/
	function goEnd()
	{
		mp.gotoEnd();
	}
	/**
	*一键到头
	*/
	function goStart()
	{
		mp.gotoStart();
	}
		
	/**
	*取消退出层
	*/
	function cancel()
	{
		resume();
	//	setSTB();
		hideQuitDiv();
	}
	
/**
*退出当前页
*/
function quit()
{	
	clearTimeout(t);
	var url = goBackUrl;
	if(errorDivIsShow){hideErrorDiv();}
	mp.stop();
	//搜索页面转码
	if(url.indexOf("self_ResultList.jsp")==0)
	{
		if(itype==1){url = encodeURI(url);window.location.href = url ;}
		else if(itype==0){window.location.href = url;	}		
	}
	else{window.location.href = url;	}
	if(url.indexOf("?")>0){
		if(goBackUrl.indexOf("&sitcom")!=-1){
			var tytmpstr = 	goBackUrl.substring(goBackUrl.indexOf("?"));
			tytmpstr = tytmpstr.substring(tytmpstr.indexOf("&sitcom"));
			var tmpsidx = tytmpstr.lastIndexOf("&");
			goBackUrl = goBackUrl.replace(tytmpstr,"");
		}
		url=goBackUrl+"&sitcom="+sitNum;
	}else{
		url=goBackUrl+"?sitcom="+sitNum;
	}
	window.location.href =url;
}
	
/**
*结束播放
*/
function finishedPlay()
{
	hideAllDiv();
	showFinishedDiv();
}


/**
*保存书签并退出
*/
function saveBookMark()
{
	clearTimeout(t);
	var url = goBackUrl;
	var jumpUrl = url;
	if(errorDivIsShow){hideErrorDiv();}
	//addBook();
	mp.stop();
	var backurl=goBackUrl+"&sitcom="+sitNum;
	window.location.href =backurl;
}
	

/**
*播放上一集
*/
function goPreProg()
{
	clearTimeout(minEpgShowDelayId);
	if(preProgId == '-1')
	{
		return true;
	}
	var jumpUrl = "au_PlayFilm.jsp?PROGID=" + preProgId + "&PROGTYPE=" + '<%=EPGConstants.VOD_ISSITCOM_YESSUBFILM %>'
			 + "&PLAYTYPE=" + '<%=EPGConstants.PLAYTYPE_VOD%>' + "&CONTENTTYPE=" + '<%=EPGConstants.CONTENTTYPE_VOD_VIDEO%>'
			 + "&BUSINESSTYPE=" + '<%=EPGConstants.BUSINESSTYPE_VOD%>' + "&ISTVSERIESFLAG=1&FATHERSERIESID=" + fatherId+"&TYPE_ID="+typeId+"&returnurl="+escape(goBackUrl);
	if(preCanPlay=="1")
	{
		jumpUrl = "errorinfo.jsp?ERROR_TYPE=2&ERROR_ID=129" ;
	}
	//setEPG();
	mp.stop();
	window.location.href = jumpUrl;
}

/**
*播放下一集
*/
function goNextProg()
{	
	clearTimeout(t);
	clearTimeout(minEpgShowDelayId);
	if(nextProgId == '-1'){return true;}
	var jumpUrl = "au_PlayFilm.jsp?PROGID=" + nextProgId + "&PROGTYPE=" + '<%=EPGConstants.VOD_ISSITCOM_YESSUBFILM %>'
			 + "&PLAYTYPE=" + '<%=EPGConstants.PLAYTYPE_VOD%>' + "&CONTENTTYPE=" + '<%=EPGConstants.CONTENTTYPE_VOD_VIDEO%>'
			 + "&BUSINESSTYPE=" + '<%=EPGConstants.BUSINESSTYPE_VOD%>' + "&ISTVSERIESFLAG=1&FATHERSERIESID=" + fatherId+"&TYPE_ID="+typeId+"&returnurl="+escape(goBackUrl);
	if(nextCanPlay=="1")
	{
		jumpUrl = "errorinfo.jsp?ERROR_TYPE=2&ERROR_ID=129" ;
	}
	mp.stop();
	window.location.href = jumpUrl;
}
	
	/**
	*进入退出层时，重置退出层
	*/
	function resetQuitDiv()
	{
		positionFlag = 0;
	}

	/**
	*页面加载结束后触发此函数
	*/
	function init()
	{
		loadData();
		bookMarkIsShow();
		genSeekTable();
	}
	
	/**
	*获取数据
	*/
	function loadData()
	{
		var dataIframe = $("getDataIframe");
		dataIframe.src = "play_controlVodData.jsp?progId="+ progId + "&fatherId=" + fatherId+"&isChildren="+isChildren;
	}
	
	//添加书签
	function addBook()
	{
		var bookIframe=$("addBookIframe");
	    var progTime=mp.getCurrentPlayTime(); //读取当前播放的时间
		var endTime = mp.getMediaDuration(); //该vod播放时长
		//var addBookUrl="datajsp/space_bookMarkAdd_iframedata.jsp?SUPVODID=<%=fatherId%>&PROGID=<%=progId%>&BEGINTIME="+progTime+"&ENDTIME="+endTime;
		//alert("addBookUrl:"+addBookUrl);
		//bookIframe.src=addBookUrl;
		getAJAXData("datajsp/space_bookMarkAdd_iframedata.jsp?SUPVODID=<%=fatherId%>&PROGID=<%=progId%>&BEGINTIME="+progTime+"&ENDTIME="+endTime,GetJson);
	}
    function GetJson(num)
	{
		//alert("添加书签成功返回"+num);	
	}
	
	/**
	*判断是否要显示书签
	*/
	//var showBookMark = false;
	function bookMarkIsShow()
	{
		if(!isAssess)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

/*************************涉及页面层显示部分 start**************************************************/
	var errorDivIsShow = false; //错误提示层是否显示标志位
	/**
	*显示错误提示层
	*/
	function showErrorDiv()
	{
		if(errorDivIsShow)
		{
			return true;
		}
		
		var errorDiv = $("errorDiv");
		var errorDiv2 = $("errorDiv2");
		errorDiv.style.display = "block";
		errorDiv2.style.display = "block";
		errorDivIsShow = true;
	}
	
	/**
	*隐藏错误提示层
	*/
	function hideErrorDiv()
	{
		$("errorDiv").style.display = "none";
		$("errorDiv2").style.display = "none";
		errorDivIsShow = false;
	}
	var minEpgIsShow = false; //minepg是否显示标志位
	var minEpgShowDelayId = 0;
	var minEpgHideDelayId = 0;
	/**
	*显示minEPG
	*/
	function showMinEpg()
	{
		if(minEpgHideDelayId != 0)
		{
			clearTimeout(minEpgHideDelayId);
			minEpgHideDelayId = 0;
		}
		if(minEpgIsShow)
		{
			return;
		}
		if(volumeDivIsShow)
		{
			hideBottom();
		}
		if(jumpDivIsShow)
		{	
			return; //如果跳转层显示,则返回
			hideJumpTimeDiv();
		}
		if(seekDivIsShow)
		{	
			return;//如果进度条显示，则不显示miniEPG
			$("seekDiv").style.display = "none";
		}
		var minEpgDiv = $("minEpgDiv");
		minEpgDiv.style.display = "block";

		minEpgIsShow = true;
		minEpgHideDelayId = setTimeout("hideMinEpg()",hideTime);
	}
	/**
	*隐藏minEPG
	*/
	function hideMinEpg()
	{
		if(minEpgIsShow == false)
		{	
			return;
		}
		if(minEpgShowDelayId != 0)
		{
			clearTimeout(minEpgShowDelayId);
			minEpgShowDelayId = 0;
		}
		$("minEpgDiv").style.display = "none";

		minEpgIsShow = false;
	}
	/**
	*生成Minepg层，在数据获取页面调用
	*/
	function createMinEpg()
	{
		setTimeout("delayCreateMinEpg()",1200);
	}
	function delayCreateMinEpg()
	{
			$("vodName").innerHTML = vodName;
			$("director").innerHTML = director;
			$("actor").innerHTML = actor;
			$("time").innerHTML = getVodTime();
			$("introduce").innerHTML = introduce;
			minEpgShowDelayId = setTimeout("showMinEpg()",delayTime);
	}
	var quitDivIsShow = false; //退出层是否显示标志位
	var finishedDivIsShow = false; //播放结束层是否显示的标志位
	/**
	*显示退出层
	*/
function showQuitDiv()
{
	if(quitDivIsShow == true){return;}
	$("quitDiv").style.display = "block";
	//$("bottomAd").style.display = "block";
	$("quit").focus();
	quitDivIsShow = true;
	//clearTimeout(minEpgShowDelayId);//20110821
}
	/**
	*隐藏退出层
	*/
	function hideQuitDiv()
	{
        if(quitDivIsShow == false)
		{
			return;
		}
		$("quitDiv").style.display = "none";
		//$("bottomAd").style.display = "none";
		quitDivIsShow = false;
		
	}
	function hideFinishedDiv()
	{
		if(finishedDivIsShow == false)
		{
			return;
		}
		$("finishedBackground").style.display = "none";
		//$("bottomAd").style.display = "none";
		if(nextProgId != "-1")
		{
			$("preNextDiv").style.display = "none";
		}
		else
		{
			$("endDiv").style.display = "none";
		}
		finishedDivIsShow = false;

	}
	
	//播放结束
	function showFinishedDiv()
	{	
		if(finishedDivIsShow == true){return;}
		$("finishedBackground").style.display = "block";
		//$("bottomAd").style.display = "block";
		if(nextProgId != "-1")
		{
			$("preNextDiv").style.display = "block";
			$("nextProg").focus();
			positionFlag = 3;
			clearTimeout(t);
			t = setTimeout("goNextProg()",3000);
		}
		else
		{
			$("endDiv").style.display = "block";
			$("end").focus();
			positionFlag = 5;
			tempTime=  setTimeout("antoQuit();",1000);
		}
		finishedDivIsShow = true;
	}
	
	function antoQuit()
	{
		 clearTimeout(tempTime);
	  	 window.location.href =goBackUrl;
	}
	/**
	*生成退出层,在数据获取页面调用（子页面）
	*/
	function createQuitDiv()
	{
		if(!isAssess)
		{
			$("saveBookMark").style.display = "block";
		}
		if(preProgId != "-1")
		{
			$("prePlay").style.visibility = "visible";
		}
		if(nextProgId != "-1")
		{
		//	$("nextPlay").style.visibility = "visible";
		}
	}

	/**
	*隐藏所有层
	*/
	function hideAllDiv()
	{	
		hideMinEpg();
		hideQuitDiv();
		hideFinishedDiv();
		hideBottom();
		hideErrorDiv();
		if(jumpDivIsShow)
		{
			hideJumpTimeDiv();
		}
		$("seekDiv").style.display = "none";
		seekDivIsShow =false;
		isSeeking = 0;		
		jumpPos =0 ;
		count=0;
		$("currentTime_progress").style.background="url(../images/play/chanMini_lostTimePro.png)";
		$("jumpTimeHour").focus();
	}
/*************************涉及页面层显示部分 end**************************************************/	
	/**
	*获取vod的播放时间
	*/
	function getVodTime()
    {
		var time = '';
		var hour = 0;
    	var minute = 0;
		var second = 0;
    	var totalSecond = mp.getMediaDuration();
    	
    	if(totalSecond != "undefined" && second != null)
    	{
    		minute = Math.floor(totalSecond/60);
			second = totalSecond%60;
    	}
		hour = Math.floor(minute/60);
		minute = minute%60;
		
		if(hour < 10)
		{
			hour = '0' + hour;
		}
		
		if(minute < 10)
		{
			minute = '0' + minute;
		}
		
		if(second < 10)
		{
			second = '0' + second;
		}
		time = hour + ':'+ minute + ':' + second;
    	return time;
    }
	
    /**
     *生成进度条，此方法只是生成背景，具体进度在processSeek方法中生憿
     *整个进度条长度为500像素，每个td即片长的1%斿像素
     */
function genSeekTable()
{
	var seekTableDef = "";
	seekTableDef = '<table width="1000" height="" border="0" cellpadding="0" cellspacing="0" bgcolor="#000080"><tr>';
	seekTableDef +='<td id="td_0" width="0%" height="20" style="border-style:none;"></td>';
	seekTableDef +='<td id="td_1" width="100%" height="20" style="border-style:none;"></td>';
	seekTableDef += '</tr></table>';
	$("seekTable").innerHTML = seekTableDef;
}
/**
*复写的公共控制页面的方法，判断公共页面的层是否可以显示
*/
function commonJumpDivCanShow()
{
	var canShow = false;
	if(!quitDivIsShow && !errorDivIsShow && !finishedDivIsShow)
	{
		canShow = true;
	}
	return canShow;
}
</script>
</head>
<body bgcolor="transparent" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="background-color: transparent" onLoad="start();init()" onUnload="unload()">
<div style="width:1px; height:1px; top:1px; left:1px;">
<a id="currentTime" href="#" style="width:1px; height:1px; top:-1px; left:-1px;"><img src="../images/dot.gif" width="1" height="1"/></a>
</div>

<div id="bottomframe" style="position:absolute;left:60px; top:530px; width:1200px; height:190px;color:green;font-size:36;"></div>

<!-- 进度条及跳转框所在的div begin-->
<div id="seekDiv" style="position:absolute;width:1280px;height:200px;left:0px;top:413px; z-index:1;display:none;">
  <!-- 进度条中显示的百分比 -->
  <div id="seekPercent" style="position:absolute;color:#FFFFFF;width:45;height:23;top:139;left:640;z-index:3;"></div>
    <!--进度点-->
  <div id="currentTime_progress" style="position:absolute;left:343px;top:168px;width:23px;height:23px; z-index:3; background:url(../images/play/chanMini_lostTimePro.png);"></div>


  <!-- 进度条所在div -->
  <div style="position:absolute; background:url(../images/play/control_bbg.png) repeat-x; width:100%; height:237px;left:0;top:87;z-index:-2;"></div>
  
  <div style="position:absolute;width:1280;height:237px;left:0;top:125;z-index:2;color:white;">
    <table width="1280" height="70" border="0" cellpadding="0" cellspacing="0">
      <tr height="40">
        <td></td>
        <td height="40"><table width="940" border="0" cellpadding="0" cellspacing="0" >
            <tr>
              <!-- 当前时间 -->
              <td id="currTimeShow" width="268" valign="middle" align="right" style="color:#FFF"></td>
              <!-- 当前播放状态-->
              <td id="statusImg" height="40" align="right" style="color:#FFF"></td>
              <td width="5"></td>
            </tr>
          </table></td>
        <td></td>
      </tr>
      <tr  style="color:#FFF">
        <td width="105" height="30" valign="middle" align="center" style="color:#FFF">00:00:00</td>
        <td width="1000"  valign="middle" align="center"  height="30">
			<table width="" height="" border="0" cellpadding="0" cellspacing="0">
				<tr>
				  <!-- 进度条-->
				  <td id="seekTable" width="" height="30" style="color:#FFF"></td>
				</tr>
			  </table>
		  </td>
        <td width="105" valign="middle" align="center" id="fullTime" style="color:#FFF"></td>
      </tr>
    </table>
  </div>
  
  <!-- 跳转框所在div -->
  <div id="jumpTimeImg" style="position:absolute; width:100%; height:220px;left:0;top:70;z-index:-3;"></div>
  
  <div id="jumpTimeDiv" style="position:absolute;width:1280;height:76;left:0;top:205px;z-index:3;color:white;">
    <table width="1280" height="76" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="5" colspan="6"></td>
      </tr>
      <tr height="36">
        <td width="40"></td>
        <td width="180" height="36" valign="middle" align="center" style="color:#FFF">请输入播放时间</td>
        <form action="javascript:clickJumpBtn();">
          <td width="60" valign="middle" align="center"><input id="jumpTimeHour" type="text" width="60" height="28" maxlength="2" size="2" style="color:#000000;font-size:24px"/></td>
          <td width="30" valign="middle" align="center" style="color:#FFF;">时</td>
          <td width="60" valign="middle" align="center"><input id="jumpTimeMin" type="text" width="60" height="28" maxlength="2" size="2" style="color:#000000;font-size:24px"/> </td>
        </form>
        <td width="30" valign="middle" align="center" style="color:#FFF">分</td>
        <td width="280" valign="middle" align="center"><a id="ensureJump" href="javascript:clickJumpBtn();"><img src="../images/play/ensureJump.png" width="73" height="28"/></a> &nbsp;&nbsp;&nbsp;&nbsp; <a id="cancelJump" href="javascript:pauseOrPlay();"><img src="../images/play/cancelJump.png" width="73" height="28"/></a> </td>
      </tr>
      <tr>
        <td height="5" colspan="6"></td>
      </tr>
      <tr>
        <!-- 跳转框下的提示信息 -->
        <td id="timeError" width="640" height="30" valign="middle" align="center" colspan="7" style="color:DAA520;font-size:24px"></td>
      </tr>
    </table>
  </div>
</div>
<!-- 进度条及跳转框所在的div end-->


<%--minEPG显示层开始--%>
<div style="position:absolute; left:15px; top:15px; width:54px; height:66px; z-index:3;"><img id="voice" src="images/dot.gif"/></div>
<div id="minEpgDiv" style="display:none;">
<div id="minEpgBackground" style="position:absolute; bottom:0; background:url(../images/play/control_bbg.png) repeat-x; width:1280px; height:237px;left:0px; top:500px; z-index:1;"></div>
<div style="position:absolute;left:40px; top:530px; width:1280px; height:160px;z-index:2;">
  <table width="1280" height="220">
    <tr>
      <td  height="3"></td>
    </tr>
   <tr>
      <td valign="bottom" height="25"><table>
          <tr valign="bottom">
            <td width="5"  height="25"></td>
            <td id="vodName" style="font-size:26px;color:#fff" align="left"></td>
          </tr>
        </table></td>
    </tr>
    <tr height="3">
      <td></td>
    </tr>
    <tr height="25">
      <td style="overflow:hidden"><table width="90%">
          <tr>
            <td class="blueFont"> 【导演】 </td>
            <td style="width:300px; height:20px;overflow:hidden;line-height:20;align:left;color:#fff;font-size:24px" id="director">
			
			</td>
            <td class="blueFont"> 【演员】 </td>
            <td style="width:300px; height:20px;overflow:hidden;line-height:20;align:left;color:#fff;font-size:24px" id="actor">
			
			</td>
            <td class="blueFont"> 【时长】 </td>
            <td id="time" style="font-size:26px;color:#fff" align="left"></td>
          </tr>
        </table></td>
    </tr>
    <tr height="3">
      <td></td>
    </tr>
    <tr>
      <td valign="top"><table width="100%">
          <tr>
            <td width="20"></td>
            <td class="whiteFont" valign="top" width="80" style="font-size:26px;color:#fff;" > 简介: </td>
            <td id="introduce" style="font-size:26px;color:#fff; line-height:30px" align="left"></td>
          </tr>
        </table></td>
    </tr>
  </table>
</div>
</div>
<%--minEPG显示层结束--%>

<%-- AD-begin--%>
<div id="bottomAd" style="position:absolute; bottom:0; left:0; background:url(../images/bottombg.png) repeat-x; width:1280px; height:152px;z-index:4;display:none;">
		<div class="bottom_ad" style="position:absolute; top:40px; left:72px"><img src="../images/temp/ad_1.jpg" /><img src="../images/temp/ad_2.jpg" /><img src="../images/temp/ad_3.jpg" /></div>	
</div>
<%--AD-END--%>

<%--退出层开始--%>
<div id="quitDiv" style="display:none;">

<div style="position:absolute; left:255px; top:135px; width:380px; height:262px;" align="center">
 <img src="../images/play/popup_bg2.png" height="380" width="730"> </div>
 
<div style="position:absolute; left:390px; top:155px; width:730px; height:480px; z-index:2; color:#FFFFFF; font-size:32px;">
  <table height="250" width="450" border="0" style="color:#FFF">
    <tr height="60px;">
      <td colspan="5"></td>
    </tr>
    <tr>
      <td colspan="5" align="center" style="color:#FFF">您是否要退出当前收看节目?</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td align="center" style="color:#FFF">退出</td>
      <td>&nbsp;</td>
      <td align="center" style="color:#FFF">取消</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td id="saveBookMark" colspan="3" style="position:relative;padding-left:60px; padding-top:5px;color:#FFF" align="center">加入书签并退出</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <div style="position:absolute; left:1px;top:160px;"></div>
  <a id="quit" href="javascript:quit();" style="position:absolute; left:72px; top: 132px;"><img src = "../images/dot.gif" width="83px" height="36px"/></a> 
  <a id="cancel" href="javascript:cancel();" style="position:absolute;left:295px; top:132px;"><img src = "../images/dot.gif" width="83px" height="36px"/></a>
  <a id="bookmark" href="javascript:saveBookMark();" style="position:absolute;left:138px; top:200px;"><img src = "../images/dot.gif" width="225px" height="36px"/></a> 
</div>

</div>
<%--退出层结束--%> 
  
<!--连续剧播放下一集-->
<div id="finishedBackground" style="position:absolute; left:255px; top:135px; width:730px; height:380px; display:none;"> 
<img src="../images/play/popup_bg2.png" height="380" width="730"> </div>
<div id="preNextDiv" style="position:absolute; left:450px; top:155px; width:730px; height:480px;display:none; z-index:2; color:#FFFFFF; font-size:24px;">
  <table height="140" width="320">
    <tr height="20px">
      <td colspan="5"></td>
    </tr>
    <tr>
      <td colspan="5" style="color:#FFF">您是否继续收看下一集?</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td style="color:#FFF">下一集</td>
      <td>&nbsp;</td>
      <td style="color:#FFF">退出</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <div style="position:absolute; left:-80px; top:170px;"> <img height="120px" width="450px" src="../images/temp/11.jpg" /> </div>
  <a id="nextProg" href="javascript:goNextProg();" style="position:absolute; left: 23px; top: 90px;"><img src = "../images/dot.gif" width="83px" height="36px"/></a>
  <a id="finishedQuit" href="javascript:quit();"  style="position:absolute;left:178px; top:90px;"><img src = "../images/dot.gif" width="83px" height="36px"/></a> </div>


<%--播放结束层--%>
<div id="endDiv" style="position:absolute; left:450px; top:200px; width:310px; height:262px; display:none; color:#FFFFFF; font-size:24px;">
 <table height="72" width="320" border="0">
    <tr>
      <td style="color:#FFFFFF; font-size:40px;" align="center">谢谢观看</td>
    </tr>
  </table>
  <div style="position:absolute; left:50px;top:132px;font-size:28px">1秒后自动退出</div>
  <a id="end" href="javascript:quit();" style="position:absolute; left: 73px; top: 12px; "><img src = "../images/dot.gif"  width="170px" height="44px"/></a> </div>
<%--播放结束--%>

<%--错误提示层--%>
<div id="errorDiv" style="position:absolute; left:120px; top:300px; width:400px; height:80px; z-index:-1; display:none"> <img src="../images/play/errorBack.gif" width="400px" height="80px"/> </div>
<div id="errorDiv2" style="position:absolute; left:120px; top:300px; width:400px; height:80px; z-index:1;display:none">
  <table align="center" width="400" align="center" height="80">
      <tr>
        <td class="whiteFont" align="center"> 系统错误，请按返回键退出或稍候再试！</td>
      </tr>
  </table>
</div>

<!--<div id="testDiv" style=" position:absolute;display:none;left:100px; top:100px;">
<img src="images/playcontrol/playVod/123.gif">
</div>-->

<%--隐藏层--%>
<div style="display:none">
  <%--获取数据--%>
  <iframe id="getDataIframe" width="0" height="0"></iframe>
  <%--记录书签--%>
  <iframe id="addBookIframe" width="0" height="0"></iframe>
</div>
 
<div id="test" style="font-size:36px; color:#FFF;">
</div>
<div style="display:none;">
<img src="../images/play/popup_bg2.png" />
<img src="../images/play/pause.png" />

</div>
</body>
<%@ include file = "play_pageVideoControl.jsp"%>
</div>
</html>
