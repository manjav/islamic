package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.views.buttons.FlatButton;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;
	
	public class IndexSorter extends LayoutGroup
	{
		private var titleDisplay:RTLLabel;
		private var ayaSortter:FlatButton;
		public var button:FlatButton;
		private var _title:String = "";
		
		public function IndexSorter()
		{
			super();
		}
		
		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
			if(titleDisplay)
				titleDisplay.text = _title;
		}

		override protected function initialize():void
		{
			super.initialize();
			
			layout = new AnchorLayout();
			
			titleDisplay = new RTLLabel(_title, 0xFFFFFF, "center", null, false, null, AppModel.instance.itemHeight/4);
			titleDisplay.layoutData = new AnchorLayoutData(0,0,0,0);
			//titleDisplay.height = AppModel.instance.actionHeight/3;
			addChild(titleDisplay);
			
			var icon:ImageLoader = new ImageLoader();
			icon.layoutData = new AnchorLayoutData(NaN,NaN,0,NaN,0);
			icon.height = AppModel.instance.itemHeight/3;
			icon.source = Assets.getTexture("chevron_w");
			addChild(icon);
			
			button = new FlatButton();
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			button.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(button);

		}
		
		private function button_triggeredHandler():void
		{
			dispatchEventWith(Event.TRIGGERED);
		}		
		
	}
}