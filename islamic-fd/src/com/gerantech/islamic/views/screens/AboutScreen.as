package com.gerantech.islamic.views.screens
{
	
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.Spacer;
	import com.gerantech.islamic.views.items.DrawerItemRenderer;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.events.Event;
	
	public class AboutScreen extends BaseCustomPanelScreen
	{
		private var list:List;
		
		override protected function initialize():void
		{
			super.initialize();
			verticalScrollPolicy = SCROLL_POLICY_AUTO;
			
			var mlayout:VerticalLayout = new VerticalLayout();
			mlayout.lastGap = mlayout.firstGap = appModel.sizes.border;
			mlayout.gap = -appModel.sizes.border;
			mlayout.padding = appModel.sizes.border*2;
			mlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout = mlayout;
			
			createAboutHeader();
			addChild(new Spacer());
			
			var dec:RTLLabel = new RTLLabel(loc("app_descript")+"\n"+loc("alpha_popup_message")+"\n\n", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "justify", null, true, null, 0.9);
			dec.layoutData = new VerticalLayoutData(94);
			addChild(dec);
			
			addChild(new Spacer());
			createList();
			addChild(new Spacer());
		}
		
		private function createAboutHeader():void
		{

			var appIcon:ImageLoader = new ImageLoader();
			appIcon.source = "app:/com/gerantech/islamic/assets/images/icon/icon-192.png";
			appIcon.width = appIcon.height = appModel.sizes.twoLineItem;
			addChild(appIcon);
			
			var appName:RTLLabel = new RTLLabel(loc("app_title"), BaseMaterialTheme.PRIMARY_TEXT_COLOR, "center", null, true, null, 0, null, "bold");
			addChild(appName);
			addChild(new Spacer());
			
			var appVersion:RTLLabel = new RTLLabel(StrTools.getNumberFromLocale(appModel.descriptor.versionLabel), BaseMaterialTheme.PRIMARY_TEXT_COLOR, "center", null, false, null, 0.8);
			addChild(appVersion);
			addChild(new Spacer());
			
			var appCopyRight:RTLLabel = new RTLLabel(ConfigModel.instance.market, BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", null, false, null, 0.7);
			addChild(appCopyRight);
		
		}/*
		
		private function createAboutHeader():void
		{
			var headerGroup:LayoutGroup = new LayoutGroup();
			var hlayout:HorizontalLayout = new HorizontalLayout();
			hlayout.gap = appModel.sizes.border*3;
			hlayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			headerGroup.layout = hlayout;
			addChild(headerGroup);
			
			var appIcon:ImageLoader = new ImageLoader();
			appIcon.source = "assets/images/icon/icon-192.png";
			//appIcon.source = Assets.getTexture("icon_144");
			appIcon.width = appIcon.height = appModel.sizes.itemHeight;
			
			var appDetails:LayoutGroup = new LayoutGroup();
			var dLayout:VerticalLayout = new VerticalLayout();
			dLayout.horizontalAlign = appModel.align;
			appDetails.layout = dLayout
			appDetails.layoutData = new HorizontalLayoutData(100,100);
			
			var appName:RTLLabel = new RTLLabel(loc("app_title"), 0, null, null, false, null, 0, null, "bold");
			appDetails.addChild(appName);
			
			var appVersion:RTLLabel = new RTLLabel(appModel.descriptor.versionLabel, 0, null, null, false, null, userModel.fontSize*0.8);
			appDetails.addChild(appVersion);
			
			var appCopyRight:RTLLabel = new RTLLabel(ConfigModel.instance.market, 0x666666, null, null, false, null, userModel.fontSize*0.8);
			appDetails.addChild(appCopyRight);
			
			headerGroup.addChild(appModel.ltr?appIcon:appDetails);
			headerGroup.addChild(appModel.ltr?appDetails:appIcon);
		}*/
		
		private function createList():void
		{
			var data:Array = [{
				title: "rate_us",
				icon: "star"
				},
				{
					title: "share_us",
					icon: "share_variant"
				},
				{
					title: "contact_us",
					icon: "email"
				}];
			
			list = new List();
			list.layoutData = new VerticalLayoutData(100);
			list.dataProvider = new ListCollection(data);
			list.verticalScrollPolicy = list.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new DrawerItemRenderer(appModel.ltr);
			};
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
		}
		
		private function list_changeHandler( event:Event ):void
		{
			if(list.selectedItem)
			switch(list.selectedItem.title)
			{
				case "rate_us":
					BillingManager.instance.rate();
					break;
				case "share_us":
					BillingManager.instance.share();
					break;
				case "contact_us":
/*					var headers:String = 'Bcc: $emailList';
					headers += "From: no-reply@thepartyfinder.co.uk\r\nX-Mailer: php";
					headers += "MIME-Version: 1.0\r\n";
					headers += "Content-type:text/html;charset=UTF-8\r\n";*/
					var url:String = "mailto:hidaya@gerantech.com?subject=(ver: "+appModel.descriptor.versionNumber+" "+(userModel.premiumMode?"pro":"free")+" ,market: "+appModel.descriptor.market+")";
					navigateToURL(new URLRequest(url));
						break;
			}
			list.selectedIndex = -1;
		}
	}
}