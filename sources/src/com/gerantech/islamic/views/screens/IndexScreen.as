package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Hizb;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.SearchInput;
	import com.gerantech.islamic.views.headers.IndexHeader;
	import com.gerantech.islamic.views.items.HizbItemRenderer;
	import com.gerantech.islamic.views.items.SuraItemRenderer;
	import com.gerantech.islamic.views.lists.FastList;

	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;

	import starling.events.Event;
	import feathers.layout.VerticalAlign;
	import feathers.layout.HorizontalAlign;

	public class IndexScreen extends BaseCustomScreen
	{
		private var suraCollection:ListCollection;
		private var indexHeader:IndexHeader;
		private var surasList:FastList;
		private var suraArray:Array;
		private var lastSortMode:String;
		private var hizbsList:FastList;
		private var hizbArray:Array;
		private var filteredArray:Array;
		private var suraScrollPosition:Number = 0;
		private var hizbScrollPosition:Number = 0;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			//Create header for sort sura and hizbs
			indexHeader = new IndexHeader();
			indexHeader.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0);
			indexHeader.y = appModel.sizes.toolbar;
			indexHeader.addEventListener(Event.CHANGE, indexHeader_changeHandler);
			lastSortMode = indexHeader.sortMode;

			//Create hizb list on right of the page
			var hizbsLayout: VerticalLayout = new VerticalLayout();
			hizbsLayout.verticalAlign = VerticalAlign.TOP;
			hizbsLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			hizbsLayout.paddingTop = appModel.sizes.subtitle + appModel.sizes.toolbar;
			
			hizbsList = new FastList();
			hizbsList.layout = hizbsLayout;
			hizbsList.layoutData = new AnchorLayoutData(0, NaN, 0, 0);
			hizbsList.width = appModel.sizes.subtitle;
			hizbsList.itemRendererFactory = function():IListItemRenderer
			{
				return new HizbItemRenderer();
			}
			hizbsList.addEventListener(Event.CHANGE, hizbsList_changeHandler);
			//hizbsList.addEventListener(Event.SCROLL, hizbsList_scrollHandler);
			addChild(hizbsList);
		
			//Create sura list on left of the page
			var surasLayout: VerticalLayout = new VerticalLayout();
			surasLayout.verticalAlign = VerticalAlign.TOP;
			surasLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			surasLayout.paddingTop = appModel.sizes.subtitle + appModel.sizes.toolbar;
			
			surasList = new FastList();
			surasList.layout = surasLayout;
			surasList.layoutData = new AnchorLayoutData(0, 0, 0, appModel.sizes.subtitle);
			surasList.itemRendererFactory = function():IListItemRenderer
			{
				return new SuraItemRenderer();
			}
			surasList.addEventListener(Event.CHANGE, surasList_changeHandler);
			surasList.addEventListener(Event.SCROLL, surasList_scrollHandler);
			addChild(surasList);
			
			addChild(indexHeader);
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}
		
		
		private function transitionInCompleteHandler():void
		{
			suraArray = new Array()
			for each(var s:Sura in ResourceModel.instance.suraList)
				suraArray.push(s);
				
			startSearch("");
			
			hizbArray = new Array();
			for(var h:uint=0; h<ResourceModel.instance.hizbList.length; h++)
				hizbArray.push(ResourceModel.instance.hizbList[h]);
			hizbsList.dataProvider = new ListCollection(hizbArray);
		
		}
		
		////Update header and toolbar position according to hizb and sura list vertical scroll position
		private function surasList_scrollHandler(event:Event):void
		{
			var scrollPos:Number = Math.max(0, surasList.verticalScrollPosition);
			var changes:Number = suraScrollPosition-scrollPos;
			if(scrollPos<appModel.sizes.toolbar && hizbsList.verticalScrollPosition<appModel.sizes.toolbar && changes<0)
				hizbsList.verticalScrollPosition += -changes;
			updateHeaderPosition(changes);
			suraScrollPosition = scrollPos;
		}
		/*private function hizbsList_scrollHandler(event:Event):void
		{
			var scrollPos:Number = Math.max(0, hizbsList.verticalScrollPosition);
			var changes:Number = hizbScrollPosition-scrollPos;
			if(scrollPos<appModel.sizes.toolbar && surasList.verticalScrollPosition<appModel.sizes.toolbar && changes<0)
				surasList.verticalScrollPosition += -changes;
			updateHeaderPosition(changes);
			hizbScrollPosition = scrollPos;
		}*/
		private function updateHeaderPosition(y:Number):void
		{
			y = Math.max(0, Math.min(appModel.sizes.toolbar, indexHeader.y+y));
			indexHeader.y = y;
			appModel.toolbar.dispatchEventWith("moveToolbar", false, y-appModel.sizes.toolbar);
		}
		
		private function hizbsList_changeHandler():void
		{
			var item:Hizb = hizbsList.selectedItem as Hizb;
			userModel.setLastItem(item.sura, item.aya);
			appModel.navigator.popScreen();
		}
		
		private function surasList_changeHandler(event:Event):void
		{
			var item:Sura = surasList.selectedItem as Sura;
			userModel.setLastItem(item.sura, 1);
			appModel.navigator.popScreen();
		}
		
		private function indexHeader_changeHandler(event:Event):void
		{
			surasList.removeEventListener(Event.CHANGE, surasList_changeHandler);
			hizbsList.removeEventListener(Event.CHANGE, hizbsList_changeHandler);
			
			if(indexHeader.sortMode=="hizb")
			{
				if(lastSortMode==indexHeader.sortMode)
					hizbArray.reverse();
				else			
					hizbArray.sortOn([indexHeader.sortMode], [Array.NUMERIC]);
				
				hizbsList.dataProvider = new ListCollection(hizbArray);
				hizbsList.validate();
				hizbsList.dispatchEventWith(FeathersEventType.SCROLL_COMPLETE);
			}
			else
			{
				if(lastSortMode==indexHeader.sortMode)
					suraArray.reverse();
				else			
					suraArray.sortOn([indexHeader.sortMode], [Array.NUMERIC]);
				
				surasList.dataProvider = new ListCollection(suraArray);
				surasList.validate();
				surasList.dispatchEventWith(FeathersEventType.SCROLL_COMPLETE);
			}
			lastSortMode = indexHeader.sortMode;
			
			//list.selectedItem = ResourceModel.instance.getSuraByPage(UserModel.instance.lastPage);//ex = getCurrentSuraIndex(ResourceModel.instance.getSuraByPage(UserModel.instance.lastPage), suraArray);//trace(sura.index, list.height)
			surasList.addEventListener(Event.CHANGE, surasList_changeHandler);
			hizbsList.addEventListener(Event.CHANGE, hizbsList_changeHandler);
		}
		
		public function startSearch(patt:String):void
		{
			patt = StrTools.getSimpleString(patt).toLowerCase();
			filteredArray = new Array();
			for each(var s:Sura in suraArray)
				if(StrTools.getSimpleString(s.name).indexOf(patt)>-1 || StrTools.getSimpleString(s.tname).indexOf(patt)>-1)
					filteredArray.push(s);
				
			surasList.dataProvider = new ListCollection(filteredArray);
		}
		
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.centerItem = new SearchInput();
		}
	}
}