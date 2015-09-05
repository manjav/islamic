package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.views.buttons.FlatButton;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import mx.resources.ResourceManager;
	
	import starling.events.Event;
	
	public class PersonHeader extends LayoutGroup
	{
		public var searchInput:TextInput;
		public var closeButton:FlatButton;
		private var _enabled:Boolean;
		
		public function PersonHeader()
		{
			super();
		}
		
		

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			alpha = value ? 1 : 0.4;
		}

		override protected function initialize():void
		{
			enabled = true;
			super.initialize();
			
			height = AppModel.instance.actionHeight;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.padding = height*0.2;
			layout = myLayout;
			
			closeButton = new FlatButton("arrow_w_"+AppModel.instance.align);
			closeButton.name = "flag";
			closeButton.layoutData = new HorizontalLayoutData(NaN, 100);
			closeButton.addEventListener(Event.TRIGGERED, buttons_triggeredHandler);
			closeButton.width = height*0.6;
			
			var spacer:LayoutGroup = new LayoutGroup();
			spacer.layoutData = new HorizontalLayoutData(100);
			
			searchInput = new TextInput();
			searchInput.visible = false;
			searchInput.addEventListener(FeathersEventType.ENTER, searchInput_enterHandler);
			searchInput.layoutData = new HorizontalLayoutData(100, 80);
			searchInput.styleNameList.add(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT);
			searchInput.prompt = ResourceManager.getInstance().getString("loc", "search_page");
			
			addChild(AppModel.instance.ltr?closeButton:searchInput);			
			addChild(spacer);
			addChild(AppModel.instance.ltr?searchInput:closeButton);
		}
		
		private function searchInput_enterHandler(event:Event):void
		{
			if(enabled && hasEventListener(FeathersEventType.ENTER))
				dispatchEventWith(FeathersEventType.ENTER);
		}
		
		private function buttons_triggeredHandler(event:Event):void
		{
			if(enabled && hasEventListener(Event.CLOSE))
				dispatchEventWith(Event.CLOSE);
		}		
		
	}
}