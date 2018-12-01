package gt.events
{
	import flash.events.Event;
	
	import gt.php.MySQLResult;

	public class MySQLEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
/*		public static const IO_ERROR:String = "ioError";
*/		
		public var result:MySQLResult;
		
		public function MySQLEvent(type:String, result:MySQLResult=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		override public function clone():Event
		{
			return new MySQLEvent(type, result, bubbles, cancelable);
		}
	}
}