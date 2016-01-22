package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.items.TimeItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;

	public class TimesScreen extends BaseCustomPanelScreen
	{
		public var date:MultiDate;
		
		private var list:List;
		private var data:Vector.<Date>;
		
		override protected function initialize():void
		{
			super.initialize();
			
			var dates:Vector.<Date> = appModel.prayTimes.getTimes(date.dateClass).toDates();
			for (var i:uint=0; i<userModel.timesModel.times.length; i++)
				userModel.timesModel.times[i].date = dates[i+1];
			
			title = getDateString();
			
			layout = new AnchorLayout();
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
		
		private function getDateString():String
		{
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					return loc("week_day_"+date.day)+" "+num(date.dateShamsi)+" "+loc("month_p_"+date.monthShamsi)	+ " " + num(date.fullYearShamsi);
				case "ar_SA":
					return loc("week_day_"+date.day)+" "+num(date.dateQamari)+" "+loc("month_i_"+date.monthQamari)	+ " " + num(date.fullYearQamari);
				default:
					return loc("week_day_"+date.day)+" "+date.date+" "+loc("month_g_"+date.month) + ", " + num(date.fullYear);
			}	
			return null;
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
			userModel.activeSaver();
			list.dataProvider = new ListCollection(userModel.timesModel.times);
			userModel.timesModel.updateNotfications();
		}
		
		protected function num(input:Object):String
		{
			return StrTools.getNumber(input);
		}
		
	}
}