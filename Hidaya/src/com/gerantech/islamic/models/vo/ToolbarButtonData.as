package com.gerantech.islamic.models.vo
{
	public class ToolbarButtonData
	{
		public var name:String;
		public var icon:String;
		public var callback:Function;
		
		public function ToolbarButtonData(name:String, icon:String, callback:Function)
		{
			this.name = name;
			this.icon = icon;
			this.callback = callback;
		}
	}
}