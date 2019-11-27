package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Time;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.MetricUtils;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.ImageLoader;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;

	import gt.utils.GTStringUtils;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import feathers.layout.VerticalAlign;

	public class TimeItemRenderer extends BaseCustomItemRenderer
	{
		private var iconDisplay:ImageLoader;
		private var nameDisplay:RTLLabel;
		private var timeDisplay:RTLLabel;
		private var editDisplay:ImageLoader;
		
		override protected function initialize():void
		{
			super.initialize();
			var sizes:MetricUtils = appModel.sizes;
			
			var hlayout:HorizontalLayout = new HorizontalLayout();
			hlayout.verticalAlign = VerticalAlign.MIDDLE;
			hlayout.gap = sizes.DP8;
			hlayout.firstGap = appModel.ltr ? sizes.DP8 : sizes.DP24;
			hlayout.lastGap = appModel.ltr ? sizes.DP24 : sizes.DP8;
			hlayout.paddingLeft = appModel.ltr ? sizes.DP8 : sizes.DP16;
			hlayout.paddingRight = appModel.ltr ? sizes.DP16 : sizes.DP8;

			layout = hlayout;
			
			var elements:Array = new Array();
			
			height = sizes.DP48;
			
			iconDisplay = new ImageLoader();
			iconDisplay.layoutData = new HorizontalLayoutData(NaN, 100);
			iconDisplay.width = height-sizes.DP24;
			elements.push(iconDisplay);

			nameDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0, null, "bold");
			nameDisplay.layoutData = new HorizontalLayoutData(100);
			elements.push(nameDisplay);
			
			timeDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", "ltr", false, null, 0, null, "bold");
			timeDisplay.width = sizes.DP64;
			elements.push(timeDisplay);
			
			editDisplay = new ImageLoader();
			editDisplay.source = Assets.getTexture("pencil_gray");
			editDisplay.width = height/3;
			elements.push(editDisplay);
			
			if(!appModel.ltr)
				elements.reverse();
			
			for each(var e:DisplayObject in elements) 
				addChild(e);
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
			
			var time:Time = _data as Time;
			
			if(backgroundSkin == null)
			{
				createSkin();
				if(time.isPending(userModel.timesModel.date.dateClass))
				{
					skin.setTextureForState("normal", Assets.getBackgroundTexture("down"));
				}
				if(time.pending)
				{
					var skinTween:Tween = new Tween(skin, 1.0, Transitions.EASE_OUT);
					skin.alpha = 0;
					skinTween.delay = 1;
					skinTween.repeatCount = 5;
					skinTween.fadeTo(1);
					Starling.juggler.add(skinTween);	
				}
				skin.defaultTexture = skin.getTextureForState(currentState);
			}
			
			//alpha = index%3==0 ? 1 : 0.6
			nameDisplay.text = loc("pray_time_"+index);
			timeDisplay.text = StrTools.getNumber(GTStringUtils.dateToTime(time.date));
			iconDisplay.source = Assets.getTexture("time-"+index);
			nameDisplay.alpha = timeDisplay.alpha = iconDisplay.alpha = time.enabled ? 1 : 0.6;
		}
		
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			if(value==lastState)
				return;
			
			skin.defaultTexture = skin.getTextureForState(value);
		}
	}
}