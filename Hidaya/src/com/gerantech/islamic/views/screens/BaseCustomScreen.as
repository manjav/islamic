package com.gerantech.islamic.views.screens
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Screen;
	
	public class BaseCustomScreen extends Screen
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