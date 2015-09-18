package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import starling.events.Event;

	
	public class AyaHeader extends LayoutGroup
	{

		private var ayaText:TextBlockTextRenderer;

		private var circle:ImageLoader;
		private var textRenderer:TextBlockTextRenderer;
		
		
		public function AyaHeader()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			layout = new AnchorLayout();
			
			circle = new ImageLoader();
			circle.layoutData = new AnchorLayoutData(0,0,0);
			circle.source = Assets.getTexture("circle_icon");
			addChild(circle);
			
			textRenderer = new TextBlockTextRenderer();
			textRenderer.width = height
			//	textRenderer.width = _height*3+AppModel.instance.sizes.border;
			textRenderer.text = "233";
			var fd:FontDescription = new FontDescription( "mequran", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			//textRenderer.wordWrap = true;
			//textRenderer.bidiLevel = 1;
			//textRenderer.leading = UserModel.instance.fontSize*0.7;
			//textRenderer.textJustifier = new SpaceJustifier( "ar", LineJustification.ALL_BUT_LAST );
			textRenderer.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
			textRenderer.elementFormat = new ElementFormat(fd, UserModel.instance.fontSize, 0x000000);
			textRenderer.layoutData = new AnchorLayoutData(NaN,0,NaN,NaN,NaN,0);
			addChild(textRenderer);
			
		}

		
		public function update(aya:Aya):void
		{
			textRenderer.text = aya.aya.toString();
		}
		
		
	}
}