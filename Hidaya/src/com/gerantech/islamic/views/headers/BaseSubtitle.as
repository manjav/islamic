package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import feathers.controls.LayoutGroup;
	
	import starling.display.Quad;
	
	public class BaseSubtitle extends LayoutGroup
	{
		public var _height:uint = 56;
		protected var appModel:AppModel;
		
		public function BaseSubtitle()
		{
			super();
			
			appModel = AppModel.instance;
			
			height = _height = AppModel.instance.sizes.subtitle;
			backgroundSkin = new Quad(1, 1, UserModel.instance.nightMode ? BaseMaterialTheme.DESCRIPTION_TEXT_COLOR : BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
		}
	}
}