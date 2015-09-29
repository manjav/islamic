package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.lists.TranslatorPickerList;
	import com.gerantech.islamic.views.popups.SearchSettingPopup;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.core.PopUpManager;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class SearchSubtitle extends BaseSubtitle
	{
		private var translatorImage:ImageLoader;
		private var titleLabel:RTLLabel;
		private var descriptionLabel:RTLLabel;
		private var resultLabel:RTLLabel;
		private var actionButton:FlatButton;
		public var translatorSelector:TranslatorPickerList;
		private var _result:String;

		private var overlay:FlatButton;

		private var searchPopUp:SearchSettingPopup;
		
		public function SearchSubtitle()
		{
			super();
			height = _height = AppModel.instance.sizes.twoLineItem;
		}
		
		public function set result(value:String):void
		{
			if(_result==value)
				return;
			
			_result = value;
			resultLabel.text = _result;
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
			
			translatorImage = new ImageLoader();
			translatorImage.layoutData = new AnchorLayoutData(border, NaN, _height/2, border);
			addChild(translatorImage);
			
			var translatorLayout:LayoutGroup = new LayoutGroup();
			translatorLayout.layout = new VerticalLayout();
			translatorLayout.layoutData = new AnchorLayoutData(border, border, _height/2, border+_height/2);
			addChild(translatorLayout);
			
			titleLabel = new RTLLabel("", 1, "left", null, false, null, 0.9);
			titleLabel.layoutData = new VerticalLayoutData(100, 60);
			translatorLayout.addChild(titleLabel);
			
			descriptionLabel = new RTLLabel("جستجو در متن قرآن کریم", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "left", null, false, null, 0.84);
			descriptionLabel.layoutData = new VerticalLayoutData(100, 60);
			translatorLayout.addChild(descriptionLabel);
			
			resultLabel = new RTLLabel("جستجو در این بخش صورت میگیرد", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", null, true, null, 0.8);
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

			translatorSelector = new TranslatorPickerList();
			translatorSelector.addEventListener(Event.CHANGE, translatorSelector_changeHandler);
			addChild(translatorSelector); 
			
			translatorSelector_changeHandler(null);
		}
		
		private function translatorSelector_changeHandler(event:Event):void
		{
			if(translatorSelector.selectedItem==null)
				return;
			
			titleLabel.text = translatorSelector.selectedItem.name;
			translatorImage.source = translatorSelector.selectedItem.icon;
		}
		
		private function actionButton_triggerd():void
		{
			searchPopUp = new SearchSettingPopup();
			searchPopUp.addEventListener(Event.CLOSE, searchPopUp_closeHandler);
			PopUpManager.overlayFactory = function():DisplayObject
			{
				overlay = new FlatButton(null, null, true, 0.3, 0.3, 0);
				overlay.addEventListener(Event.TRIGGERED, searchPopUp.close);
				return overlay;
			};
			PopUpManager.addPopUp(searchPopUp);
		}		
		
		private function searchPopUp_closeHandler():void
		{
			overlay.removeEventListener(Event.TRIGGERED, searchPopUp.close);
			searchPopUp.removeEventListener(Event.CLOSE, searchPopUp_closeHandler);
			if(PopUpManager.isPopUp(searchPopUp))
				PopUpManager.removePopUp(searchPopUp);
		}
		
	}
}