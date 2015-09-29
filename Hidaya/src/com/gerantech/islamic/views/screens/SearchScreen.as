package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.models.vo.Word;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.headers.SearchSubtitle;
	import com.gerantech.islamic.views.items.SearchItemRenderer;
	import com.gerantech.islamic.views.items.WordItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class SearchScreen extends BaseScreen
	{
		private var list:List;
		private var resultList:Array;
		private var wordList:List;
		private var searchSubtitle:SearchSubtitle;
		private var startScrollBarIndicator:Number = 0;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			searchSubtitle = new SearchSubtitle();
			searchSubtitle.layoutData = new AnchorLayoutData(NaN,0,NaN,0);
			
			var listLayout: VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.paddingTop = searchSubtitle._height+appModel.sizes.DP4;
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new SearchItemRenderer();
			}
			list.addEventListener(Event.CHANGE, listChangeHandler);
			list.addEventListener(Event.SCROLL, listScrollHandler);
			list.decelerationRate = 0.999;
			addChild(list);
			
			wordList = new List();
			//wordList.layout = listLayout;
			wordList.layoutData = new AnchorLayoutData(0,0,0,0);
			wordList.itemRendererFactory = function():IListItemRenderer
			{
				return new WordItemRenderer();
			}
			wordList.addEventListener(Event.CHANGE, wordList_changeHandler);
			addChild(wordList);
			
			addChild(searchSubtitle);
		}	
		
		private function listScrollHandler():void
		{
			var scrollPos:Number = Math.max(0,list.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			if(changes<0)
				changes /=2;
			
			searchSubtitle.y = Math.max(-searchSubtitle._height/2, Math.min(0, searchSubtitle.y+changes));
			startScrollBarIndicator = scrollPos;			
		}
		
		private function searchMode(param0:Boolean):void
		{
			searchSubtitle.visible = list.visible = param0;
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
			//searchMode(false);
			if(input.length<2)
				return;
			
			if(userModel.searchSource>0)
			{
				userModel.searchPatt = input;
				startSearch()
				return;
			}
			
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
			
			searchSubtitle.result = wordCount== 0 ? loc("search_no") : StrTools.getNumberFromLocale(wordCount) + " " + loc('search_item') + " " + StrTools.getNumberFromLocale(resultList.length) + " " + loc('verses_in')
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