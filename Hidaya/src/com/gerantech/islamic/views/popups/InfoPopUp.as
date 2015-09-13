package com.gerantech.islamic.views.popups
{
	
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
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

			messageLabel = new RTLLabel(_message, BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "justify", null, true, null, uint(userModel.fontSize*0.9));
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
			cancelButton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompjleteHandler);
			cancelButton.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
			
			if(acceptButtonLabel==null)
				buttonBar.addChild(cancelButton);
			
			if(acceptButtonLabel!=null)
			{
				var acceptButton:Button = new Button();
				acceptButton.label = acceptButtonLabel;
				acceptButton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompjleteHandler);
				acceptButton.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
				
				buttonBar.addChild(appModel.ltr?cancelButton:acceptButton);
				buttonBar.addChild(appModel.ltr?acceptButton:cancelButton);
			}
			
			show();
		}
		
		private function buttons_creationCompjleteHandler(event:Event):void
		{
			var btn:Button = event.currentTarget as Button;
			var fd2:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			var fe:ElementFormat = new ElementFormat(fd2, uint(userModel.fontSize*1.05), BaseMaterialTheme.SELECTED_TEXT_COLOR);
			var fd:ElementFormat = new ElementFormat(fd2, uint(userModel.fontSize*1.05), BaseMaterialTheme.DARK_DISABLED_TEXT_COLOR);
			btn.disabledLabelProperties.bidiLevel = btn.downLabelProperties.bidiLevel = btn.defaultLabelProperties.bidiLevel = appModel.ltr ? 0 : 1;
			btn.defaultLabelProperties.elementFormat = fe;
			btn.downLabelProperties.elementFormat = fd;
			btn.disabledLabelProperties.elementFormat = fe;
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			btn.stateToSkinFunction = skinSelector.updateValue;
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