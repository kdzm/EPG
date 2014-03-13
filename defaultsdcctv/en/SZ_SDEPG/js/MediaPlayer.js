var mp = new MediaPlayer();
var playUrl = "";
var playmode="tv";
var playstatus="first";
function initMediaStr(playUrl)
{
	mediaStr = '[{mediaUrl:"'+ playUrl +'",';
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
}

function initMediaPlay()
{
	var instanceId = mp.getNativePlayerInstanceID();
	var playListFlag = 0;
	var videoDisplayMode = 1,useNativeUIFlag = 1;
	var height = 0,width = 0,left = 0,top = 0;
	var muteFlag = 0;
	var subtitleFlag = 0;
	var videoAlpha = 0;
	var cycleFlag = 0;
	var randomFlag = 0;
	var autoDelFlag = 0;
	mp.initMediaPlayer(instanceId,playListFlag,videoDisplayMode,height,width,left,top,muteFlag,useNativeUIFlag,subtitleFlag,videoAlpha,cycleFlag,randomFlag,autoDelFlag);
	mp.setSingleMedia(mediaStr); //����ý�岥��������ý������
	mp.setAllowTrickmodeFlag(0); //�����Ƿ�����trick������ 0:���� 1��������
	mp.setNativeUIFlag(0); //�������Ƿ���ʾȱʡ��Native UI��  0:���� 1��������
	mp.setAudioTrackUIFlag(1);//��������ı���UI��ʾ��־ 0:������ 1������
	mp.setMuteUIFlag(1); //���þ����ı���UI��ʾ��־ 0:������ 1������
	mp.setAudioVolumeUIFlag(1);//�����������ڱ���UI����ʾ��־ 0:������ 1������
	mp.setVideoDisplayArea(203, 20,405, 305 );//ȫ����ʾ*/
	mp.setVideoDisplayMode(0); //1:ȫ����ʾ
	mp.setCycleFlag(1);
	mp.refreshVideoDisplay(); //������Ƶ��ʾ����Ҫ������������� 
}

function playChannel(lastChan){
	if(playmode=="tv" && playstatus=="second"){
	    mp.stop();
		mp.setVideoDisplayArea(203, 20,405, 305 );//ȫ����ʾ*/
	    mp.setVideoDisplayMode(0); //1:ȫ����ʾ
		//mp.refreshVideoDisplay(); //������Ƶ��ʾ����Ҫ������������� 
	    mp.joinChannel(lastChan);
	}else if(playmode=="tvod"  && playstatus=="second"){
		playmode="tv";
		mp.stop();
		mp.setVideoDisplayArea(203, 20,405, 305 );//ȫ����ʾ*/
	    mp.setVideoDisplayMode(0); //1:ȫ����ʾ
	    mp.joinChannel(lastChan);
	}else{
		initMediaPlay();
		mp.joinChannel(lastChan);
		playmode="tv";
	}
	playstatus="second";
}

function play(playUrl)
{
	initMediaStr(playUrl);
	Authentication.CTCSetConfig("key_ctrl_ex","0");
    if(playmode=="tv" && playstatus=="second")
	{
	   mp.leaveChannel();
	   mp.stop();
	   playmode="tvod";
	   mp.setSingleMedia(mediaStr); //����ý�岥��������ý������
	   mp.setCycleFlag(0);
	   mp.refreshVideoDisplay(); //������Ƶ��ʾ����Ҫ������������� 
	   mp.playFromStart();
	}
	else if(playmode=="tvod" && playstatus=="second")
	{
		mp.stop();
	    mp.setSingleMedia(mediaStr); //����ý�岥��������ý������
	    mp.setCycleFlag(0);
	    mp.refreshVideoDisplay(); //������Ƶ��ʾ����Ҫ������������� 
	    mp.playFromStart();
	}
	else
	{ 
	    initMediaPlay();
	    mp.playFromStart();
		playmode="tvod";
	}
	playstatus="second";
}

function destoryMP(){
	var instanceId = mp.getNativePlayerInstanceID();
	mp.stop();
	mp.releaseMediaPlayer(instanceId);
}

function setMuteFlag(){
	var flag = mp.getMuteFlag();
	if(flag == 0){
		mp.setMuteFlag(1);
	}else{
		mp.setMuteFlag(0);
	}
}

function volumUp(){
	var muteFlag = mp.getMuteFlag();
	if(muteFlag == 1)
	{
		mp.setMuteFlag(0);
	}
	var volume = mp.getVolume();
	volume += 5;	
	if(volume >= 100)
	{
		volume = 100;    
	}
	mp.setVolume(volume);  
}

function volumDown(){
	var muteFlag = mp.getMuteFlag();
	if(muteFlag == 1)
	{
		mp.setMuteFlag(0);
	}
	var volume = mp.getVolume();
	volume -= 5;	
	if(volume <= 0)
	{
		volume = 0;    
	}
	mp.setVolume(volume);  
}