package com.gerantech.islamic.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import gt.events.MySQLEvent;
	import gt.mobile.DeviceInfo;
	import gt.php.MySQL;

	
	public class UpdateDB
	{/*
		private var appModel:AppModel;
		private var userModel:UserModel;
		private var devInfo:DeviceInfo;
		private var p:Profile;
		private var d:Descriptor;
		
		private var uid:String;
		private var location:String;
		private var manufacturer:String;
		private var model:String;
		private var osVersion:String;
		private var sqlConnector:MySQL;
		
		private var db_host :String = 'localhost';
		private var db_name:String = "gerantec_bayan"//'quranbay_db';
		private var db_user:String = "gerantec_badmin"//'quranbay_user';
		private var db_pass:String = "B@y@n@dm1n"//'DBm@ns0ur';//""
		private var db_path:String = "gerantech.com/bayan/php/database.php"//'quranbayan.com/database.php';//""
		
		
		public function UpdateDB()
		{
			appModel = AppModel.Instance;
			userModel = UserModel.Instance;
			p = userModel.profile;
			d = appModel.decriptor;
			
			if (p.location == "" || new Date().month!=userModel.profile.lastMonth)
			{
				var urlReq:URLRequest = new URLRequest("http://api.ipinfodb.com/v3/ip-city/?key=dcf5919a583049cec01c1c5dd66663ec28e0cc7c01b5a66e48198e408468dc56");
				urlReq.method = URLRequestMethod.POST;
				var urlLoader:URLLoader = new URLLoader(urlReq);
				urlLoader.addEventListener(Event.COMPLETE, urlLoader_EventsHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_EventsHandler);
				p.lastMonth = new Date().month;
			}
			else
			{
				location = p.location;
				loadDeviceInfo();
			}
			
		}
		
		private function urlLoader_EventsHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, urlLoader_EventsHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, urlLoader_EventsHandler);
			if(event.type == Event.COMPLETE)
			{
				var ipList:Array = String(event.currentTarget.data).split(";");
				location = ipList[5]+" | "+ipList[4];//ipList[2]+'|'+ipList[3]+'|'+
				
			}
			loadDeviceInfo();
		}
		
		private function loadDeviceInfo():void
		{
			devInfo = new DeviceInfo();
			devInfo.addEventListener(Event.COMPLETE, devInfo_completeHandler);
			devInfo.addEventListener(IOErrorEvent.IO_ERROR, devInfo_completeHandler);
		}
		
		protected function devInfo_completeHandler(event:Event):void
		{
			devInfo.removeEventListener(Event.COMPLETE, devInfo_completeHandler);
			devInfo.removeEventListener(IOErrorEvent.IO_ERROR, devInfo_completeHandler);
			if(event.type == Event.COMPLETE)
			{
				manufacturer =	devInfo.MANUFACTURER;
				model =			devInfo.MODEL;
				osVersion =		devInfo.VERSION;
			}
			else
			{
				manufacturer =	p.manufacturer;
				model =			p.model;
				osVersion =		p.osVersion;
			}
			
			userModel.save();
			checkDatabase();
		}
		
		private function checkDatabase():void
		{
			var ip:String =	location!=p.location			? ("ip='"+location+"', ")		: ""; 
//			var mn:String =	manufacturer!=p.manufacturer	? ("mn='"+manufacturer+"', ")	: ""; 
//			var md:String =	model!=p.model					? ("md='"+model+"', ")			: ""; 
//			var ov:String =	osVersion!=p.osVersion			? ("ov='"+osVersion+"', ")		: "";
			var av:String =	"av='"+	d.versionNumber+"', ";
			var ds:String =	"ds='"+	d.description +	"', ";
			var lr:String =	"lr='"+	"&*&"+			"', ";
			var pr:String = "pr="+	(d.isPro?1:0)+	", ";
			var nr:String =	"nr="+	p.numRun;
			
			if(p.uid == '' || p.uid==null)
			{
				uid = UIDUtil.createUID();
				av = d.versionNumber;
				ds = d.description;
				nr = p.numRun.toString();
				pr = String(d.isPro?1:0);
				query = "INSERT INTO `installs` (`ud`, `ip`, `mn`, `md`, `ov`, `av`, `ds`, `pr`, `nr`, `lr`, `fr`) VALUES ('"+
				uid+"','"+location+"','"+manufacturer+"','"+model+"','"+osVersion+"','"+av+"','"+ds+"',"+pr+","+nr+",'&*&','&*&');";
			}
			else
			{
				query = "UPDATE `installs` SET " + ip + av + pr + ds + lr + nr +" WHERE `ud`='"+p.uid+"'";
			}
		}
		
		private function set query(query:String):void
		{
			trace(query);
			sqlConnector = new MySQL(db_host, db_name, db_user, db_pass, db_path);
			sqlConnector.addEventListener(MySQLEvent.ERROR,		sql_completeHandler);
			sqlConnector.addEventListener(MySQLEvent.COMPLETE,	sql_completeHandler);
			sqlConnector.runQuery(query);
		}		
		private function sql_completeHandler(event:MySQLEvent):void
		{trace(event)
			sqlConnector.removeEventListener(MySQLEvent.ERROR,		sql_completeHandler);
			sqlConnector.removeEventListener(MySQLEvent.COMPLETE,	sql_completeHandler);
			if(event.type==MySQLEvent.ERROR)
				p.uid =	'';
			if(event.type==MySQLEvent.COMPLETE)
			{
				p.uid =			uid				?	uid			:	p.uid;
				p.location =	location		?	location	:	p.location; 
				p.manufacturer=	manufacturer	?	manufacturer:	p.manufacturer; 
				p.model =		model			?	model		:	p.model; 
				p.osVersion	=	osVersion		?	osVersion	:	p.osVersion; 
				
//				if(!userModel.profile.registered) 
//					appModel.dispatchEvent(new AlertEvent(AlertEvent.OPEN_POPUP, appModel.app.getLocalString("reg_quest"), "question", closer));
			}
		}
		
		private function closer (accept:Boolean):void
		{
			if(accept)
				appModel.mainApp.navigator.pushView(ProfileView)
		}*/
		
	}
}