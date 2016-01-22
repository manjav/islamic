package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.views.items.AlertItemRenderer;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class TimePopup extends InfoPopUp
	{
		private var _time:Time;
		private var addButton:Button;
		private var list:List;
		private var picker:TimePicker;
		private var selectedAlartIndex:int;
		public function TimePopup()
		{
			message = loc("alert_setting_message");
			acceptButtonLabel = loc("ok_button");
			cancelButtonLabel = loc("cancel_button");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var clayout:VerticalLayout = new VerticalLayout();
			clayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			clayout.paddingBottom = appModel.sizes.DP16;
			container.layout = clayout;
			
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				var ret:AlertItemRenderer = new AlertItemRenderer();
				ret.labelFunction = getAlertTitle;
				return ret;
			}
			list.maxHeight = maxHeight-appModel.sizes.dashboard 
			container.addChild(list);
			
			picker = new TimePicker();
			picker.buttonProperties.visible = false;
			picker.listProperties.width = AppModel.instance.sizes.width*0.8;
			picker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var ret:SettingItemRenderer = new SettingItemRenderer(appModel.sizes.DP48);
				ret.labelFunction = getAlertTitle;
				return ret;
			}
			picker.listProperties.maxHeight = maxHeight-appModel.sizes.dashboard 
			picker.includeInLayout = false;
			addChild(picker);
			
			acceptCallback = acceptCallbackHandler;
		}
		
		public function set time(value:Time):void
		{
			_time = new Time(value.index);
			for each(var t:int in value.alerts)
				_time.alerts.push(t);
			
			title = loc("pray_time_"+_time.index);
		
			picker.dataProvider = new ListCollection(Time.ALERT_PEAKS);
			picker.addEventListener(Event.CHANGE, picker_changeHandler);

			list.dataProvider = new ListCollection(_time.alerts);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			
			addButton = new Button();
			addButton.label = loc("alert_add");
			addButton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompleteHandler);
			addButton.addEventListener(Event.TRIGGERED, addButton_triggeredHandler);
			container.addChild(addButton);
		}
		
		private function list_changeHandler():void
		{
			selectedAlartIndex = list.selectedIndex;
			picker.selectedIndex = Time.ALERT_PEAKS.indexOf(list.selectedItem);
			picker.openList();
			
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			list.selectedIndex = -1;
			list.addEventListener(Event.CHANGE, list_changeHandler);			
		}
		
		private function picker_changeHandler():void
		{
			picker.closeList();
			if(picker.selectedItem == null)
				return;
			
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			picker.removeEventListener(Event.CHANGE, picker_addHandler);
			picker.removeEventListener(Event.CHANGE, picker_changeHandler);
			
			var t:int = picker.selectedItem as int;
			if(t == 1000)
				_time.alerts.splice(selectedAlartIndex, 1);
			else
				_time.alerts[selectedAlartIndex] = picker.selectedItem;
			list.dataProvider = new ListCollection(_time.alerts);
			
			picker.addEventListener(Event.CHANGE, picker_changeHandler);
			list.addEventListener(Event.CHANGE, list_changeHandler);			
		}
		
		
		private function addButton_triggeredHandler():void
		{
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			picker.removeEventListener(Event.CHANGE, picker_changeHandler);
			
			picker.openList();		
			//picker.selectedIndex = Time.ALERT_PEAKS.indexOf(0);
			picker.getList().scrollToDisplayIndex(picker.selectedIndex);
			picker.addEventListener(Event.CHANGE, picker_addHandler);
		}		
		private function picker_addHandler():void
		{
			picker.closeList();
			if(picker.selectedItem == null)
				return;
			
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			picker.removeEventListener(Event.CHANGE, picker_addHandler);
			picker.removeEventListener(Event.CHANGE, picker_changeHandler);
			
			var t:int = picker.selectedItem as int;
			if(t != 1000 && _time.alerts.indexOf(t)==-1)
			{
				_time.alerts.push(t);
				list.dataProvider = new ListCollection(_time.alerts);
			}
			
			picker.addEventListener(Event.CHANGE, picker_changeHandler);
			list.addEventListener(Event.CHANGE, list_changeHandler);			
		}
		
		private function acceptCallbackHandler():void
		{
			userModel.timesModel.times[_time.index].alerts = _time.alerts;
			dispatchEventWith(Event.CHANGE);
		}

		
		private function getAlertTitle(item:Object):String
		{
			return _time.getAlertTitle(int(item));
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