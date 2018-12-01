package com.gerantech.islamic.views.popups
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.views.buttons.FlatButton;
	
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class BasePopUp extends LayoutGroup
	{
		public var closable:Boolean = true;
		public var overlay:FlatButton;
		
		public function BasePopUp()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_isInitialized = true;
			
			autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE; 
			stage_resizeHandler(null);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyUpHandler);	 
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			
			Flurry.getInstance().logEvent(getQualifiedClassName(this).split("::")[1]);
		}
		
		private function removeFromStageHandler(event:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyUpHandler);
		}
		
		private function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(!closable)
				return;
			if(event.keyCode==Keyboard.BACK)
			{
				//stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyUpHandler);
				event.preventDefault();
				close();
			}
		}
		
		public function close():void
		{
			dispatchEventWith(Event.CLOSE);
		}		
		
		
		protected function loc(resourceName:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", resourceName, parameters, locale);
		}
		protected function get appModel():		AppModel		{	return AppModel.instance;		}
		protected function get userModel():		UserModel		{	return UserModel.instance;		}
		protected function get configModel():	ConfigModel		{	return ConfigModel.instance;	}
		protected function get resourceModel():	ResourceModel	{	return ResourceModel.instance;	}
	}
}