package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;

	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;

	import starling.events.Event;
	
	public class NavigationDrawer extends AbstractDrawer
	{
		private var list:List;

		
		public function NavigationDrawer()
		{
			super();
			
			list = new List();
			list.dataProvider = new ListCollection(ConfigModel.instance.views);
			list.verticalScrollPolicy = list.horizontalScrollPolicy = ScrollContainer.ScrollPolicy.OFF
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer : DefaultListItemRenderer = new DefaultListItemRenderer();
				//renderer.nameList.add( DDTheme.LIST_ITEM_NAME_BLANK );
				renderer.width = list.width;
				renderer.labelField = "title";
				
				renderer.isQuickHitAreaEnabled = true;
				renderer.minTouchWidth = renderer.width;
				renderer.minTouchHeight = renderer.height;
				
				return renderer;
			};
			list.addEventListener(Event.CHANGE, list_changeHandler);
			container.addChild(list);
			
			validateSize();
		}

		
		
		override public function validateSize():void
		{
			super.validateSize()
			
			list.width = containerWidth;
			list.height = AppModel.instance.sizes.heightFull;
		}
		
		private function list_changeHandler( event:Event ):void
		{
			var list:List = List( event.currentTarget );
			//trace( "selectedIndex:", list.selectedIndex );
			hide();
			AppController.instance.pushView(list.selectedIndex);
		}
	}
}