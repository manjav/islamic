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

		
		public var toolbar:Toolbar;
		public var drawers:CustomDrawers;
		//public var leftDrawer:DrawerView;
		//public var rightDrawer:DrawerView;
		public var myDrawer:DrawerList;
		public var navigator:StackScreenNavigator;
		
		public var descriptor:Descriptor ;
/*		
		public var calloutIsOpen:Boolean;
		public var menusIsOpen:Boolean;
		public var popupIsOpen:Boolean;

*/
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
			isAndroid = Capabilities.os.substr(0, 5)=="Linux";
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
				
		public var main:Hidaya;

		
		public var orginalFontSize:uint;
		public var orginalWidth:Number;
		public var orginalHeight:Number;
		public var orginalHeightFull:Number;
		
	//	public var scaledHeight:Number;
		//public var scaledHeightFull:Number;
		
		public var width:Number;
		public var height:Number;
		public var heightFull:Number;
		
		public var headerHeight:Number = 66;
		public var actionHeight:Number = 66;
		public var itemHeight:Number = 80;
		public var playerHeight:Number = 0;
		public var border:uint = 0;
		public var itemBorder:uint;
		
		public var autoPlay:Boolean;
		public var isCalloutOpen:Boolean;
		public var pageViewState:String = "normal";
		
		public var autoDownload:Boolean;
		public var navigateToItem:Boolean;
		//public var overlay:OverlayScreen;
		public var dpi:Number;
		public var suraItemHeight:Number;
		public var theme:CustomTheme;
		public var preventPurchaseWarning:Boolean;
		public var gotoPopUP:GotoPopUp;
		public var isTablet:Boolean;
		public var assetManager:AssetManager;
		public var puased:Boolean;
		public var byteArraySec:ByteArray;
		public var isAndroid:Boolean;

		public function get pushTransition():Function
		{
			return ltr ? Cover.createCoverLeftTransition() : Cover.createCoverRightTransition() ;
		}
		public function get popTransition():Function
		{
			return ltr ? Reveal.createRevealRightTransition() : Reveal.createRevealLeftTransition() ;
		}
	}
}