package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.LineJustification;
	import flash.text.engine.SpaceJustifier;
	
	
	public class TranslatorHeader extends LayoutGroup
	{
		private var icon:ImageLoader;
		private var textField:TextBlockTextRenderer;
		private var mlayout:HorizontalLayout;
		
		public function TranslatorHeader()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			mlayout = new HorizontalLayout();
			mlayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			mlayout.gap = mlayout.paddingRight = mlayout.paddingLeft = AppModel.instance.border;
			layout = mlayout;
		}
		
		public function set translator(value:Person):void
		{
			height = AppModel.instance.actionHeight*0.8;
			textField = new TextBlockTextRenderer();
			textField.text = value.name;
			var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			textField.leading = UserModel.instance.fontSize;
			textField.bidiLevel = value.flag.dir=="rtl"?1:0;
			textField.textJustifier = new SpaceJustifier(value.flag.dir=="rtl"?"ar":"en", LineJustification.ALL_BUT_LAST );
			textField.textAlign = TextBlockTextRenderer.TEXT_ALIGN_RIGHT;
			textField.elementFormat = new ElementFormat(fd, UserModel.instance.fontSize, 0x000000);
			textField.layoutData = new HorizontalLayoutData(100);
			addChild(textField);
			
			icon = new ImageLoader();
			icon.layoutData = new HorizontalLayoutData(NaN, 100);
			icon.delayTextureCreation = true;
			icon.source = value.iconTexture;
			addChild(icon);
		}
	}
}