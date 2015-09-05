package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Hizb;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.headers.IndexHeader;
	import com.gerantech.islamic.views.items.HizbItemRenderer;
	import com.gerantech.islamic.views.items.SuraItemRenderer;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.events.Event;

	public class IndexScreen extends BaseScreen
	{
		private var suraCollection:ListCollection;
		private var indexHeader:IndexHeader;
		private var surasList:List;
		private var suraArray:Array;
		private var lastSortMode:String;
		private var hizbsList:List;
		private var hizbArray:Array;
		private var filteredArray:Array;
		private var startScrollBarIndicator:Number = 0;

		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			/*var listsContainer:LayoutGroup = new LayoutGroup();
			listsContainer.layoutData = new AnchorLayoutData(appModel.actionHeight*0.8, 0, 0, 0);
			listsContainer.layout = new HorizontalLayout();
			addChild(listsContainer);*/
			
			indexHeader = new IndexHeader();
			indexHeader._width = appModel.suraItemHeight;
			indexHeader.layoutData = new AnchorLayoutData(NaN,0,NaN,0);
			indexHeader.addEventListener(Event.CHANGE, indexHeader_changeHandler);
			lastSortMode = indexHeader.sortMode;
			addChild(indexHeader);
			
			
/*			var suraLayout: VerticalLayout = new VerticalLayout();
			var hizbLayout: VerticalLayout = new VerticalLayout();
			hizbLayout.verticalAlign = suraLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			hizbLayout.horizontalAlign = suraLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			hizbLayout.paddingTop = suraLayout.paddingTop = indexHeader._height;*/

			hizbsList = new List();
			//hizbsList.layout = hizbLayout;
			hizbsList.layoutData = new AnchorLayoutData(appModel.actionHeight*0.8, NaN, 0, 0);
			hizbsList.width = appModel.itemHeight;
			hizbsList.itemRendererFactory = function():IListItemRenderer
			{
				return new HizbItemRenderer();
			}
			hizbsList.addEventListener(Event.CHANGE, hizbsList_changeHandler);
			//hizbsList.addEventListener(Event.SCROLL, list_scrollChangedHandler);
			addChild(hizbsList);

			surasList = new List();
			//surasList.layout = suraLayout;
			surasList.layoutData = new AnchorLayoutData(appModel.actionHeight*0.8, 0, 0, appModel.itemHeight);
			surasList.itemRendererFactory = function():IListItemRenderer
			{
				return new SuraItemRenderer();
			}
			surasList.addEventListener(Event.CHANGE, surasList_changeHandler);
			//surasList.addEventListener(Event.SCROLL, list_scrollChangedHandler);
			addChild(surasList);
			
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
			
		}
		
		private function list_scrollChangedHandler(event:Event):void
		{
			var list:List = event.currentTarget as List;
			var scrollPos:Number = Math.max(0,list.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			indexHeader.y = Math.max(-header.height, Math.min(0, indexHeader.y+changes));
			startScrollBarIndicator = scrollPos;
			
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
			filteredArray = new Array();
			for each(var s:Sura in suraArray)
				if(StrTools.getSimpleString(s.name).indexOf(patt)>-1 || StrTools.getSimpleString(s.tname).indexOf(patt)>-1)
					filteredArray.push(s);
				
			surasList.dataProvider = new ListCollection(filteredArray);
		}

	}
}