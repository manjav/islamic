package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class MenuList extends List
	{
		private var overlay:FlatButton;
		private var array:Array;
		
		public function MenuList()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var llaouyt:VerticalLayout = new VerticalLayout();
			//llaouyt.firstGap = AppModel.instance.sizes.twoLineItem/4;
			llaouyt.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout = llaouyt;
			
			//{value:"sura_navi"}, {value:"juze_navi"}, {value:"page_navi"}
			width = Math.min(AppModel.instance.sizes.twoLineItem*6, AppModel.instance.sizes.orginalWidth*0.8);

			itemRendererFactory = function():IListItemRenderer
			{
				return new SettingItemRenderer( AppModel.instance.sizes.getPixelByDP(48));
			}
			selectedIndex = getSelectedIndex();
			addEventListener(Event.CHANGE, changeHandler);
		}
		
		private function getSelectedIndex():int
		{
			var i:int = 0
			for each(var obj:Object in array)
			{
				if(obj.value==UserModel.instance.navigationMode.value)
					return i;
				i++;
			}
			return -1;
		}		

		
		private function changeHandler(event:Event):void
		{
			var item:ToolbarButtonData = selectedItem as ToolbarButtonData;
			if(item.callback)
				item.callback(item);
			
			/*switch(selectedItem.value)
			{
				case "page_navi":
				case "sura_navi":
				case "juze_navi":
					UserModel.instance.navigationMode = selectedItem;
					AppModel.instance.navigator.activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
					break;*/

			dispatchEventWith(Event.CLOSE);
		}		
		
	}
}