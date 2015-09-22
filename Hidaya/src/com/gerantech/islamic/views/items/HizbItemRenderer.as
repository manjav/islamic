package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Hizb;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;

	public class HizbItemRenderer extends BaseCustomItemRenderer
	{		
		private var iconDisplay:ImageLoader;
		private var titleDisplay:TextBlockTextRenderer;
		private var hizb:Hizb;
		
		public function HizbItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
		//	backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			height = AppModel.instance.sizes.twoLineItem;
			
			layout = new AnchorLayout();
			
			iconDisplay = new ImageLoader();
			iconDisplay.width = iconDisplay.height = appModel.sizes.twoLineItem*0.8;
			iconDisplay.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			iconDisplay.delayTextureCreation = true;
			addChild(iconDisplay);

			titleDisplay = new TextBlockTextRenderer();
			var fd:FontDescription = new FontDescription("mequran", FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			titleDisplay.textAlign = "center";
			titleDisplay.elementFormat = new ElementFormat(fd, appModel.sizes.twoLineItem/3, BaseMaterialTheme.PRIMARY_TEXT_COLOR);
			titleDisplay.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			addChild(titleDisplay);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			if(_data==hizb)
				return;
			
			hizb = _data as Hizb;
			
			titleDisplay.visible = hizb.index%4==0;
			titleDisplay.text = String(hizb.index/4+1)
			iconDisplay.source = Assets.getTexture("hizb_"+(hizb.index%4)+"_4");
			super.commitData();
		}

	}
}