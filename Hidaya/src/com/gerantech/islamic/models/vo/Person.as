package com.gerantech.islamic.models.vo
{	
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.LoadAndSaver;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	public class Person extends EventDispatcher
	{
		public static const TYPE_TRANSLATOR:String = "translator";
		public static const TYPE_RECITER:String = "reciter";
		
		public static const TRANSLATION_LOADED:String = "translationLoaded";
		public static const TRANSLATION_PROGRESS_CHANGED:String = "translationProgressChanged";
		public static const TRANSLATION_ERROR:String = "translationError";
		
		public static const CHECKSUM_LOADED:String = "checksumLoaded";
		public static const CHECKSUM_ERROR:String = "checksumError";
		
		public static const ICON_LOADED:String = "iconLoaded";
		
		public static const STATE_CHANGED:String = "stateChanged";
		
		public static const NO_FILE:String = "noFile";
		public static const PREPARING:String = "preparing";
		public static const LOADING:String = "loading";
		public static const HAS_FILE:String = "hasFile";
		public static const SELECTED:String = "selected";
		
		private static var _defaultImage:Texture;
		
		public var path:String;
		public var percent:Number = 0;
		
		public var name:String = "";
		public var ename:String = "";
		public var url:String = "";
		//public var pic:String = "";
		public var size:Number = 1200;
		
		public var mode:String = "";
		public var type:String = "";
		
		public var iconUrl:String = "";
		public var iconPath:String = "";

		public var flag:Local;
		
		public var index:uint;
		public var loadTime:uint;
		
		public var existsFile:Boolean;
		public var hasIcon:Boolean;
		public var iconTexture:Texture;
		public var buttonIcon:Texture;

		public var free:Boolean;
		
		protected var localPath:String = "";
		protected var rm:IResourceManager;
		protected var _state:String = null;
		
		private var imageLoading:Boolean;
		private var iconLoadSaver:LoadAndSaver;

		public function Person(person:Object=null, type:String="translator", flag:Local=null)
		{
			this.type = type;
			this.flag = flag;
			setPerson(person);
		}
		
		private function setPerson(value:Object):void
		{
			if(value==null)
				return;
			
			this.ename = value.ename;
			this.name = value.name;
			this.path = value.path;
			this.url = value.url;
			this.size = value.size;
			this.mode = value.mode;
			this.iconUrl = "http://gerantech.com/islamic/images/"+type+"s/"+value.path.split(" ").join("-")+".png";
			this.iconPath = (type==TYPE_TRANSLATOR?UserModel.instance.TRANSLATOR_PATH:UserModel.instance.SOUNDS_PATH) + path + "/" + path + ".pbqr";
			if(type==TYPE_TRANSLATOR)
				this.localPath = UserModel.instance.TRANSLATOR_PATH + path + "/" + path + ".idb" ;
			else
				this.localPath = UserModel.instance.SOUNDS_PATH + path + "/" ;
			this.state = checkState();
			rm = ResourceManager.getInstance();
			//message = getcurrentMessage();
		}
		
		
		//Load Person Image ---------------------------------
		public function loadImage():void
		{
			loadTime ++;
			if(loadTime>2 || imageLoading)
				return;
			//trace(path, imageUrl)
			imageLoading = true;
			
			iconLoadSaver = new LoadAndSaver(iconPath, iconUrl, null, true);
			iconLoadSaver.addEventListener("complete", iconLoadSaver_completeHandler);
			iconLoadSaver.addEventListener("ioError", iconLoadSaver_ioErrorHandler);
		}
		
		protected function iconLoadSaver_ioErrorHandler(event:IOErrorEvent):void
		{
			iconLoadSaver.removeEventListener("complete", iconLoadSaver_completeHandler);
			iconLoadSaver.removeEventListener("ioError", iconLoadSaver_ioErrorHandler);
			iconTexture = Person.getDefaultImage();
			iconTextureCreated();
		}
		
		protected function iconLoadSaver_completeHandler(event:Object):void
		{
			iconLoadSaver.removeEventListener("complete", iconLoadSaver_completeHandler);
			iconLoadSaver.removeEventListener("ioError", iconLoadSaver_ioErrorHandler);
			if(iconLoadSaver.fileLoader)
				iconTexture = Texture.fromBitmap(iconLoadSaver.fileLoader.content as Bitmap);
			iconTextureCreated();
		}

		private function iconTextureCreated():void
		{
			hasIcon = true;
			imageLoading = false;
			dispatchEventWith(ICON_LOADED);			
		}
		
		public function checkState():String
		{
			var ret:String = state;
			if(localPath=="" || localPath==null)
				return NO_FILE;
			
			if(type==TYPE_TRANSLATOR)
			{
				existsFile = new File(localPath).exists;
				if(ret != SELECTED)
					ret = existsFile ? HAS_FILE : NO_FILE;
			}
			else if(ret != SELECTED)
				ret = HAS_FILE;
			
			//trace(localPath, ret, type)
			return ret;
		}
		
		public function getCurrentMessage():String
		{
			var sizeStr:String = '';//trace(type, state)
			if(type==TYPE_TRANSLATOR && (state==NO_FILE||state==LOADING))
			{
				if(size>1000000)
					sizeStr = ' , ' + StrTools.getNumberFromLocale(size/1048576).substr(0,4)	+ " " + rm.getString("loc", "mbyte_t");
				else
					sizeStr = ' , ' + StrTools.getNumberFromLocale(size/1024)					+ " " + rm.getString("loc", "kbyte_t");
			}
			return (rm.getString("loc", mode)+' , '+rm.getString("loc", flag.name) + sizeStr);
		}

		public function set state(value:String):void
		{
			if(_state==value)
				return;
			_state = value;
			dispatchEventWith(STATE_CHANGED);
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function get selected():Boolean
		{
			return _state==SELECTED;
		}
		
		
		public static function getDefaultImage():Texture
		{
			if(_defaultImage == null)
			{
				//var ba:ByteArray = AppModel.instance.assetManager.getByteArray("unknown");
				_defaultImage = Assets.getTexture("unknown");
				//ba.clear();
			}
			return _defaultImage;
		}
		
		
		protected function loc(resourceName:String):String
		{
			return ResourceManager.getInstance().getString("loc", resourceName);
		}
	}
}