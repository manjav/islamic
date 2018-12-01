package com.gerantech.islamic.models.vo
{
	public class Alert
	{
		public static const TYPE_ALARM:String = "typeAlarm";		
		public static const TYPE_NOTIFICATION:String = "typeNotification";		

		public var offset:int;
		public var type:String;
		public var owner:Time;
		public var moathen:Moathen;
		
		public function Alert(offset:int=0, moathen:Moathen=null, owner:Time=null, type:String="typeAlarm")
		{
			this.offset = offset;
			this.moathen = moathen;
			this.owner = owner;
			this.type = type;
		}
	}
}