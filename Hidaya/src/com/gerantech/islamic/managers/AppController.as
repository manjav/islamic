package com.gerantech.islamic.managers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.popups.BasePopUp;
	import com.gerantech.islamic.views.popups.InfoPopUp;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.core.PopUpManager;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
		
	public class AppController extends EventDispatcher
	{
		private var appModel:AppModel;
		
		private static var _this:AppController;
		private var idleTimeout:uint;
		private var saveTimeout:uint;
		private var _frameRate:int = 60;

		public static function get instance():AppController
		{
			if(_this == null)
				_this = new AppController();
			return (_this);
		}
		
		public function AppController()
		{
			appModel = AppModel.instance;
		}
		/*
		public function setFullScreenDisabled(value:Boolean):void
		{
			//appModel.main.stage.displayState = value ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//appModel.main.validateScreenSize();
		}*/
		
		public function setLanguage(value:Object):void
		{
			ResourceManager.getInstance().localeChain = [value.value];
			appModel.direction = value.dir;
			
			/*if(appModel.drawers!=null)
			{
				appModel.myDrawer = new DrawerList(appModel.ltr);
				appModel.drawers.rightDrawer = appModel.drawers.leftDrawer = null;
				
				if(appModel.ltr)
					appModel.drawers.leftDrawer = appModel.myDrawer;
				else
					appModel.drawers.rightDrawer = appModel.myDrawer;
			}*/
			
			if(appModel.toolbar!=null)
				appModel.toolbar.setLayout();
		}
		
		public function toggleDrawer():void
		{
			appModel.ltr?appModel.drawers.toggleLeftDrawer() : appModel.drawers.toggleRightDrawer();
		}

		public function setIdleMode(value:Object):void
		{
			switch(value.value)
			{
				case "awake_on":
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
					break;
				case "awake_of":
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
					break;
				case "while_playing":
					NativeApplication.nativeApplication.systemIdleMode = Player.instance.playing ? SystemIdleMode.KEEP_AWAKE : SystemIdleMode.NORMAL;
					break;
			}
			//trace(value.value, NativeApplication.nativeApplication.systemIdleMode)
		}

		/*public function startSearch(value:String):void
		{
		}
		

		public function setFontSize(value:uint):void
		{
		}
		public function setFontFamily(value:String):void
		{
		}*/
		
		//CLOSE_____________________________________________________________________________________________
		public function close():void
		{
			//userModel.save();
			//openPopup("quit_msg", '', appCloser);
			NativeApplication.nativeApplication.exit();
		}
		/*private function appCloser (accept:Boolean):void
		{
			appModel.popupIsOpen = false;
			if(accept)
			{
			}
			//buttonsList.selectedIndex = -1;
		}*/
		
		public function setPaths(userModel:UserModel, rootPath:String=""):void
		{
			if(rootPath=="")
				userModel.storagePath = File.documentsDirectory.nativePath;
			else
				userModel.storagePath = rootPath;
			
			var root:File = new File(userModel.storagePath);
			if(!root.exists)
			{
				root = File.documentsDirectory;
				userModel.storagePath = root.nativePath;
			}
			if(userModel.storagePath.search("islamic")==-1)
			{
				userModel.TRANSLATOR_PATH = root.url + "/islamic/texts/translations/";
				userModel.SOUNDS_PATH = root.url + "/islamic/sounds/";			
			}
			else
			{
				userModel.TRANSLATOR_PATH = root.url + "/texts/translations/";
				userModel.SOUNDS_PATH = root.url + "/sounds/";			
			}
				
		}
		public function addPopup(popupClass:Class, closeCallback:Function=null, closable:Boolean=true, overlayFactory:Function=null):BasePopUp
		{		
			var overlay:FlatButton;
			var popup:BasePopUp = new popupClass();
			popup.closable = closable;
			popup.addEventListener(Event.CLOSE, popup_closeHandler);
			if(overlayFactory == null)
				overlayFactory = geoPopup_overlayFactory;
			PopUpManager.addPopUp(popup, true, true, overlayFactory);
			
			function geoPopup_overlayFactory():DisplayObject
			{
				overlay = new FlatButton(null, null, true, 0.3, 0.2, 0);
				popup.overlay = overlay;
				if(closable)
					overlay.addEventListener(Event.TRIGGERED, popup.close);
				
				return overlay;
			}
			function popup_closeHandler():void
			{
				if(closeCallback!=null)
					closeCallback();
				
				var tw:Tween = new Tween(overlay, 0.2);
				tw.fadeTo(0);
				tw.onComplete = fadeToCompleteHandler;
				Starling.juggler.add(tw);
			}
			function fadeToCompleteHandler():void
			{
				if(overlay != null)
					overlay.removeEventListener(Event.TRIGGERED, popup.close);
				if(PopUpManager.isPopUp(popup))
					PopUpManager.removePopUp(popup);
			}
			return popup;
		}
		
		public function alert(title:String, message:String, cancelButtonLabel:String="know_button", acceptButtonLabel:String="", acceptCallback:Function=null, cancelCallback:Function=null, closable:Boolean=true):void
		{
			var ttl:String = ResourceManager.getInstance().getString("loc", title);
			if(ttl==null)
				ttl = title;
			
			var msg:String = ResourceManager.getInstance().getString("loc", message);
			if(msg==null)
				msg = message;
			
			var overlay:FlatButton;
			var infoPopUp:InfoPopUp = new InfoPopUp();
			infoPopUp.closable = closable;
			infoPopUp.title = ttl;
			infoPopUp.message = msg;
			infoPopUp.cancelButtonLabel = ResourceManager.getInstance().getString("loc", cancelButtonLabel);
			infoPopUp.cancelCallback = cancelCallback;
			infoPopUp.acceptButtonLabel = ResourceManager.getInstance().getString("loc", acceptButtonLabel);
			infoPopUp.acceptCallback = acceptCallback;
			infoPopUp.addEventListener(Event.CLOSE, infoPopUp_closeHandler);
			PopUpManager.addPopUp(infoPopUp, true, true, infoPopUp_overlayFactory);
			
			function infoPopUp_overlayFactory():DisplayObject
			{
				overlay = new FlatButton(null, null, true, 0.3, 0.3, 0);
				if(infoPopUp.closable)
					overlay.addEventListener(Event.TRIGGERED, infoPopUp.close);
				return overlay;
			};
			function infoPopUp_closeHandler(event:Event):void
			{
				var tw:Tween = new Tween(overlay, 0.2);
				tw.fadeTo(0);
				tw.onComplete = fadeToCompleteHandler;
				Starling.juggler.add(tw);
			}
			function fadeToCompleteHandler():void
			{
				overlay.removeEventListener(Event.TRIGGERED, infoPopUp.close);
				if(PopUpManager.isPopUp(infoPopUp))
					PopUpManager.removePopUp(infoPopUp);
			}
		}
		


		public function resetIdle():void
		{
			if(appModel.puased)
				appModel.puased = false;
			
			frameRate = 60;
			
			clearTimeout(saveTimeout);
			clearTimeout(idleTimeout);
			saveTimeout = setTimeout(stratSaveMode, 3000);
			
		}
		
		private function stratSaveMode():void
		{
			clearTimeout(saveTimeout);
			clearTimeout(idleTimeout);
			if(!Starling.current.isStarted)
				return;
			
			frameRate = 20;
			idleTimeout = setTimeout(stratIdleMode, 20000);
		}
		
		private function stratIdleMode():void
		{
			if(!Starling.current.isStarted)
				return;
			
			appModel.puased = true;
			frameRate = 13;
		}		
		
		public function get frameRate():int
		{
			return _frameRate;
		}
		public function set frameRate(value:int):void
		{
			if(_frameRate==value)
				return;
			
			_frameRate = value;
			Starling.current.nativeStage.frameRate = value;
		}

	}
}