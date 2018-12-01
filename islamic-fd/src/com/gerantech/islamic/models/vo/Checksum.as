package com.gerantech.islamic.models.vo
{
	public class Checksum
	{
		public var md5:String;
		public var path:String;
		
		public function Checksum(checksumStr:String)
		{
			var arr:Array = checksumStr.split("  ");
			if(arr.length==1)
				arr = arr[0].split(" *");
			if(arr.length>1)
			{
				md5 = arr[0];
				path = arr[1];
				path = path.substr(0, 6);
			}
			//trace(path, md5, arr);
		}
	}
}