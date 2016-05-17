package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	import com.gerantech.islamic.views.lists.QList;
	import com.gerantech.islamic.views.popups.CustomBottomDrawerPopUpContentManager;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.events.Event;
	
	public class SettingPanel extends LayoutGroup
	{
		private var titleDisplay:RTLLabel;
		public var picker:PickerList;
		private var label:String;

		private var spacer:Spacer;
		
		public function SettingPanel(label:String, data:Object, selectedItem:Object, itemRendererFactory:Class=null)
		{
			this.label = label;
			if(itemRendererFactory==null)
				itemRendererFactory = SettingItemRenderer;
			
			height = AppModel.instance.sizes.singleLineItem;
			
			var mLayout:HorizontalLayout = new HorizontalLayout();
			mLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			mLayout.gap = AppModel.instance.sizes.DP8;
			layout = mLayout;
			
			var index:uint = 0;
			var selectedIndex:uint;
			if(selectedItem is uint || selectedItem is int)
				selectedIndex = selectedItem as uint;

			for each(var obj:Object in data)
			{//trace(obj.value, selectedItem.value)
				if(!obj.name)
					obj.name = ResourceManager.getInstance().getString("loc", obj.value); //trace(obj.name, obj.value);
				
				if(obj.hasOwnProperty("value") && selectedItem.hasOwnProperty("value") && obj.value==selectedItem.value)
					selectedIndex = index;
				index++;
			}			
			
			titleDisplay = new RTLLabel(label, BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0.9, null, "bold");
			//titleDisplay.layoutData =  new HorizontalLayoutData(100);
			
			spacer = new Spacer()
			spacer.layoutData =  new HorizontalLayoutData(100);
			
			picker = new PickerList();
			//list.layoutData = new HorizontalLayoutData(100);
			picker.buttonProperties.iconPosition = AppModel.instance.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			picker.labelField = "name";
			picker.listFactory = function () : QList
			{
				var list:QList = new QList();
				//list.addEventListener(Event.CHANGE, picker_changeHandler);
				return list;
			}
			//picker.listProperties.width = AppModel.instance.sizes.width*0.8;
			picker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				return new itemRendererFactory();
			}
			picker.dataProvider = new ListCollection(data);
			picker.selectedIndex = selectedIndex;
			picker.addEventListener(Event.CHANGE, picker_changeHandler);
			resetContent();

		}	

		private function picker_changeHandler():void
		{
			if(picker.selectedItem)
			{
				dispatchEventWith(Event.CHANGE);
				//picker.popUpContentManager.close();
				trace("aaa");
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
	}
}