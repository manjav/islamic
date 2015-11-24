package com.gerantech.islamic.models
{	
	
	import com.gerantech.islamic.models.vo.Descriptor;
	import com.gerantech.islamic.themes.CustomTheme;
	import com.gerantech.islamic.utils.MetricUtils;
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

		private var _isAndroid:Boolean;
		public function get isAndroid():Boolean{return _isAndroid;}

		public var autoPlay:Boolean;
		public var isCalloutOpen:Boolean;
		public var pageViewState:String = "normal";
		
		public var autoDownload:Boolean;
		public var navigateToItem:Boolean;
		public var puased:Boolean;
		public var preventPurchaseWarning:Boolean;

		public var sizes:MetricUtils;
		
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
			sizes = new MetricUtils(Capabilities.screenDPI, main.stage);
		}
	}
}