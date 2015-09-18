package com.gerantech.islamic.views.popups
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class BasePopUp extends LayoutGroup
	{
		protected  var appModel:AppModel;
		protected var userModel:UserModel;
		public var closable:Boolean = true;
		
		public function BasePopUp()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			appModel = AppModel.instance;
			userModel = UserModel.instance;
			
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
		
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}
		
		public function close():void
		{
			dispatchEventWith(Event.CLOSE);
		}		
		
		
		/*override protected function stage_resizeHandler(event:Event):void
		{
		width = AppModel.instance.sizes.width-AppModel.instance.sizes.border*2;
		height = AppModel.instance.sizes.height-AppModel.instance.sizes.border*6;
		
		if(event)
		super.stage_resizeHandler(event);
		}*/	}
}