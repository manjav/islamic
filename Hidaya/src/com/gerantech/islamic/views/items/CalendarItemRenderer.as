package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.themes.MaterialTheme;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.globalization.StringTools;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	
	import mx.utils.StringUtil;
	
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	public class CalendarItemRenderer extends BaseCustomItemRenderer
	{
		private var titleDiplay:RTLLabel;
		private var date:MultiDate;
		private var color:uint;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			height = appModel.sizes.singleLineItem;
			
			date = new MultiDate();
			
			titleDiplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			titleDiplay.layoutData = new AnchorLayoutData(NaN, appModel.sizes.DP16, NaN, appModel.sizes.DP16, NaN, 0);
			addChild(titleDiplay);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			date.setTime(_data);
			setTitleStyle(date.date==appModel.date.date && date.month==appModel.date.month ? BaseMaterialTheme.CHROME_COLOR : BaseMaterialTheme.DESCRIPTION_TEXT_COLOR); 
			switch(userModel.locale.value)
			{
				case "fa_IR":
					titleDiplay.text =  loc("week_day_"+date.day)+" "+StrTools.getNumber(date.dateShamsi)+" "+loc("month_p_"+date.monthShamsi)	+ " " + StrTools.getNumber(date.fullYearShamsi);
					break;
				case "ar_SA":
					titleDiplay.text =  loc("week_day_"+date.day)+" "+StrTools.getNumber(date.dateQamari)+" "+loc("month_i_"+date.monthQamari)	+ " " + StrTools.getNumber(date.fullYearQamari);
					break;
				default:
					titleDiplay.text =  loc("week_day_"+date.day)+" "+date.date+" "+loc("month_g_"+date.month) + ", " + StrTools.getNumber(date.fullYear);
					break;
			}	
		}
		
		private function setTitleStyle(color:uint):void
		{
			if(this.color == color)
				return;
			
			this.color = color;
			titleDiplay.fontDescription = new FontDescription(titleDiplay.fontFamily, color==BaseMaterialTheme.CHROME_COLOR?"bold":"normal", titleDiplay.fontPosture, FontLookup.EMBEDDED_CFF);
			titleDiplay.elementFormat = new ElementFormat(titleDiplay.fontDescription, titleDiplay.fontSize, color);
		}
		
		
	}
}