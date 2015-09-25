package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.events.Event;
	
	public class SettingPanel extends LayoutGroup
	{
		private var titleDisplay:RTLLabel;
		public var list:PickerList;
		private var label:String;
		
		public function SettingPanel(label:String, data:Object, selectedItem:Object)
		{
			this.label = label;
			
			height = AppModel.instance.sizes.singleLineItem;
			
			var mLayout:HorizontalLayout = new HorizontalLayout();
			mLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			mLayout.gap = AppModel.instance.sizes.DP8;
			layout = mLayout;
			
			var index:uint = 0;
			var selectedIndex:uint;
					
			for each(var obj:Object in data)
			{//trace(obj.value, selectedItem.value)
				if(!obj.name)
					obj.name = ResourceManager.getInstance().getString("loc", obj.value); //trace(obj.name, obj.value);
				
				if(obj.value==selectedItem.value)
					selectedIndex = index;
				index++;
			}			
			
			titleDisplay = new RTLLabel(label, BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0, null, "bold");
			titleDisplay.layoutData =  new HorizontalLayoutData(100);
			
			list = new PickerList();
			list.layoutData = new HorizontalLayoutData(100);
			list.buttonProperties.iconPosition = AppModel.instance.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			list.labelField = "name";
			list.listProperties.width = AppModel.instance.sizes.width*0.8;
			list.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				return new SettingItemRenderer();
			}
			list.dataProvider = new ListCollection(data);
			list.selectedIndex = selectedIndex;
			list.addEventListener(Event.CHANGE, picker_changeHandler);
			resetContent();

		}	

		private function picker_changeHandler():void
		{
			if(list.selectedItem)
			{
				dispatchEventWith(Event.CHANGE);
				//list.closeList();
			}
		}
		
		public function resetContent():void
		{
			titleDisplay.bidiLevel = AppModel.instance.ltr?0:1;
			titleDisplay.textAlign = AppModel.instance.ltr?"left":"right";
			addChild(!AppModel.instance.ltr?list:titleDisplay);
			addChild(AppModel.instance.ltr?list:titleDisplay);
			
			var _label:String = ResourceManager.getInstance().getString("loc", label);
			if(_label==null)
				_label = label;
			titleDisplay.text = _label;
		}
	}
}