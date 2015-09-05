package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.models.vo.Word;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.CustomTextInput;
	import com.gerantech.islamic.views.controls.SettingPanel;
	import com.gerantech.islamic.views.items.SearchItemRenderer;
	import com.gerantech.islamic.views.items.WordItemRenderer;
	
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class SearchScreen extends BaseScreen
	{
		private var locPanel:SettingPanel;
		private var naviPanel:SettingPanel;
		private var idlePanel:SettingPanel;
		private var fontPanel:SettingPanel;


		private var searchInput:CustomTextInput;
		private var clearButton:FlatButton;

		private var myHeader:Header;
		private var searchItems:Vector.<DisplayObject>;
		private var hasText:Boolean;
		private var list:List;
		private var resultList:Array;
		private var wordList:List;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
		//	backgroundSkin = new Quad(1,1,0xFFFFFF);
			
			list = new List();
			//list.isQuickHitAreaEnabled = true;
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new SearchItemRenderer();
			}
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.addEventListener(Event.CHANGE, listChangeHandler);
			list.decelerationRate = 0.999;
			addChild(list);
			
			wordList = new List();
			wordList.layoutData = new AnchorLayoutData(0,0,0,0);
			wordList.itemRendererFactory = function():IListItemRenderer
			{
				return new WordItemRenderer();
			}
			wordList.addEventListener(Event.CHANGE, wordList_changeHandler);
			addChild(wordList);
			
		}	
		
		private function searchMode(param0:Boolean):void
		{
			list.visible = param0;
			wordList.visible = !param0;
		}
		
		private function wordList_changeHandler():void
		{
			if(wordList.selectedIndex==-1)
				return;
			userModel.searchPatt = wordList.selectedItem.text
			startSearch()
		}
		
		private function listChangeHandler():void
		{
			var item:Bookmark = Bookmark.getFromObject(list.selectedItem);//trace(item.sura, item.aya)
			userModel.setLastItem(item.sura, item.aya);
			appModel.navigator.popScreen();
		}		

		/*
		override protected function customHeaderFactory():Header
		{
			myHeader = new Header();
			myHeader.visible = false
			
			var backButton:FlatButton = new FlatButton("arrow_"+AppModel.instance.align);
			backButton.addEventListener(Event.TRIGGERED, backButtonHandler);
			myHeader[AppModel.instance.align+"Items"] = new <DisplayObject>[backButton];
			
			searchItems = new <DisplayObject>[clearButton, searchInput];
			if(AppModel.instance.ltr)
				searchItems.reverse();
			
			myHeader[AppModel.instance.ltr?"rightItems":"leftItems"] = new <DisplayObject>[searchInput];
			return myHeader;
		}*/
		
		
		public function updateSuggests(input:String):void
		{
			searchMode(false);
			if(input.length<2)
				return;
			
			var inputs:Array = input.split(" ");
			var words:Array = new Array();
			
			for each(var w:Word in ResourceModel.instance.wordList)
				for each(var inp:String in inputs)
					if(inp.length>1 && w.text.search(inp)>-1 && words.indexOf(w)==-1)
						words.push(w);
			
			wordList.dataProvider = new ListCollection(words);
		}
		
		public function startSearch():void
		{
			resultList = new Array  ;
			var wordCount:uint;//trace(userModel.translator.flag.path)
			var s:uint;
			var a:uint;
			var l:uint;
			for each (var sr:Array in ResourceModel.instance.simpleQuran)
			{
				for each (var ay:String in sr)
				{
					if (ay.search(userModel.searchPatt) != -1)
					{
						var book:Bookmark = new Bookmark(s+1, a+1);//serachItemList.length+1, , ay.@text, pattern);
						book.isSearch = true;
						book.colorList = getColorList(ay, userModel.searchPatt);
						wordCount += (book.colorList.length-1)/2;
						book.index = l;
						resultList.push(book);
						l ++;
					}
					a ++;
				}
				s ++;
				a = 0;
			}
			
			/*if(wordCount)
				new Alert(this, StrTools.getNumberFromLocale(wordCount) + " " + loc('search_item') + " " + StrTools.getNumberFromLocale(resultList.length) + " " + loc('verses_in'));
			else
				new Alert(this, loc("search_no"));*/
			list.dataProvider = new ListCollection(resultList);
			searchMode(true);
		}

		private function getColorList(text:String, searchPatt:String):Array
		{
			var firstPoint:int=0;
			var secondPoint:int=-1;
			var colorList:Array = new Array()
			colorList.push(0)
			while(colorList.length<50)
			{
				firstPoint = StrTools.getSimpleString(text).indexOf(userModel.searchPatt, secondPoint+1);
				if(firstPoint == -1)break;
				secondPoint = firstPoint + userModel.searchPatt.length;
				colorList.push(firstPoint);
				colorList.push(secondPoint);
			}
			return colorList;
		}
	}
}