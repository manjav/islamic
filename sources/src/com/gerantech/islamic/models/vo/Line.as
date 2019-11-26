package com.gerantech.islamic.models.vo
{
	public class Line
	{
		public var start:uint;
		public var end:uint;
		public var text:String;
		public var used:Boolean;
		
		public function Line(start:Object, end:Object)
		{
			this.start = uint(start);
			this.end = uint(end)-1;
		}
	}
}