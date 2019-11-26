package com.gerantech.islamic.managers
{

	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Profile;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import gt.events.MySQLEvent;
	import gt.php.MySQL;
	
	[Event(name="close", type="flash.events.Event")]
	[Event(name="connect", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	
	public class ServiceConnector extends EventDispatcher
	{
		public var profile:Profile;
		
		public function ServiceConnector(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/*public function connect(stage:Stage):void
		{
			webView = new StageWebView(true);
			webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			webView.stage = stage;
			this.stage = stage;
			AppModel.instance.webService = this;
		}
		
		public function close(event:Event=null):void
		{
			//trace(event);
			if (! webView)
				return;
			
			webView.stage = null;
			webView.dispose();
			webView = null;
		}*/
		
		
		private var db_host :String = 'localhost';//"manjav"
		private var db_name:String = 'gerantec_islamic';//"ddbb"
		private var db_user:String = 'gerantec_padmin';//"root"
		private var db_pass:String = 'P@1nt@dm1n';//""
		private var db_path:String = 'gerantech.com/islamic/php/users.php';//""
		private var sqlConnector:MySQL;
		
		public function insertUser():void
		{
			profile = UserModel.instance.user.profile;
			
			var queryStr:String = "SELECT `ml`,`nm`,`gn`,`bd`,`pc` FROM `users` WHERE `ml`='"+profile.email+"'";
			sqlConnector = new MySQL(db_host, db_name, db_user, db_pass, db_path);
			sqlConnector.addEventListener(MySQLEvent.ERROR,		sqlConnector_errorHadler);
			sqlConnector.addEventListener(MySQLEvent.COMPLETE,	sqlConnector_select_completeHadler);
			sqlConnector.runQuery(queryStr); 
		}
		
		protected function sqlConnector_select_completeHadler(event:MySQLEvent):void
		{//trace(event.result.message)
			var queryStr:String = "";
			sqlConnector = new MySQL(db_host, db_name, db_user, db_pass, db_path);
			sqlConnector.addEventListener(MySQLEvent.ERROR,		sqlConnector_errorHadler);
			sqlConnector.addEventListener(MySQLEvent.COMPLETE,	sqlConnector_insert_completeHadler);
/*			
			var sets:Array = new Array();
			if(profile.name && profile.name!="")
				sets.push("`nm`='"+profile.name+"'");
			
			if(profile.birthDate)
				sets.push("`bd`='"+profile.birthDate.time+"'");
			if(profile.gender && profile.gender!="")
				sets.push("`gn`='"+profile.gender+"'");
			if(profile.photoURL && profile.photoURL!="")
				sets.push("`pc`='"+profile.photoURL+"'");*/
			
			if(event.result.list.length==0)
				queryStr = "INSERT INTO `users` (`id`, `nm`, `ml`, `bd`, `gn`, `pc`) VALUES ('"+profile.gid+"','"+profile.name+"','"+profile.email+"','"+(profile.birthDate?profile.birthDate.time:"")+"','"+profile.gender+"','"+profile.photoURL+"')";
			else if(event.result.list.length==1)
			{
				profile.synced = true;
				UserModel.instance.userUpdater.restore(UserModel.instance.user);
				/*if(isCustom)
				{
					var u:Object = event.result.list[0];
					if(u.gl!="")user.email = u.gl.split("****").join("@");
					if(u.gn!="")user.gender = u.gn;
					if(u.nm!="")user.name = u.nm;
					if(u.bd!="")user.birthDate = new Date(u.bd);
					if(u.pc!="")user.photoURL = u.pc;
						
					trace(user)
					if(hasEventListener(Event.COMPLETE))
						dispatchEvent(new Event(Event.COMPLETE));
					return
				}
				queryStr = "UPDATE `users` SET "+sets.join(", ")+" WHERE `ml`='"+profile.email+"'";*/
			}
			else
			{
				trace("Warning : Multi user exeption !!!");
				return;
			}
			//trace(queryStr);
			sqlConnector.runQuery(queryStr); 
		}
		
		protected function sqlConnector_insert_completeHadler(event:MySQLEvent):void
		{
			if(hasEventListener(Event.COMPLETE))
				dispatchEvent(new Event(Event.COMPLETE));
			//trace(event.result.message);
			profile.synced = true;
			UserModel.instance.userUpdater.backup(UserModel.instance.user);
		}

		
		protected function sqlConnector_errorHadler(event:MySQLEvent):void
		{
			if(hasEventListener(Event.CLOSE))
				dispatchEvent(new Event(Event.CLOSE));
			//trace(event.result.message);
		}
		
		
	}
}