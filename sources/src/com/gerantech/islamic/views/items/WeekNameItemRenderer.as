package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	public class WeekNameItemRenderer extends BaseCustomItemRenderer
	{
		private var titleDiplay:RTLLabel;
		override protected function initialize():void
		{
			super.initialize();

			layout = new AnchorLayout();
			width = appModel.sizes.width/7;
			
			titleDiplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR, "center", null, false, null, 0.8, null, "bold");
			titleDiplay.layoutData = new AnchorLayoutData(NaN, appModel.sizes.getPixelByDP(1), NaN, appModel.sizes.getPixelByDP(1), NaN, 0);
			addChild(titleDiplay);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			titleDiplay.text = loc("week_day_"+_data);
		}
	}
}