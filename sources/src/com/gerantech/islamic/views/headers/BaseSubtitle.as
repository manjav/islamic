package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;

	import feathers.controls.LayoutGroup;

	import gt.utils.Localizations;

	import starling.display.Quad;
	
	public class BaseSubtitle extends LayoutGroup
	{
		public var _height:uint = 56;
		protected var appModel:AppModel;
		protected var userModel:UserModel;
		
		public function BaseSubtitle()
		{
			super();
			
			appModel = AppModel.instance;
			userModel = UserModel.instance;
			
			height = _height = AppModel.instance.sizes.subtitle;
			backgroundSkin = new Quad(1, 1, UserModel.instance.nightMode ? BaseMaterialTheme.DESCRIPTION_TEXT_COLOR : BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
		}
		
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return Localizations.instance.get(str, parameters);//, locale);
		}
		
	}
}