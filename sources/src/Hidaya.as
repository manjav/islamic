package 
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.Main;
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.managers.NotificationManager;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import starling.core.Starling;

	public class Hidaya extends Sprite
	{
		private var _starling:Starling;
		private var appModel:AppModel;
		private var userModel:UserModel;
		private var configModel:ConfigModel;
		private var appController:AppController;
		
		private var validateScreenTimeoutID:uint;
		public static var ft:int;

		/**
		 * First method runs in app.
		 */
		public function Hidaya()
		{
			ft = getTimer();
				
			mouseEnabled = mouseChildren = false;
			appModel = AppModel.instance;

			if(stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.setOrientation(StageOrientation.DEFAULT);
				stage.autoOrients=false;
			}
			
			NativeAbilities.instance.showOnLockScreen();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, nativeApplication_invokeHandler);
			loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			
			trace(" --  Hidaya", getTimer()-ft);
		}
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			//trace(" --  Hidaya loaderInfo_completeHandler", getTimer()-ft);
			loaderInfo.removeEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			
			appModel.init(this as Hidaya);
			appController = AppController.instance;
			configModel = ConfigModel.instance;
			
			//Start Starling ----------------------------------------------------------
			_starling = new Starling(Main, stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			_starling.supportHighResolutions = true;
			_starling.enableErrorChecking = false;
			setTimeout(function():void{_starling.skipUnchangedFrames = true}, 4000);
			//_starling.showStats = true;
			//_starling.showStatsAt(HAlign.CENTER, VAlign.BOTTOM);
			_starling.addEventListener("rootCreated", starling_rootCreatedHandler);
			_starling.start();

			trace(ResourceManager.getInstance().getString("loc", "quran_t"))
		}
		
		private function starling_rootCreatedHandler():void
		{
			_starling.removeEventListener("rootCreated", starling_rootCreatedHandler);
			//trace(" --  starling_rootCreatedHandler", getTimer()-ft);
			
			userModel = UserModel.instance;
			userModel.addEventListener(UserEvent.LOAD_DATA_COMPLETE, user_completeHandler);
			userModel.addEventListener(UserEvent.LOAD_DATA_ERROR, user_completeHandler);
			userModel.load(appModel, appController, configModel);

			stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
			stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			stage_resizeHandler();
		}
		
		protected function user_completeHandler():void
		{
			//trace(" --  user_completeHandler", getTimer()-ft);
			
			// Flurry initialising ----------------------------------------------------
			//Flurry.getInstance().logEnabled = true
			Flurry.getInstance().setAndroidAPIKey("34RKN4HMZ7C8YWW9BD52");
			Flurry.getInstance().startSession();
			Flurry.getInstance().setAppVersion(appModel.descriptor.versionNumber);
			
			// NotificationManager initialising ----------------------------------------
			NotificationManager.instance;
			
			// BillingManager initialising ----------------------------------------
			BillingManager.instance.init();
			
			if(Capabilities.cpuArchitecture=="x86" || userModel.fontSize==12)
			{
				userModel.fontSize = Math.round(appModel.sizes.orginalFontSize);
			//	trace(appModel.sizes.orginalFontSize, userModel.fontSize)
			//	UserModel.instance.premiumMode = Capabilities.cpuArchitecture=="x86"
			}
			Main(_starling.root).createScreens();
			//stage.quality = StageQuality.BEST;
			//Assets.save();
			trace("5", getTimer()-ft);
		}
	
		
		protected function nativeApplication_invokeHandler(event:InvokeEvent):void
		{
			//NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, nativeApplication_invokeHandler);
			trace(" --  nativeApplication_invokeHandler", getTimer()-ft);
			for(var k:String in event.arguments)
			{
				var val:String = String(event.arguments[k]);
				if(val.search("hidaya://athan")>-1)
				{
					var urlVariables:URLVariables =  new URLVariables(val.split("?")[1]);
					appModel.invokeData = {type:"athan", timeIndex:urlVariables.timeIndex, alertIndex:urlVariables.alertIndex};
					if(appModel.hasEventListener(InvokeEvent.INVOKE))
						appModel.dispatchEventWith(InvokeEvent.INVOKE, false, appModel.invokeData);
				}
			}
		}
		
		
		private function stage_resizeHandler(event:Event=null):void
		{
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler, false);
			appModel.sizes.resize(stage.stageWidth, stage.stageHeight);
			appModel.upside = stage.stageHeight>stage.stageWidth;//stage.deviceOrientation=="default" || stage.deviceOrientation=="upsideDown" || stage.deviceOrientation=="unknown";
			
			if(_starling == null)
				return;
			
			var viewPort:Rectangle = _starling.viewPort;
			viewPort.width = appModel.sizes.width
			viewPort.height = appModel.sizes.heightFull;
			
			_starling.stage.stageWidth = appModel.sizes.width;
			_starling.stage.stageHeight = appModel.sizes.heightFull;
			
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
			_starling.skipUnchangedFrames = false;
			_starling.stop();
			stage.frameRate = (Player.instance.playing||DownloadManager.instance.downloading) ? 0.5 : 0;
			stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
			//userModel.activeBackup();
		}
		
		private function stage_activateHandler(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			_starling.start();
			stage.frameRate = 60;
			//userModel.deactiveBackup();
			setTimeout(function():void{_starling.skipUnchangedFrames = true}, 4000);
		}
	}
}