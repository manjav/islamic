package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontWeight;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;

	public class SettingItemRenderer extends BaseCustomItemRenderer
	{		
		/*public static const FONT:String = "font";
		public static const LANGUAGE:String = "language";
		public static const IDLE:String = "idle";
		public static const NAVIGATION:String = "navigation";*/
		
		private var mode:String;
		private var titleDisplay:RTLLabel;
		private var iconDisplay:ImageLoader;

		public var labelFunction:Function;
		
		public function SettingItemRenderer(height:Number=0)
		{
			super();
			this.height = height;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			
			if(height==0)
				height = AppModel.instance.sizes.listItem;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.gap = myLayout.padding = AppModel.instance.sizes.border*2;
			layout = myLayout;
			
			titleDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, uint(userModel.fontSize*0.9), null, FontWeight.BOLD);
			titleDisplay.layoutData = new HorizontalLayoutData(100);
			
			iconDisplay = new ImageLoader();
			iconDisplay.width = iconDisplay.height = height/2
			iconDisplay.delayTextureCreation = true;
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			/*if(bookmark==_data)
				return;*/
			
			if(_data.hasOwnProperty("icon"))
			{
				iconDisplay.source = _data.icon
				addChild(appModel.ltr?iconDisplay:titleDisplay);
				addChild(appModel.ltr?titleDisplay:iconDisplay);
			}
			else
				addChild(titleDisplay);

			
			if(!_data.name)
			{
				_data.name = ResourceManager.getInstance().getString("loc", String(_data.value));
			}
			if(labelFunction!=null)
			{
				titleDisplay.text = labelFunction(_data);
			}
			else
				titleDisplay.text = _data.name
			super.commitData();
		}
		
		
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			if(value==lastState)
				return;
			//	trace(value)
			backgroundSkin = new Quad(1, 1, (value==STATE_SELECTED||value==STATE_DOWN)?BaseMaterialTheme.SELECTED_BACKGROUND_COLOR:BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			if(titleDisplay)
			titleDisplay.elementFormat = new ElementFormat(titleDisplay.fontDescription, titleDisplay.fontSize, (value==STATE_SELECTED||value==STATE_DOWN) ? BaseMaterialTheme.SELECTED_TEXT_COLOR : BaseMaterialTheme.PRIMARY_TEXT_COLOR);
		}


	}
}