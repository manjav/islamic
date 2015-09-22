package com.gerantech.islamic.views.items
{
	import com.greensock.TweenLite;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Local;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import mx.resources.ResourceManager;
	
	import starling.display.Image;
	import starling.display.Quad;
		
	public class LocalItemRenderer extends BaseCustomItemRenderer
	{
		private var local:Local;
		private var labelDisplay:TextBlockTextRenderer;
		public var listLen:uint;
		
		public function LocalItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			backgroundSkin = new Scale9Image(Assets.getItemTextures());
			layout = new AnchorLayout();
			height = width = uint(AppModel.instance.sizes.twoLineItem*1.5);
			
			
			labelDisplay = new TextBlockTextRenderer();
			var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			labelDisplay.textAlign = TextBlockTextRenderer.TEXT_ALIGN_RIGHT;
			labelDisplay.elementFormat = new ElementFormat(fd, UserModel.instance.fontSize, 0);
			labelDisplay.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			addChild(labelDisplay);
			alpha = 0;
		}
		
		override protected function commitData():void
		{
			if(_data && _owner)
			{
				if(local==_data)
					return;
				local = _data as Local;
				labelDisplay.text = ResourceManager.getInstance().getString("loc", local.name);
				TweenLite.to(this, 0.5, {delay:index/listLen/3, alpha:1});
			}
		}
		
		/*override public function set isSelected(value:Boolean):void
		{
			_data.selected = value;
			super.isSelected = value;
		}*/
		
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			if(value==lastState)
				return;
			backgroundSkin = new Scale9Image(Assets.getItemTextures(value==STATE_DOWN||value==STATE_SELECTED));
		}		

	}
}