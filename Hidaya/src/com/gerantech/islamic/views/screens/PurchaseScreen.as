package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.Spacer;
	
	import feathers.controls.Button;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;


	
	public class PurchaseScreen extends BaseCustomPanelScreen
	{
		
		public static const RECITER:uint = 0;
		public static const TRANSLATOR:uint = 1;
		//public static const PLAYER:uint = 0;

		public var mode:uint = 0;
		
		private var titleLabel:RTLLabel;
		private var messageLabel:RTLLabel;
		
		override protected function initialize():void
		{
			super.initialize();
			
			var fontSize:uint = userModel.fontSize*0.94;
			
			var mlayout:VerticalLayout = new VerticalLayout();
			mlayout.lastGap = mlayout.firstGap = appModel.sizes.border;
			mlayout.gap = mlayout.padding = appModel.sizes.border*4;
			mlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout = mlayout;
			
			var purchaseMessage:String;
			var persons:Array = new Array();
			var bullet:String = appModel.ltr ? "▸" : "◂";
			switch(mode)
			{
				case 0:
					for each(var r:String in resourceModel.freeReciters)
						persons.push(resourceModel.getReciterByPath(r).name);
					
					purchaseMessage = loc("purchase_player_1")+"\n"+bullet+" ";
					purchaseMessage+= (persons.join("\n"+bullet+" "));
					purchaseMessage += ("\n"+loc("purchase_player_2"));
					break;
				
				case 1:
					for each(var t:String in resourceModel.freeTranslators)
						persons.push(resourceModel.getTranslatorByPath(t).name);
					
					purchaseMessage = loc("purchase_translate_1")+"\n"+bullet+" ";
					purchaseMessage+= (persons.join("\n"+bullet+" "));
					purchaseMessage += ("\n"+loc("purchase_translate_2"));
					break;
			}
			
			titleLabel = new RTLLabel(purchaseMessage, 0, "justify", null, true, null, fontSize, null, "bold");
			addChild(titleLabel);
			
			messageLabel = new RTLLabel(loc("purchase_popup_message"), 0, "justify", null, true, null, fontSize*0.94);
			addChild(messageLabel);
			
			addChild(new Spacer())
			
			var button:Button = new Button();
			button.label = loc("purchase_popup_accept_label");
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
		}
		
		private function button_triggeredHandler():void
		{
			BillingManager.instance.purchase();
		}
		
	}
}