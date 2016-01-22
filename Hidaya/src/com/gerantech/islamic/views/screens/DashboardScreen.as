package com.gerantech.islamic.views.screens
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Location;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.Dashboard;
	import com.gerantech.islamic.views.items.DashboardItemRenderer;
	import com.gerantech.islamic.views.popups.BasePopUp;
	import com.gerantech.islamic.views.popups.GeoPopup;
	
	import flash.net.FileReference;
	
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class DashboardScreen extends BaseCustomScreen
	{
		private var list:List;
		private var listLayout:TiledRowsLayout;
		private var dashboard:Dashboard;
		override protected function initialize():void
		{
			
			super.initialize();
			layout = new AnchorLayout();
			backButtonHandler = null;
			
			dashboard = new Dashboard();
			dashboard.layoutData = new AnchorLayoutData(0,0,NaN,0);
			addChild(dashboard);
			
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR); 
			
			listLayout = new TiledRowsLayout();
			listLayout.useSquareTiles = false;
			//listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_BOTTOM
			//listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_BOTTOM;
			listLayout.paddingTop = appModel.sizes.orginalHeightFull//-appModel.sizes.orginalHeight/1.5;
			listLayout.typicalItemWidth = listLayout.typicalItemHeight = appModel.sizes.DP72*3;
			
			list = new List();
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.layout = listLayout;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.snapToPages = true;
			list.pageHeight = appModel.sizes.orginalWidth/3*1.4
			list.itemRendererFactory = function ():IListItemRenderer
			{
				return new DashboardItemRenderer();
			}
			list.dataProvider = new ListCollection(ConfigModel.instance.parts);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			list.addEventListener(Event.SCROLL, list_scrollHandler);
			addChild(list);
			appModel.toolbar.y = -appModel.sizes.toolbar;
			addEventListener(FeathersEventType.TRANSITION_IN_START, transitionInStartHandler);
		}
		
		private function list_scrollHandler():void
		{
			var scrollPos:Number = appModel.sizes.dashboard-list.verticalScrollPosition-appModel.sizes.toolbar;
			appModel.toolbar.y = Math.min(0, Math.max(-appModel.sizes.toolbar, -scrollPos));//trace(appModel.toolbar.y)
			dashboard.alpha = scrollPos/(appModel.sizes.dashboard-appModel.sizes.toolbar);
		}
		
		private function transitionInStartHandler():void
		{
			Starling.juggler.tween(listLayout, 0.7, {delay:0.3, paddingTop:appModel.sizes.dashboard, transition:Transitions.EASE_OUT});
		}
		
		private function list_changeHandler(event:Event):void
		{
			switch(list.selectedItem.title)
			{
				case "page_greeting":
					new FileReference().browse();
					break;
				case "page_finder":
					var geoPopup:BasePopUp = AppController.instance.addPopup(GeoPopup);
					geoPopup.addEventListener(Event.COMPLETE, geoPopup_completeHandler);
					break;
				case appModel.PAGE_TIMES:
					var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_TIMES);
					screenItem.properties = {date:appModel.date};
					appModel.navigator.pushScreen(appModel.PAGE_TIMES); 
					break;
				default:
					appModel.navigator.pushScreen(list.selectedItem.title);
					break;
			}
			list.removeEventListener(Event.CHANGE, list_changeHandler);
			list.selectedIndex = -1;
			list.addEventListener(Event.CHANGE, list_changeHandler);
		}
		
		private function geoPopup_completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, geoPopup_completeHandler);
			var location:Location = event.data as Location;
			NativeAbilities.instance.runIntent("android.intent.action.VIEW", "http://www.google.com/maps/search/mosque/@"+location.latitude+","+location.longitude+",18z")
		}
		
		override protected function createToolbarItems():void
		{
			appModel.toolbar.resetItem();
			appModel.toolbar.accessoriesData.push(new ToolbarButtonData("page_about", "info", toolbarButtons_triggerdHandler));
		}
		private function toolbarButtons_triggerdHandler(item:ToolbarButtonData):void
		{
			appModel.navigator.pushScreen(item.name);
		}
	}
	

	
}