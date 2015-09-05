package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import mx.resources.ResourceManager;
	
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	public class ShopHeader extends SimpleLayoutButton
	{
		private var messageText:RTLLabel;
		public var _height:Number = 0;
		private var closeButton:FlatButton;
		
		public function ShopHeader()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var hlayout:HorizontalLayout = new HorizontalLayout();
			hlayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			hlayout.paddingRight = AppModel.instance.ltr? 0 : AppModel.instance.border*3;
			hlayout.paddingLeft = AppModel.instance.ltr? AppModel.instance.border*3 : 0;
			layout = hlayout;
			height = _height = AppModel.instance.actionHeight*0.8;
			
			backgroundSkin = new Quad(1,1,0x96000e);
			
			messageText = new RTLLabel(ResourceManager.getInstance().getString("loc", "purchase_warning"), 0xFFFFFF);
			messageText.layoutData = new HorizontalLayoutData(100);
			
			closeButton = new FlatButton("close_w", null, true);
			closeButton.iconScale = 0.6;
			closeButton.addEventListener(Event.TRIGGERED, closeButton_triggerdHandler);
			closeButton.width = closeButton.height = _height;
			
			addChild(AppModel.instance.ltr?messageText:closeButton);
			addChild(AppModel.instance.ltr?closeButton:messageText);
		}
		
		private function closeButton_triggerdHandler():void
		{
			dispatchEventWith(Event.CLOSE);
		}
		
	}
}