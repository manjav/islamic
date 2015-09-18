package com.gerantech.islamic.views.items
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class TranslationPageItemRenderer extends BasePageItemRenderer
	{
		private var waitingLabel:RTLLabel;
		private var listLayout:VerticalLayout;
		private var list:List;
		private var translatorIndex:uint;
		private var translations:Array;
		private var aya:Aya;
		private var setItemTimoutID:uint;
		private var isFirstCommit:Boolean = true;
		private var startScrollBarIndicator:Number = 0;

		private var currentTranslator:Translator;
		
		
		public function TranslationPageItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			waitingLabel = new RTLLabel(loc("translation_waiting"), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			waitingLabel.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN,0,0);
			waitingLabel.visible = false
			addChild(waitingLabel);
			
			listLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.padding = appModel.sizes.border*2;
			listLayout.paddingBottom = ConfigModel.instance.hasReciter?appModel.sizes.toolbar*1.5+appModel.sizes.border:appModel.sizes.border
			listLayout.hasVariableItemDimensions = true;
			listLayout.useVirtualLayout = true;
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TranslationItemRenderer ();
			};
			//list.addEventListener(Event.SCROLL, list_scrollHandler);
			list.isQuickHitAreaEnabled = true;
			list.visible = false;
			addChild(list);
		}
		
		private function list_scrollHandler():void
		{
			var scrollPos:Number = Math.max(0,list.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			startScrollBarIndicator = scrollPos;
			//trace(changes)
			if(ConfigModel.instance.hasReciter)
			{
				Player.instance.dispatchEventWith(Player.APPEARANCE_CHANGED, false, changes);
/*				if(changes>1)
					SoundPlayer.instance.show();
				else if(changes<-1)
					SoundPlayer.instance.hide();
*/			}
		}
		
		private function _owner_scrollCompleteHandler():void
		{
			if(!isShow || aya==null)
				return;
			
			_owner.dispatchEventWith("translateChanged", false, aya);
		}

		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			if(aya && (aya.sura==_data.sura && aya.aya==_data.aya))
				return;
			

			super.commitData();
			aya = _data as Aya;
			waitingLabel.visible = true;
			list.visible = false;
			list.scrollToPosition(0, 0, 0);
			
			listLayout.paddingTop = appModel.sizes.toolbar*( aya.hasBism ? 1.5 : 1.2);
		}
		
		override protected function commitAfterStopScrolling():void
		{
			super.commitAfterStopScrolling();
			Flurry.getInstance().logEvent("TurnTranslationPage", {sura:aya.sura, aya:aya.aya});
			
			if(isFirstCommit)
				_owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, _owner_scrollCompleteHandler);
			isFirstCommit = false;
			
			translations = new Array();
			translations.push(aya);
			
			translatorIndex = 0;
			addTranslationText();
		}
		
		private function addTranslationText():void
		{
			if (translatorIndex<ConfigModel.instance.selectedTranslators.length)
				loadTranslator();
			else
			{
				waitingLabel.visible = false;
				list.visible = true;
				list.dataProvider = new ListCollection(translations);
				//list.validate();
			}
		}
		
		private function loadTranslator():void
		{
			currentTranslator = ConfigModel.instance.selectedTranslators[translatorIndex];
			currentTranslator.removeEventListener(Person.TRANSLATION_LOADED, loadTranslator);
			currentTranslator.removeEventListener(Person.TRANSLATION_ERROR, translationErrorHandler);
			
			if(currentTranslator.loadingState!=Translator.L_LOADED)
			{
				currentTranslator.loadTransltaion();
				currentTranslator.addEventListener(Person.TRANSLATION_LOADED, loadTranslator);
				currentTranslator.addEventListener(Person.TRANSLATION_ERROR, translationErrorHandler);
				return;
			}
			translations.push(currentTranslator);
			
			if(!userModel.premiumMode && !currentTranslator.free && aya.sura>2)
			{
				var txt:String = loc("purchase_translate_long", null, currentTranslator.flag.dir=="ltr"?"en_US":"fa_IR")
				translations.push({text:txt, translator:currentTranslator, aya:aya});
				translatorIndex ++;
				addTranslationText();
				return;
			}
			
			//Query for get aya translation from person .
			currentTranslator.getAyaText(aya, ayaTextReciever);
		}

		
		private function ayaTextReciever(txt:String):void
		{
			if(txt.indexOf("#")>-1)
			{
				txt = "تفسیر این آیه، در آیه یا آیات قبلی بصورت یکجا آمده است.";
				//var num:uint = uint(txt.split("#")[1]);
				//return getText(translator, sura, num-1);
				addToTranslations([txt]);
				gotoNextTranslator()
				return ;
			}
			txt = (currentTranslator.path=="fa.gharaati") ? StrTools.getRepTranslate(txt) : txt;
			txt = txt.replace(/[\u000d\u000a\u0008]+/g,"  "); 
			//txt = txt.split("* * *").join("* * *.");
			
			var textList:Array = StrTools.getNumberFromLocale(txt, currentTranslator.flag.dir).split(".");
			addToTranslations(textList);
			gotoNextTranslator()
		}
		
		private function gotoNextTranslator():void
		{
			translatorIndex ++;
			addTranslationText();
		}
		
		private function addToTranslations(textList:Array):void
		{
			var textTemp:String = "";
			for each(var t:String in textList)
			{
				switch(t)
				{
					case " ":
					case ". \n":
					case ".\n":
					case ". ":
					case "":						
						break;
					
					default:
						if(textTemp.length<userModel.fontSize*(appModel.isTablet?20:10))
							textTemp += (t+".");
						else
						{
							translations.push({text:textTemp, translator:currentTranslator, aya:aya});
							textTemp = (t+".");
						}
						break;
				}
			}
			if(textTemp!="")
				translations.push({text:textTemp, translator:currentTranslator, aya:aya});	
		}
		
		
		private function translationErrorHandler(event:Event):void
		{
			var translator:Person = Person(event.currentTarget)
			translator.removeEventListener(Person.TRANSLATION_LOADED, loadTranslator);
			translator.removeEventListener(Person.TRANSLATION_ERROR, translationErrorHandler);
			
			translations.push(translator);
			translations.push({text:(translator.flag.dir=="rtl" ? loc("translation_error") : "Nerwork error")+"\n", translator:translator, aya:aya});
			translatorIndex ++;
			addTranslationText();
		}
							
	}
}