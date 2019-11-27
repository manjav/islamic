package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.screens.CityScreen;
	import com.gerantech.islamic.views.screens.FilteredPersonScreen;
	import com.gerantech.islamic.views.screens.IndexScreen;
	import com.gerantech.islamic.views.screens.SearchScreen;

	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;

	import gt.utils.Localizations;

	import starling.core.Starling;
	import starling.events.Event;
	
	public class SearchInput extends LayoutGroup
	{
		private var clearButton:FlatButton;
		private var searchText:CustomTextInput;
		
		public function SearchInput()
		{
			super();
		}
		
		public function get searchPage():Boolean
		{
			return AppModel.instance.navigator.activeScreenID==AppModel.instance.PAGE_SEARCH;
		}
		
		public function updateData():void
		{
			if(searchText==null)
				return;
			
			var prompt:String;
			switch(AppModel.instance.navigator.activeScreenID)
			{
				case AppModel.instance.PAGE_SEARCH: prompt="search_in"; break;
				case AppModel.instance.PAGE_INDEX: prompt="index_search"; break;
				case AppModel.instance.PAGE_FILTERED: prompt="search_in"; break;
				case AppModel.instance.PAGE_CITY: prompt="city_prompt"; break;
			}
			searchText.prompt = Localizations.instance.get(prompt);
			searchText.text = searchPage ? UserModel.instance.searchPatt : "";
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			searchText = new CustomTextInput(SoftKeyboardType.DEFAULT, ReturnKeyLabel.SEARCH);
			//searchText.prompt = Localizations.instance.get("search_in");
			//searchText.text = UserModel.instance.searchPatt;
			searchText.layoutData = new AnchorLayoutData(0,0,0,0);
			searchText.addEventListener(Event.CHANGE, searchInput_changeHandler);
			searchText.addEventListener(FeathersEventType.ENTER, searchInput_enterHandler);
			addChild(searchText);
			
			clearButton = new FlatButton("close_w");
			clearButton.iconScale = 0.3;
			clearButton.addEventListener(Event.TRIGGERED, clearButton_triggerHandler);
			clearButton.layoutData = new AnchorLayoutData(0, AppModel.instance.ltr?0:NaN, 0, AppModel.instance.ltr?NaN:0);
			addChild(clearButton);
			searchInput_changeHandler(null);
			
			updateData();
			//AppModel.instance.navigator.addEventListener(Event.CHANGE, navigator_changeHandler);
		}
		
		private function navigator_changeHandler():void
		{
			updateData();
		}
		
		private function searchInput_changeHandler(event:Event):void
		{
//			searchTimeoutId = setTimeout(startSearch, 500, searchText.text)
			changeHeader(searchText.text.length>0);
			switch(AppModel.instance.navigator.activeScreenID)
			{
				case AppModel.instance.PAGE_SEARCH: 
					SearchScreen(AppModel.instance.navigator.activeScreen).updateSuggests(searchText.text); 
					break;
				case AppModel.instance.PAGE_INDEX: 
					IndexScreen(AppModel.instance.navigator.activeScreen).startSearch(searchText.text); 
					break;
				case AppModel.instance.PAGE_FILTERED: 
					FilteredPersonScreen(AppModel.instance.navigator.activeScreen).startSearch(searchText.text); 
					break;
				case AppModel.instance.PAGE_CITY: 
					CityScreen(AppModel.instance.navigator.activeScreen).startSearch(searchText.text); 
					break;
			}

		}
		
		private function changeHeader(hasText:Boolean):void
		{
			clearButton.visible = hasText;
		}
		
		private function clearButton_triggerHandler():void
		{
			searchText.text = "";
		}
		
		private function searchInput_enterHandler():void
		{
			if(!searchPage)
				return;

			SearchScreen(AppModel.instance.navigator.activeScreen).startSearch(searchText.text);
			Starling.current.nativeStage.focus = null;
		}
	}
}