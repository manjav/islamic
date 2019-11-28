package com.gerantech.islamic.views.screens
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.items.AlertItemRenderer;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	import com.gerantech.islamic.views.lists.QList;

	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;

	import starling.events.Event;

	public class AlertScreen extends BaseCustomPanelScreen
	{
		public var time:Time;
		private var _time:Time;
		private var addButton:Button;
		private var list:List;
		private var picker:PickerList;
		private var selectedAlartIndex:int;
		private var titleLable:RTLLabel;
		private var alertCollection:ListCollection;
		private var pickerList:QList;

		override protected function initialize():void
		{
			super.initialize();
			
			_time = time/*new Time(time.index);
			for each(var a:Alert in time.alerts)
				_time.alerts.push(a);
			*/
			var clayout:VerticalLayout = new VerticalLayout();
			clayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			clayout.gap = appModel.sizes.DP16;
			layout = clayout;
			
			alertCollection = new ListCollection(_time.alerts);
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new AlertItemRenderer();
			}
			list.maxHeight = maxHeight-appModel.sizes.dashboard;
			list.dataProvider = alertCollection;
			list.addEventListener(AlertItemRenderer.EVENT_SELECT, list_eventSelectHandler);
			list.addEventListener(AlertItemRenderer.EVENT_DELETE, list_eventDeleteHandler);
			list.addEventListener(AlertItemRenderer.EVENT_CHANGE_TYPE, list_eventChangeTypeHandler);
			list.addEventListener(AlertItemRenderer.EVENT_CHANGE_RECITER, list_eventChangeReciterHandler);
			addChild(list);
			
			picker = new PickerList();
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
			picker.addEventListener(FeathersEventType.CREATION_COMPLETE, picker_creationCompleteHandler);
			picker.listFactory = function () : QList
			{
				var list:QList = new QList();
				pickerList = list;
				return list;
			}
			addChild(picker);
			
			title = loc("pray_time_"+_time.index);
			
			addButton = new Button();
			addButton.label = loc("alert_add");
			addButton.addEventListener(Event.TRIGGERED, addButton_triggeredHandler);
			appModel.theme.setSimpleButtonStyle(addButton);
			addChild(addButton);
		}
		
		private function picker_creationCompleteHandler():void
		{
			picker.removeEventListener(FeathersEventType.CREATION_COMPLETE, picker_creationCompleteHandler);
			pickerList.addEventListener(Event.CHANGE, pickerList_changeHandler);
		}
		
		// athan list items handlers -----------------------
		private function list_eventChangeReciterHandler(event:Event):void
		{
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_FILTERED);
			screenItem.properties = {type:Person.TYPE_MOATHEN, mode:new Local("athan_t",""), flags:[], alert:event.data};
			appModel.navigator.pushScreen(appModel.PAGE_FILTERED);
		}
		private function list_eventChangeTypeHandler(event:Event):void
		{
			_time.alerts[event.data[0]].type = event.data[1];
			NativeAbilities.instance.showToast(loc(event.data[1]==Alert.TYPE_ALARM ? "alert_type_alarm" : "alert_type_notification"), 1);
			update();
		}
		private function list_eventDeleteHandler(event:Event):void
		{
			_time.alerts.splice(event.data as int, 1);
			update();
		}
		private function list_eventSelectHandler(event:Event):void
		{
			pickerList.removeEventListener(Event.CHANGE, pickerList_changeHandler);
			
			selectedAlartIndex = event.data as int;
			var selectedAlert:Alert = _time.alerts[selectedAlartIndex];
			pickerList.selectedIndex = Time.ALERT_PEAKS.indexOf(selectedAlert.offset);
			pickerList.scrollToDisplayIndex(pickerList.selectedIndex, 0.4);
			picker.openList();
			
			pickerList.addEventListener(Event.CHANGE, pickerList_changeHandler);
		}
		
		
		private function addButton_triggeredHandler():void
		{
			pickerList.removeEventListener(Event.CHANGE, pickerList_changeHandler);
			
			pickerList.selectedIndex = selectedAlartIndex = -1;
			pickerList.scrollToDisplayIndex(Time.ALERT_PEAKS.indexOf(0), 0.4);
			picker.openList();		
			
			pickerList.addEventListener(Event.CHANGE, pickerList_changeHandler);
		}
		
		
		private function pickerList_changeHandler():void
		{
			picker.closeList();
			if(pickerList.selectedItem == null)
				return;

			trace(selectedAlartIndex);
			// when add athan button triggered ------------------
			if(selectedAlartIndex == -1)
			{
				var breaked:Boolean;
				var t:int = pickerList.selectedItem as int;
				for each(var a:Alert in _time.alerts)
				if(a.offset == t)
				{
					breaked = true;
					break;
				}
				
				if(!breaked)
					_time.alerts.push(new Alert(t, userModel.timesModel.moathens[0], _time));
			}
			// when an athan list item selected ------------------
			else
			{
				_time.alerts[selectedAlartIndex].offset = pickerList.selectedItem as int;
			}
			
			update();
		}

		
		private function update():void
		{
			list.height = Math.min(maxHeight-appModel.sizes.dashboard, _time.alerts.length * appModel.sizes.singleLineItem);
			alertCollection.updateAll();
			userModel.timesModel.updateNotfications();
			userModel.scheduleSaving(1000);
		}
		
		private function getAlertTitle(item:Object):String
		{
			return _time.getAlertTitle(int(item));
		}
	}
}