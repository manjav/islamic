package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	public class TranslationHeader extends LayoutGroup
	{
		private var appModel:AppModel;
		private var _aya:Aya;

		private var ayaLabel:RTLLabel;
		private var suraImage:ImageLoader;
		
		public function TranslationHeader()
		{
			super();
			appModel = AppModel.instance;
		}
		
		public function get aya():Aya
		{
			return _aya;
		}
		public function set aya(value:Aya):void
		{
			if(_aya==value)
				return;
			
			_aya = value;
/*			if(ayaLabel)
				ayaLabel.text = "   -   "+_aya.aya;*/
			
			if(suraImage)
				suraImage.source = Assets.getTexture(_aya.sura.toString());//StrTools.getZeroNum((sura-1).toString(), 3)
		}

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			height = appModel.sizes.subtitle;
			backgroundSkin = new Quad(1,1,BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			backgroundSkin.alpha = 0.8//UserModel.instance.nightMode ? 0.9 : 0.7;
			
			/*var slayout:HorizontalLayout = new HorizontalLayout();
			slayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			slayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var suraGroup:LayoutGroup = new LayoutGroup();
			suraGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			suraGroup.layout = slayout;
			addChild(suraGroup);
			
			ayaLabel = new RTLLabel("", 0, null, null, false, null, appModel.sizes.itemHeight*0.5, "mequran");
			suraGroup.addChild(ayaLabel);*/
			
			suraImage = new ImageLoader();
			suraImage.delayTextureCreation = true;
			suraImage.height = uint(height*0.6);
			suraImage.layoutData = new AnchorLayoutData(NaN,NaN,NaN,NaN,0,0);
			addChild(suraImage);
			
			var closeButton:FlatButton = new FlatButton("arrow_w_right", null, true);
			closeButton.layoutData = new AnchorLayoutData(0,0,0);
			closeButton.width = height;
			closeButton.iconScale = 0.5;
			closeButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(closeButton);
		}
		
		private function closeButton_triggeredHandler():void
		{
			dispatchEventWith(Event.CLOSE);
		}		
		
		
	}
}