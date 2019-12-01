package com.gerantech.islamic.models
{
	import com.gerantech.islamic.models.vo.Local;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	
	import gt.utils.GTStreamer;

	public class ConfigModel
	{
		public var config:Object;
		
		public var locals:Array;
		public var parts:Array;
		public var fonts:Array;
		public var languages:Array;
		public var supportEmail:String;
		public var market:String;
		
		[Embed(source = "../assets/contents/config-embeded.json", mimeType="application/octet-stream")]
		private static const YourJSON:Class;
		
		private static var _this:ConfigModel;
		
		public var searchSources:Array;

		public static function get instance():ConfigModel
		{
			if(_this == null)
				_this = new ConfigModel();
			return (_this);
		}

		public function setAssets(appModel:AppModel, userModel:UserModel):void
		{
			config = JSON.parse(new YourJSON());
			/*var configFile:File = new File(userModel.storagePath+"/islamic/texts/config-data.json");
			if(configFile.exists)
				config = appModel.assetManager.getObject("config-data");
			else
				config = appModel.assetManager.getObject("config-embeded");*/
			
			locals = getLocals();
			parts = config.application.parts;
			fonts = config.application.fonts;
			languages = config.languages;
			
			for(var i:uint=0; i<parts.length; i++)
				parts[i].enabled = i<5;
			

			/*var urlStream:URLLoader = new URLLoader(new URLRequest("http://gerantech.com/islamic/config-data.xml"))
			urlStream.addEventListener(Event.COMPLETE, configLoader_completeHandler);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, configLoader_ioErrorHandler);*/
		}
		
		protected function configLoader_ioErrorHandler(event:IOErrorEvent):void
		{
			trace("http://gerantech.com/islamic/config-data.xml not found.");
		}
		
		protected function configLoader_completeHandler(event:Event):void
		{
			var gtStreamer:GTStreamer = new GTStreamer(UserModel.instance.storagePath+"/islamic/texts/config-data.json", onSave, null, null, false, false);
			gtStreamer.save(URLLoader(event.currentTarget).data);
		}
		
		private function onSave(gtStreamer:GTStreamer):void
		{
			trace("config-data.json saved")
		}

		//FLAGS ______________________________________________________________________________________________________
		private function getLocals():Array
		{
			var ret:Array = new Array();
			for each(var f:Object in config.flags)
			{
				ret.push(new Local(f.path+"_fl", f.path, f.dir));
			}	
			return ret;
		}
		
		public function getFlagByPath(path:String):Local
		{
			for each(var l:Local in locals)
			{
				if(l.path == path)
					return l;
			}
			return null;
		}
	}
}