package com.gerantech.islamic.views.screens
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	
	public class BaseScreen extends PanelScreen
	{
		protected var appModel:AppModel;
		protected var userModel:UserModel;
		public var type:String = "";

		public function BaseScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			appModel = AppModel.instance;
			userModel = UserModel.instance;
			
			appModel.drawers.isEnabled = false;
			width = appModel.sizes.width;
			height = appModel.sizes.height;
			headerFactory = customHeaderFactory;
			backButtonHandler = backButtonFunction;
			searchButtonHandler = searchButtonFunction;
			
			Flurry.getInstance().logEvent(getQualifiedClassName(this).split("::")[1], {type:type});
		}
		
		protected function customHeaderFactory():Header
		{
			var header:Header = new Header();
			header.visible = false
			//header.backgroundSkin = new Quad( 10, 10, 0xff0000 );
			/*var backButton:FlatButton = new FlatButton("arrow_g_"+app.align);
			backButton.addEventListener(Event.TRIGGERED, backButtonHandler);
			
			header[app.align+"Items"] = new <DisplayObject>[backButton];*/
			return header;
		}
		
		
		protected function backButtonFunction():void
		{
			//appModel.navigator.rootScreenID = "quran";
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