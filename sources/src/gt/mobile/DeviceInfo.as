package gt.mobile
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import gt.utils.GTStreamer;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	public class DeviceInfo extends EventDispatcher
	{
		private var streamer:GTStreamer;
		
		//public var BRAND:String="";
		//public var CHANGELIST:String="";
		//public var DEVICE:String="";
		//public var HOST:String="";
		//public var INCREMENTAL:String="";
		//public var ID:String="";
		//public var LANGUAGE:String="";
		public var MANUFACTURER:String="";
		public var MODEL:String="";
		//public var SDK:String="";
		public var IMEI:String="";
		public var VERSION:String="";

		private var path:String;
		
		public function DeviceInfo()
		{//trace(Capabilities.manufacturer)
			switch(Capabilities.manufacturer)
			{
				case "Android Linux": path="/system/build.prop"; break;
				case "Adobe Windows": path=File.userDirectory.nativePath+"/InfoDev.txt"; break;
				//case "Android Linux": path="/system/build.prop"; break;
			}
			
			streamer = new GTStreamer(path, loadStremerHandler, errorStremerHandler);
		}
		private function errorStremerHandler():void
		{
			if(hasEventListener(IOErrorEvent.IO_ERROR))
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		private function loadStremerHandler(g:GTStreamer):void
		{
			//streamer.isMultiline = true;
			dataLoaded(g.utfBytes);
		}

		private function dataLoaded(str:String):void
		{
			if(str.length<300)
			{
				if(hasEventListener(IOErrorEvent.IO_ERROR))
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				return;
			}
			//streamer = new DataStream(File.userDirectory.nativePath+"/InfoDev.txt", "write");streamer.utfBytes = str;return;
			var lines:Array;
					var pattern : RegExp = /\r?\n/;
					lines = str.split(pattern) ;
			/*switch(Capabilities.manufacturer)
			{
				case "Android Linux": 
					lines = str.split(pattern) ;
					break;
				case "Adobe Windows": 
					//var pattern : RegExp = /\r?\n/;
					//lines = str.split("\r") ;
					break;
			}*/
			
			var lineSplited:Array ;
			for each(var line:String in lines)
			{
				if (line!="" && line.indexOf("ro.")!=-1 && line.indexOf("=")!=-1)
				{
					lineSplited = line.split("=");
					switch(lineSplited[0])
					{
						//case "ro.build.id" : ID=lineSplited[1]; break;
						//case "ro.build.host" : HOST=lineSplited[1]; break;
						//case "ro.build.version.incremental" : INCREMENTAL=lineSplited[1]; break;
						//case "ro.build.changelist" : CHANGELIST=lineSplited[1]; break;
						//case "ro.product.brand" : BRAND=lineSplited[1]; break;
						//case "ro.product.device" : DEVICE=lineSplited[1]; break;
						//case "ro.build.version.sdk" : SDK=lineSplited[1]; break;
						case "ro.build.version.release":	VERSION=lineSplited[1].toUpperCase();		break;
						case "ro.product.model":			MODEL=lineSplited[1].toUpperCase();			break;
						case "ro.product.manufacturer":		MANUFACTURER=lineSplited[1].toUpperCase();	break;
						//case "ro.product.locale.language" : LANGUAGE=lineSplited[1]; break;
						//case "ro.build.date.utc" : IMEI=lineSplited[1]; break;
					}
				}
			}
			/*if(Deviceimei.deviceimei.extContext!=null)
			{
				IMEI = DeviceStats(Deviceimei.deviceimei.deviceinfo()).imei.toString();
			}*/
			//trace("VERSION:", VERSION, "MODEL:", MODEL, "MANUFACTURER:", MANUFACTURER)
			if(hasEventListener(Event.COMPLETE))
				dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}