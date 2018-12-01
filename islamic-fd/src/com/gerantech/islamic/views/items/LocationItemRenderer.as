package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.text.engine.ElementFormat;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;

	public class LocationItemRenderer extends BaseCustomItemRenderer
	{		
		
		private var titleDisplay:RTLLabel;
		private var messageDisplay:RTLLabel;
		private var lastState:String;

		override protected function initialize():void
		{
			super.initialize();
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			height = AppModel.instance.sizes.singleLineItem;
			layout = new AnchorLayout();
			var gap:uint = appModel.sizes.DP8;
			
			titleDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0, null, "bold");
			titleDisplay.layoutData = new AnchorLayoutData(gap, gap, height*0.4, gap);
			addChild(titleDisplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.8);
			messageDisplay.layoutData = new AnchorLayoutData(height*0.6, gap, gap, gap);
			addChild(messageDisplay);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			
			titleDisplay.text = data.name_latin;
			messageDisplay.text = data.country_name
			super.commitData();
		}
		
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			
			if(lastState==value || stage==null)
				return;
			backgroundSkin = new Quad(1, 1, (value==STATE_SELECTED||value==STATE_DOWN)?BaseMaterialTheme.SELECTED_BACKGROUND_COLOR:BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			if(titleDisplay)
				titleDisplay.elementFormat = new ElementFormat(titleDisplay.fontDescription, titleDisplay.fontSize, (value==STATE_SELECTED||value==STATE_DOWN) ? BaseMaterialTheme.SELECTED_TEXT_COLOR : BaseMaterialTheme.PRIMARY_TEXT_COLOR);
			lastState = value;
		}
	}
}