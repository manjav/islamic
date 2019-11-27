package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.Devider;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;

	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.LineJustification;
	import flash.text.engine.SpaceJustifier;

	import starling.filters.ColorMatrixFilter;
	import feathers.layout.VerticalAlign;
	
	public class TranslationItemRenderer extends BaseCustomItemRenderer	
	{
		private var rtlText:TextBlockTextRenderer;
		private var htmlText:TextFieldTextRenderer;
		//private var devider:Devider;
		
		private var uthmaniFont:FontDescription;
		private var translateFont:FontDescription;

		private var translatorHeader:LayoutGroup;
		private var translatorIcon:ImageLoader;
		private var translatorName:RTLLabel;

		private var tLayout:HorizontalLayout;
		private var bismHeader:ImageLoader;

		private var border:uint;
		private var devider:Devider;
		private var translator_iconLoadedHandler:Object;

		private var translator:Person;
		
		public function TranslationItemRenderer()
		{
			super();
			isQuickHitAreaEnabled = true;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			border = UserModel.instance.fontSize/2;
			
			bismHeader = new ImageLoader();
			bismHeader.delayTextureCreation = true;
			bismHeader.height = AppModel.instance.sizes.DP24;
			bismHeader.source = Assets.getTexture("bism_header", "surajuze");
			bismHeader.layoutData = new AnchorLayoutData(0, NaN, NaN, NaN, 0);
			if(UserModel.instance.nightMode)
			{
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
				colorFilter.invert();
				bismHeader.filter = colorFilter;
			}
			

			uthmaniFont = new FontDescription( userModel.font.value, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			translateFont = new FontDescription( "SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			
			rtlText = new TextBlockTextRenderer();
			rtlText.wordWrap = true;
			rtlText.textAlign = "right";
			rtlText.bidiLevel = 1;//translator.flag.dir=="rtl"?1:0;
			rtlText.textJustifier = new SpaceJustifier("fa", LineJustification.ALL_BUT_MANDATORY_BREAK );

			htmlText = new TextFieldTextRenderer();
			htmlText.isHTML = true;
			htmlText.wordWrap = true;
			htmlText.embedFonts = true;
			htmlText.layoutData = new AnchorLayoutData(0, border*2, NaN, border*2);
			htmlText.textFormat = new TextFormat("SourceSans", UserModel.instance.fontSize, 0x333333, null, null, null, null, null, "justify", null, null, null);//, -fontSize/1.2
		
			devider = new Devider(BaseMaterialTheme.CHROME_COLOR, border/7);
			devider.layoutData = new AnchorLayoutData(border,0,NaN,0);
			
			tLayout = new HorizontalLayout();
			tLayout.verticalAlign = VerticalAlign.MIDDLE;
			tLayout.gap = tLayout.paddingBottom = tLayout.paddingTop = border;
			
			translatorHeader = new LayoutGroup();
			//translatorHeader.backgroundSkin = new Quad(1,1,0xFDFEFE);
			translatorHeader.layoutData = new AnchorLayoutData(border,0,NaN,0);
			translatorHeader.layout = tLayout;
			
			translatorIcon = new ImageLoader();
			translatorIcon.width = translatorIcon.height = uint(UserModel.instance.fontSize*2.4);
			translatorIcon.delayTextureCreation = true;
			
			translatorName = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, userModel.fontSize, null, "bold");
		}
		
		
		override protected function commitData():void
		{
			super.commitData();
			removeChildren();
			//trace(_data)
			if(_data==null || _owner==null)
				return;
			
			if(_data is Aya)
			{
				var aya:Aya = _data as Aya;
				
				if(aya.hasBism)
					addChild(bismHeader);
				
				if(aya.sura<2 && aya.aya==1)
					return;
				
				rtlText.layoutData = new AnchorLayoutData((aya.hasBism?AppModel.instance.sizes.twoLineItem:0), border*2, NaN, border*2);
				rtlText.elementFormat = new ElementFormat(uthmaniFont, UserModel.instance.fontSize*1.2*userModel.font.scale, BaseMaterialTheme.PRIMARY_TEXT_COLOR);
				rtlText.textAlign = "right";
				rtlText.text = aya.aya + ". " + ResourceModel.instance.quranXML.sura[aya.sura-1].aya[aya.aya-1].@text;
				addChild(rtlText);
				return;
			}
			
			if(_data is Person)
			{
				if(translator!=null)
					translator.removeEventListener(Person.ICON_LOADED, translator_iconLoadedHandler);

				translator = _data as Person;
				translatorHeader.removeChildren();
				translatorName.text = translator.name;
				tLayout.horizontalAlign = translator.flag.align;
				translatorHeader.addChild(translator.flag.align=="left"?translatorIcon : translatorName);
				translatorHeader.addChild(translator.flag.align=="right"?translatorIcon : translatorName);
				addChild(translatorHeader);
				addChild(devider);
				if(translator.iconTexture==null)
				{
					translator.loadImage();
					translator.addEventListener(Person.ICON_LOADED, translator_iconLoadedHandler);
				}
				else
					translatorIcon.source = translator.iconTexture;
				
				function translator_iconLoadedHandler():void
				{
					translator.removeEventListener(Person.ICON_LOADED, translator_iconLoadedHandler);
					translatorIcon.source = translator.iconTexture;
				}
				return;
			}
/*			minHeight = 160;
			
		}
		
		override protected function commitBeforeStopScrolling():void
		{
			super.commitBeforeStopScrolling();
			
			if(_data==null || _owner==null)
				return;
			if(_data is Aya || _data is Person)
				return;*/
			
			var color:uint = UserModel.instance.premiumMode || _data.translator.free || _data.aya.sura<3 ? BaseMaterialTheme.DESCRIPTION_TEXT_COLOR : 0xFF0000;
			
			if(_data.translator.path=="en.transliteration")
			{
				htmlText.textFormat = new TextFormat("SourceSans", UserModel.instance.fontSize, color, null, null, null, null, null, "justify", null, null, null);//, -fontSize/1.2
				htmlText.text = _data.text;//trace(txt)
				addChild(htmlText);
				return;
			}
			
			rtlText.layoutData = new AnchorLayoutData(0, border*2, NaN, border*2);
			rtlText.elementFormat = new ElementFormat(translateFont, UserModel.instance.fontSize, color);
			rtlText.textAlign = _data.translator.flag.align;
			rtlText.bidiLevel = _data.translator.flag.align=="left"?0:1;
			rtlText.text = (_data.text as String);
			addChild(rtlText);
		}
		
		
	}
}