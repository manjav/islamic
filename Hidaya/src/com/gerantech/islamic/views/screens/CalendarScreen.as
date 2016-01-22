package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.views.items.CalendarItemRenderer;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;

	public class CalendarScreen extends BaseCustomPanelScreen
	{
		private var list:List;
		
		override protected function initialize():void
		{
			super.initialize();
			
			layout = new AnchorLayout();
			
			var t:Number = new Date().getTime();
			var times:Vector.<Number> = new Vector.<Number>(1000,true);
			for(var i:uint=0; i<1000; i++)
				times[i] = t + Time.DAY_TIME_LEN*(i-500);
			
			list = new List();
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new CalendarItemRenderer();
			}
			list.dataProvider = new ListCollection(times);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			list.scrollToDisplayIndex(500);
			addChild(list);
		}
		
		private function list_changeHandler():void
		{
			var md:MultiDate = new MultiDate();
			md.setTime(list.selectedItem);
			
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_TIMES);
			screenItem.properties = {date:md};
			appModel.navigator.pushScreen(appModel.PAGE_TIMES); 
 		}
	}
}