package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.views.items.TimeItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	public class TimesScreen extends BaseCustomPanelScreen
	{
		private var list:List;
		private var data:Vector.<Date>;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			data = appModel.prayTimes.getTimes().toDates();
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TimeItemRenderer();
			}
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.dataProvider = new ListCollection(data);
			addChild(list);
		}
		
		
	}
}