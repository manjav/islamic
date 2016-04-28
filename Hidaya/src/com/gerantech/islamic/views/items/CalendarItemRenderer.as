package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.DayDataProvider;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
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
			vlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout = vlayout;
			height = HEIGHT;
			
			dayData = new DayDataProvider();
			dayData.addEventListener("update", dayData_updateHandler);
			
			todaySkin = new Quad(1,1, BaseMaterialTheme.ACCENT_COLOR);
			otherSkin = new Quad(1,1, BaseMaterialTheme.CHROME_COLOR);
			
			header = new LayoutGroup();
			header.layoutData = new VerticalLayoutData(100);
			header.layout = new AnchorLayout();
			addChild(header);
			
			titleDiplay = new RTLLabel("", 0xFFFFFF, null, null, true, null, 1, null, "bold");
			titleDiplay.layoutData = new AnchorLayoutData(0,appModel.sizes.DP16,0,appModel.sizes.DP16);
			header.addChild(titleDiplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, true, null, 0.8);
			messageDisplay.layoutData = new VerticalLayoutData(((appModel.sizes.width-appModel.sizes.DP32)/appModel.sizes.width)*100, 100);
			addChild(messageDisplay);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			dayData.setTime(_data);
			header.backgroundSkin = dayData.isToday ? todaySkin : otherSkin;
		}
		
		private function dayData_updateHandler(event:Event):void
		{//trace(dayData.mainDateString, dayData.currentDate);
			titleDiplay.text = dayData.mainDateString;
			messageDisplay.text = dayData.secondaryDatesString + "\n" + dayData.eventsString + "\n" + dayData.googleEventsString;
			/*if(message.length>0)
				message += "\n"+ evStr;
			messageDisplay.text = message;*/
		}
	
	}
}