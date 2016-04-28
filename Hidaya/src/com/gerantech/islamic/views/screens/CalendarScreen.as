package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.headers.CalendarHeader;
	import com.gerantech.islamic.views.items.CalendarItemRenderer;
	import com.gerantech.islamic.views.items.WeekCalItemRenderer;
	import com.gerantech.islamic.views.lists.QList;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.filters.BlurFilter;

	public class CalendarScreen extends BaseCustomPanelScreen
	{
		public var date:Date;
		private var weekList:List;
		private var weekLayout:TiledRowsLayout;
		private var times:Vector.<Number>;
		private var calHeader:CalendarHeader;
		private var list:QList;
		private var scrollTimeoutID:uint;
		private var firstItemIndex:int = -1;
		private var actionButton:FlatButton;
		private var actionButtonShown:Boolean;
		
		override protected function initialize():void
		{
			super.initialize();
			title = loc(appModel.PAGE_CALENDAR);
			layout = new AnchorLayout();

			var startOfWeek:uint = appModel.ltr ? 0 : 6;
			var calLen:uint = (5*21)+(date.day-startOfWeek);
			// create data for lists
			var t:Number = date.getTime();
			times = new Vector.<Number>(calLen*2, true);
			for(var i:uint=0; i<calLen*2; i++)
				times[i] = t + Time.DAY_TIME_LEN*(i-calLen);
			
			calHeader = new CalendarHeader();
			calHeader.layoutData = new AnchorLayoutData(0,0,NaN,0);
			
			weekLayout = new TiledRowsLayout();
			weekLayout.useSquareTiles = false;
			weekLayout.typicalItemWidth = weekLayout.typicalItemHeight = Math.min(appModel.sizes.width, appModel.sizes.height)/7;
			weekLayout.requestedColumnCount = 7;

			weekList = new List();
			weekList.backgroundSkin = new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR);
			weekList.backgroundSkin.alpha = 0.1;
			weekList.layout = weekLayout;
			weekList.layoutData = new AnchorLayoutData(calHeader.height, 0, NaN, 0);
			weekList.height = appModel.sizes.getPixelByDP(100);
			weekList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			weekList.itemRendererFactory = function():IListItemRenderer
			{
				return new WeekCalItemRenderer();
			}
			weekList.scaleX = appModel.ltr ? 1 : -1;
			weekList.pivotX = appModel.sizes.width/2
			weekList.dataProvider = new ListCollection(times);
			weekList.scrollToDisplayIndex(calLen);
			weekList.selectedIndex = calLen;
			weekList.isQuickHitAreaEnabled = false
			weekList.addEventListener(Event.TRIGGERED, weekList_triggeredHandler);
			addChild(weekList);

			list = new QList();
			list.layoutData = new AnchorLayoutData(appModel.sizes.getPixelByDP(100)+calHeader.height,0,0,0);
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new CalendarItemRenderer();
			}
			list.visible = false;
			list.alpha = 0;
			list.dataProvider = new ListCollection(times);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
			
			addChild(calHeader);
			
			var shadow:ImageLoader = new ImageLoader();
			shadow.source = Assets.getTexture("shadow");
			shadow.maintainAspectRatio = false;
			shadow.layoutData = new AnchorLayoutData(appModel.sizes.getPixelByDP(100)+calHeader.height,0,NaN,0);
			shadow.height = appModel.sizes.DP8;
			addChild(shadow);
			
			actionButton = new FlatButton("calendar_today_white", "action_accent", false, 1, 1);
			actionButton.iconScale = 0.3;
			actionButton.width = actionButton.height = AppModel.instance.sizes.toolbar;
			actionButton.filter = BlurFilter.createDropShadow(AppModel.instance.sizes.getPixelByDP(2), 90*(Math.PI/180), 0, 0.4, 3);
			actionButton.addEventListener(Event.TRIGGERED, actionButton_triggerd);
			actionButton.layoutData = new AnchorLayoutData(NaN, appModel.sizes.DP16, NaN);
			//actionButton.visible = false;
			actionButton.y = appModel.sizes.height + appModel.sizes.DP16 - AppModel.instance.sizes.toolbar;
			addChild(actionButton);
			
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}
		
		override protected function stage_resizeHandler(event:Event):void
		{
			weekList.pivotX = appModel.sizes.width/2
			super.stage_resizeHandler(event);
		}
		
		private function transitionInCompleteHandler():void
		{
			list.visible = true;
			Starling.juggler.tween(list, 0.4, {alpha:1, delay:0.1});
			list.verticalScrollPosition = times.length/2*CalendarItemRenderer.HEIGHT;
			list.addEventListener(Event.SCROLL, list_scrollHandler);
		}
		
		private function list_scrollHandler(event:Event):void
		{
			var f:CalendarItemRenderer = list.firstItem as CalendarItemRenderer;
			if(f.index == firstItemIndex)
				return;
			
			firstItemIndex = f.index;
			weekList.scrollToDisplayIndex(firstItemIndex, 0.5);
			weekList.selectedIndex = firstItemIndex;
			//trace(f.index, f.visible, f.titleDiplay.text)	
			
			showActionButton(times[firstItemIndex] != appModel.date.firstTime);
		}
		
		private function showActionButton(param0:Boolean):void
		{
			if(actionButtonShown == param0)
				return;
			
			actionButtonShown = param0;
			
			if(actionButtonShown)
				Starling.juggler.tween(actionButton, 0.4, {y:appModel.sizes.height - appModel.sizes.DP16 - AppModel.instance.sizes.toolbar, transition:Transitions.EASE_OUT});
			else
			{
				var tw:Tween = new Tween(actionButton, 0.4, Transitions.EASE_IN);
				tw.animate("y", appModel.sizes.height+appModel.sizes.toolbar*2);
				tw.delay = 0.2;
				tw.onComplete = function ():void
				{
					actionButtonShown = false;
				};
				Starling.juggler.add(tw);
			}
		}
		
		private function list_changeHandler():void
		{
			var md:MultiDate = new MultiDate();
			md.setTime(list.selectedItem);
			date.setTime(list.selectedItem);
			
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_TIMES);
			screenItem.properties = {date:md};
			appModel.navigator.pushScreen(appModel.PAGE_TIMES); 
 		}
		
		private function weekList_triggeredHandler(event:Event):void
		{
			gotoDay(event.data as Number);
		}
		
		private function gotoDay(time:Number):void
		{
			list.removeEventListener(Event.SCROLL, list_scrollHandler);
			var index:int = times.indexOf(time);
			var newPosition:Number = Math.min(index*CalendarItemRenderer.HEIGHT, times.length*CalendarItemRenderer.HEIGHT-list.height);

			//reduce distance for performance 
			if(Math.abs(list.verticalScrollPosition-newPosition)>10)
				list.verticalScrollPosition -= (list.verticalScrollPosition-newPosition)*0.9;
			var tw:Tween = new Tween(list, 0.4, Transitions.EASE_OUT);
			tw.animate("verticalScrollPosition", newPosition);
			tw.onComplete = function ():void
			{
				list.addEventListener(Event.SCROLL, list_scrollHandler);
			};
			Starling.juggler.add(tw);
			
			weekList.scrollToDisplayIndex(index, 0.5);
			weekList.selectedIndex = index;
		}
		
		private function actionButton_triggerd(event:Event):void
		{
			gotoDay(appModel.date.middleTime);
			showActionButton(false);
		}
		
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.accessoriesData.push(new ToolbarButtonData(appModel.PAGE_SETTINGS, "setting", toolbarButtons_triggerdHandler));
		}
		
		private function toolbarButtons_triggerdHandler(item:ToolbarButtonData):void
		{
			appModel.navigator.pushScreen(item.name);
		}		
		
		
	}
}