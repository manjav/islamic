package com.gerantech.islamic.models
{	
	
	import com.gerantech.islamic.models.vo.Descriptor;
	import com.gerantech.islamic.themes.CustomTheme;
	import com.gerantech.islamic.views.controls.CustomDrawers;
	import com.gerantech.islamic.views.headers.Toolbar;
	import com.gerantech.islamic.views.lists.DrawerList;
	import com.gerantech.islamic.views.popups.GotoPopUp;
	
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import feathers.controls.StackScreenNavigator;
	import feathers.motion.Cover;
	import feathers.motion.Reveal;
	import feathers.system.DeviceCapabilities;
	
	import starling.events.EventDispatcher;
	import starling.utils.AssetManager;

	/*[Event(name="appFullScreen", type="com.gerantech.islamic.events.AppEvent")]
	[Event(name="appautoOrientsDisabled", type="com.gerantech.islamic.events.AppEvent")]
	[Event(name="appOrientationChanged", type="com.gerantech.islamic.events.AppEvent")]
	[Event(name="appDirectionChanged", type="com.gerantech.islamic.events.AppEvent")]
	[Event(name="appIdleModeChanged", type="com.gerantech.islamic.events.AppEvent")]
	
	[Event(name="playerSelectAya", type="com.gerantech.islamic.events.AppEvent")]*/
	
	
	public class AppModel extends EventDispatcher
	{
		
		public const PAGE_QURAN:String = "page_quran";
		public const PAGE_INDEX:String = "page_index";
		public const PAGE_BOOKMARKS:String = "page_bookmarks";
		public const PAGE_SETTINGS:String = "page_settings";
		public const PAGE_SEARCH:String = "page_search";
		public const PAGE_ABOUT:String = "page_about";
		public const PAGE_PERSON:String = "page_person";
		public const PAGE_FILTERED:String = "page_filtered";
		public const PAGE_OMEN:String = "page_omen";
		public const PAGE_PURCHASE:String = "page_purchase";
		public const PAGE_DOWNLOAD:String = "page_download";

		
		public var theme:CustomTheme;
		public var toolbar:Toolbar;
		public var drawers:CustomDrawers;
		public var myDrawer:DrawerList;
		public var navigator:StackScreenNavigator;
		public var descriptor:Descriptor ;
		public var gotoPopUP:GotoPopUp;
		public var assetManager:AssetManager;
		public var byteArraySec:ByteArray;

		private static var _this:AppModel;
		public static function get instance():AppModel
		{
			if(_this == null)
				_this = new AppModel();
			return (_this);
		}
		
		public function AppModel()
		{
			descriptor = new Descriptor(NativeApplication.nativeApplication.applicationDescriptor);
			byteArraySec = new ByteArray();
			byteArraySec.writeUTFBytes("d@t@B@53_53cur3d");
			_isAndroid = Capabilities.os.substr(0, 5)=="Linux";
			_dpi = Capabilities.screenDPI;
		}

		public var upside:Boolean = true;
		public var align:String = "left";
		public var ltr:Boolean;
		
		
		private var _direction:String = "ltr";
		public function set direction(value:String):void
		{
			_direction = value;
			align = value=="ltr"? "left" : "right";
			ltr = value=="ltr";
		}
		public function get direction():String
		{
			return(_direction);
		}
				
		private var _main:Hidaya;
		public function get main():Hidaya{return _main;}

		private var _isTablet:Boolean;
		public function get isTablet():Boolean{return _isTablet;}

		private var _isAndroid:Boolean;
		public function get isAndroid():Boolean{return _isAndroid;}

		private var _dpi:Number;
		public function get dpi():Number{return _dpi;}

		private var _orginalFontSize:uint;
		public function get orginalFontSize():uint{return _orginalFontSize;}

		private var _orginalWidth:Number;
		public function get orginalWidth():Number{return _orginalWidth;}

		private var _orginalHeight:Number;
		public function get orginalHeight():Number{return _orginalHeight;}

		private var _orginalHeightFull:Number;
		public function get orginalHeightFull():Number{return _orginalHeightFull;}

		private var _toolbarSize:Number = 66;
		public function get toolbarSize():Number{return _toolbarSize;}

		private var _subtitleHeight:Number = 66;
		public function get subtitleHeight():Number{return _subtitleHeight;}

		private var _itemHeight:Number = 80;
		public function get itemHeight():Number{return _itemHeight;}

		//private var _playerHeight:Number = 0;
		//public function get playerHeight():Number{return _playerHeight;}

		private var _border:uint = 0;
		public function get border():uint{return _border;}


		public var width:Number;
		public var height:Number;
		public var heightFull:Number;
				
		public var autoPlay:Boolean;
		public var isCalloutOpen:Boolean;
		public var pageViewState:String = "normal";
		
		public var autoDownload:Boolean;
		public var navigateToItem:Boolean;
		public var puased:Boolean;
		public var preventPurchaseWarning:Boolean;
		
		public function get pushTransition():Function
		{
			return ltr ? Cover.createCoverLeftTransition() : Cover.createCoverRightTransition() ;
		}
		public function get popTransition():Function
		{
			return ltr ? Reveal.createRevealRightTransition() : Reveal.createRevealLeftTransition() ;
		}
		
		public function init(main:Hidaya):void
		{
			_main = main;
			_isTablet = DeviceCapabilities.isTablet(main.stage);
			_orginalWidth = main.stage.stageWidth;
			_orginalHeightFull = main.stage.stageHeight;
			
			var scale:Number = dpi/160;
			trace("scale", scale)
			_toolbarSize = Math.round(56*scale);//56
			_subtitleHeight = Math.round(48*scale);
			_itemHeight = Math.round(72*scale);//Math.min(Math.max(64, _orginalHeightFull/8), 240);
			height = heightFull-_toolbarSize;
			//_actionHeight = uint(_itemHeight*0.76);//trace(_itemHeight, _actionHeight);
			_orginalHeight = _orginalHeightFull - _toolbarSize;
			_orginalFontSize = Math.round(16*scale);//uint(height/40+2);
			_border = Math.round(_itemHeight/16);
			
		}
	}
}