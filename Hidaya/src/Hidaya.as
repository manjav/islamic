package 
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.Main;
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.managers.NotificationManager;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;

	[SWF(frameRate="60")]
	
	[ResourceBundle("loc")]

	public class Hidaya extends Sprite
	{
		private var _starling:Starling;
		private var appModel:AppModel;
		private var userModel:UserModel;
		private var configModel:ConfigModel;
		private var appController:AppController;
		
		private var validateScreenTimeoutID:uint;
		private var tt:int;

		public function Hidaya()
		{
			tt = getTimer();
			trace(ResourceManager.getInstance().getString("loc", "quran_t"))//, String.fromCharCode(0x25b8));
			mouseEnabled = mouseChildren = false;
			
			
			
			if(stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
			//	stage.quality = StageQuality.LOW;
				stage.align = StageAlign.TOP_LEFT;
				stage.setOrientation(StageOrientation.DEFAULT);
				stage.autoOrients=false;
			}
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

			//Add Splash -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			graphics.beginFill(0x009688);
			graphics.drawRect(0,0,Math.max(stage.stageWidth, stage.stageHeight), Capabilities.screenDPI/3.2);
		}
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			loaderInfo.removeEventListener(Event.COMPLETE, loaderInfo_completeHandler);

			appModel = AppModel.instance;
			appModel.init(this as Hidaya);
			
			//Flurry initialising ----------------------------------------------------
			//Flurry.getInstance().logEnabled = true
			Flurry.getInstance().setAndroidAPIKey("34RKN4HMZ7C8YWW9BD52");
			Flurry.getInstance().startSession();
			Flurry.getInstance().setAppVersion(appModel.descriptor.versionNumber);
			
			//NotificationManager initialising ----------------------------------------
			NotificationManager.instance;
			
			//Start Starling ----------------------------------------------------------
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			_starling = new Starling(Main, stage);
			_starling.enableErrorChecking = false;
			//_starling.showStats = true;
			//_starling.showStatsAt(HAlign.CENTER, VAlign.BOTTOM);
			_starling.addEventListener("rootCreated", starling_rootCreatedHandler);
			//_starling.addEventListener("context3DCreate", starling_rootCreatedHandler);
			_starling.start();
		}
		
		private function starling_rootCreatedHandler():void
		{
			_starling.removeEventListener("rootCreated", starling_rootCreatedHandler);
			//_starling.removeEventListener("context3DCreate", starling_rootCreatedHandler);
			validateScreenSize();
			//Load Assets --------------------------------------------------------
			appModel.assetManager = new AssetManager();
			appModel.assetManager.verbose = false
			appModel.assetManager.enqueue(File.applicationDirectory.resolvePath("com/gerantech/islamic/assets/images/atlases"));
			appModel.assetManager.enqueue(File.applicationDirectory.resolvePath("com/gerantech/islamic/assets/images/bitmaps"));
			appModel.assetManager.enqueue(File.applicationDirectory.resolvePath("com/gerantech/islamic/assets/contents"));
			appModel.assetManager.loadQueue(loadQueueHandler);
		}
		
		private function loadQueueHandler(ratio:Number):void
		{
			if (ratio < 1.0)
				return;
			
			scaled9TexturesLoaded();
			Assets.loadSclaed9Textures(["dialog", "item_roundrect_down", "item_roundrect_normal", "item_roundrect_selected", "i_item_roundrect_down", "i_item_roundrect_normal", "i_item_roundrect_selected"], null);
		}
		
		private function scaled9TexturesLoaded():void
		{trace(getTimer()-tt)
			appController = AppController.instance;
			configModel = ConfigModel.instance;
			
			/*graphics.clear();
			graphics.beginFill(0x009688);
			graphics.drawRect(0,0,Math.max(stage.stageWidth, stage.stageHeight), appModel.itemHeight);
			*/			
			userModel = UserModel.instance;
			userModel.addEventListener(UserEvent.LOAD_DATA_COMPLETE, user_completeHandler);
			userModel.addEventListener(UserEvent.LOAD_DATA_ERROR, user_completeHandler);
			loadUserData()
		}
		
		private function loadUserData():void
		{
			if(ResourceManager.getInstance().localeChain==null)
			{
				setTimeout(loadUserData, 1);
				return;
			}
			userModel.load(appModel, appController, configModel);
		}
		
		protected function user_completeHandler():void
		{
			BillingManager.instance.init();
			
			if(Capabilities.cpuArchitecture=="x86" || userModel.fontSize==12)
			{
				userModel.fontSize = appModel.orginalFontSize;
			//	UserModel.instance.premiumMode = Capabilities.cpuArchitecture=="x86"
			}

			stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
			Main(_starling.root).createScreens();
			graphics.clear();
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			validateScreenSize();
		}
		
		public function validateScreenSize():void
		{
			//trace("validate Screen Size")
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler, false);
			appModel.width = 				stage.stageWidth;
			appModel.heightFull = 			stage.stageHeight;
			appModel.height = 				appModel.heightFull - appModel.toolbarSize;
			appModel.upside =  				appModel.heightFull>appModel.width;//stage.deviceOrientation=="default" || stage.deviceOrientation=="upsideDown" || stage.deviceOrientation=="unknown";
			
			if(_starling==null)
				return;
			
			var viewPort:Rectangle = _starling.viewPort;
			viewPort.width = appModel.width
			viewPort.height = appModel.heightFull;
			
			_starling.stage.stageWidth = appModel.width;
			_starling.stage.stageHeight = appModel.heightFull;
			
			try
			{
				_starling.viewPort = viewPort;
			}
			catch(error:Error) {trace(error.message)}
			//_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
			
			if(AppController.instance.hasEventListener(AppEvent.ORIENTATION_CHANGED))
				AppController.instance.dispatchEvent(new AppEvent(AppEvent.ORIENTATION_CHANGED));
			//appModel.overlay.width = width;
			//appModel.overlay.height = height;
			
			clearTimeout(validateScreenTimeoutID);
			validateScreenTimeoutID = setTimeout(addResizeHandler, 500);			
		}
		private function addResizeHandler():void
		{
			stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
		}
		
		
		//Active and deactive handler ---------------------------------------------
		private function stage_deactivateHandler(event:Event):void
		{
			_starling.stop();
			stage.frameRate = (Player.instance.playing||DownloadManager.instance.downloading) ? 0.5 : 0;
			stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
			userModel.activeBackup();
		}
		
		private function stage_activateHandler(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			_starling.start();
			stage.frameRate = 60;
			userModel.deactiveBackup();
		}
	}
}