package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.items.TranslationItemRenderer;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	import gt.utils.Localizations;
	
	public class TranslationList extends LayoutGroup
	{
		private var headerHeight:Number;
		private var appModel:AppModel;
		private var userModel:UserModel;
		private var _page:Page;
		
		private var waitingLabel:RTLLabel;
		private var listLayout:VerticalLayout;
		private var list:List;
		private var translations:Array;
		private var translatorIndex:int;

		private var currentTranslator:Translator;
		
		public function TranslationList(headerHeight:Number = 30)
		{
			super();
			this.headerHeight = headerHeight;
			
			//autoSizeMode = AutoSizeMode.STAGE;
			
			appModel = AppModel.instance;
			userModel = UserModel.instance;
			
			layout = new AnchorLayout();
			//backgroundSkin = new Quad(1,1);
			//backgroundSkin.visible = false
			//elasticity = 0.05;
			//decelerationRate = 0.8;

			waitingLabel = new RTLLabel(loc("translation_waiting"), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			waitingLabel.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN,0,0);
			waitingLabel.visible = false
			addChild(waitingLabel);
			
			listLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.padding = appModel.sizes.border*2;
			listLayout.paddingTop = headerHeight;
			listLayout.paddingBottom = ResourceModel.instance.hasReciter?appModel.sizes.toolbar*1.5+appModel.sizes.border:appModel.sizes.border
			listLayout.hasVariableItemDimensions = true;
			listLayout.useVirtualLayout = true;
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TranslationItemRenderer ();
			}
			list.visible = false;
			addChild(list);
		}
		
		public function get page():Page
		{
			return _page;
		}
		public function set page(value:Page):void
		{
			if(value==null || _page==value)
				return;
			
			_page = value;
			
			waitingLabel.visible = true;
			list.scrollToPosition(0,0,0);
			list.visible = false;
			
			translations = new Array();
			translatorIndex = 0;
			addTranslationText();
		}
		
		private function addTranslationText():void
		{
			if (translatorIndex<ResourceModel.instance.selectedTranslators.length)
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
			currentTranslator = ResourceModel.instance.selectedTranslators[translatorIndex];
			currentTranslator.removeEventListener(Person.LOADING_COMPLETE, loadTranslator);
			currentTranslator.removeEventListener(Person.LOADING_ERROR, translationErrorHandler);
			
			if(currentTranslator.loadingState!=Translator.L_LOADED)
			{
				currentTranslator.load();
				currentTranslator.addEventListener(Person.LOADING_COMPLETE, loadTranslator);
				currentTranslator.addEventListener(Person.LOADING_ERROR, translationErrorHandler);
				return;
			}
			translations.push(currentTranslator);
			
			if(!userModel.premiumMode && !currentTranslator.free && page.sura>2)
			{
				var txt:String = loc("purchase_translate_long", null, currentTranslator.flag.dir=="ltr"?"en_US":"fa_IR")
				translations.push({text:txt, translator:currentTranslator, aya:page.ayas[0]});
				gotoNextTranslator();
				return;
			}
			
			//Query for get aya translation from person .
			currentTranslator.getAyas(page.ayas, ayaTextReciever);
		}
		
		private function ayaTextReciever(txts:Array):void
		{
			var a:String = "";
			var t:String = "";
			for (var i:uint=0; i<txts.length; i++)
			{
				a = " {{ "+StrTools.getNumberFromLocale(page.ayas[i].aya, currentTranslator.flag.dir) + " }}  ";
				t =  a + (txts[i] + "  ");
				
				if(t.indexOf("#")>-1)
					t = a + "تفسیر این آیه، در آیه یا آیات قبلی بصورت یکجا آمده است.";
				else
				{
					t = (currentTranslator.path=="fa.gharaati") ? StrTools.getRepTranslate(t) : t;
					t = t.replace(/[\u000d\u000a\u0008]+/g,""); 
				}
				addToTranslations(t.split("."), currentTranslator);
			}
					
			gotoNextTranslator();
		}
		
		private function gotoNextTranslator():void
		{
			translatorIndex ++;
			addTranslationText();
		}
		
	/*	private function getText(translator:Person):String
		{
			var txt:String = '';
			var t:String;
			var a:String;
			try
			{
				for each(var aya:Aya in page.ayas)
				{
					a = "{"+StrTools.getNumberFromLocale(aya.aya,translator.flag.dir) + "} ";
					t =  a + (translator.xml.sura[aya.sura-1].aya[aya.aya-1].@text + "  ");

					if(t.indexOf("#")>-1)
					{
						t = a + "تفسیر این آیه، در آیه یا آیات قبلی بصورت یکجا آمده است.";
						//var num:uint = uint(t.split("#")[1]);
						//return getText(translator, sura, num-1);
					}
					else
					{
						t = (translator.path=="fa.gharaati") ? StrTools.getRepTranslate(t) : t;
						t = t.replace(/[\u000d\u000a\u0008]+/g,""); 
						//t = t.split("* * *").join("* * *.");
					}
					
					txt += (t+"\n");
				}
			}
			catch(error:Error)
			{
				trace(error.message);
			//	return txt;
			}
			
			return StrTools.getNumberFromLocale(txt, translator.flag.dir);
		}
		*/
		private function addToTranslations(textList:Array, translator:Person):void
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
						if(textTemp.length<appModel.sizes.twoLineItem*10)
							textTemp += t
						else
						{
							translations.push({text:textTemp, translator:translator, aya:page.ayas[0]});
							textTemp = t;
						}
						break;
				}
			}
			if(textTemp!="")
				translations.push({text:textTemp, translator:translator, aya:page.ayas[0]});	
			//translations.push({text:textList.join(" "), translator:translator, aya:page.ayas[0]});
		}
		
		
		private function translationErrorHandler(event:Event):void
		{
			var translator:Person = Person(event.currentTarget)
			translator.removeEventListener(Person.LOADING_COMPLETE, loadTranslator);
			translator.removeEventListener(Person.LOADING_ERROR, translationErrorHandler);
			
			translations.push(translator);
			translations.push({text:(translator.flag.dir=="rtl" ? loc("translation_error") : "Nerwork error")+"\n", translator:translator, aya:page.ayas[0]});
			gotoNextTranslator();
		}
				
		
		private function loc(resourceName:String, parameters:Array=null, locale:String=null):String
		{
			return Localizations.instance.get(resourceName, parameters);//, locale);
		}
	}
}