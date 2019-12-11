package com.gerantech.islamic.models.vo
{	
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.LoadAndSaver;
	import com.gerantech.islamic.utils.StrTools;

	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	import gt.utils.Localizations;

	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	public class Person extends EventDispatcher
	{
		public static const TYPE_TRANSLATOR:String = "translator";
		public static const TYPE_RECITER:String = "reciter";
		public static const TYPE_MOATHEN:String = "moathen";
		
		public static const LOADING_COMPLETE:String = "translationLoaded";
		public static const LOADING_PROGRESS_CHANGED:String = "translationProgressChanged";
		public static const LOADING_ERROR:String = "translationError";
		
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
		protected var _state:String = "noFile";
		
		private var imageLoading:Boolean;
		private var iconLoadSaver:LoadAndSaver;
		private var sourceLoadSaver:LoadAndSaver;

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
			this.iconUrl = "http://grantech.ir/islamic/images/"+type+"s/"+value.path.split(" ").join("-")+".png";
			this.iconPath = (type==TYPE_TRANSLATOR?UserModel.instance.TRANSLATOR_PATH:UserModel.instance.SOUNDS_PATH) + path + "/" + path + ".pbqr";
			if(type==TYPE_TRANSLATOR)
				this.localPath = UserModel.instance.TRANSLATOR_PATH + path + "/" + path + ".idb" ;
			else if(type==TYPE_MOATHEN)
				this.localPath = UserModel.instance.SOUNDS_PATH + path + "/" + path + ".dat" ;
			else
				this.localPath = UserModel.instance.SOUNDS_PATH + path + "/" ;
			this.state = checkState();
		}
		
		
		//Load Person Image ---------------------------------
		public function loadImage():void
		{
			loadTime ++;
			if(loadTime>2 || imageLoading)
				return;
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
		
		public function checkState(forceCheck:Boolean=false):String
		{
			var ret:String = state;
			if(localPath=="" || localPath==null)
				return NO_FILE;
			
			if(type==TYPE_TRANSLATOR || type == TYPE_MOATHEN)
			{
				existsFile = new File(localPath).exists;
				if(ret != SELECTED || forceCheck)
					ret = existsFile ? HAS_FILE : NO_FILE;
			}
			else if(type==TYPE_RECITER && ret != SELECTED)
				ret = HAS_FILE;
			
			//trace(localPath, ret, type)
			return ret;
		}
		
		public function getCurrentMessage():String
		{
			var sizeStr:String = '';//trace(type, state)
			if((type==TYPE_TRANSLATOR||type==TYPE_MOATHEN) && (state==NO_FILE||state==LOADING))
			{
				if(size>1000000)
					sizeStr = StrTools.getNumberFromLocale(size/1048576).substr(0,4)	+ " " + loc("mbyte_t");
				else
					sizeStr = StrTools.getNumberFromLocale(int(size/1024))				+ " " + loc("kbyte_t");
			}
			return (loc(mode)+(type==TYPE_MOATHEN?"":' , '+loc(flag.name)) + (sizeStr==""?"":' , '+sizeStr));
		}

		// states  -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
		
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
				_defaultImage = Assets.getTexture("unknown");
			
			return _defaultImage;
		}
		
		// source loading -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
		
		/**
		 * Load any source such as translation database or athan sound file from url and save to path
		 */
		public function load():void
		{
			sourceLoadSaver = new LoadAndSaver(localPath, url, null, false, size);
			sourceLoadSaver.addEventListener("complete", sourceLoadSaver_completeHandler);
			sourceLoadSaver.addEventListener(IOErrorEvent.IO_ERROR, sourceLoadSaver_ioErrorHandler);
			sourceLoadSaver.addEventListener(ProgressEvent.PROGRESS, sourceLoadSaver_progressHandler);
			state = PREPARING;
		}
		
		protected function sourceLoadSaver_progressHandler(event:ProgressEvent):void
		{
			state = LOADING;
			percent = event.bytesLoaded/size;//trace(event.bytesLoaded, size, event.bytesTotal)
			dispatchEventWith(LOADING_PROGRESS_CHANGED);
			//trace(percent, event.bytesLoaded/1200000);
		}
		
		protected function sourceLoadSaver_completeHandler(event:*):void
		{//trace(event)
			sourceLoadSaver.removeEventListener("complete", sourceLoadSaver_completeHandler);
			sourceLoadSaver.removeEventListener(IOErrorEvent.IO_ERROR, sourceLoadSaver_ioErrorHandler);
			sourceLoadSaver.removeEventListener(ProgressEvent.PROGRESS, sourceLoadSaver_progressHandler);
		}
		
		protected function sourceLoadSaver_ioErrorHandler(event:IOErrorEvent):void
		{//trace(event.text)
			unload();
			dispatchEventWith(LOADING_ERROR);
		}
		
		public function unload():void
		{
			//isTranslateDownloading = false;
			percent = 0;
			state = NO_FILE;    
			sourceLoadSaver.closeLoader();
			sourceLoadSaver.removeEventListener("complete", sourceLoadSaver_completeHandler);
			sourceLoadSaver.removeEventListener(IOErrorEvent.IO_ERROR, sourceLoadSaver_ioErrorHandler);
			sourceLoadSaver.removeEventListener(ProgressEvent.PROGRESS, sourceLoadSaver_progressHandler);
			//testFile(itemRenderer);//loadingState = "noFile";
		}
	
		
		// utils -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
		
		protected function loc(resourceName:String):String
		{
			return Localizations.instance.get(resourceName);
		}
	}
}