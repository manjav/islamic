package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.popups.SearchSettingPopup;
	
	import flash.text.engine.ElementFormat;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class SearchSubtitle extends BaseSubtitle
	{
		private var translatorImage:ImageLoader;
		private var titleLabel:RTLLabel;
		private var descriptionLabel:RTLLabel;
		private var resultLabel:RTLLabel;
		private var actionButton:FlatButton;
		private var _result:String;
		
		public function SearchSubtitle()
		{
			super();
			height = _height = AppModel.instance.sizes.twoLineItem;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			var border:uint = appModel.sizes.DP8;
			
			var shadowUp:LayoutGroup = new LayoutGroup();
			shadowUp.backgroundSkin = new Image(Assets.getTexture("shadow"));
			shadowUp.height = border/2;
			shadowUp.layoutData = new AnchorLayoutData(NaN, 0, -border/2, 0);
			addChild(shadowUp);
			
			var bg:LayoutGroup = new LayoutGroup();
			bg.layoutData = new AnchorLayoutData(0, 0, _height*0.4, 0);
			bg.backgroundSkin = new Quad(1,1,BaseMaterialTheme.CHROME_COLOR);
			bg.alpha = 0.5;
			addChild(bg);
			
			translatorImage = new ImageLoader();
			translatorImage.layoutData = new AnchorLayoutData(border, NaN, _height/2, border);
			addChild(translatorImage);
			
			titleLabel = new RTLLabel("", 1, "center", null, true, "center", 0.85);
			titleLabel.layoutData = new AnchorLayoutData(NaN, border, NaN, border+_height/2, NaN, -_height/4.6);
			addChild(titleLabel);
			
			resultLabel = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", null, true, null, 0.8);
			resultLabel.layoutData = new AnchorLayoutData(NaN, _height, border, border);
			resultLabel.maxHeight = _height/2;
			addChild(resultLabel);
			
			actionButton = new FlatButton("pencil_white", "action_accent", false, 1, 0.8);
			actionButton.iconScale = 0.4;
			actionButton.width = actionButton.height = appModel.sizes.toolbar;
			actionButton.pivotY = actionButton.pivotX = actionButton.width/2;
			actionButton.filter = BlurFilter.createDropShadow(border/8, 90*(Math.PI/180), 0, 0.6, border/16);
			actionButton.addEventListener(Event.TRIGGERED, actionButton_triggerd);
			actionButton.layoutData = new AnchorLayoutData(NaN, border*2, -appModel.sizes.toolbar/2, NaN);
			addChild(actionButton);
			
			var q:Translator = new Translator();
			q.name = ResourceManager.getInstance().getString("loc", "quran_t");
			q.iconUrl = "app:/com/gerantech/islamic/assets/images/icon/icon-192.png";
			q.iconPath = userModel.TRANSLATOR_PATH + "quran/quran.pbqr";

			ConfigModel.instance.searchSources = new Array(q);
			for each(var p:Person in ConfigModel.instance.selectedTranslators)
				ConfigModel.instance.searchSources.push(p);
			
			if(userModel.searchSource>ConfigModel.instance.searchSources.length-1)
				userModel.searchSource = 0;
				
			updateElements();
		}

		
		private function actionButton_triggerd():void
		{
			AppController.instance.addPopup(SearchSettingPopup, searchPopUp_closeCallback);
		}		
		private function searchPopUp_closeCallback():void
		{
			updateElements();
			dispatchEventWith(Event.CHANGE);
		}
		
		private function updateElements():void
		{
			var obj:Translator  = ConfigModel.instance.searchSources[userModel.searchSource];
			translatorImage.source = obj.iconTexture;
			var des:String = loc("search_set_source") + ": " + obj.name + " - ";
			
			des += loc("search_set_scope") + ": ";
			if(userModel.searchScope==1)
				des += loc("sura_l") + " " + (appModel.ltr ? ResourceModel.instance.suraList[userModel.searchSura].tname : ResourceModel.instance.suraList[userModel.searchSura].name);
			else if(userModel.searchScope==2)
				des += loc("juze_l") + " " + loc("j_"+(userModel.searchJuze+1));
			else
				des += loc("search_set_scope_0");
			
			titleLabel.text = des;
		}
		
		public function log(value:String, color:uint=0):void
		{
			if(_result==value)
				return;
			
			_result = value;
			if(resultLabel.color!=color)
				resultLabel.elementFormat = new ElementFormat(resultLabel.fontDescription, resultLabel.fontSize, color);
			resultLabel.text = _result;	
		}
	}
}