package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.EventsProvider;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.ImageLoader;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import com.gerantech.islamic.models.UserModel;

	public class WeekCalItemRenderer extends BaseCustomItemRenderer
	{
		private var background:ImageLoader;
		private var titleDiplay:RTLLabel;
		
		private var todayFontDescription:FontDescription;
		private var otherFontDescription:FontDescription;
		
		private var _currentElementFormat:String;
		private var elementFormat_selected_today:ElementFormat;
		private var elementFormat_selected_other:ElementFormat;
		private var elementFormat_normal_today:ElementFormat;
		private var elementFormat_normal_other:ElementFormat;
		
		private var firstLayoutData:AnchorLayoutData;
		private var normalLayoutData:AnchorLayoutData;
		private var monthDiplay:RTLLabel;
		private var elementFormat_selected_first:ElementFormat;
		private var elementFormat_normal_first:ElementFormat;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			width = appModel.sizes.width/7;
			height = appModel.sizes.DP32;
			
			background = new ImageLoader();
			background.visible = false;
			background.source = Assets.getTexture("action");
			background.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(background);

			firstLayoutData = new AnchorLayoutData(NaN, NaN, appModel.sizes.getPixelByDP(1), NaN);
			normalLayoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, NaN, appModel.sizes.getPixelByDP(1));
			
			titleDiplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, "center");
			titleDiplay.width = width;
			titleDiplay.x = appModel.ltr ? 0 : width;
			titleDiplay.scaleX = appModel.ltr ? 1 : -1;
			titleDiplay.layoutData = normalLayoutData;
			addChild(titleDiplay);
			
			monthDiplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, "center", null, false, null, 0.7);
			monthDiplay.width = width;
			monthDiplay.x = appModel.ltr ? 0 : width;
			monthDiplay.scaleX = appModel.ltr ? 1 : -1;
			monthDiplay.layoutData = new AnchorLayoutData(appModel.sizes.getPixelByDP(1), NaN, NaN, NaN);;
			
			todayFontDescription = new FontDescription (titleDiplay.fontFamily, "bold",		titleDiplay.fontPosture, FontLookup.EMBEDDED_CFF);
			otherFontDescription = new FontDescription (titleDiplay.fontFamily, "normal",	titleDiplay.fontPosture, FontLookup.EMBEDDED_CFF);
			
			elementFormat_selected_today =	new ElementFormat(todayFontDescription, appModel.sizes.orginalFontSize*1.2,	BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			elementFormat_selected_other =	new ElementFormat(otherFontDescription, appModel.sizes.orginalFontSize*1.0,	BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			elementFormat_normal_today =	new ElementFormat(todayFontDescription, appModel.sizes.orginalFontSize*1.2,	BaseMaterialTheme.PRIMARY_TEXT_COLOR);
			elementFormat_normal_other =	new ElementFormat(otherFontDescription, appModel.sizes.orginalFontSize*1.0,	BaseMaterialTheme.PRIMARY_TEXT_COLOR);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			monthDiplay.removeFromParent();
			
			events.setTime(_data);
			if(events.isFirstDay)
			{
				monthDiplay.text = loc("month_p_"+events.currentMonth);
				addChild(monthDiplay);
			}
			
			titleDiplay.text =  StrTools.getNumber(events.currentDate);

			setTitleStyle(true);
		}

/*	override public function set currentState(value:String):void
		{
			if(_currentState == value)
				return;
			setTitleStyle();
			super.currentState = value;
		}*/
		
		override public function set isSelected(value:Boolean):void
		{
			if(super.isSelected == value)
				return;
			
			super.isSelected = value;
			setTitleStyle();
		}
		
		private function setTitleStyle(force:Boolean=false):void
		{
			var elFrm:String = "elementFormat_"+(isSelected?"selected_":"normal_")+(events.isToday?"today":"other");
			background.visible = isSelected;
			if(elFrm == _currentElementFormat && !force)
				return;
			
			//trace(date.dateShamsi, currentState)
			_currentElementFormat = elFrm;
			titleDiplay.layoutData = !isSelected&&events.isFirstDay?firstLayoutData:normalLayoutData;
			monthDiplay.visible = !isSelected&&events.isFirstDay;
			titleDiplay.elementFormat = this[_currentElementFormat];
		}
		
		static public function get events():EventsProvider
		{
			return UserModel.instance.timesModel.events;
		}

	}
}