package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.MetricUtils;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import gt.utils.GTStringUtils;
	
	import starling.display.Quad;

	public class TimeItemRenderer extends BaseCustomItemRenderer
	{
		private var iconDisplay:ImageLoader;
		private var nameDisplay:RTLLabel;
		private var timeDisplay:RTLLabel;
		
		public function TimeItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			var sizes:MetricUtils = appModel.sizes;
			
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			height = sizes.singleLineItem;
			
			iconDisplay = new ImageLoader();
			iconDisplay.layoutData = new AnchorLayoutData(NaN, appModel.ltr?NaN:sizes.DP16, NaN, appModel.ltr?sizes.DP16:NaN, NaN, 0);
			iconDisplay.source = Assets.getTexture("compass");
			iconDisplay.width = sizes.DP40;
			addChild(iconDisplay);
			
			nameDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0, null, "bold");
			nameDisplay.layoutData = new AnchorLayoutData(NaN, appModel.ltr?sizes.getPixelByDP(128):sizes.DP72, NaN, appModel.ltr?sizes.DP72:sizes.getPixelByDP(128), NaN, 0);
			addChild(nameDisplay);
			
			timeDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", "ltr");
			timeDisplay.width = sizes.DP56;
			timeDisplay.layoutData = new AnchorLayoutData(NaN, appModel.ltr?sizes.DP64:NaN, NaN, appModel.ltr?NaN:sizes.DP64, NaN, 0);
			addChild(timeDisplay);
			/*
			progressBar = new LinierProgressBar();
			progressBar.fontSize = uint(fontSize*0.9);
			progressBar.layoutData = new VerticalLayoutData(100);
			mainContents.addChild(progressBar)*/;
		}
		
		override protected function commitData():void
		{
			super.commitData();
			if(_data==null || _owner==null)
				return;
			alpha = index%3==0 ? 1 : 0.6
			nameDisplay.text = loc("pray_time_"+index);
			timeDisplay.text = StrTools.getNumber(GTStringUtils.dateToTime(_data as Date))
		}
	}
}