package com.gerantech.islamic.models.vo
{
	public class Alert
	{
		public static const TYPE_NOTIFICATION:String = "typeNotification";		
		public static const TYPE_ALARM:String = "typeAlarm";		

		public var offset:int;
		public var type:String;
		public var owner:Time;
		
		public function Alert(offset:int=0, type:String="typeNotification", owner:Time=null)
		{
			this.offset = offset;
			this.type = type;
			this.owner = owner;
		}
	}
}