package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.DayDataProvider;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class CalendarItemRenderer extends BaseCustomItemRenderer
	{
		private var titleDiplay:RTLLabel;
		private var messageDisplay:RTLLabel;
		private var vlayout:VerticalLayout;
		private var header:LayoutGroup;
		private var todaySkin:Quad;
		private var otherSkin:Quad;

		private var dayData:DayDataProvider;
		private var isToday:Boolean;
		

		public static function get HEIGHT():uint
		{
			return AppModel.instance.sizes.threeLineItem;
		}

		override protected function initialize():void
		{			
			super.initialize();
			vlayout = new VerticalLayout();
			vlayout.gap = vlayout.paddingTop = vlayout.paddingBottom = appModel.sizes.DP4;
			//vlayout.paddingLeft = vlayout.paddingRight = appModel.sizes.DP16;
			vlayout.horizontalAlign = HorizontalAlign.CENTER;
			layout = vlayout;
			height = HEIGHT;
			
			dayData = new DayDataProvider();
			
			todaySkin = new Quad(1,1, BaseMaterialTheme.ACCENT_COLOR);
			otherSkin = new Quad(1,1, BaseMaterialTheme.CHROME_COLOR);
			
			header = new LayoutGroup();
			header.layoutData = new VerticalLayoutData(100);
			header.layout = new AnchorLayout();
			header.backgroundSkin = otherSkin;
			addChild(header);
			
			titleDiplay = new RTLLabel("", userModel.nightMode ? BaseMaterialTheme.PRIMARY_TEXT_COLOR : BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR, null, null, true, null, 1, null, "bold");
			titleDiplay.layoutData = new AnchorLayoutData(appModel.sizes.DP8, appModel.sizes.DP16,appModel.sizes.DP8, appModel.sizes.DP16);
			header.addChild(titleDiplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, true, null, 0.8);
			messageDisplay.layoutData = new VerticalLayoutData(((appModel.sizes.width-appModel.sizes.DP32)/appModel.sizes.width)*100, 100);
			addChild(messageDisplay);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			dayData.setTime(_data);
			setHeader(dayData.isToday);
			titleDiplay.text = dayData.mainDateString;
			messageDisplay.visible = false;
		}
		
		private function setHeader(value:Boolean):void
		{
			if(isToday == value)
				return;
			
			isToday = value;
			header.backgroundSkin = isToday ? todaySkin : otherSkin
			
		}
		
		override protected function commitAfterStopScrolling():void
		{
			if(!dayData.updated)
			{
				dayData.addEventListener("update", dayData_updateHandler);
				return;
			}
			dayData_updateHandler(null);
		}
		
		private function dayData_updateHandler(event:Event):void
		{//trace(dayData.mainDateString, dayData.currentDate);
			dayData.removeEventListener("update", dayData_updateHandler);
			
			messageDisplay.text = dayData.secondaryDatesString + "\n" + dayData.eventsString + "\n" + dayData.googleEventsString;
			messageDisplay.visible = true;
			messageDisplay.alpha = 0;
			Starling.juggler.tween(messageDisplay, 0.2, {alpha:1});
		}
	}
}