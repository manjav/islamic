package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.Devider;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.TranslationLine;
	import com.gerantech.islamic.views.headers.BismHeader;
	import com.gerantech.islamic.views.headers.ToolsList;
	
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	import feathers.skins.ImageSkin;
	
	import starling.core.Starling;
	import starling.events.Event;
	import feathers.layout.HorizontalAlign;
	
	public class AyaItemRenderer extends BaseCustomItemRenderer
	{
		public var aya:Aya;
		private var translations:Vector.<TranslationLine>;

		private var bismHeader:BismHeader;
		private var toolsList:ToolsList;
		private var translatIndex:int;
		private var fastTimeout:uint;

		private var vLayout:VerticalLayout;
		private var quranTextRenderer:RTLLabel;
		//private var hasMore:Boolean = true;
		private var hasTranslation:Boolean;

		private var devider:Devider;
		private var moreStrip:SimpleLayoutButton;
		private var reservedFontSize:uint;

		override protected function initialize():void
		{
			super.initialize();
			
			skin = new ImageSkin(Assets.getCardTextures(STATE_NORMAL));
			skin.setTextureForState( STATE_NORMAL, Assets.getCardTextures(STATE_NORMAL) );
			skin.setTextureForState( STATE_SELECTED, Assets.getCardTextures(STATE_SELECTED) );
			skin.setTextureForState( STATE_DOWN, Assets.getCardTextures(STATE_DOWN) );
			skin.scale9Grid = new Rectangle(skin.width/2-1, skin.height/2-1, 2, 2);
			backgroundSkin = skin;
			
			hasTranslation = ResourceModel.instance.hasTranslator;
			deleyCommit = true;
			
			userModel.addEventListener(UserEvent.FONT_SIZE_CHANGE_START, user_fontSizeChangeHandler);
			userModel.addEventListener(UserEvent.FONT_SIZE_CHANGING, user_fontSizeChangeHandler);
			userModel.addEventListener(UserEvent.FONT_SIZE_CHANGE_END, user_fontSizeChangeHandler);
			
			vLayout = new VerticalLayout();
			vLayout.gap = Math.round(Math.min(appModel.sizes.border*3, userModel.fontSize*1.2))*0.7; 
			vLayout.paddingTop = vLayout.paddingRight = vLayout.paddingLeft = vLayout.gap*3;
			vLayout.horizontalAlign = HorizontalAlign.CENTER;
			vLayout.paddingBottom = vLayout.gap*2;
			layout = vLayout
			
			toolsList = new ToolsList();
			toolsList.height = appModel.sizes.DP36;
			toolsList.layoutData = new VerticalLayoutData(100);
			addChild(toolsList);
			
			bismHeader = new BismHeader();
			bismHeader.layoutData = new VerticalLayoutData(100);
						
			quranTextRenderer = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, "justify", "rtl", true, "center", userModel.fontSize*1.3*userModel.font.scale, userModel.font.value);
			quranTextRenderer.layoutData = new VerticalLayoutData(100);
			addChild(quranTextRenderer);
			
			if(!hasTranslation)
				return;
				
			devider = new Devider(BaseMaterialTheme.CHROME_COLOR, Math.ceil(userModel.fontSize/14));
			devider.layoutData = new VerticalLayoutData(60);
			addChild(devider);
			
			translations = new Vector.<TranslationLine>();
			var len:uint = Math.min(2, ResourceModel.instance.selectedTranslators.length);
			for (var i:uint; i<len; i++)
			{
				var ttr:TranslationLine = new TranslationLine(ResourceModel.instance.selectedTranslators[i]);
				ttr.layoutData = new VerticalLayoutData(100);
				translations.push(ttr);
				addChild(ttr);
			}
			
			moreStrip = new SimpleLayoutButton();
			moreStrip.layoutData = new VerticalLayoutData(100)
			moreStrip.addEventListener(Event.TRIGGERED, moreStrip_triggeredHandler);
			moreStrip.height = appModel.sizes.singleLineItem/2;
			addChild(moreStrip);
			
			var moreStripImage:ImageLoader = new ImageLoader();
			moreStripImage.source =  Assets.getTexture("chevron_g");
			moreStrip.backgroundSkin = moreStripImage;
			
			FAST_COMMIT_TIMEOUT = 0;
		}

		
		private function moreStrip_triggeredHandler():void
		{
			_owner.dispatchEventWith(Event.SELECT, false, this);
		}
		
		override protected function commitData():void
		{
			if(_data && _owner)
			{
				if(aya==_data)
					return;

				backgroundSkin.height = 10;
				aya = _data as Aya;
				
				clearTimeout(fastTimeout);
				fastTimeout = setTimeout(fastCommit, FAST_COMMIT_TIMEOUT);
			}
			super.commitData();
		}
		
		private function fastCommit():void
		{
			aya.bookmarked = userModel.bookmarks.exist(aya)>-1;
			if(aya.hasBism)
			{
				//bismHeader.aya = aya;
				addChildAt(bismHeader, 1);
			}
			else
				bismHeader.removeFromParent();
			
			toolsList.setData(aya, currentState==STATE_SELECTED);
			
			if(reservedFontSize != userModel.fontSize)
				quranTextRenderer.elementFormat = new ElementFormat(quranTextRenderer.fontDescription, uint(userModel.fontSize*1.3*userModel.font.scale), BaseMaterialTheme.PRIMARY_TEXT_COLOR);

			//quranTextRenderer.alpha = 0.1;
			if(aya.text==null)
				aya.text = ResourceModel.instance.quranXML.sura[aya.sura-1].aya[aya.index].@text;
			quranTextRenderer.text = aya.text;//trace(aya.text)
			
			//(aya.aya==1?(aya.aya + " . "):"") + 	
			if(!hasTranslation)
			{
				vLayout.paddingBottom = vLayout.gap*2 + (aya.isLastItem? appModel.sizes.twoLineItem/3 : 0);
				return;
			}
			/*if(moreStrip.parent == this)
				moreStrip.removeFromParent();
*/
			for each (var t:TranslationLine in translations) 
				t.label.visible = false;
			
			//hasMore = true;// ConfigModel.instance.selectedTranslators.length>2;
			moreStrip.visible = false;
			moreStrip.alpha = 0;
		}
	
		override protected function commitBeforeStopScrolling():void
		{
			if(!hasTranslation)
				return;
			
			moreStrip.visible = true;
			Starling.juggler.tween(moreStrip, 0.5, {delay:0.5, alpha:1});
			
			translatIndex = 0;
			setTimeout(setNextTranslation, FAST_COMMIT_TIMEOUT);
		}
		
		
		private function setNextTranslation():void
		{
			if(translatIndex<translations.length)
			{
				translations[translatIndex].aya = aya;
				setTimeout(checkHasMore, FAST_COMMIT_TIMEOUT, translations[translatIndex]);
			}
			else
			{
				/*if(hasMore)
				{*/
				vLayout.paddingBottom = vLayout.gap*2;
				//addChild(moreStrip);
				//moreStrip.visible = true;
				/*}
				else
				vLayout.paddingBottom = vLayout.gap*2 + (aya.isLastItem? appModel.sizes.itemHeight/2 : 0);*/
			}
		}
		
		private function checkHasMore(str:TranslationLine):void
		{
			//if(!hasMore)
			//	hasMore = str.isTruncated;
			
			translatIndex ++;
			setTimeout(setNextTranslation, FAST_COMMIT_TIMEOUT);
		}		
		
		private function user_fontSizeChangeHandler(event:Event):void
		{
			if(hasTranslation && event.type==UserEvent.FONT_SIZE_CHANGE_START)
			{
				//moreStrip.removeFromParent();
				moreStrip.visible = false;
				return;
			}
			
			if(isShow && reservedFontSize!=userModel.fontSize)
			{
				quranTextRenderer.elementFormat = new ElementFormat(quranTextRenderer.fontDescription, uint(userModel.fontSize*1.3*userModel.font.scale), BaseMaterialTheme.PRIMARY_TEXT_COLOR);
				reservedFontSize = userModel.fontSize;
			}
			
			if(event.type==UserEvent.FONT_SIZE_CHANGE_END)
			{
				vLayout.gap = Math.round(Math.min(appModel.sizes.border*3, userModel.fontSize*1.2))*0.7;
				moreStrip.visible = true;
				//setTimeout(setNextTranslation, FAST_COMMIT_TIMEOUT);
			}		
		}
		
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			if(value == lastState)
				return;
			
			skin.defaultTexture = skin.getTextureForState(value);
			//backgroundSkin = new Scale9Image(Assets.getItemTextures(value));//||value==STATE_SELECTED
			if(value != STATE_DOWN)
				toolsList.setData(aya, value==STATE_SELECTED);
		}	

	}
}