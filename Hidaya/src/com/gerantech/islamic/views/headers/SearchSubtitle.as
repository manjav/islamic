package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.lists.TranslatorPickerList;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
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
		private var translatorSelector:TranslatorPickerList;
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
			

			
			translatorImage = new ImageLoader();
			translatorImage.layoutData = new AnchorLayoutData(border, NaN, _height/2, border);
			translatorImage.source = "app:/com/gerantech/islamic/assets/images/icon/icon-192.png";
			addChild(translatorImage);
			
			var translatorLayout:LayoutGroup = new LayoutGroup();
			translatorLayout.layout = new VerticalLayout();
			translatorLayout.layoutData = new AnchorLayoutData(border, border, _height/2, border+_height/2);
			addChild(translatorLayout);
			
			titleLabel = new RTLLabel("asd", 1, "left");
			titleLabel.layoutData = new VerticalLayoutData(100, 60);
			translatorLayout.addChild(titleLabel);
			
			descriptionLabel = new RTLLabel("asd dfd", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "left", null, false, null, 0.92);
			descriptionLabel.layoutData = new VerticalLayoutData(100, 60);
			translatorLayout.addChild(descriptionLabel);
			
			resultLabel = new RTLLabel("asd dfda d dfd", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", null, true, null, 0.86);
			resultLabel.layoutData = new AnchorLayoutData(NaN, _height, border, border);
			resultLabel.maxHeight = _height/2;
			addChild(resultLabel);
			
			actionButton = new FlatButton("action_plus", "action_player", false, 1, 0.8);
			actionButton.iconScale = 0.3;
			actionButton.width = actionButton.height = appModel.sizes.toolbar;
			actionButton.pivotY = actionButton.pivotX = actionButton.width/2;
			actionButton.filter = BlurFilter.createDropShadow(border/4, 90*(Math.PI/180), 0, 0.4, border/6);
			actionButton.addEventListener(Event.TRIGGERED, actionButton_triggerd);
			actionButton.layoutData = new AnchorLayoutData(NaN, border*2, -appModel.sizes.toolbar/2, NaN);
			addChild(actionButton);

			translatorSelector = new TranslatorPickerList();
			translatorSelector.buttonProperties.visible = false;
			addChild(translatorSelector); 
		}
		
		private function actionButton_triggerd():void
		{
			translatorSelector.openList();
		}		
		
	}
}