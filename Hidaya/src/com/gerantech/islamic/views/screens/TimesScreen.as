package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.vo.DayDataProvider;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.items.TimeItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.events.Event;

	public class TimesScreen extends BaseCustomPanelScreen
	{
		public var date:MultiDate;
		
		private var list:List;
		private var data:Vector.<Date>;
		private var eventsLabel:RTLLabel;
		private var dayData:DayDataProvider;

		private var mainDateLabel:RTLLabel;

		private var secondaryDateLabel:RTLLabel;
		
		override protected function initialize():void
		{
			super.initialize();
			verticalScrollPolicy = horizontalScrollPolicy = SCROLL_POLICY_OFF;
			
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.paddingTop = appModel.sizes.DP8; 
			vlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout = vlayout;
			
			mainDateLabel = new RTLLabel("", 1, null, null, false, null, 0.9);
			addChild(mainDateLabel);
			secondaryDateLabel = new RTLLabel("", 1, "center", null, false, null, 0.9);
			addChild(secondaryDateLabel);

			eventsLabel = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.8);
			eventsLabel.layoutData = new VerticalLayoutData(((appModel.sizes.width-appModel.sizes.DP32)/appModel.sizes.width)*100);
			addChild(eventsLabel);
			
			dayData = new DayDataProvider();
			dayData.addEventListener("update", dayData_updateHandler);
			dayData.setTime(date.dateClass.getTime());
			
			var dates:Vector.<Date> = appModel.prayTimes.getTimes(date.dateClass).toDates();
			for (var i:uint=0; i<userModel.timesModel.times.length; i++)
				userModel.timesModel.times[i].date = dates[i+1];
			
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TimeItemRenderer();
			}
			list.layoutData = new VerticalLayoutData(100, 100);
			list.dataProvider = new ListCollection(userModel.timesModel.times);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
		}
		
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.accessoriesData.push(new ToolbarButtonData(appModel.PAGE_SETTINGS,	"setting",	toolbarButtons_triggerdHandler));
		}
		
		private function toolbarButtons_triggerdHandler(item:ToolbarButtonData):void
		{
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(item.name);
			screenItem.properties = {mode : SettingsScreen.MODE_TIMES};
			appModel.navigator.pushScreen(item.name);
		}
		
		private function dayData_updateHandler():void
		{
			mainDateLabel.text = dayData.mainDateString;
			secondaryDateLabel.text = dayData.secondaryDatesString+(dayData.eventsString.length+dayData.googleEventsString.length>0?"\n\n"+loc("day_events"):"");
			if(dayData.eventsString.length+dayData.googleEventsString.length>0)
				eventsLabel.text = dayData.eventsString+"\n"+ dayData.googleEventsString;		
		}
		
		private function list_changeHandler():void
		{
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_ALERT);
			screenItem.properties = {time:list.selectedItem};
			appModel.navigator.pushScreen(appModel.PAGE_ALERT);
			
			/*var popup:TimePopup = AppController.instance.addPopup(TimePopup, null) as TimePopup;
			popup.addEventListener(Event.CHANGE, popup_changeHandler);
			popup.time = list.selectedItem as Time;*/
			
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			list.selectedIndex = -1;
			list.addEventListener(Event.CHANGE, list_changeHandler);			
		}
		
		private function popup_changeHandler():void
		{
			userModel.scheduleSaving();
			list.dataProvider = new ListCollection(userModel.timesModel.times);
			userModel.timesModel.updateNotfications();
		}
		
		protected function num(input:Object):String
		{
			return StrTools.getNumber(input);
		}
	}
}