function CommonProcess()
{
  this.default_EVENT=function()
  {
  };
  this.KEY_CHANNELUP_NUMBER_EVENT=function(num)
  {
  };
  this.KEY_HELP_INFO_EVENT=function()
  {
  };
  this.KEY_AUDIO_TRACK_EVENT=function()
  {
  };
  this.KEY_Sound_TRACK_EVENT=function()
  {
  };
  this.KEY_FASTFORWARD_EVENT=function()
  {
  };
  this.KEY_FASTREWIND_EVENT=function()
  {
  };
  this.KEY_MUTE_EVENT=function()
  {
  };
  this.KEY_SEEK_EVENT=function()
  {
  };
  this.KEY_PAGEUP_EVENT=function()
  {
  };
  this.KEY_PAGEDOWN_EVENT=function()
  {
  };
  this.KEY_CHANNELUP_EVENT=function()
  {
  };
  this.KEY_CHANNELDOWN_EVENT=function()
  {
  };
  this.KEY_UP_EVENT=function()
  {
    this.moveFocus(0);
  };
  this.KEY_DOWN_EVENT=function()
  {
    this.moveFocus(2)
  };
  this.KEY_LEFT_EVENT=function()
  {
    this.moveFocus(3)
  };
  this.KEY_RIGHT_EVENT=function()
  {
    this.moveFocus(1)
  };
  this.KEY_OK_EVENT=function()
  {
    this.doSelect()
  };
  this.KEY_PLAY_EVENT=function()
  {
  };
  this.KEY_BACK_EVENT=function()
  {
  };
  this.KEY_STOP_EVENT=function()
  {
  };
  this.KEY_VOLUP_EVENT=function()
  {
  };
  this.KEY_VOLDOWN_EVENT=function()
  {
  };
  this.KEY_AUDIOCHANNEL_EVENT=function()
  {
  };
  this.MEDIA_ERROR_EVENT=function(errorCode)
  {
  };
  this.PLAYMODE_CHANGE_EVENT=function()
  {
  };
  this.MEDIA_END_EVENT=function()
  {
  };
  this.MEDIA_BEGINING_EVENT=function()
  {
  };
  this.GO_CHANNEL_EVENT=function()
  {
  };
  this.REMINDER_EVENT=function()
  {
  };
  this.TVMS_MESSAGE_EVENT=function()
  {
  };
  this.clearFocus_EVENT=function()
  {
  };
  this.showFocus_EVENT=function()
  {
  };
  this.moveFocus=function(direction)
  {
	var objs = linkMap.get(currentSelectObjectId);
    if(objs!=undefined&&objs[direction]!=undefined&&objs[direction]!="")
    {
      var strs=objs[direction].split(",");
      for(var i=0;i<strs.length;i++)
      {
        if(document.getElementById(strs[i])!=null)
        {
          this.clearFocus_EVENT();
          currentSelectObjectId=strs[i];
          this.showFocus_EVENT();
          break;
        }
      }
    }
  };
  this.doSelect=function()
  {
    var obj=document.getElementById(currentSelectObjectId);
    var strs=obj.title;
    if(strs==undefined||strs==null||strs=="")
    {
      return ;
    }
    eval("var _addressObj = "+strs);
    if(_addressObj!=undefined&&_addressObj!=null&&_addressObj.length>0)
    {
      var jsname=_addressObj[0].js;
      var str=_addressObj[0].url;
      if(_addressObj.length==2)
      {
        if(_addressObj[0].js!=undefined&&_addressObj[0].js!=null)
        {
          jsname=_addressObj[0].js;
          str=_addressObj[1].url;
        }
        else
        {
          jsname=_addressObj[1].js;
          str=_addressObj[0].url;
        }
      }
      var jsresult=true;
      if(jsname!=undefined&&jsname!=null&&jsname!="")
      {
        try
        {
          jsresult=eval(jsname);
        }
        catch(e)
        {
          jsresult=false;
        }
      }
      if(str!=undefined&&str!=null&&str!="")
      {
        var temp=str.split("?");
        str=temp[0];
        if(temp.length>1)
        {
          str+="?"+encodeURI(temp[1]);
        }
        if(jsresult==true)
        {
          window.location.href=str;
        }
      }
      return jsresult;
    }
  }
}

///////////////////////////////////////
function getConfig(A)
{
  var B=Authentication.CUGetConfig(A);
  return B;
}

