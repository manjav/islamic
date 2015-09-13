package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.views.items.LocalItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.events.Event;
	import com.gerantech.islamic.views.lists.PersonHeader;

	public class LanguageSelector extends BasePopUp
	{
		private var listDisplay:List;
		public var selectedLocal:Local;
		
		public function LanguageSelector()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			layout = new VerticalLayout();
			var app:AppModel = AppModel.instance;
			
			
			var header:PersonHeader = new PersonHeader();
			header.addEventListener(Event.CLOSE, close);
			header.layoutData = new VerticalLayoutData(100); 
			addChild(header);
			
			var listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.verticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout.gap = AppModel.instance.sizes.border*2;
			listLayout.useSquareTiles = true;
			
			listDisplay = new List();
			listDisplay.layout = listLayout;
			listDisplay.layoutData = new VerticalLayoutData(100, 100); 
			listDisplay.itemRendererFactory = function():IListItemRenderer
			{
				var r:LocalItemRenderer = new LocalItemRenderer();
				r.listLen = ConfigModel.instance.multiTransFlags.length;
				return r;
			};
			listDisplay.dataProvider = new ListCollection(ConfigModel.instance.multiTransFlags);
			listDisplay.addEventListener(Event.CHANGE, listDisplay_changeHandler);
			addChild(listDisplay);
		}

		
		private function listDisplay_changeHandler(event:Event):void
		{
			selectedLocal = listDisplay.selectedItem as Local;				
			dispatchEventWith(Event.CHANGE);
		}
		
	}
}