package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.headers.CalendarHeader;
	import com.gerantech.islamic.views.items.CalendarItemRenderer;
	import com.gerantech.islamic.views.items.WeekCalItemRenderer;
	import com.gerantech.islamic.views.lists.FastList;
	import com.gerantech.islamic.views.lists.QList;

	import feathers.controls.ImageLoader;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;

	import flash.geom.Point;
	import flash.utils.getTimer;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.DropShadowFilter;

	public class CalendarScreen extends BaseCustomPanelScreen
	{
		public var date:Date;
		private var weekList:FastList;
		private var weekLayout:TiledRowsLayout;
		private var times:Vector.<Number>;
		private var calHeader:CalendarHeader;
		private var list:QList;
		private var scrollTimeoutID:uint;
		private var firstItemIndex:int = -1;
		private var actionButton:FlatButton;
		private var actionButtonShown:Boolean;
		
		private var weekCollection:ListCollection;
		private var daysCollection:ListCollection;
		private var dayTime:Number;
		private var region:Point;
		private var todayIndex:uint;
		
		override protected function initialize():void
		{
			super.initialize();
			title = loc(appModel.PAGE_CALENDAR);
			layout = new AnchorLayout();

			var startOfWeek:uint = appModel.ltr ? 0 : 6;
			var passedDays:uint = 140; // passed day must be factor 7 for week list alignment
			dayTime = date.getTime();
			region = new Point();
			times = getTimes(startOfWeek-date.day-passedDays, 350);
			daysCollection = new ListCollection(times);
			todayIndex = passedDays-startOfWeek;

			calHeader = new CalendarHeader();
			calHeader.layoutData = new AnchorLayoutData(0,0,NaN,0);
			addChild(calHeader);
			
			weekLayout = new TiledRowsLayout();
			weekLayout.useSquareTiles = false;
			weekLayout.typicalItemWidth = weekLayout.typicalItemHeight = Math.min(appModel.sizes.width, appModel.sizes.height)/7;
			weekLayout.requestedColumnCount = 7;

			weekList = new FastList();
			weekList.alignPivot("right", "top");
			weekList.backgroundSkin = new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR);
			weekList.backgroundSkin.alpha = 0.1;
			weekList.interactionMode = "mouse";
			weekList.layout = weekLayout;
			weekList.layoutData = new AnchorLayoutData(calHeader.height, 0, NaN, 0);
			weekList.height = Math.min(appModel.sizes.DP32 * 4, appModel.sizes.height/4);
			weekList.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			weekList.itemRendererFactory = function():IListItemRenderer
			{
				return new WeekCalItemRenderer();
			}
			weekList.isQuickHitAreaEnabled = false;
			weekList.addEventListener(Event.TRIGGERED, weekList_triggeredHandler);
			addChild(weekList);
			
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
			var shadow:ImageLoader = new ImageLoader();
			shadow.source = Assets.getTexture("shadow");
			shadow.maintainAspectRatio = false;
			shadow.layoutData = new AnchorLayoutData(weekList.height+calHeader.height,0,NaN,0);
			shadow.height = appModel.sizes.DP8;
			addChild(shadow);
			
			list = new QList();
			list.layoutData = new AnchorLayoutData(weekList.height+calHeader.height,0,0,0);
			list.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new CalendarItemRenderer();
			}
			list.addEventListener(Event.CHANGE, list_changeHandler);
			addChild(list);
			
			actionButton = new FlatButton("calendar_today_white", "action_accent", false, 1, 1);
			actionButton.iconScale = 0.3;
			actionButton.width = actionButton.height = appModel.sizes.toolbar;
			actionButton.filter = new DropShadowFilter(appModel.sizes.getPixelByDP(2), 90*(Math.PI/180), 0, 0.4, 3);
			actionButton.addEventListener(Event.TRIGGERED, actionButton_triggerd);
			actionButton.layoutData = new AnchorLayoutData(NaN, appModel.sizes.DP16, NaN);
			actionButton.y = appModel.sizes.height+appModel.sizes.toolbar*2;
			addChild(actionButton);
		}

		private function transitionInCompleteHandler():void
		{
			trace(" --  Calendar tc1", getTimer()-Hidaya.ft);
			
			weekList.scaleX = appModel.ltr ? 1 : -1;
			weekList.alignPivot("right", "top");
			weekList.alpha = 0;
			Starling.juggler.tween(weekList, 0.3, {alpha:1});
			weekList.dataProvider = daysCollection;
			//weekList.scrollToDisplayIndex(todayIndex);
			//weekList.selectedIndex = todayIndex;
			trace(" --  weekList data set", getTimer()-Hidaya.ft);

			list.alpha = 0;
			Starling.juggler.tween(list, 0.4, {alpha:1, delay:0.1});
			list.dataProvider = daysCollection;
			//list.verticalScrollPosition = todayIndex * CalendarItemRenderer.HEIGHT;
			//list.addEventListener(Event.SCROLL, list_scrollHandler);
			trace(" --  list data set", getTimer()-Hidaya.ft);
			
			//daysCollection.addAll(new ListCollection(getTimes(region.y, 500)));
			trace(" --  data added", getTimer()-Hidaya.ft);
			gotoDay(userModel.timesModel.date.middleTime);
			//showActionButton(true);
		}
		
		private function list_scrollHandler(event:Event):void
		{
			var f:CalendarItemRenderer = list.firstItem as CalendarItemRenderer;
			if(f.index == firstItemIndex)
				return;
			
			firstItemIndex = f.index;
			weekList.scrollToDisplayIndex(firstItemIndex, 0.5);
			weekList.selectedIndex = firstItemIndex;
			
			//updateTimes(f.index);	
			showActionButton(times[firstItemIndex] != userModel.timesModel.date.firstTime);
		}

		// toggle appearance of action button
		private function showActionButton(show:Boolean):void
		{
			if(actionButtonShown == show)
				return;
			
			actionButtonShown = show;
			
			if(actionButtonShown)
				Starling.juggler.tween(actionButton, 0.4, {y:appModel.sizes.height - appModel.sizes.DP16 - appModel.sizes.toolbar, transition:Transitions.EASE_OUT});
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
		
		private function gotoDay(time:Number, duration:Number=0.5):void
		{
			list.removeEventListener(Event.SCROLL, list_scrollHandler);
			var index:int = times.indexOf(time);
			var newPosition:Number = Math.min(index*CalendarItemRenderer.HEIGHT, times.length*CalendarItemRenderer.HEIGHT-list.height);
			
			if(duration == 0)
				list.verticalScrollPosition = newPosition;
			else
			{
				//reduce distance for performance 
				if(Math.abs(list.verticalScrollPosition-newPosition)>10)
					list.verticalScrollPosition -= (list.verticalScrollPosition-newPosition)*0.9;
				var tw:Tween = new Tween(list, duration, Transitions.EASE_OUT);
				tw.animate("verticalScrollPosition", newPosition);
				tw.onComplete = function ():void
				{
					list.addEventListener(Event.SCROLL, list_scrollHandler);
				};
				Starling.juggler.add(tw);
			}
			
			weekList.scrollToDisplayIndex(index, duration);
			weekList.selectedIndex = index;
		}
		
		/**
		 * action button click handler
		 */
		private function actionButton_triggerd(event:Event):void
		{
			gotoDay(userModel.timesModel.date.middleTime);
			showActionButton(false);
		}
		
		/**
		 * every page that need to custom toolbar, must call this overrided method
		 */
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.accessoriesData.push(new ToolbarButtonData(appModel.PAGE_SETTINGS, "setting", toolbarButtons_triggerdHandler));
		}
		
		/**
		 * all toobar buttons click handler
		 */
		private function toolbarButtons_triggerdHandler(item:ToolbarButtonData):void
		{
			switch(item.name)
			{
				case appModel.PAGE_SETTINGS:
					var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_SETTINGS);
					screenItem.properties = {mode : SettingsScreen.MODE_CALENDAR};
					appModel.navigator.pushScreen(appModel.PAGE_SETTINGS);
					break;
				
				default:
					appModel.navigator.pushScreen(item.name);
					break;
			}
		}
		
		/**
		 * lazy loading times for bot lists
		 */
		private function updateTimes(index:int):void
		{
			// fill passed days
			if(index==0)
			{
				list.removeEventListener(Event.SCROLL, list_scrollHandler);
				daysCollection.addAllAt(new ListCollection(getTimes(region.x-14, 14)), 0);
				gotoDay(times[index + 14], 0);
				list.addEventListener(Event.SCROLL, list_scrollHandler);
			}
			// fill next days
			if(index > times.length-7)
			{
				daysCollection.addAll(new ListCollection(getTimes(region.y, 14)));
			}
		}
		
		/**
		 * provide array of times by index of start day in calendar
		 */
		private function getTimes(start:int, length:int):Vector.<Number>
		{
			// set region of days
			if(start < region.x) 
				region.x = start;
			if(start+length > region.y)
				region.y = start+length;
			//trace(region);
			
			var ret:Vector.<Number> = new Vector.<Number>();
			for(var i:uint=0; i<length; i++)
				ret[i] = dayTime + Time.DAY_TIME_LEN * (start+i);
			return ret;
		}
	}
}