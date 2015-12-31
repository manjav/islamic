package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.Tute_0;
	
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class TutorialItemRenderer extends BasePageItemRenderer
	{
		private var appModel:AppModel;

		private var tute:Tute_0;
		private var nextButton:FlatButton;
		
		public function TutorialItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			appModel = AppModel.instance;
			width = appModel.sizes.width;
			height = appModel.sizes.heightFull;
			layout = new AnchorLayout();
			tute = new Tute_0();
			tute.layoutData = new AnchorLayoutData(0,0,appModel.sizes.twoLineItem,0);
			addChild(tute);
			
			nextButton = new FlatButton("arrow_g_"+(appModel.ltr?"right":"left"), null, true);
			nextButton.width = nextButton.height = appModel.sizes.DP48;
			nextButton.layoutData = new AnchorLayoutData(NaN, appModel.ltr?appModel.sizes.border:NaN, appModel.sizes.border, appModel.ltr?NaN:appModel.sizes.border);
			nextButton.addEventListener(Event.TRIGGERED, nextButton_triggeredHandler);
			addChild(nextButton);
		}
		
		override protected function commitData():void
		{
			super.commitData();
		}
		
		override protected function selfRemovedHandler(event:Event):void
		{
			super.selfRemovedHandler(event);
			Starling.juggler.removeTweens(nextButton);
			//TweenMax.killAll();
		}
		
		override protected function commitAfterStopScrolling():void
		{
			super.commitAfterStopScrolling();
			tute.data = "tute_"+_data;
			
			/*var color:ColorMatrixFilter = new ColorMatrixFilter();
			color.tint(0x00FFEE, 1);
			nextButton.icon.filter = color;*/
			
			nextButton.icon.alpha = 0;
			Starling.juggler.tween(nextButton.icon, 2, {alpha:1, repeatCount:7});
			//tw.repeatCount = 7;
			//var tm:TweenMax = TweenMax.to(nextButton.icon, 2, {alpha:1, ease:"easenone"});
			//tm.repeat = 7;
		}
		
		
		private function nextButton_triggeredHandler():void
		{
			_owner.dispatchEventWith("next");
		}
		
	}
}