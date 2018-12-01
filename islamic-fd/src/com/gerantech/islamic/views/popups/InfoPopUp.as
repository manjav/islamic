package com.gerantech.islamic.views.popups
{
	
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.Button;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;
	
	public class InfoPopUp extends SimplePopUp
	{
		private var _message:String = "";
		
		public var cancelButtonLabel:String = "";
		public var acceptButtonLabel:String = "";
		public var acceptCallback:Function;
		public var cancelCallback:Function;
		private var messageLabel:RTLLabel;
		
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			if(_message==value)
				return;
			
			_message = value;
			if(messageLabel)
				messageLabel.text = _message;
		}
		
	/*	override protected function initialize():void
		{
			super.initialize();
			//height = Math.round(Math.min(appModel.sizes.orginalWidth, appModel.sizes.orginalHeightFull)*0.9);
		}	*/	
		
		override protected function initialize():void
		{
			super.initialize();
			container.layout = new AnchorLayout();

			messageLabel = new RTLLabel(_message, BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "justify", null, true, null, 0.9);
			messageLabel.layoutData = new AnchorLayoutData(0,0,NaN,0);
			container.addChild(messageLabel);
/*			
			messageLabel = new ScrollText();
			messageLabel.layoutData = new AnchorLayoutData(0,0,NaN,0);
			messageLabel.text = _message+"\n"+_message;
			container.addChild(messageLabel);
*/			
			var cancelButton:Button = new Button();
			cancelButton.label = cancelButtonLabel;
			appModel.theme.setSimpleButtonStyle(cancelButton);
			cancelButton.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
			
			if(acceptButtonLabel==null)
				buttonBar.addChild(cancelButton);
			
			if(acceptButtonLabel!=null)
			{
				var acceptButton:Button = new Button();
				acceptButton.label = acceptButtonLabel;
				appModel.theme.setSimpleButtonStyle(acceptButton);
				acceptButton.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
				
				buttonBar.addChild(appModel.ltr?cancelButton:acceptButton);
				buttonBar.addChild(appModel.ltr?acceptButton:cancelButton);
			}
			
			show();
		}

		
		private function buttons_triggerHandler(event:Event):void
		{
			if(Button(event.currentTarget).label == acceptButtonLabel)
			{
				if(acceptCallback!=null)
					acceptCallback();
			}
			else
			{
				if(cancelCallback!=null)
					cancelCallback();
			}
			close();
		}
	
	}
}