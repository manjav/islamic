package com.gerantech.islamic.models.vo
{
	public class Location
	{
		public var name:String;
		public var latitude:Number;
		public var longitude:Number;
		
		public function Location(name:String = "Tehran,IR", latitude:Number = 35.6961, longitude:Number = 51.42310)
		{
			this.name = name;
			this.latitude = latitude;
			this.longitude = longitude;
		}
	}
}