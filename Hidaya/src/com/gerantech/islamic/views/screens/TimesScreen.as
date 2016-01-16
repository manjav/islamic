package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.views.items.TimeItemRenderer;
	import com.gerantech.islamic.views.popups.TimePopup;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;

	public class TimesScreen extends BaseCustomPanelScreen
	{
		private var list:List;
		private var data:Vector.<Date>;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			var dates:Vector.<Date> = appModel.prayTimes.getTimes().toDates();
			for (var i:uint=0; i<userModel.timesModel.times.length; i++)
				userModel.timesModel.times[i].date = dates[i+1];
			
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TimeItemRenderer();
			}
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.dataProvider = new ListCollection(userModel.timesModel.times);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
		}
		
		private function list_changeHandler():void
		{
			var popup:TimePopup = AppController.instance.addPopup(TimePopup, null) as TimePopup;
			popup.addEventListener(Event.CHANGE, popup_changeHandler);
			popup.time = list.selectedItem as Time;
			
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			list.selectedIndex = -1;
			list.addEventListener(Event.CHANGE, list_changeHandler);			
		}
		
		private function popup_changeHandler():void
		{
			userModel.activeSaver();
			list.dataProvider = new ListCollection(userModel.timesModel.times);
			userModel.timesModel.updateNotfications();
		}
		
	}
}