package com.gerantech.islamic.models.vo
{
	public class Local
	{
		
		public var name:String;
		public var path:String;
		
		public var dir:String;
		
		public var align:String;
		public var num:uint;
		
		public var selected:Boolean;
		
		public function Local(name:String, path:String, dir:String="ltr")
		{
			this.name = name;
			this.path = path;
			this.dir = dir;
			this.align = dir=="ltr"?"left":"right";
		}
	}
}