package com.gerantech.islamic.views.screens
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.views.buttons.ToolbarButton;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Screen;
	
	import starling.events.Event;
	
	public class BaseScreen extends Screen
	{
		public var type:String = "";

		override protected function initialize():void
		{
			super.initialize();
			
			appModel.drawers.isEnabled = false;
			backButtonHandler = backButtonFunction;
			searchButtonHandler = searchButtonFunction;
			createToolbarItems();
			
			Flurry.getInstance().logEvent(getQualifiedClassName(this).split("::")[1], {type:type});
		}
		
		protected function backButtonFunction():void
		{
			appModel.navigator.popScreen();
		}
		protected function searchButtonFunction():void
		{
			appModel.navigator.pushScreen(appModel.PAGE_SEARCH);
		}
		
		protected function createToolbarItems():void
		{
			appModel.toolbar.resetItem();
			appModel.toolbar.navigationCallback = backButtonFunction;
		}
		
		
		
		protected function loc(str:String):String
		{
			return ResourceManager.getInstance().getString("loc", str);
		}
		
		protected function get userModel():UserModel { return UserModel.instance; }
		protected function get appModel():AppModel { return AppModel.instance; }
		
	}
}