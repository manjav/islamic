package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.views.controls.AboutView;
	import com.gerantech.islamic.views.controls.ProfileView;
	import com.gerantech.islamic.views.controls.Spacer;
	import com.gerantech.islamic.views.items.DrawerItemRenderer;
	
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.events.Event;

	public class DrawerList extends ScrollContainer
	{

		private var isLeft:Boolean;
		private var appModel:AppModel;
		private var shadow:ImageLoader;
		private var list:List;
		private var profileView:ProfileView;

		public function DrawerList(isLeft:Boolean)
		{
			this.isLeft = isLeft;
			appModel = AppModel.instance;
			width = Math.min(appModel.itemHeight*5, appModel.orginalWidth*0.8);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var myLayout:VerticalLayout = new VerticalLayout();
			myLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			myLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			myLayout.gap = appModel.border*3;
			layout = myLayout;
			
			profileView = new ProfileView();
			addChild(profileView);
			
			if(!UserModel.instance.premiumMode && ConfigModel.instance.views[ConfigModel.instance.views.length-1].icon!="cart_grey")
				ConfigModel.instance.views.push({icon: "cart_grey", title: "purchase_popup_accept_label"});		

			
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.hasVariableItemDimensions = true;
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new VerticalLayoutData (100);
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.dataProvider = new ListCollection(ConfigModel.instance.views);
			list.verticalScrollPolicy = list.horizontalScrollPolicy = List.SCROLL_POLICY_OFF
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new DrawerItemRenderer(isLeft);
			};
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
			
			addChild(new Spacer());
			
			var about:AboutView = new AboutView();
			about.addEventListener(Event.TRIGGERED, about_triggereddHandler);
			addChild(about);
						
			setTimeout(addShadow, 100);				
		}
		
		private function addShadow():void
		{
			shadow = new ImageLoader();
			shadow.source = Assets.getTexture("shadow_"+appModel.align);
			shadow.delayTextureCreation = true;
			shadow.includeInLayout = false;
			shadow.maintainAspectRatio = false
			shadow.width = appModel.border*2;
			shadow.x = isLeft?width-shadow.width : 0;
			shadow.height = viewPort.height;
			addChild(shadow);
		}
		
		
		public function resetContent():void
		{
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new DrawerItemRenderer(isLeft);
			};
			list.dataProvider = new ListCollection(ConfigModel.instance.views);
			profileView.reload();
			validate();
		}
		
		private function list_changeHandler( event:Event ):void
		{
			if(list.selectedItem==null)
				return;
			
			var stayInDrawer:Boolean;
			switch(list.selectedItem.title)
			{
				case appModel.PAGE_INDEX:
				case appModel.PAGE_BOOKMARKS:
				case appModel.PAGE_SETTINGS:
				case appModel.PAGE_OMEN:
					appModel.navigator.pushScreen(list.selectedItem.title);
					break;
				
				case "purchase_popup_accept_label":
					stayInDrawer = true;
					var purchaseMessage:String = ResourceManager.getInstance().getString("loc", "purchase_repeat")+"\n"+ResourceManager.getInstance().getString("loc", "purchase_popup_message");
					AppController.instance.alert("purchase_popup_title", purchaseMessage, "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
					break;
				
				case "profile":
					stayInDrawer = true;
					//UserModel.instance.profileManager.insertUser();
					break;
				
				default:
					stayInDrawer = true;
					AppController.instance.alert("soon_title", "soon_message");
					break;				
			}
			if(!stayInDrawer)
				AppController.instance.toggleDrawer();
			list.selectedIndex = -1;
		}
		
		private function about_triggereddHandler():void
		{
			appModel.navigator.pushScreen(appModel.PAGE_ABOUT);
			AppController.instance.toggleDrawer();
		}

	}
}
