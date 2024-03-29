package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.models.vo.Juze;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.models.vo.Word;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.headers.SearchSubtitle;
	import com.gerantech.islamic.views.items.SearchItemRenderer;
	import com.gerantech.islamic.views.items.WordItemRenderer;
	
	import flash.data.SQLResult;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	import com.gerantech.islamic.views.controls.SearchInput;
	import feathers.layout.HorizontalAlign;
	
	public class SearchScreen extends BaseCustomPanelScreen
	{
		private var list:List;
		private var wordList:List;
		private var resultList:Array;
		private var searchSubtitle:SearchSubtitle;
		private var startScrollBarIndicator:Number = 0;
		private var loadingTranslation:Boolean;
		private var _suggestMode:Boolean = true;
		

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			searchSubtitle = new SearchSubtitle();
			searchSubtitle.layoutData = new AnchorLayoutData(NaN,0,NaN,0);
			searchSubtitle.addEventListener(Event.CHANGE, searchSubtitle_changeHandler);
			
			var listLayout: VerticalLayout = new VerticalLayout();
			listLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			listLayout.hasVariableItemDimensions = true;
			listLayout.paddingTop = searchSubtitle._height+appModel.sizes.DP8;
			
			var wLayout: VerticalLayout = new VerticalLayout();
			wLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			wLayout.paddingTop = searchSubtitle._height+appModel.sizes.DP32;
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new SearchItemRenderer();
			}
			list.addEventListener(Event.CHANGE, listChangeHandler);
			list.addEventListener(Event.SCROLL, listScrollHandler);
			//list.decelerationRate = 0.9985;
			addChild(list);
			
			wordList = new List();
			wordList.layout = wLayout;
			wordList.layoutData = new AnchorLayoutData(0,0,0,0);
			wordList.itemRendererFactory = function():IListItemRenderer
			{
				return new WordItemRenderer();
			}
			wordList.addEventListener(Event.CHANGE, wordList_changeHandler);
			addChild(wordList);
			
			addChild(searchSubtitle);
		}	
		
		/**
		 * Change subtitle position with lists scrolling
		 */
		private function listScrollHandler():void
		{
			var scrollPos:Number = Math.max(0, list.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			if(changes<0)
				changes /=2;
			
			searchSubtitle.y = Math.max(-searchSubtitle._height*0.6, Math.min(0, searchSubtitle.y+changes));
			startScrollBarIndicator = scrollPos;			
		}
		
		private function searchSubtitle_changeHandler():void
		{
			if(userModel.searchSource==0)
				updateSuggests(userModel.searchPatt);
			else
				startTranslationSearch(userModel.searchPatt);
		}
		
		public function updateSuggests(input:String):void
		{
			suggestMode = userModel.searchSource==0;
			if(input.length<2)
			{
				searchSubtitle.log(loc("search_error"), 0xFF0000);
				return;
			}
			if(userModel.searchSource>0)
				return;
			
			var inputs:Array = input.split(" ");
			var words:Array = new Array();
			
			for each(var w:Word in ResourceModel.instance.wordList)
			for each(var inp:String in inputs)
			if(inp.length>1 && w.text.search(inp)>-1 && words.indexOf(w)==-1)
				words.push(w);
			
			wordList.dataProvider = new ListCollection(words);
		}
		
		/**
		 * Show and hide suggest list
		 */
		private function set suggestMode(value:Boolean):void
		{
			if(_suggestMode == value)
				return;
			
			_suggestMode = value;
			list.visible = !_suggestMode;
			wordList.visible = _suggestMode;
		}

		
		private function wordList_changeHandler():void
		{
			if(wordList.selectedIndex==-1)
				return;
			
			startSearch(wordList.selectedItem.text);
		}
		
		public function startSearch(pattern:String):void
		{
			if(pattern.length<2)
			{
				searchSubtitle.log(loc("search_error"), 0xFF0000);
				return;
			}
			
			suggestMode = false;
			userModel.searchPatt = StrTools.getSimpleString(pattern);//trace(pattern, userModel.searchPatt)
			if(userModel.searchSource>0)
			{
				startTranslationSearch(pattern);
				return;
			}
			resultList = new Array ();
			var wordCount:uint;//trace(userModel.translator.flag.path)
			var s:uint;
			var a:uint;
			var l:uint;
			
			var j:Juze;
			var jLen:uint;
			var firstAya:uint;
			var lastAya:uint;
			var firstSura:uint;
			var lastSura:uint;
			var skip:Boolean;
			var searchScope:Array;
			
			if(userModel.searchScope==2)
			{
				j = ResourceModel.instance.juzeList[UserModel.instance.searchJuze];
				if(j.ayas==null)
					j.complete();
				jLen = j.ayas.length;
				firstAya = j.ayas[0].aya-1;
				lastAya = j.ayas[jLen-1].aya-1;
				s = firstSura = j.ayas[0].sura-1;
				lastSura = j.ayas[jLen-1].sura-1;
				searchScope = ResourceModel.instance.simpleQuran.slice(firstSura, lastSura+1);
			}
			else if(userModel.searchScope==1)
			{
				s = userModel.searchSura;
				searchScope = [ResourceModel.instance.simpleQuran[userModel.searchSura]];
			}
			else
				searchScope = ResourceModel.instance.simpleQuran;
				
			for each (var sr:Array in searchScope)
			{
				for each (var ay:String in sr)
				{
					//trace(firstSura, firstAya, " ", lastSura, lastAya, " -> ", a.sura, a.aya);
					if(userModel.searchScope==2)
						skip = (s==firstSura && a<firstAya) || (s==lastSura && a>lastAya);
					
					if(!skip && ay.search(userModel.searchPatt) > -1)
					{
						var book:Bookmark = new Bookmark(s+1, a+1, 0, 3, 0, ay);//serachItemList.length+1, , ay.@text, pattern);
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
			
			searchSubtitle.log(wordCount== 0 ? loc("search_no") : StrTools.getNumberFromLocale(wordCount) + " " + loc('search_item') + " " + StrTools.getNumberFromLocale(resultList.length) + " " + loc('verses_in'));
			list.dataProvider = new ListCollection(resultList);
		}

				
		private function startTranslationSearch(pattern:String):void
		{
			if(loadingTranslation)
				return;
			
			var tr:Translator = ConfigModel.instance.searchSources[userModel.searchSource];
			if(tr.loadingState!=Translator.L_LOADED)
			{
				loadingTranslation = true;
				tr.addEventListener(Person.LOADING_COMPLETE, translationLoaded);
				tr.addEventListener(Person.LOADING_ERROR, translationErrorHandler);
				tr.load();
				return;
			}
			
			suggestMode = false;
			tr.search(userModel.searchPatt, searchResponder);
		}
		
		private function translationErrorHandler(event:Event):void
		{
			loadingTranslation = false;
			searchSubtitle.log("translationErrorHandler", 0xFF0000);
			event.currentTarget.removeEventListener(Person.LOADING_COMPLETE, translationLoaded);
			event.currentTarget.removeEventListener(Person.LOADING_ERROR, translationErrorHandler);
		}
		
		private function translationLoaded(event:Event):void
		{
			loadingTranslation = false;
			event.currentTarget.removeEventListener(Person.LOADING_COMPLETE, translationLoaded);
			event.currentTarget.removeEventListener(Person.LOADING_ERROR, translationErrorHandler);
			startTranslationSearch(userModel.searchPatt);
		}
		
		private function searchResponder(obj:Object):void
		{
			if(obj is String)
			{
				searchSubtitle.log(obj as String, 0xFF0000);
				return;
			}
			
			var wordCount:uint;
			resultList = new Array();
			var l:uint;

			var j:Juze;
			var jLen:uint;
			var firstAya:uint;
			var lastAya:uint;
			var firstSura:uint;
			var lastSura:uint;
			var skip:Boolean;
			
			if(userModel.searchScope==2)
			{
				j = ResourceModel.instance.juzeList[UserModel.instance.searchJuze];
				jLen = j.ayas.length;
				firstAya = j.ayas[0].aya-1;
				lastAya = j.ayas[jLen-1].aya-1;
				firstSura = j.ayas[0].sura-1;
				lastSura = j.ayas[jLen-1].sura-1;
			}

			if(obj is SQLResult && obj.data is Array)
			{
				for each(var a:Object in obj.data)
				{
					//trace(firstSura, firstAya, " ", lastSura, lastAya, " -> ", a.sura, a.aya);
					if(userModel.searchScope==2)
						skip = (a.sura==firstSura && a.aya<firstAya) || (a.sura==lastSura && a.aya>lastAya);

					if(!skip)
					{
						var book:Bookmark = new Bookmark(a.sura+1, a.aya+1, 0, 3, 0, a.text);
						book.isSearch = true;
						book.colorList = getColorList(a.text, userModel.searchPatt);
						wordCount += (book.colorList.length-1)/2;
						book.index = l;
						resultList.push(book);
						l ++;
					}
				}
			}
			searchSubtitle.log(resultList.length== 0 ? loc("search_no") : StrTools.getNumberFromLocale(wordCount) + " " + loc('search_item') + " " + StrTools.getNumberFromLocale(resultList.length) + " " + loc('verses_in'));
			list.dataProvider = new ListCollection(resultList);
			suggestMode = false;
		}
		
		private function getColorList(text:String, searchPatt:String):Array
		{
			var firstPoint:int=0;
			var secondPoint:int=-1;
			var colorList:Array = new Array()
			colorList.push(0)
			while(colorList.length<50)
			{
				firstPoint = text.indexOf(userModel.searchPatt, secondPoint+1);
				if(firstPoint == -1)break;
				secondPoint = firstPoint + userModel.searchPatt.length;
				colorList.push(firstPoint);
				colorList.push(secondPoint);
			}
			return colorList;
		}
		
		private function listChangeHandler():void
		{
			var item:Bookmark = Bookmark.getFromObject(list.selectedItem);//trace(item.sura, item.aya)
			userModel.setLastItem(item.sura, item.aya);
			appModel.navigator.popScreen();
		}
		
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.centerItem = new SearchInput();
		}
		
	}
}