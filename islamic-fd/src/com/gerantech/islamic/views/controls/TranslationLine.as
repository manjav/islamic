package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.core.ITextRenderer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class TranslationLine extends LayoutGroup
	{
		public var label:ITextRenderer;
		public var translator:Translator;
		
		private var icon:ImageLoader;
		private var _aya:Aya;
		private var textBlock:RTLLabel;
		
		private var hLayout:HorizontalLayout;
		private var textField:LTRLable;

		private var newLine:int;
		private var isHtml:Boolean;
		private var _limitMode:Boolean;
		
		public function TranslationLine(translator:Translator)
		{
			this.translator = translator;
			height = UserModel.instance.fontSize*2;
			_isEnabled = !UserModel.instance.premiumMode && !translator.free;
			
			hLayout = new HorizontalLayout();
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			hLayout.gap = UserModel.instance.fontSize;
			layout = hLayout;
			
			isHtml = translator.path=="en.transliteration";

			
			if(!isHtml)
			{
				textBlock = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, translator.flag.align, translator.flag.dir, false, null, UserModel.instance.fontSize);
				//textBlock.truncateToFit = false
				textBlock.layoutData = new HorizontalLayoutData(100);
				addChild(textBlock);
				label = textBlock;
			}
			addIcon();
			if(isHtml)
			{
				textField = new LTRLable("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "justify");
				textField.isHTML = true;
				textField.layoutData = new HorizontalLayoutData(100, 100);
				addChild(textField);
				label = textField;
			}
			label.alpha = 0;
			
			UserModel.instance.addEventListener(UserEvent.FONT_SIZE_CHANGE_START, user_fontSizeChangeHandler);
			UserModel.instance.addEventListener(UserEvent.FONT_SIZE_CHANGE_END, user_fontSizeChangeHandler);
		}
		
		public function get limitMode():Boolean
		{
			return _limitMode;
		}

		public function set limitMode(value:Boolean):void
		{
			if(_limitMode==value)
				return;
			
			_limitMode = value;
			if(!isHtml)
				textBlock.elementFormat = new ElementFormat(textBlock.fontDescription, UserModel.instance.fontSize, _limitMode?0xFF0000:BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			else
				textField.textFormat = new TextFormat("SourceSans", UserModel.instance.fontSize, _limitMode?0xFF0000:BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, null, null, null, "justify", null, null);//, -fontSize/1.2
		}

		private function addIcon():void
		{
			icon = new ImageLoader();
			icon.width = icon.height = uint(UserModel.instance.fontSize*2);
			icon.delayTextureCreation = true;
			addChild(icon);
			if(translator.iconTexture==null)
			{
				translator.loadImage();
				translator.addEventListener(Person.ICON_LOADED, iconLoaded);
			}
			else
				icon.source = translator.iconTexture;
		}
		
		private function iconLoaded(event:Event):void
		{
			translator.removeEventListener(Person.ICON_LOADED, iconLoaded);
			icon.source = translator.iconTexture;
		}
		
		public function get aya():Aya
		{
			return _aya;
		}
		public function set aya(value:Aya):void
		{
			_aya = value;
			limitMode = _isEnabled && _aya.sura>2;
			if(limitMode)
			{
				label.text = ResourceManager.getInstance().getString("loc", "purchase_translate", null, translator.flag.dir=="rtl"?"fa_IR":"en_US"); 
				showLabel();
				return;
			}
			
			if(translator.loadingState!=Translator.L_LOADED)
			{
				translator.load();
				translator.addEventListener(Person.LOADING_COMPLETE, translationLoaded);
				translator.addEventListener(Person.LOADING_ERROR, translationErrorHandler);
				return;
			}
			
			translator.getAyaText(_aya, textResponder);
		}
		
		private function textResponder(txt:String):void
		{
			if(txt.indexOf("#")>-1)
			{
				txt = "تفسیر این آیه، در آیه یا آیات قبلی بصورت یکجا آمده است.";
				textBlock.text = txt;
				newLine = 1;
				showLabel();
				return ;
			}
			txt = (translator.path=="fa.gharaati") ? StrTools.getRepTranslate(txt) : txt;
			//txt = txt.replace(/[\u000d\u000a\u0008]+/g,""); 
			newLine = Math.min(txt.indexOf("\n")-1, UserModel.instance.fontSize*(AppModel.instance.sizes.isTablet?10:6));
			if(newLine>0)
				txt = txt.substr(0, newLine) + " ...";
			
			if(!isHtml)
				textBlock.text = txt;
			else
				textField.text = txt;//trace(txt)
			showLabel();
		}

		
		private function translationErrorHandler():void
		{
			label.text = translator.flag.dir=="rtl" ? ResourceManager.getInstance().getString("loc", "translation_error") : "Nerwork error";
			showLabel();
		}
		
		private function showLabel():void
		{
			label.visible = true;
			label.alpha = 0;
			Starling.juggler.tween(label, 1.5, {alpha:1});
			//TweenLite.to(label, 1.5, {alpha:1});
		}
		
		private function translationLoaded(event:Event):void
		{
			translator.removeEventListener(Person.LOADING_COMPLETE, translationLoaded);
			aya = _aya;
		}
		
		public function get isTruncated():Boolean
		{
			if(newLine>0)
				return true;
			return label["isTruncated"];
		}
		
		private function user_fontSizeChangeHandler(event:Event):void
		{
			if(event.type==UserEvent.FONT_SIZE_CHANGE_START)
			{
				label.alpha = 0;
				return;
			}
			
			if(textField)
				textField.textFormat = new TextFormat("SourceSans", UserModel.instance.fontSize, BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, null, null, null, "justify", null, null, 0);
			
			if(textBlock)
			{
				textBlock.elementFormat = new ElementFormat(textBlock.fontDescription, uint(UserModel.instance.fontSize), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
				height = uint(UserModel.instance.fontSize*2);
			}
			label.alpha = 1;
			icon.width = icon.height = uint(UserModel.instance.fontSize*2.4);
			
			hLayout.gap = UserModel.instance.fontSize;
		}
		
	}
}
