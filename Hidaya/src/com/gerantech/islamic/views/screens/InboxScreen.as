package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.views.items.DrawerItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;
	import com.gerantech.islamic.views.items.InboxItemRenderer;

	public class InboxScreen extends BaseCustomPanelScreen
	{
		private var list:List;
		public function InboxScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			list = new List();
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.dataProvider = new ListCollection(userModel.inbox);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new InboxItemRenderer;
			};
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
		}
		
		private function list_changeHandler():void
		{
			// TODO Auto Generated method stub
			
		}		
		
	}
}