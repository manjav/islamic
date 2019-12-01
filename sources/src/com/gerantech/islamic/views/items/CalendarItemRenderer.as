package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.EventsProvider;
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

	public class CalendarItemRenderer extends BaseCustomItemRenderer
	{
		private var titleDiplay:RTLLabel;
		private var messageDisplay:RTLLabel;
		private var vlayout:VerticalLayout;
		private var header:LayoutGroup;
		private var skin:Quad;
		private var skins:Array;
		private var skinIndex:int = -1;
	
		static public function get HEIGHT():uint
		{
			return AppModel.instance.sizes.threeLineItem * 1.4;
		}

		static public function get events():EventsProvider
		{
			return UserModel.instance.timesModel.events;
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
			
			skins = [new Quad(1, 1, BaseMaterialTheme.ACCENT_COLOR), new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR), new Quad(1, 1, BaseMaterialTheme.DARK_TEXT_COLOR)];
			
			header = new LayoutGroup();
			header.layoutData = new VerticalLayoutData(100);
			header.layout = new AnchorLayout();
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
			
			events.setTime(_data);
			setHeader(events.isToday ? 2 : (events.isHoliday ? 0 : 1));
			titleDiplay.text = events.mainDateString;
			messageDisplay.visible = false;
			messageDisplay.text = events.secondaryDatesString + "\n" + events.eventsString + "\n" + events.googleEventsString;
		}
		
		private function setHeader(skinIndex:int):void
		{
			if(this.skinIndex == skinIndex)
				return;
			this.skinIndex = skinIndex;
			header.backgroundSkin = this.skins[skinIndex];
		}
		
		override protected function commitAfterStopScrolling():void
		{
			messageDisplay.visible = true;
			messageDisplay.alpha = 0;
			Starling.juggler.tween(messageDisplay, 0.2, {alpha:1});
		}
	}
}