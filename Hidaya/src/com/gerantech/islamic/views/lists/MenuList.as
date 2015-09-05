package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	import com.gerantech.islamic.views.popups.GotoPopUp;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class MenuList extends List
	{
		private var overlay:FlatButton;
		private var array:Array;
		
		public function MenuList()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var llaouyt:VerticalLayout = new VerticalLayout();
			llaouyt.firstGap = AppModel.instance.itemHeight/4;
			llaouyt.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout = llaouyt;
			
			
			width = Math.min(AppModel.instance.actionHeight*7, AppModel.instance.orginalWidth*0.8);
			array = new Array({value:"goto_popup", icon:Assets.getTexture("jump")}, {value:"sura_navi"}, {value:"juze_navi"}, {value:"page_navi"});
			dataProvider = new ListCollection(array); 
			itemRendererFactory = function():IListItemRenderer
			{
				return new SettingItemRenderer( AppModel.instance.itemHeight*0.75);
			}
			selectedIndex = getSelectedIndex();
			addEventListener(Event.CHANGE, changeHandler);
		}
		
		private function getSelectedIndex():int
		{
			var i:int = 0
			for each(var obj:Object in array)
			{
				if(obj.value==UserModel.instance.navigationMode.value)
					return i;
				i++;
			}
			return -1;
		}		

		
		private function changeHandler(event:Event):void
		{
			switch(selectedItem.value)
			{
				case "page_navi":
				case "sura_navi":
				case "juze_navi":
					/*if(!UserModel.instance.premiumMode)
					{
						var purchaseMessage:String = ResourceManager.getInstance().getString("loc", "purchase_navigation")+"\n"+ResourceManager.getInstance().getString("loc", "purchase_popup_message");
						AppController.instance.alert("purchase_popup_title", purchaseMessage, "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
						return;
					}*/
					UserModel.instance.navigationMode = selectedItem;
					AppModel.instance.navigator.activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
					break;
					
				case "goto_popup":
					if(AppModel.instance.gotoPopUP==null)
					{
						AppModel.instance.gotoPopUP = new GotoPopUp();
						AppModel.instance.gotoPopUP.addEventListener(Event.CLOSE, gotoPopUP_closeHandler);
					}
					PopUpManager.overlayFactory = function():DisplayObject
					{
						overlay = new FlatButton(null, null, true, 0.3, 0.3, 0);
						overlay.addEventListener(Event.TRIGGERED, AppModel.instance.gotoPopUP.close);
						return overlay;
					};
					PopUpManager.addPopUp(AppModel.instance.gotoPopUP);
					AppModel.instance.gotoPopUP.show();
					break;
			}
			dispatchEventWith(Event.CLOSE);
		}		
		
		private function gotoPopUP_closeHandler(event:Event):void
		{
			overlay.removeEventListener(Event.TRIGGERED, gotoPopUP_closeHandler);
			PopUpManager.removePopUp(AppModel.instance.gotoPopUP);
		}		
	}
}