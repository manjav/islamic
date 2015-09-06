package gt.php
{
	public class MySQLResult
	{
		public function MySQLResult(json:Object=null)
		{
			if(json==null)
				return;
			
			success = json.success;
			if(json.message)
				message = json.message;
			if(json.list)
				list = json.list;
		}
		
		public var success:Boolean;
		public var message:String;
		public var list:Array;
	}
}