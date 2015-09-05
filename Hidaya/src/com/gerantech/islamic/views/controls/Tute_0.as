package com.gerantech.islamic.views.controls
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	public class Tute_0 extends LayoutGroup
	{
		private var image:ImageLoader;
		private var tip:RTLLabel;
		private var _data:String;
		
		public function Tute_0()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout = vlayout
			
			image = new ImageLoader();
			image.alpha = 0;
			image.layoutData = new VerticalLayoutData(90, 80);
			image.source = "com/gerantech/islamic/assets/images/tutorial/"+_data+".png";
			addChild(image);
			
			tip = new RTLLabel(ResourceManager.getInstance().getString("loc", _data), 0, "center", null, true);
			tip.alpha = 0;
			tip.layoutData = new VerticalLayoutData(80, 20);
			addChild(tip);
		}
		
		public function set data(value:String):void
		{
			_data = value;
			if(image)
			{
				image.source = "com/gerantech/islamic/assets/images/tutorial/"+_data+".png";
				TweenLite.to(image, 0.5 ,{alpha:1});
			}
			if(tip)
			{
				tip.text = ResourceManager.getInstance().getString("loc", _data);
				TweenLite.to(tip, 0.5 ,{alpha:1, delay:0.2});
			}
		}


		
	}
}