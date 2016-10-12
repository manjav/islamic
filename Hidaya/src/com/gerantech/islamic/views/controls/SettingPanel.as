package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	import com.gerantech.islamic.views.lists.QList;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.events.Event;
	
	public class SettingPanel extends LayoutGroup
	{
		private var titleDisplay:RTLLabel;
		public var picker:PickerList;
		private var label:String;

		private var spacer:Spacer;
		private var changed:Boolean;
		
		private var data:Object;
		private var _selectedItem:Object;
		private var itemRendererFactory:Class;
		private var pickerList:QList;
		
		public function SettingPanel(label:String, data:Object, selectedItem:Object, itemRendererFactory:Class=null)
		{
			this.label = label;
			if(itemRendererFactory==null)
				itemRendererFactory = SettingItemRenderer;
			
			height = AppModel.instance.sizes.singleLineItem;
			
			this.data = data;
			this._selectedItem = selectedItem;
			this.itemRendererFactory = itemRendererFactory;
		}
		
		protected override function initialize():void
		{
			super.initialize()
			
			var mLayout:HorizontalLayout = new HorizontalLayout();
			mLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			mLayout.gap = AppModel.instance.sizes.DP8;
			layout = mLayout;
			
			// set selected index for list preview
			var index:uint = 0;
			var selectedIndex:uint;
			if(_selectedItem is uint || _selectedItem is int)
				selectedIndex = _selectedItem as uint;

			for each(var obj:Object in data)
			{//trace(obj.value, _selectedItem.value)
				if(!obj.name)
					obj.name = ResourceManager.getInstance().getString("loc", obj.value); //trace(obj.name, obj.value);
				
				if(obj.hasOwnProperty("value") && _selectedItem.hasOwnProperty("value") && obj.value==_selectedItem.value)
					selectedIndex = index;
				index++;
			}			
			
			titleDisplay = new RTLLabel(label, BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0.9, null, "bold");
			
			spacer = new Spacer()
			spacer.layoutData =  new HorizontalLayoutData(100);
			
			picker = new PickerList();
			picker.buttonProperties.iconPosition = AppModel.instance.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			picker.labelField = "name";
			picker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				return new itemRendererFactory();
			}
			picker.dataProvider = new ListCollection(data);
			picker.selectedIndex = selectedIndex;
			picker.addEventListener(FeathersEventType.CREATION_COMPLETE, picker_creationCompleteHandler);
			picker.listFactory = function () : QList
			{
				var list:QList = new QList();
				pickerList = list;
				return list;
			}
			resetContent();
			
		}	
		
		private function picker_creationCompleteHandler():void
		{
			picker.removeEventListener(FeathersEventType.CREATION_COMPLETE, picker_creationCompleteHandler);
			pickerList.addEventListener(Event.CHANGE, pickerList_changeHandler);
		}
		
		private function pickerList_changeHandler(event:Event):void
		{
			//trace("picker_changeHandler", event, pickerList.selectedItem);
			if(picker.selectedItem && hasEventListener(Event.CHANGE))
			{
				dispatchEventWith(Event.CHANGE);
				picker.closeList();
			}
		}
		
		public function resetContent():void
		{
			titleDisplay.bidiLevel = AppModel.instance.ltr?0:1;
			titleDisplay.textAlign = AppModel.instance.ltr?"left":"right";
			
			var els:Array;
			if(AppModel.instance.ltr)
				els = new Array(titleDisplay, spacer, picker) ;
			else
				els = new Array(picker, spacer, titleDisplay) ;

			removeChildren();
			for each(var c:FeathersControl in els)
				addChild(c);
			
			var _label:String = ResourceManager.getInstance().getString("loc", label);
			if(_label==null)
				_label = label;
			titleDisplay.text = _label;
		}
		
		public function get selectedItem():Object
		{
			if(pickerList)
				return pickerList.selectedItem;
			return null;
		}
		
	}
}