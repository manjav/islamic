package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.skins.ImageSkin;

	public class SettingItemRenderer extends BaseCustomItemRenderer
	{		
		/*public static const FONT:String = "font";
		public static const LANGUAGE:String = "language";
		public static const IDLE:String = "idle";
		public static const NAVIGATION:String = "navigation";*/
		
		protected var mode:String;
		protected var titleDisplay:RTLLabel;
		protected var iconDisplay:ImageLoader;

		public var labelFunction:Function;
		public var iconFunction:Function;

		protected var lastState:String;

		protected var myLayout:HorizontalLayout;
		
		public function SettingItemRenderer(height:Number=0)
		{
			super();
			this.height = height;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			skin = new ImageSkin(Assets.getTexture("background-light-skin"));
			skin.setTextureForState( STATE_NORMAL, Assets.getTexture("background-light-skin") );
			skin.setTextureForState( STATE_SELECTED, Assets.getTexture("background-disabled-skin") );
			skin.setTextureForState( STATE_DOWN, Assets.getTexture("background-disabled-skin") );
			skin.scale9Grid = new Rectangle(2,2,14,14);
			backgroundSkin = skin;
			
			if(height==0)
				height = AppModel.instance.sizes.singleLineItem;
			
			myLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.gap = myLayout.padding = height/4;
			layout = myLayout;
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			
			if(titleDisplay == null)
				addElements(iconFunction!=null || _data.hasOwnProperty("icon"));
			
			// set image for icon
			if(iconFunction!=null)
				iconDisplay.source = iconFunction(_data);
			else if(_data.hasOwnProperty("icon"))
			{
				if(_data.icon is String && _data.icon.indexOf(".")==-1)
					iconDisplay.source = Assets.getTexture(_data.icon);
				else
					iconDisplay.source = _data.icon;
			}

			// set name for title text
			if(_data.hasOwnProperty("value") && !data.hasOwnProperty("name"))
			{
				_data.name = loc(String(_data.value));
			}
			if(labelFunction!=null)
			{
				titleDisplay.text = StrTools.getNumberFromLocale(labelFunction(_data));
			}
			else if(data.hasOwnProperty("name"))
				titleDisplay.text = StrTools.getNumberFromLocale(_data.name);
			else
				titleDisplay.text = _data.toString();
			
			super.commitData();
		}
		
		/**
		 * Add title and icon elemensts in first data set
		 */
		protected function addElements(hasIcon:Boolean):void
		{
			titleDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0.9, null, "bold");
			titleDisplay.layoutData = new HorizontalLayoutData(100);
//
			if(hasIcon)
			{
				iconDisplay = new ImageLoader();
				iconDisplay.width = iconDisplay.height = height/2;
				iconDisplay.delayTextureCreation = true;

				addChild(appModel.ltr?iconDisplay:titleDisplay);
				addChild(appModel.ltr?titleDisplay:iconDisplay);
			}
			else
				addChild(titleDisplay);
		}
		
		
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			
			if(lastState==value || stage==null)
				return;
			
			skin.defaultTexture = skin.getTextureForState(value);
			
			if(titleDisplay)
				titleDisplay.elementFormat = new ElementFormat(titleDisplay.fontDescription, titleDisplay.fontSize, (value==STATE_SELECTED||value==STATE_DOWN) ? BaseMaterialTheme.SELECTED_TEXT_COLOR : BaseMaterialTheme.PRIMARY_TEXT_COLOR);
			lastState = value;
		}


	}
}