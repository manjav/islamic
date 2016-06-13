package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.items.AlertItemRenderer;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class AlertScreen extends BaseCustomPanelScreen
	{
		public var time:Time;
		private var _time:Time;
		private var addButton:Button;
		private var list:List;
		private var picker:TimePicker;
		private var selectedAlartIndex:int;
		private var titleLable:RTLLabel;

		override protected function initialize():void
		{
			super.initialize();
			
			_time = time/*new Time(time.index);
			for each(var a:Alert in time.alerts)
				_time.alerts.push(a);
			*/
			var clayout:VerticalLayout = new VerticalLayout();
			clayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			clayout.gap = appModel.sizes.DP16;
			layout = clayout;
			
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new AlertItemRenderer();
			}
			list.maxHeight = maxHeight-appModel.sizes.dashboard 
			list.dataProvider = new ListCollection(_time.alerts);
			list.addEventListener(AlertItemRenderer.EVENT_SELECT, list_eventSelectHandler);
			list.addEventListener(AlertItemRenderer.EVENT_DELETE, list_eventDeleteHandler);
			list.addEventListener(AlertItemRenderer.EVENT_CHANGE_TYPE, list_eventChangeTypeHandler);
			list.addEventListener(AlertItemRenderer.EVENT_CHANGE_RECITER, list_eventChangeReciterHandler);
			addChild(list);
			
			picker = new TimePicker();
			picker.buttonProperties.visible = false;
			picker.listProperties.width = appModel.sizes.width*0.8;
			picker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var ret:SettingItemRenderer = new SettingItemRenderer(appModel.sizes.DP48);
				ret.labelFunction = getAlertTitle;
				return ret;
			}
			picker.listProperties.maxHeight = maxHeight-appModel.sizes.dashboard 
			picker.includeInLayout = false;
			picker.dataProvider = new ListCollection(Time.ALERT_PEAKS);
			picker.addEventListener(Event.CHANGE, picker_changeHandler);
			addChild(picker);
			
			title = loc("pray_time_"+_time.index);
			
			addButton = new Button();
			addButton.label = loc("alert_add");
			addButton.addEventListener(Event.TRIGGERED, addButton_triggeredHandler);
			appModel.theme.setSimpleButtonStyle(addButton);
			addChild(addButton);
			//acceptCallback = acceptCallbackHandler;
		}
		
		private function list_eventChangeReciterHandler(event:Event):void
		{
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_FILTERED);
			screenItem.properties = {type:Person.TYPE_MOATHEN, mode:new Local("", ""), flags:[], alert:event.data};
			appModel.navigator.pushScreen(appModel.PAGE_FILTERED);
		}
		
		private function list_eventChangeTypeHandler(event:Event):void
		{
//			var selectedAlert:Alert = _time.alerts[event.data[0]];
			_time.alerts[event.data[0]].type = event.data[1];
			//list.dataProvider = new ListCollection(_time.alerts);
		}
		
		private function list_eventDeleteHandler(event:Event):void
		{
			_time.alerts.splice(event.data as int, 1);
			list.dataProvider = new ListCollection(_time.alerts);
			update();
		}
		
		private function list_eventSelectHandler(event:Event):void
		{
			selectedAlartIndex = event.data as int;
			var selectedAlert:Alert = _time.alerts[selectedAlartIndex];
			picker.selectedIndex = Time.ALERT_PEAKS.indexOf(selectedAlert.offset);
			picker.getList().scrollToDisplayIndex(picker.selectedIndex, 0.4);
			picker.openList();
		}
		
		private function picker_changeHandler():void
		{
			picker.closeList();
			if(picker.selectedItem == null)
				return;
			
			picker.removeEventListener(Event.CHANGE, picker_addHandler);
			picker.removeEventListener(Event.CHANGE, picker_changeHandler);
			
			time.alerts[selectedAlartIndex].offset = picker.selectedItem as int;
			list.dataProvider = new ListCollection(_time.alerts);
			update();
			
			picker.addEventListener(Event.CHANGE, picker_changeHandler);
		}
		
		private function addButton_triggeredHandler():void
		{
			//list.removeEventListener(Event.CHANGE, list_changeHandler);
			picker.removeEventListener(Event.CHANGE, picker_changeHandler);
			
			picker.openList();		
			picker.selectedIndex = -1;
			picker.getList().scrollToDisplayIndex(Time.ALERT_PEAKS.indexOf(0), 0.4);
			picker.addEventListener(Event.CHANGE, picker_addHandler);
		}		
		private function picker_addHandler():void
		{
			picker.closeList();
			if(picker.selectedItem == null)
				return;
			
			picker.removeEventListener(Event.CHANGE, picker_addHandler);
			picker.removeEventListener(Event.CHANGE, picker_changeHandler);
			
			var breaked:Boolean;
			var t:int = picker.selectedItem as int;
			for each(var a:Alert in _time.alerts)
				if(a.offset == t)
				{
					breaked = true;
					break;
				}

			if(!breaked)
			{
				_time.alerts.push(new Alert(t, userModel.timesModel.moathens[0], _time));
				list.dataProvider = new ListCollection(_time.alerts);
			}
			update();
			picker.addEventListener(Event.CHANGE, picker_changeHandler);
		}
		/*
		private function acceptCallbackHandler():void
		{
			userModel.timesModel.times[_time.index].alerts = _time.alerts;
			dispatchEventWith(Event.CHANGE);
		}*/
		
		private function getAlertTitle(item:Object):String
		{
			return _time.getAlertTitle(int(item));
		}
		
		private function update():void
		{
			userModel.timesModel.updateNotfications();
		}
		
	}
}
import feathers.controls.List;
import feathers.controls.PickerList;

class TimePicker extends PickerList
{
	public function getList():List
	{
		return list;
	}
}