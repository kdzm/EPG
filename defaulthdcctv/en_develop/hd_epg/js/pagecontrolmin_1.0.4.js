﻿﻿var pageobj;var channelNum=5;var cTempChannelNum='';var tempChannelNum=0;var channelNumCount=0;var delayTime=2000;var t_num;var isTextBox;function PageObj(curareaid,index,areas,popups)
{this.curareaid=curareaid;this.areas=areas;this.popups=popups;this.backurl=undefined;this.youwanauseobj=undefined;this.pageOkEvent=undefined;this.goBackEvent=undefined;this.pageNumTypeEvent=undefined;this.jumpToChannelSBM=undefined;this.pageNumTypeEvent=function(num)
{}
this.pageTurnEvent=undefined;if(this.areas!=undefined)
for(i=0;i<this.areas.length;i++)
{this.areas[i].id=i;this.areas[i].pageobj=this;}
if(this.areas!=undefined)
areas[curareaid].changefocus(index,true);if(this.popups!=undefined)
{for(i=0;i<this.popups.length;i++)
this.popups[i].pageobj=this;}
this.move=function(dir)
{if(this.areas!=undefined)
{var nextareadata=this.areas[this.curareaid].move(dir==0||dir==1?-1:1,dir);if(nextareadata!=-1&&nextareadata!=undefined)
{this.curareaid=parseInt(nextareadata[0]);if(!this.areas[this.curareaid].doms[nextareadata[1]==undefined?0:nextareadata[1]].canFocus){nextareadata[1]=this.areas[this.curareaid].doms[nextareadata[1]==undefined?0:nextareadata[1]].replaceIndex;}
this.areas[parseInt(nextareadata[0])].areain(nextareadata[1]!=undefined?parseInt(nextareadata[1]):undefined,dir);}}}
this.ok=function()
{if(!!this.pageOkEvent)
this.pageOkEvent();if(this.areas!=undefined)
this.areas[this.curareaid].ok();}
this.numType=function(num)
{if(!!this.pageNumTypeEvent){this.pageNumTypeEvent(num);}
if(this.areas!=undefined)
this.areas[this.curareaid].numType(num);}
this.pageTurn=function(num,areaid)
{if(this.areas!=undefined)
this.areas[areaid==undefined?this.curareaid:areaid].pageTurn(num,areaid);if(!!this.pageTurnEvent)
this.pageTurnEvent(num);}
this.goBack=function()
{if(this.areas!=undefined)
{if(!this.areas[this.curareaid].goback())
{if(!!this.goBackEvent)
this.goBackEvent();if(this.backurl!=undefined)
window.location.href=this.backurl;}}}
this.getfocusindex=function()
{if(this.areas!=undefined)
return this.areas[this.curareaid].curindex;}
this.getfocusdom=function()
{if(this.areas!=undefined)
return this.areas[this.curareaid].doms[this.areas[this.curareaid].curindex];}
this.changefocus=function(areaid,index)
{if(this.areas!=undefined)
for(i=0;i<this.areas.length;i++)
{this.areas[i].clearfocus();if(i==areaid)
this.areas[i].changefocus(index,true);this.curareaid=areaid;}}}
var t1;Area.names=new Array();function Area(numrow,numcolum,doms,directions)
{this.dataarea=undefined;this.delay=true;this.datanum=undefined;this.curindex=0;this.stayindexdir=undefined;this.doms=doms;this.lockin=undefined;this.stablemoveindex=undefined;this.outstaystyle=false;this.youwanauseobj=undefined;this.curpage=1;this.pagecount=undefined;this.scrolldir=undefined;this.darkness=false;this.darknessIndex=undefined;this.asyngetdata=undefined;this.showasyndata=undefined;this.areaOkEvent=undefined;this.areaIningEvent=undefined;this.areaInedEvent=undefined;this.areaOutingEvent=undefined
this.areaOutedEvent=undefined;this.areaNumTypeEvent=undefined;this.firstpageEvent=undefined;this.lastpageEvent=undefined;this.changefocusingEvent=undefined;this.changefocusedEvent=undefined;this.areaPageTurnEvent=undefined;this.goBackEvent=undefined;this.bindDataEvent=undefined;this.id=undefined;this.numrow=numrow;this.numcolum=numcolum;this.directions=directions;this.pageobj=undefined;this.useoneobj=false;this.circledir=undefined;this.directionsallow=new Array(directions[0]==-1?false:true,directions[1]==-1?false:true,directions[2]==-1?false:true,directions[3]==-1?false:true);this.stayindexarray=new Array(-1,-1);this.outstaydir=undefined;this.endwiseCrossturnpage=false;this.broadwiseCrossturnpage=false;this.commonfocusstyle=undefined;this.commonunfocusstyle=undefined;this.curSelectDomFocusStyle=undefined;this.curSelectDomUnfocusStyle=undefined;this.curSelectPage=1;this.upattention=undefined;this.downattention=undefined;this.leftattention=undefined;this.rightattention=undefined;this.tempindex=this.curindex;for(i=0;i<this.doms.length;i++)
{this.doms[i].id=i;this.doms[i].belongarea=this;}
this.flag=Area.names.length;Area.names[this.flag]=this;this.move=function(num,dirindex)
{if(num!=-1&&num!=1)
return-1;var cross;var isemptydom=false;if(dirindex==0||dirindex==2)
{var currow=parseInt(this.curindex/this.numcolum);if(num>0)
cross=(currow+num)>this.numrow-1;else
cross=(currow+num)<0;if(!cross)
{if(this.datanum!=undefined)
{var tmpnextindex=this.curindex+num*this.numcolum;if(tmpnextindex>this.datanum-1)
{cross=true;isemptydom=true;}}}
if(this.circledir==0)
return this.insidemove(true,dirindex,num,cross);}
else if(dirindex==1||dirindex==3)
{var curcolum=this.curindex%this.numcolum;if(num>0)
cross=(curcolum+num)>this.numcolum-1;else
cross=(curcolum+num)<0;if(!cross)
{if(this.datanum!=undefined)
{var tmpnextindex=this.curindex+num;if(tmpnextindex>this.datanum-1)
{cross=true;isemptydom=true;}}}
if(this.circledir==1)
return this.insidemove(true,dirindex,num,cross);}
if(cross)
{if(((!this.endwiseCrossturnpage||dirindex==1||dirindex==3)&&(!this.broadwiseCrossturnpage||dirindex==0||dirindex==2))||(this.curpage==1&&num<0)||(this.curpage==this.pagecount&&num>0))
{var changearea=this;var ischangearea=false;if(this.stablemoveindex!=undefined&&this.stablemoveindex[dirindex]!=-1)
{var tmpchange=(this.stablemoveindex[dirindex]).split(',');for(i=0;i<tmpchange.length;i++)
if(parseInt(tmpchange[i].split('-')[0])==this.curindex)
{break;}}
if(this.directions[dirindex]==-1?false:true)
{if(!!this.areaOutingEvent)
if(this.areaOutingEvent())
return-1;if(this.pageobj.areas[this.directions[dirindex]].lockin||(this.pageobj.areas[this.directions[dirindex]].datanum!=undefined&&this.pageobj.areas[this.directions[dirindex]].datanum<=0))
return-1;if(this.outstaydir!=undefined&&this.outstaydir==dirindex)
{this.darkness=true;if(typeof(this.outstaystyle)!="boolean")
{if(this.darknessIndex!=this.curindex){if(this.outstaystyle.constructor==Array)
this.doms[this.curindex].changestyle(this.outstaystyle);else
this.doms[this.curindex].changestyle(new Array(this.outstaystyle));}else{this.doms[this.curindex].changestyle(this.doms[this.curindex].focusstyle);}}
else if(!this.outstaystyle)
this.changefocus(this.curindex,false);}
else
{this.darkness=false;this.changefocus(this.curindex,false);}
var tmpstable;var tmpstablearea;if(this.stablemoveindex!=undefined)
if(this.stablemoveindex[dirindex]!=-1)
{var tmpmoveindex=this.stablemoveindex[dirindex].split(',');var stableindex;if(isemptydom)
{if(dirindex==2)
{var lastcolumindex=(this.numrow-1)*this.numcolum;var tmpcolum=this.curindex%this.numcolum;stableindex=lastcolumindex+tmpcolum;}
else if(dirindex==3)
{var tmprow=parseInt((this.curindex+1)/this.numcolum);stableindex=(tmprow+1)*this.numcolum-1;}}
else
stableindex=this.curindex;for(k=0;k<tmpmoveindex.length;k++)
{var tmp=tmpmoveindex[k].split('-');if(parseInt(tmp[0])==stableindex)
{if(tmp[1].indexOf('>')==-1)
tmpstable=parseInt(tmp[1]);else
{tmpstablearea=tmp[1].split('>')[0];tmpstable=tmp[1].split('>')[1];}
break;}}}
if(this.stayindexdir!=undefined)
if(this.stayindexdir.indexOf(''+dirindex)!=-1)
{this.stayindexarray[0]=this.curindex;this.stayindexarray[1]=dirindex;}
else
{this.stayindexarray[1]=-1;}
if(!!this.areaOutedEvent)
this.areaOutedEvent();return new Array((tmpstablearea!=undefined)?tmpstablearea:this.directions[dirindex],tmpstable);}
else
return-1;}
else
{if(dirindex==0)
this.pageturn(-1);else if(dirindex==2)
this.pageturn(1);if(dirindex==1)
this.pageturn(-1);else if(dirindex==3)
this.pageturn(1);return-1;}}
else
{return this.insidemove(false,dirindex,num);}}
this.insidemove=function(circle,dirindex,num,cross)
{if(!this.useoneobj)
this.changefocus(this.curindex,false);var nextindex;if(this.doms[this.curindex].canFocus)
this.tempindex=this.curindex;if(dirindex==0||dirindex==2)
nextindex=!circle?(this.curindex+num*this.numcolum):(num>0?(cross?(this.curindex-(this.numrow-1)*this.numcolum):(this.curindex+num*this.numcolum)):(cross?(this.curindex+(this.numrow-1)*this.numcolum):(this.curindex+num*this.numcolum)));else
nextindex=!circle?(this.curindex+num):(num>0?(cross?(this.curindex-this.numcolum+1):(this.curindex+num)):(cross?(this.curindex+this.numcolum-1):(this.curindex+num)));this.curindex=nextindex;if(!this.doms[this.curindex].canFocus){if(this.directions[dirindex]==-1&&this.circledir==undefined)
if(dirindex==0||dirindex==2){if((this.curindex/this.numcolum)<1||Math.ceil((this.curindex+1)/this.numcolum)>=this.numrow){this.curindex=this.tempindex;this.changefocus(this.curindex,true);return;}}else{if(this.curindex%this.numcolum==0||(this.curindex+1)%this.numcolum==0){this.curindex=this.tempindex;this.changefocus(this.curindex,true);return;}}
this.pageobj.move(dirindex);return;}
this.changefocus(this.curindex,true);return-1;}
this.changefocus=function(index,focusornot,backnochanggedata)
{if(!!this.changefocusingEvent)
if(focusornot)
if(this.changefocusingEvent())
return;this.curindex=index;this.doms[index].changefocus(focusornot,backnochanggedata);if(!!this.changefocusedEvent)
if(focusornot)
this.changefocusedEvent();}
this.areain=function(stableindex,dir)
{if(!!this.areaIningEvent)
if(this.areaIningEvent())
return;var tmpindex=0;if(stableindex!=undefined)
{if(this.datanum!=undefined&&stableindex>this.datanum-1)
{if(dir==0)
{var ifheng=true;for(i=1;i<this.numrow;i++)
if(stableindex-this.numcolum*i<=this.datanum-1)
{tmpindex=stableindex-this.numcolum*i;ifheng=false;break;}
if(ifheng)
{for(i=1;i<this.numcolum;i++)
if(this.numcolum-i-1<=this.datanum-1)
{tmpindex=this.numcolum-i-1;break;}}}
else if(dir==1)
{for(i=1;i<this.numcolum*this.numrow;i++)
{if(stableindex-i<=this.datanum-1)
{tmpindex=stableindex-i;break;}}}
else if(dir==2)
{var tmp=stableindex%this.numcolum+1;for(i=1;i<tmp;i++)
if(tmp-i<=this.datanum-1)
{tmpindex=tmp-i;break;}}
else if(dir==3)
{for(i=1;i<this.numrow;i++)
if(stableindex-this.numcolum*i<=this.datanum-1)
{tmpindex=stableindex-this.numcolum*i;break;}}}
else
tmpindex=stableindex;}
var backnochanggedata=false;if(this.stayindexarray[0]!=-1&&this.stayindexarray[1]==((dir+2)>3?(dir+2)%4:(dir+2)))
{tmpindex=this.stayindexarray[0];backnochanggedata=true;}
this.changefocus(tmpindex,true,backnochanggedata);if(!!this.areaInedEvent)
this.areaInedEvent();}
this.ok=function()
{if(this.areaOkEvent!=undefined)
this.areaOkEvent();if(this.darknessIndex!=undefined){if(!!this.commonunfocusstyle&&!!this.commonfocusstyle){this.doms[this.darknessIndex].unfocusstyle=this.commonunfocusstyle;this.doms[this.darknessIndex].focusstyle=this.commonfocusstyle;this.doms[this.darknessIndex].changestyle(this.commonunfocusstyle);}
this.darknessIndex=this.curindex;this.curSelectPage=this.curpage;if(!!this.curSelectDomFocusStyle&&!!this.curSelectDomUnfocusStyle){this.doms[this.darknessIndex].focusstyle=this.curSelectDomFocusStyle;this.doms[this.darknessIndex].unfocusstyle=this.curSelectDomUnfocusStyle;this.doms[this.darknessIndex].changestyle(this.curSelectDomFocusStyle);}}
this.doms[this.curindex].ok();}
this.setfocuscircle=function(circledir)
{this.circledir=circledir;}
this.setonlyoneobj=function(yesoront)
{this.useoneobj=yesoront;}
this.getid=function()
{return this.id;}
this.pageturn=function(num,pagebtn,areaid)
{if(this.curpage!=undefined&&this.pagecount!=undefined)
{var nextpage=this.curpage+num;if(nextpage>=1&&nextpage<=this.pagecount)
{this.curpage=nextpage;this.datanum=0;if(this.darknessIndex!=undefined){if(this.curSelectPage!=this.curpage){this.doms[this.darknessIndex].changestyle(this.commonunfocusstyle);this.doms[this.darknessIndex].focusstyle=this.commonfocusstyle;this.doms[this.darknessIndex].unfocusstyle=this.commonunfocusstyle;}else{this.doms[this.darknessIndex].focusstyle=this.curSelectDomFocusStyle;this.doms[this.darknessIndex].unfocusstyle=this.curSelectDomUnfocusStyle;this.doms[this.darknessIndex].changestyle(this.curSelectDomUnfocusStyle);}}
clearTimeout(t1);if(this.curpage==1&&!!this.firstpageEvent)
this.firstpageEvent();else if(this.curpage==this.pagecount&&!!this.lastpageEvent)
this.lastpageEvent();if(!!this.areaPageTurnEvent){this.areaPageTurnEvent(num);}
if(!pagebtn){if(this.endwiseCrossturnpage||this.broadwiseCrossturnpage)
{if(num>0)
{this.changefocus(this.curindex,false);this.changefocus(0,true);}
else if(num<0)
{this.changefocus(this.curindex,false);this.changefocus((this.numrow*this.numcolum)-1,true);}}}else if(areaid==undefined){this.changefocus(this.curindex,false);this.changefocus(0,true);}else if(areaid!=undefined){pageobj.areas[areaid].changefocus(pageobj.areas[areaid].curindex,false);}}}}
this.setendwisepageturnattention=function(up,canup,cantup,down,candown,cantdown)
{this.upattention=new Array($(up),canup,cantup);this.downattention=new Array($(down),candown,cantdown);}
this.setbroadwisepageturnattention=function(left,canleft,cantleft,right,canright,cantright)
{this.leftattention=new Array($(left),canleft,cantleft);this.rightattention=new Array($(right),canright,cantright);}
this.pagego=function(num)
{if(this.curpage!=undefined&&this.pagecount!=undefined)
if(num>=1&&num<=pagecount)
{curpage=num;this.asyngetdata();}}
this.numType=function(num)
{if(!!this.areaNumTypeEvent)
this.areaNumTypeEvent(num);if(!!this.doms[this.curindex].domNumTypeEvent){this.doms[this.curindex].domNumTypeEvent(num);}}
this.pageTurn=function(num,areaid)
{this.pageturn(num,true,areaid);}
this.checkfocusover=function()
{if(!!this.pageobj&&this.id==this.pageobj.curareaid)
{if(this.curindex>=this.datanum)
{this.changefocus(this.curindex,false);this.changefocus(0,true);}}
else
{if(this.curindex>=this.datanum)
{this.curindex=0;}}}
this.setendwisepageturndata=function(datanum,pagecount)
{this.datanum=datanum;this.pagecount=pagecount;if(this.upattention!=undefined&&this.downattention!=undefined)
if(this.pagecount==1||this.pagecount==0)
{this.upattention[0].src=this.upattention[2];this.downattention[0].src=this.downattention[2];}
else
{if(this.curpage==1)
{this.upattention[0].src=this.upattention[2];this.downattention[0].src=this.downattention[1];}
else if(this.curpage==this.pagecount)
{this.downattention[0].src=this.downattention[2];this.upattention[0].src=this.upattention[1];}else{this.downattention[0].src=this.downattention[1];this.upattention[0].src=this.upattention[1];}}
this.checkfocusover();}
this.setbroadwisepageturndata=function(datanum,pagecount)
{this.datanum=datanum;this.pagecount=pagecount;if(this.leftattention!=undefined&&this.rightattention!=undefined)
if(this.pagecount==1||this.pagecount==0)
{this.leftattention[0].src=this.leftattention[2];this.rightattention[0].src=this.rightattention[2];}
else
{if(this.curpage==1)
{this.leftattention[0].src=this.leftattention[2];this.rightattention[0].src=this.rightattention[1];}
else if(this.curpage==this.pagecount)
{this.rightattention[0].src=this.rightattention[2];this.leftattention[0].src=this.leftattention[1];}else{this.rightattention[0].src=this.rightattention[1];this.leftattention[0].src=this.leftattention[1];}}
this.checkfocusover();}
this.setstaystyle=function(staystyle,dir)
{this.outstaystyle=staystyle;this.outstaydir=dir;this.stayindexarray[1]=dir;if(this.stayindexdir!=undefined)
this.stayindexdir=this.stayindexdir+dir;else
this.stayindexdir=''+dir;}
this.setendwiseCrossturnpage=function()
{this.endwiseCrossturnpage=true;}
this.setdarknessfocus=function(index){this.curindex=index;this.darkness=true;this.stayindexarray[0]=index;if(this.outstaystyle.constructor==Array)
this.doms[index].changestyle(this.outstaystyle);else{if(!this.outstaystyle)
this.changefocus(this.curindex,true);else
this.doms[index].changestyle(new Array(this.outstaystyle));}}
this.setCurSelectDomStyle=function(focusstyle,unfocusstyle,dir){if(this.darknessIndex!=undefined){if(focusstyle.constructor!=Array){this.doms[this.darknessIndex].focusstyle=new Array(focusstyle);this.curSelectDomFocusStyle=new Array(focusstyle);}else{this.doms[this.darknessIndex].focusstyle=focusstyle;this.curSelectDomFocusStyle=focusstyle;}
if(unfocusstyle.constructor!=Array){this.doms[this.darknessIndex].unfocusstyle=new Array(unfocusstyle);this.curSelectDomUnfocusStyle=new Array(unfocusstyle);this.doms[this.darknessIndex].changestyle(new Array(unfocusstyle));}else{this.doms[this.darknessIndex].unfocusstyle=unfocusstyle;this.curSelectDomUnfocusStyle=unfocusstyle;this.doms[this.darknessIndex].changestyle(unfocusstyle);}
if(!!dir){this.outstaydir=dir;this.stayindexarray[1]=dir;if(this.stayindexdir!=undefined)
this.stayindexdir=this.stayindexdir+dir;else
this.stayindexdir=''+dir;}}}
this.clearfocus=function()
{this.changefocus(this.curindex,false);this.curindex=0;}
this.goback=function()
{if(!this.doms[this.curindex].goback()){if(!!this.goBackEvent)
{return this.goBackEvent();}
return false;}else{return true;}}}
function AreaCreator(numrow,numcolum,directions,domsidstring,domsfocusstyle,domsunfocusstyle)
{var doms=new Array();for(i=0;i<numrow*numcolum;i++)
{if(!(domsidstring.constructor==Array))
{doms[i]=new DomData(domsidstring+i);}
else
{doms[i]=new DomData();for(j=0;j<domsidstring.length;j++)
doms[i].dom[j]=$(domsidstring[j]+i);}}
var area=new Area(numrow,numcolum,doms,directions);if(domsfocusstyle!=undefined&&!(domsfocusstyle.constructor==Array))
domsfocusstyle=new Array(domsfocusstyle);area.commonfocusstyle=domsfocusstyle;if(domsunfocusstyle!=undefined&&!(domsunfocusstyle.constructor==Array))
domsunfocusstyle=new Array(domsunfocusstyle);area.commonunfocusstyle=domsunfocusstyle;return area;}
DomData.names=new Array();var t;function DomData(firstdomid,firstfocusstyle,firstunfocusstyle)
{this.id=undefined;this.dom=new Array();this.focusstyle=new Array();this.unfocusstyle=new Array();this.mylink=undefined;this.contentdom=undefined;this.imgdom=undefined;this.youwanauseobj=undefined;this.dataurlorparam=undefined;this.belongarea=undefined;this.focusEvent=undefined;this.unfocusEvent=undefined;this.domOkEvent=undefined;this.domNumTypeEvent=undefined;this.goBackEvent=undefined;this.canFocus=true;this.replaceIndex=undefined;this.dom[0]=$(firstdomid);if(arguments.length>1)
{this.focusstyle[0]=firstfocusstyle;this.unfocusstyle[0]=firstunfocusstyle;}
this.contentdom=$(firstdomid);this.imgdom=$(firstdomid);this.flag=DomData.names.length;DomData.names[this.flag]=this;this.dotime=function(){this.belongarea.dataarea.asyngetdata(this.dataurlorparam);}
this.changefocus=function(focusornot,backnochanggedata)
{if(focusornot)
{if(!!this.belongarea.dataarea&&!backnochanggedata)
{if(this.belongarea.delay)
{this.belongarea.dataarea.datanum=0;clearTimeout(t);t=setTimeout("DomData.names['"+this.flag+"'].dotime()",300);}
else
this.dotime();}
if(this.cutcontent!=undefined){if(this.belongarea.scrolldir==undefined||this.belongarea.scrolldir==false)
this.updatecontent("<marquee scrollamount='3'>"+this.content+"</marquee>");else
this.updatecontent("<marquee direction='"+this.belongarea.scrolldir+"'>"+this.content+"</marquee>");}
if(!!this.focusEvent)
this.focusEvent();}
else
{if(this.cutcontent!=undefined)
this.updatecontent(this.cutcontent);if(!!this.unfocusEvent)
this.unfocusEvent();}
if(focusornot)
{if(this.focusstyle.length>0)
this.changestyle(this.focusstyle);else if(!!this.belongarea.commonfocusstyle)
this.changestyle(this.belongarea.commonfocusstyle);}
else
{if(this.unfocusstyle.length>0)
this.changestyle(this.unfocusstyle);else if(!!this.belongarea.commonunfocusstyle)
this.changestyle(this.belongarea.commonunfocusstyle);}}
this.changestyle=function(newstyle)
{for(j=0;j<newstyle.length;j++)
{tmpstyle=newstyle[j];if(tmpstyle!=undefined)
{if(tmpstyle.indexOf(',')==-1)
{var tmpproerty=tmpstyle.split(':');this.dom[j][tmpproerty[0]]=tmpproerty[1];}
else
{var tmp=tmpstyle.split(',');for(i=0;i<tmp.length;i++)
{var tmpproerty=tmp[i].split(':');this.dom[j][tmpproerty[0]]=tmpproerty[1];}}}}}
this.ok=function()
{if(this.domOkEvent!=undefined)
this.domOkEvent();this.gotolink();}
this.gotolink=function()
{if(this.mylink!=undefined)
window.location.href=this.mylink;}
this.updatecontent=function(content)
{this.contentdom.innerHTML=content;}
this.setcontent=function(prefix,content,length,roll,dot)
{this.content=content;var cutstring=getbytelength(content)>length;if(cutstring)
{cutstring=prefix+getcutedstring(content,length,dot);this.updatecontent(cutstring);if(roll!=false)
this.cutcontent=cutstring;}
else
{this.content=undefined;this.cutcontent=undefined;this.updatecontent(prefix+content);}}
this.settext=function(num,content,prefix,length)
{var dom=this.dom[num];if(prefix==undefined&&length==undefined)
{dom.innerHTML=content;}
else
dom.innerHTML=prefix+getcutedstring(content,length,dot);}
this.updateimg=function(imgsrc)
{this.imgdom.src=imgsrc;}
this.getid=function()
{return this.id;}
this.goback=function()
{if(!!this.goBackEvent){this.goBackEvent();return true;}}
this.setCanFocus=function(canFocusFlag,replaceIndex){this.canFocus=canFocusFlag;if(!this.canFocus)
this.replaceIndex=replaceIndex;else
this.replaceIndex=undefined;}}
Popup.names=new Array();function Popup(popupdom,areas,areaid,index)
{PageObj.call(this,0,0,areas);this.closetime=undefined;this.popupdom=$(popupdom);this.pageobj=undefined;this.popareaid=areaid;this.popindex=index;this.closemedEvent=undefined;this.flag=Popup.names.length;Popup.names[this.flag]=this;this.showme=function()
{this.popupdom.style.display="block";this.pageobj=pageobj;pageobj=this;if(this.closetime!=undefined)
{setTimeout("Popup.names['"+this.flag+"'].closeme()",this.closetime*1000);}}
this.closeme=function()
{if(!!this.pageobj)
pageobj=this.pageobj;this.popupdom.style.display="none";if(!!this.closemedEvent)
this.closemedEvent();}
this.pageOkEvent=function()
{if(this.popareaid!=undefined&&this.popindex!=undefined)
if(this.curareaid==this.popareaid&&this.getfocusindex()==this.popindex)
this.closeme();}}
function $(id){return document.getElementById(id);}
function getbytelength(str){var byteLen=0,len=str.length;if(str){for(var i=0;i<len;i++)
{if(str.charCodeAt(i)>255)
byteLen+=2;else
byteLen++;}
return byteLen;}
return 0;}
function getcutedstring(sSource,iLen,dot)
{var str="";var l=0;var schar;if(dot)
iLen=iLen+4;for(var i=0;schar=sSource.charAt(i);i++)
{str+=schar;l+=(schar.match(/[^\x00-\xff]/)!=null?2:1);if(l>=iLen)
{break;}}
if(dot)
return str;else
return str+"...";}
var KEY_TV_IPTV=1290;var KEY_POWEROFF=1291;var KEY_SUBTITLE=1292;var KEY_BOOKMARK=1293;var KEY_PIP=1294;var KEY_LOCAL=1295;var KEY_REFRESH=1296;var KEY_SETUP=282;var KEY_HOME=292;var KEY_BACK=8;var KEY_DEL=8;var KEY_ENTER=13;var KEY_OK=13;var KEY_HELP=284;var KEY_LEFT=37;var KEY_UP=38;var KEY_RIGHT=39;var KEY_DOWN=40;var KEY_PAGEUP=33;var KEY_PAGEDOWN=34;var KEY_0=48;var KEY_1=49;var KEY_2=50;var KEY_3=51;var KEY_4=52;var KEY_5=53;var KEY_6=54;var KEY_7=55;var KEY_8=56;var KEY_9=57;var KEY_HOME=292;var KEY_CHANNELUP=257;var KEY_CHANNELDOWN=258;var KEY_VOLUP=259;var KEY_VOLDOWN=260;var KEY_MUTE=261;var KEY_PLAY=263;var KEY_PAUSE=263;var KEY_SEEK=271;var KEY_SWITCH=280;var KEY_FAVORITE=281;var KEY_AUDIOCHANNEL=286;var KEY_IME=283;var KEY_FASTFORWARD=264;var KEY_FASTREWIND=265;var KEY_SEEKEND=266;var KEY_SEEKBEGIN=267;var KEY_STOP=270;var KEY_MENU=290;var KEY_RED=275;var KEY_GREEN=276;var KEY_YELLOW=277;var KEY_BLUE=278;var KEY_STAR=106;var KEY_SHARP=105;var KEY_F1=291;var KEY_F2=292;var KEY_F3=293;var KEY_F4=294;var KEY_F5=295;var KEY_F6=296;var KEY_EVENT=768;document.onkeydown=keyDown;function keyDown(){var key_code=event.which?event.which:event.keyCode;switch(key_code){case 48:case KEY_0:pageobj.numType(0);break;case 49:case KEY_1:pageobj.numType(1);break;case 50:case KEY_2:pageobj.numType(2);break;case 51:case KEY_3:pageobj.numType(3);break;case 52:case KEY_4:pageobj.numType(4);break;case 53:case KEY_5:pageobj.numType(5);break;case 54:case KEY_6:pageobj.numType(6);break;case 55:case KEY_7:pageobj.numType(7);break;case 56:case KEY_8:pageobj.numType(8);break;case 57:case KEY_9:pageobj.numType(9);break;case 87:case KEY_UP:pageobj.move(0);break;case 65:case KEY_LEFT:pageobj.move(1);break;case 83:case KEY_DOWN:pageobj.move(2);break;case 68:case KEY_RIGHT:pageobj.move(3);break;case 13:case KEY_OK:pageobj.ok();break;case 32:case KEY_BACK:case 280:pageobj.goBack();break;case 188:case KEY_PAGEUP:pageobj.pageTurn(-1);break;case 190:case KEY_PAGEDOWN:pageobj.pageTurn(1);break;case KEY_RED:break;case KEY_GREEN:break;case KEY_YELLOW:break;case KEY_BLUE:break;case 113:case KEY_HOME:case KEY_MENU:window.loaction.href="<%=basePath%>page/index.jsp";break;default:break;}
return 0;}