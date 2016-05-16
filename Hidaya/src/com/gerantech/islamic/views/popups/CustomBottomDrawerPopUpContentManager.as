package com.gerantech.islamic.views.popups
{
	import feathers.controls.Header;
	import feathers.controls.popups.BottomDrawerPopUpContentManager;
	
	import starling.display.DisplayObject;
	
	public class CustomBottomDrawerPopUpContentManager extends BottomDrawerPopUpContentManager
	{
		public function CustomBottomDrawerPopUpContentManager()
		{
			super();
			
		}
		
		override public function open(content:DisplayObject, source:DisplayObject):void
		{
			super.open(content, source);
			panel.headerProperties.height = 0;
		}
		
		
		
		/**
		 * @private override
		 */
		override protected function headerFactory():Header
		{
			var header:Header = new Header();
			header.visible = header.includeInLayout = false;
			header.height = 0;
			/*var closeButton:Button = new Button();
			closeButton.label = this.closeButtonLabel;
			closeButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			header.rightItems = new <DisplayObject>[closeButton];*/
			return header;
		}

	}
}