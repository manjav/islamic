package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.popups.Alert;
	import com.gerantech.islamic.views.screens.FilteredPersonScreen;
	import com.gerantech.islamic.views.screens.IndexScreen;
	import com.gerantech.islamic.views.screens.SearchScreen;
	
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
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
			}
			searchText.prompt = ResourceManager.getInstance().getString("loc", prompt);
			searchText.text = searchPage ? UserModel.instance.searchPatt : "";
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			searchText = new CustomTextInput(SoftKeyboardType.DEFAULT, ReturnKeyLabel.SEARCH);
			//searchText.prompt = ResourceManager.getInstance().getString("loc", "search_in");
			//searchText.text = UserModel.instance.searchPatt;
			searchText.layoutData = new AnchorLayoutData(0,0,0,0);
			searchText.addEventListener(Event.CHANGE, searchInput_changeHandler);
			searchText.addEventListener(FeathersEventType.ENTER, searchInput_enterHandler);
			addChild(searchText);
			
			clearButton = new FlatButton("close_w");
			clearButton.iconScale = 0.6;
			clearButton.addEventListener(Event.TRIGGERED, clearButton_triggerHandler);
			//clearButton.layoutData = new AnchorLayoutData(0, AppModel.instance.leftDrawer?NaN:0, 0, AppModel.instance.leftDrawer?0:NaN)
			addChild(clearButton);
			searchInput_changeHandler();
		}
		
		private function searchInput_changeHandler():void
		{
//			searchTimeoutId = setTimeout(startSearch, 500, searchText.text)
			changeHeader(searchText.text.length>0);
			switch(AppModel.instance.navigator.activeScreenID)
			{
				case AppModel.instance.PAGE_SEARCH: 
					SearchScreen(AppModel.instance.navigator.activeScreen).updateSuggests(StrTools.getSimpleString(searchText.text).toLowerCase()); 
					break;
				case AppModel.instance.PAGE_INDEX: 
					IndexScreen(AppModel.instance.navigator.activeScreen).startSearch(StrTools.getSimpleString(searchText.text).toLowerCase()); 
					break;
				case AppModel.instance.PAGE_FILTERED: 
					FilteredPersonScreen(AppModel.instance.navigator.activeScreen).startSearch(searchText.text); 
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
			if(searchText.text.length<2)
			{
				new Alert(this, ResourceManager.getInstance().getString("loc", "search_error"));
				return;
			}
			UserModel.instance.searchPatt = StrTools.getSimpleString(searchText.text).toLowerCase();//, userModel.translator.flag.path
			SearchScreen(AppModel.instance.navigator.activeScreen).startSearch();
			//	dispatchEventWith("searchStarted");
		}
	}
}