///////////////////////////////////////
var KEY_AUDIO_TRACK=262;
var KEY_Sound_TRACK=189;
var KEY_TV_IPTV=1290;
var KEY_POWEROFF=1291;
var KEY_SUBTITLE=1292;
var KEY_BOOKMARK=1293;
var KEY_PIP=1294;
var KEY_LOCAL=1295;
var KEY_REFRESH=1296;
var KEY_SETUP=282;
var KEY_HOME=292;
var KEY_BACK=8;
var KEY_DEL=8;
var KEY_ENTER=13;
var KEY_OK=13;
var KEY_HELP=284;
var KEY_LEFT=37;
var KEY_UP=38;
var KEY_RIGHT=39;
var KEY_DOWN=40;
var KEY_PAGEUP=33;
var KEY_PAGEDOWN=34;
var KEY_0=48;
var KEY_1=49;
var KEY_2=50;
var KEY_3=51;
var KEY_4=52;
var KEY_5=53;
var KEY_6=54;
var KEY_7=55;
var KEY_8=56;
var KEY_9=57;
var KEY_CHANNELUP=257;
var KEY_CHANNELDOWN=258;
var KEY_VOLUP=259;
var KEY_VOLDOWN=260;
var KEY_MUTE=261;
var KEY_PLAY=263;
var KEY_PAUSE=263;
var KEY_SEEK=271;
var KEY_SWITCH=280;
var KEY_FAVORITE=281;
var KEY_AUDIOCHANNEL=262;
var KEY_IME=283;
var KEY_FASTFORWARD=264;
var KEY_FASTREWIND=265;
var KEY_SEEKEND=266;
var KEY_SEEKBEGIN=267;
var KEY_HELP_INFO=268;
var KEY_HELP_INFO2=515;
var KEY_STOP=270;
var KEY_MENU=290;
var KEY_RED=275;
var KEY_GREEN=276;
var KEY_YELLOW=277;
var KEY_BLUE=278;
var KEY_STAR=106;
var KEY_SHARP=105;
var KEY_F1=291;
var KEY_F2=292;
var KEY_F3=293;
var KEY_F4=294;
var KEY_F5=295;
var KEY_F6=296;
var KEY_EVENT=768;
///////////////////////////////////////
function CommonEvent()
{
  var process;
  this.setProcess=function(obj){
    process=obj
  };
  this.getProcess=function(){
    return process
  };
  this.processEvent=function() 
  {
    if(event==null){
      return
    }
    var key_code=event.which?event.which:event.keyCode;
    switch(key_code)
    {
      case KEY_0:case KEY_1:case KEY_2:case KEY_3:case KEY_4:case KEY_5:case KEY_6:case KEY_7:case KEY_8:case KEY_9:process.KEY_CHANNELUP_NUMBER_EVENT(key_code-48);
      break;
      case KEY_HELP_INFO2:process.KEY_HELP_INFO_EVENT();
      break;
      case KEY_HELP_INFO:process.KEY_HELP_INFO_EVENT();
      break;
      case KEY_UP:process.KEY_UP_EVENT();
      break;
      case KEY_AUDIO_TRACK:process.KEY_AUDIO_TRACK_EVENT();
      break;
      case KEY_DOWN:process.KEY_DOWN_EVENT();
      break;
      case KEY_LEFT:process.KEY_LEFT_EVENT();
      break;
      case KEY_RIGHT:process.KEY_RIGHT_EVENT();
      break;
      case 13:case KEY_OK:process.KEY_OK_EVENT();
      break;
      case KEY_PLAY:process.KEY_PLAY_EVENT()();
      break;
      case 32:case KEY_BACK:process.KEY_BACK_EVENT();
      break;
      case KEY_STOP:process.KEY_STOP_EVENT();
      break;
      case KEY_VOLUP:process.KEY_VOLUP_EVENT();
      break;
      case KEY_VOLDOWN:process.KEY_VOLDOWN_EVENT();
      break;
      case KEY_AUDIOCHANNEL:process.KEY_AUDIOCHANNEL_EVENT();
      break;
      case KEY_FASTFORWARD:process.KEY_FASTFORWARD_EVENT();
      break;
      case KEY_FASTREWIND:process.KEY_FASTREWIND_EVENT();
      break;
      case KEY_EVENT:eval("_MediaEventStr = "+Utility.getEvent());
      var typeStr=_MediaEventStr.type;
      switch(typeStr)
      {
        case"EVENT_MEDIA_ERROR":process.MEDIA_ERROR_EVENT(_MediaEventStr.error_code);
        break;
        case"EVENT_PLAYMODE_CHANGE":process.PLAYMODE_CHANGE_EVENT();
        break;
        case"EVENT_MEDIA_END":process.MEDIA_END_EVENT();
        break;
        case"EVENT_MEDIA_BEGINING":process.MEDIA_BEGINING_EVENT();
        break;
        case"EVENT_GO_CHANNEL":process.GO_CHANNEL_EVENT();
        break;
        case"EVENT_REMINDER":process.REMINDER_EVENT();
        break;
        case"EVENT_TVMS_MESSAGE":process.TVMS_MESSAGE_EVENT();
        break
      }
      break;
      case KEY_MUTE:process.KEY_MUTE_EVENT();
      break;
      case KEY_SEEK:process.KEY_SEEK_EVENT();
      break;
      case KEY_PAGEUP:process.KEY_PAGEUP_EVENT();
      break;
      case KEY_PAGEDOWN:process.KEY_PAGEDOWN_EVENT();
      break;
      case KEY_CHANNELUP:process.KEY_CHANNELUP_EVENT();
      break;
      case KEY_CHANNELDOWN:process.KEY_CHANNELDOWN_EVENT();
      break;
      default:process.default_EVENT()
    }
  }
}
////////////////////////////////////
function BaseProcess()
{
}
BaseProcess.prototype = new CommonProcess();
var _proc_0=new BaseProcess();
/////////////////////////////////////
function _eventProc()
{
  var A=new CommonEvent();
  A.setProcess(_proc_0);
  A.processEvent()
}
///////////////绑定按键事件///////////////////
function keyBinds()
{
  if(navigator.appName.indexOf("Panel")>1){
    document.onkeypress=_eventProc
  } else {
    document.onkeydown=_eventProc
  }
};
//mxr:通过此方法来进行全角半角转化 如:"中国."长度为5   "中国a"长度为5
String.prototype.cnLength = function(){
	 var arr=this.match(/[^\x00-\xff]/ig);
	 return this.length+(arr==null?0:arr.length);
}

