package com.gerantech.islamic.views.screens
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.AutoSizeMode;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollPolicy;
	import feathers.layout.AnchorLayoutData;

	import flash.utils.getQualifiedClassName;

	import gt.utils.Localizations;
	
	public class BaseCustomPanelScreen extends PanelScreen
	{
		public var type:String = "";
		protected var hasTitle:Boolean = true;
		private var titleLable:RTLLabel;

		
		override protected function initialize():void
		{
			super.initialize();
			horizontalScrollPolicy = verticalScrollPolicy = ScrollPolicy.OFF;
			autoSizeMode = AutoSizeMode.STAGE;
			
			appModel.drawers.isEnabled = false;
/*			width = appModel.sizes.width;
			height = appModel.sizes.height;*/
			headerFactory = customHeaderFactory;
			backButtonHandler = backButtonFunction;
			searchButtonHandler = searchButtonFunction;
			createToolbarItems();
			
			Flurry.getInstance().logEvent(getQualifiedClassName(this).split("::")[1], {type:type});
		}
		
		private function customHeaderFactory():Header
		{
			var h:Header = new Header();
			h.visible = false;
			return h;
		}
		
		protected function createToolbarItems():void
		{
			appModel.toolbar.resetItem();
			appModel.toolbar.navigationCallback = backButtonFunction;
			
			if(hasTitle)
			{
				titleLable = new RTLLabel(title, 0xFFFFFF, "center", null, false, null, 0, null, "bold");
				titleLable.layoutData = new AnchorLayoutData(NaN,NaN,NaN,NaN,0,0);
				appModel.toolbar.centerItem = titleLable;
			}
		}
		
		override public function set title(value:String):void
		{
			if(titleLable != null)
				titleLable.text = value;
			super.title = value;
		}
		
		


		/*protected function customHeaderFactory():Header
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
		
		protected function loc(resourceName:String, parameters:Array=null, locale:String=null):String
		{
			return Localizations.instance.get(resourceName, parameters);//, locale);
		}
		protected function get appModel():		AppModel		{	return AppModel.instance;		}
		protected function get userModel():		UserModel		{	return UserModel.instance;		}
		protected function get configModel():	ConfigModel		{	return ConfigModel.instance;	}
		protected function get resourceModel():	ResourceModel	{	return ResourceModel.instance;	}

	}
}