package com.gerantech.islamic.views.buttons
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.ImageLoader;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.skins.ImageSkin;

	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import feathers.layout.VerticalAlign;

	public class EditableButton extends SimpleLayoutButton
	{
		//private var line:ShapeLayout;
		private var labelDisplay:RTLLabel;
		private var _label:String;
		private var iconDisplay:ImageLoader;
		private var _icon:Texture;
		private var editDisplay:ImageLoader;
		private var skin:ImageSkin;
		
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
		
		public function set icon(value:Texture):void
		{
			if(_icon == value)
				return;
			
			_icon = value;
			if(iconDisplay)
				iconDisplay.source = _icon;
		}

		override protected function initialize():void
		{
			super.initialize();
			minHeight = AppModel.instance.sizes.DP40;
			
			skin = new ImageSkin(Assets.getTexture("background-focused-skin"));
			skin.setTextureForState(STATE_HOVER, Assets.getTexture("background-focused-skin"));
			skin.setTextureForState(STATE_UP, Assets.getTexture("background-focused-skin"));
			skin.setTextureForState(STATE_DISABLED, Assets.getTexture("background-inset-disabled-skin"));
			skin.setTextureForState(STATE_DOWN, Assets.getTexture("background-inset-disabled-skin"));
			skin.scale9Grid = Assets.BACKGROUND_GRID;
			backgroundSkin = skin;
			
			var hlayout:HorizontalLayout = new HorizontalLayout();
			hlayout.verticalAlign = VerticalAlign.MIDDLE;
			layout = hlayout;
			
			iconDisplay = new ImageLoader();
			iconDisplay.height = minHeight*0.8;
			if(_icon)
				iconDisplay.source = _icon;
			
			labelDisplay = new RTLLabel(_label, BaseMaterialTheme.CHROME_COLOR);
			labelDisplay.layoutData = new HorizontalLayoutData(100);
			addChild(labelDisplay);
			
			editDisplay = new ImageLoader();
			editDisplay.source = Assets.getTexture("pencil_gray");
			editDisplay.height = minHeight*0.4;
			
			var elements:Array = [iconDisplay, labelDisplay, editDisplay];
			if(!AppModel.instance.ltr)
				elements.reverse();
			
			for each(var e:DisplayObject in elements)
				addChild(e);
		}
		
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			skin.defaultTexture = skin.getTextureForState(value);
		}
	}
}