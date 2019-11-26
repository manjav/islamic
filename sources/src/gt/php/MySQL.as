package gt.php
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import gt.events.MySQLEvent;
	
	[Event(name="error",	type="gt.events.MySQLEvent")]
/*	[Event(name="ioError",	type="gt.events.MySQLEvent")]
*/	[Event(name="complete",	type="gt.events.MySQLEvent")]
	
	public class MySQL extends EventDispatcher
	{
		public var host:String;
		public var database:String;
		public var username:String;
		public var password:String;
		public var queryString:String;
		
		public var result:MySQLResult;
		private var isSelect:Boolean;
		
		private var url:String;
		private	var phpInterface:PHPInterface;
		
		public function MySQL(host:String, database:String, username:String="root", password:String="", url:String="localhost/database.php")
		{
			this.host = host ;
			this.database = database;
			this.username = username;
			this.password = password;
			this.url = url;
			
			//attributs = Utils.listProperties(new itemClass);
			//urlVar.attributs = attributs.join("|");
		}
		
		public function runQuery(mysqlQuery:String=null, ...params):void
		{
			result = new MySQLResult();
			queryString = queryString == null ? mysqlQuery : queryString;
			isSelect = (queryString.substr(0, 6).toLowerCase()=="select")
			if(queryString == null || queryString == '')
			{
				//dispatchEvent(new MySQLEvent(MySQLEvent.ERROR, 'Query String is NULL'));
				return ;
			}
			connect({host:host, database:database, username:username, password:password, queryString:queryString});
		}
		public function connect(params:Object=null):void
		{
			phpInterface = new PHPInterface(url, 'utf', params);
			phpInterface.addEventListener(IOErrorEvent.IO_ERROR, phpInterface_ioErrorHandler);
			phpInterface.addEventListener(Event.COMPLETE, phpInterface_completeHandler);
			phpInterface.load();
		}
		
		protected function phpInterface_ioErrorHandler(event:IOErrorEvent):void
		{//trace(event.text, "dddd");
			result.message = event.text;
			if(hasEventListener(MySQLEvent.ERROR))
				dispatchEvent(new MySQLEvent(MySQLEvent.ERROR, result));
		}
		
		protected function phpInterface_completeHandler(event:Event):void
		{
			var str:String = unescape(event.target.data);//trace(str, ";;;");
			
			try
			{
				result = new MySQLResult(JSON.parse(str));
			}
			catch(e:Error) 
			{
				result.message = e.message;
				if(hasEventListener(MySQLEvent.ERROR))
					dispatchEvent(new MySQLEvent(MySQLEvent.ERROR, result));
				return;
			}
			
			if(hasEventListener(MySQLEvent.COMPLETE))
				dispatchEvent(new MySQLEvent(MySQLEvent.COMPLETE, result));
		}
		
		private function get queryMode():String
		{
			return queryString.substr(0,6).toLowerCase();
		}
	}

}