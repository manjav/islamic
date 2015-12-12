package com.gerantech.islamic.views.screens
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.PanelScreen;
	
	public class BasePanelScreen extends PanelScreen
	{
		protected var appModel:AppModel;
		protected var userModel:UserModel;
		public var type:String = "";

		
		override protected function initialize():void
		{
			super.initialize();
			
			appModel = AppModel.instance;
			userModel = UserModel.instance;
			
			appModel.drawers.isEnabled = false;
/*			width = appModel.sizes.width;
			height = appModel.sizes.height;*/
		//	headerFactory = customHeaderFactory;
			backButtonHandler = backButtonFunction;
			searchButtonHandler = searchButtonFunction;
			
			Flurry.getInstance().logEvent(getQualifiedClassName(this).split("::")[1], {type:type});
		}
		/*
		protected function customHeaderFactory():Header
		{
			var header:Header = new Header();
			header.visible = false
			//header.backgroundSkin = new Quad( 10, 10, 0xff0000 );
			
			return header;
		}*/
		
		
		protected function backButtonFunction():void
		{
			appModel.navigator.popScreen();
		}
		protected function searchButtonFunction():void
		{
			appModel.navigator.pushScreen(appModel.PAGE_SEARCH);
		}
		
		protected function loc(str:String):String
		{
			return ResourceManager.getInstance().getString("loc", str);
		}
		
	}
}