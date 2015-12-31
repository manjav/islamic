package com.gerantech.islamic.managers
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class LocationManager
	{
		private var sqlConnection:SQLConnection;
		public function LocationManager()
		{
			
			sqlConnection = new SQLConnection();
			sqlConnection.addEventListener(SQLEvent.OPEN, sqlConnection_openHandler); 
			sqlConnection.addEventListener(SQLErrorEvent.ERROR, sqlConnection_errorHandler); 
			var db:File = File.applicationDirectory.resolvePath("com/gerantech/islamic/assets/contents/geoname.sqlite");
			sqlConnection.openAsync(db, SQLMode.READ);
		}
		
		protected function sqlConnection_errorHandler(event:SQLErrorEvent):void
		{trace(event)
		}
		protected function sqlConnection_openHandler(event:SQLEvent):void
		{trace(event)
		}
		
		private function query(queryStr:String, response:Function):void
		{//trace(queryStr)
			var createStmt:SQLStatement = new SQLStatement(); 
			createStmt.sqlConnection = sqlConnection; 
			createStmt.text = queryStr ;
			createStmt.addEventListener(SQLEvent.RESULT, createResult); 
			createStmt.addEventListener(SQLErrorEvent.ERROR, createError); 
			if(sqlConnection.connected)
				createStmt.execute(); 
			else
			{
				setTimeout(response, 1, "SQL Connection not found.");
				return;
			}
			function createError(event:SQLErrorEvent):void
			{
				response(event.text);
			}
			function createResult(event:SQLEvent):void
			{
				response(createStmt.getResult());
			}			
		}
		
		public function getCityByLocation(latitude:Number, longitude:Number, response:Function, index:uint=1, range:Number=0.02):void
		{
			var queryStr:String = "SELECT * FROM locations WHERE latitude > "+(latitude-(index*range))+
				" AND latitude < "+(latitude+(index*range))+" AND longitude > "+(longitude-(index*range))+" AND longitude < "+(longitude+(index*range))//+
				//" AND ORDER BY name_latin LIMIT "+from+" , "+to;
			query(queryStr, response);
		}
		
		public function searchCity(cityName:String, response:Function, from:uint=0, to:uint=500):void
		{
			var queryStr:String = "SELECT * FROM locations WHERE name_latin LIKE '%"+cityName+"%' ORDER BY name_latin LIMIT "+from+" , "+to;// AND LEN(name_latin) = 3
			query(queryStr, response);
		}	
		
		
		private static var _this:LocationManager;
		public static function get instance():LocationManager
		{
			if(_this == null)
				_this = new LocationManager();
			return (_this);
		}
	}
}