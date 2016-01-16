package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.views.controls.IndexSorter;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	public class IndexHeader extends LayoutGroup
	{
		private var myLayout:HorizontalLayout;
		public var _width:Number;
		public var _height:Number;
		private var ayaSorter:IndexSorter;
		private var orderSorter:IndexSorter;
		private var indexSorter:IndexSorter;
		public var sortMode:String = "index";
		private var appModel:AppModel;
		private var hizbSorter:IndexSorter;
		private var pageSorter:IndexSorter;
		
		public function IndexHeader()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			backgroundSkin = new Quad(1,1,0x004D40);
			appModel = AppModel.instance;
				
			_width = AppModel.instance.sizes.subtitle;
			if(appModel.sizes.width/_width<6.7)
				_width = appModel.sizes.width/6.7;
			
			height = _height = appModel.sizes.subtitle;

			myLayout = new HorizontalLayout();
			//myLayout.gap = appModel.sizes.border/2;
			//myLayout.firstGap = appModel.sizes.border/2+_width;
			//myLayout.paddingLeft = appModel.sizes.itemHeight+_width
			layout = myLayout;
			
			hizbSorter = new IndexSorter();
			hizbSorter.width = _width;
			hizbSorter.layoutData = new HorizontalLayoutData(NaN, 100);
			hizbSorter.title = loc("hizb_l");
			hizbSorter.name = "hizb"
			hizbSorter.addEventListener(Event.TRIGGERED, buttons_triggeredHandler);
			addChild(hizbSorter);
			
			_width *= 0.9;
			
			pageSorter = new IndexSorter();
			pageSorter.width = _width;
			pageSorter.layoutData = new HorizontalLayoutData(NaN, 100);
			pageSorter.title = loc("page_l");
			pageSorter.name = "page"
			pageSorter.addEventListener(Event.TRIGGERED, buttons_triggeredHandler);
			addChild(pageSorter);
			
			ayaSorter = new IndexSorter();
			ayaSorter.width = _width;
			ayaSorter.layoutData = new HorizontalLayoutData(NaN, 100);
			ayaSorter.title = loc("verses_in");
			ayaSorter.name = "numAyas"
			ayaSorter.addEventListener(Event.TRIGGERED, buttons_triggeredHandler);
			addChild(ayaSorter);
			
			orderSorter = new IndexSorter();
			orderSorter.width = _width;
			orderSorter.title = loc("order_in");
			orderSorter.layoutData = new HorizontalLayoutData(NaN, 100);
			orderSorter.name = "order"
			orderSorter.addEventListener(Event.TRIGGERED, buttons_triggeredHandler);
			addChild(orderSorter);
			
			indexSorter = new IndexSorter();
			indexSorter.title = loc("sura_l");
			indexSorter.name = "index"
			indexSorter.addEventListener(Event.TRIGGERED, buttons_triggeredHandler);
			indexSorter.layoutData = new HorizontalLayoutData(100, 100);
			addChild(indexSorter);
		}
		
		private function buttons_triggeredHandler(event:Event):void
		{
			sortMode = IndexSorter(event.currentTarget).name;
			dispatchEventWith(Event.CHANGE);
		}
		
		private function loc(str:String):String
		{
			return ResourceManager.getInstance().getString("loc", str)
		}
		
	}
}