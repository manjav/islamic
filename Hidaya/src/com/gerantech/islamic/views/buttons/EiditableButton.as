package com.gerantech.islamic.views.buttons
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.items.ShapeLayout;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;

	public class EiditableButton extends SimpleLayoutButton
	{
		private var line:ShapeLayout;
		private var labelDisplay:RTLLabel;
		private var _label:String;
		private var iconDisplay:ImageLoader;
		
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			if(_label == value)
				return;
				
			_label = value;
			if(labelDisplay)
				labelDisplay.text = _label;
		}

		override protected function initialize():void
		{
			super.initialize();
			minHeight = AppModel.instance.sizes.DP40;
			backgroundSkin = new Quad(1,1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			layout = new AnchorLayout();
			
			line = new ShapeLayout(BaseMaterialTheme.CHROME_COLOR);
			line.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			line.height = AppModel.instance.sizes.getPixelByDP(2);
			addChild(line);
			
			labelDisplay = new RTLLabel(_label, BaseMaterialTheme.CHROME_COLOR, "left");
			labelDisplay.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0, NaN, 0);
			addChild(labelDisplay);
			
			iconDisplay = new ImageLoader();
			iconDisplay.source = Assets.getTexture("pencil_gray");
			iconDisplay.layoutData = new AnchorLayoutData(NaN, 0, NaN, NaN, NaN, 0);
			iconDisplay.height = minHeight*0.4;
			addChild(iconDisplay);
		}
		
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			backgroundSkin = new Quad(1,1, value==STATE_DOWN ? BaseMaterialTheme.DESCRIPTION_TEXT_COLOR : BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
		}
	}
}