package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Person;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.text.TextField;
	
	public class MoreStrip extends LayoutGroup
	{
		public function MoreStrip()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var mlayout:HorizontalLayout = new HorizontalLayout();
			mlayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout = mlayout;
			
			height = AppModel.instance.sizes.twoLineItem/2
			var textField:TextField = new TextField(height/2, height, ConfigModel.instance.selectedTranslators.length.toString(), "SourceSans", UserModel.instance.fontSize);
			
			var icon:ImageLoader = new ImageLoader();
			icon.delayTextureCreation = true;
			icon.source = Assets.getTexture("translation_circle");
			icon.layoutData = new HorizontalLayoutData(NaN, 100);
			
			addChild(icon);
			addChild(textField);
			
		}
		
		
	}
}