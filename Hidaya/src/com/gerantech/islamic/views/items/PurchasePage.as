package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.events.Event;
	
	public class PurchasePage extends LayoutGroup
	{
		public function PurchasePage()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vlayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			vlayout.gap = AppModel.instance.sizes.twoLineItem/4;
			layout = vlayout;
			
			
			
			var message:String = loc("purchase_navigation");//ResourceManager.getInstance().getString("loc", "purchase_navigation")
			var messageDisplay:RTLLabel = new RTLLabel(message, 0xFF0000, "center", null, true);
			messageDisplay.layoutData = new VerticalLayoutData(90);
			addChild(messageDisplay);
			
			var button:Button = new Button();
			button.name = "purchase";
			button.label = loc("purchase_popup_accept_label");
			button.height = AppModel.instance.sizes.singleLineItem;
			button.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompjleteHandler);
			button.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
			addChild(button);
			
			var rbutton:Button = new Button();
			rbutton.name = "sura";
			rbutton.label = loc("sura_navi");
			rbutton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompjleteHandler);
			rbutton.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
			addChild(rbutton);	
			
			var fbutton:Button = new Button();
			fbutton.name = "first";
			fbutton.label = loc("goto_popup") + " " + loc("sura_l") + " " + loc("j_1");
			fbutton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompjleteHandler);
			fbutton.addEventListener(Event.TRIGGERED, buttons_triggerHandler);
			addChild(fbutton);
		}
		
		private function loc(resourceName:String):String
		{
			return ResourceManager.getInstance().getString("loc", resourceName);
		}

		
		private function buttons_triggerHandler(event:Event):void
		{
			switch((event.currentTarget as Button).name)
			{
				case "purchase":
					BillingManager.instance.purchase();
					break;
				
				case "sura":
					UserModel.instance.navigationMode = {value:"sura_navi"};//, {value:"juze_navi"};
					AppModel.instance.navigator.activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
					break;
				
				case "first":
					UserModel.instance.setLastItem(1, 1);
					UserModel.instance.dispatchEventWith(UserEvent.SET_ITEM);
					break;
				
				
			}
		}
		
		private function buttons_creationCompjleteHandler(event:Event):void
		{
			var btn:Button = event.currentTarget as Button;
			var fd2:FontDescription = new FontDescription("SourceSansPro", FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			var fe:ElementFormat = new ElementFormat(fd2, uint(UserModel.instance.fontSize*1.1), 0xFFFFFF);
			var fd:ElementFormat = new ElementFormat(fd2, uint(UserModel.instance.fontSize*1.1), BaseMaterialTheme.DARK_DISABLED_TEXT_COLOR);
			btn.disabledLabelProperties.bidiLevel = btn.downLabelProperties.bidiLevel = btn.defaultLabelProperties.bidiLevel = AppModel.instance.ltr ? 0 : 1;
			btn.defaultLabelProperties.elementFormat = fe;
			btn.downLabelProperties.elementFormat = fd;
			btn.disabledLabelProperties.elementFormat = fe;
			
			//var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			//skinSelector.defaultValue = new Quad(1,1);
			//btn.stateToSkinFunction = skinSelector.updateValue;
		}

	}
}