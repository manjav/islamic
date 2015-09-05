package com.gerantech.islamic.models.vo
{
	public class Message
	{
		public var title:String;
		public var message:String;
		public var date:Date;
		
		public function Message(title:String, message:String, date:Date=null)
		{
			this.title = title;
			this.message = message;
			if(date==null)
				date = new Date();
			this.date = date;
			
		}
	}
}