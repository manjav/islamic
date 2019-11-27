package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	import com.gerantech.islamic.views.lists.QList;

	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalAlign;

	import gt.utils.Localizations;

	import starling.events.Event;
	
	public class SettingPanel extends LayoutGroup
	{
		public var picker:PickerList;
		public var pickerList:QList;
		
		private var label:String;
		private var titleDisplay:RTLLabel;

		private var spacer:Spacer;
		private var changed:Boolean;
		
		private var data:Object;
		private var _selectedItem:Object;
		
		private var itemRendererFactory:Function;
		private var labelFunction:Function;
		
		public function SettingPanel(label:String, data:Object, selectedItem:Object, itemRendererClass:Class=null, itemRendererFactory:Function=null, labelFunction:Function=null)
		{
			this.label = label;
			
			// set factories -----------------------
			if ( itemRendererFactory != null )
			{
				this.itemRendererFactory = itemRendererFactory;
			}
			else 
			{
				if(itemRendererClass != null)
					this.itemRendererFactory = function():IListItemRenderer { return new itemRendererClass(); };
				else
					this.itemRendererFactory = function():IListItemRenderer { return new SettingItemRenderer(); };
				
			}
			this.labelFunction = labelFunction;
			
			
			height = AppModel.instance.sizes.singleLineItem;
			
			this.data = data;
			this._selectedItem = selectedItem;
		}
		
		protected override function initialize():void
		{
			super.initialize()
			
			var mLayout:HorizontalLayout = new HorizontalLayout();
			mLayout.verticalAlign = VerticalAlign.MIDDLE;
			mLayout.gap = AppModel.instance.sizes.DP8;
			layout = mLayout;
			
			// create label and spacer if need
			if( label!= null && label.length > 0)
			{
				titleDisplay = new RTLLabel(label, BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0.9, null, "bold");
				
				spacer = new Spacer()
				spacer.layoutData =  new HorizontalLayoutData(100);
			}
			
			// set selected index for list preview
			var index:uint = 0;
			var selectedIndex:uint;
			if(_selectedItem is uint || _selectedItem is int)
				selectedIndex = _selectedItem as uint;

			for each(var obj:Object in data)
			{
				if(!obj.name)
					obj.name = Localizations.instance.get(obj.value); //trace(obj.name, obj.value);
				
				if(obj.hasOwnProperty("value") && _selectedItem.hasOwnProperty("value") && obj.value==_selectedItem.value)
					selectedIndex = index;
				index++;
			}			
			
			picker = new PickerList();
			picker.buttonProperties.iconPosition = AppModel.instance.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			if(labelFunction != null)
				picker.labelFunction = labelFunction;
			else
				picker.labelField = "name";
			picker.listProperties.itemRendererFactory = itemRendererFactory;
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
			//picker.buttonProperties.iconPosition = appModel.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			//picker.listProperties.width = appModel.sizes.twoLineItem*3;
			//picker.listProperties.maxHeight = Math.min(appModel.sizes.height, appModel.sizes.width)-appModel.sizes.DP32;
			
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
				dispatchEventWith(Event.CHANGE);
			picker.closeList();
		}
		
		public function resetContent():void
		{
			if(titleDisplay != null)
			{
				titleDisplay.bidiLevel = AppModel.instance.ltr?0:1;
				titleDisplay.textAlign = AppModel.instance.ltr?"left":"right";
				
				var els:Array;
				if(AppModel.instance.ltr)
					els = new Array(titleDisplay, spacer, picker) ;
				else
					els = new Array(picker, spacer, titleDisplay) ;
				
				var _label:String = Localizations.instance.get(label);
				if(_label==null)
					_label = label;
				titleDisplay.text = _label;
			}
			else
			{
				picker.layoutData = new HorizontalLayoutData(100);
				els = new Array(picker);
			}

			removeChildren();
			for each(var c:FeathersControl in els)
				addChild(c);
		}
		
		public function get selectedItem():Object
		{
			if(pickerList)
				return pickerList.selectedItem;
			return null;
		}
		public function set selectedItem(value:Object):void
		{
			if(pickerList)
				pickerList.selectedItem = value;
		}
		
		public function get selectedIndex():int
		{
			if(pickerList)
				return pickerList.selectedIndex;
			return -1;
		}
		public function set selectedIndex(value:int):void
		{
			if(pickerList)
				pickerList.selectedIndex = value;
		}
		
	}
}