package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.resources.ResourceManager;
	
	import gt.utils.GTStringUtils;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	
	public class Clock extends Sprite
	{
		private var needleHour:Quad;
		private var needleMinutes:Quad;
		private var needleSecond:Quad;

		private var now:Date;
		private var intervalID:uint;
		private var nextTime:Date;
		private var nextTimeString:String;
		private var partiesContainer:Sprite;
		private var remainingLabel:RTLLabel;
		
		public function Clock()
		{
			partiesContainer = new Sprite();
			addChild(partiesContainer);
			
			//  Create outline circle ---------------------------------------
			//var cmf:ColorMatrixFilter = new ColorMatrixFilter();
			//cmf.adjustBrightness(1);
			for(var i:uint=0; i<8; i++)
			{
				var slice:Sprite = new Sprite();
				var image:Image = new Image(Assets.getTexture("radian_white"));
				image.y = -256;
				image.x = -image.width/2;
				slice.addChild(image);
				slice.rotation = i*22.5*(Math.PI/90);
				//slice.filter = cmf;
				addChild(slice);
			}
			
			//  Create needles ---------------------------------------
			needleHour = createNeedle(10, 140);
			needleMinutes = createNeedle(8, 200);
			needleSecond = createNeedle(6, 250);
			
			//  Create central circle ---------------------------------------
			/*var circle:Image = new Image(Assets.getTexture("page-indicator-selected-skin"));
			circle.smoothing = TextureSmoothing.BILINEAR;
			circle.pivotX = circle.pivotY = circle.width/2;
			circle.width = circle.height = 40;
			circle.filter = cmf;
			addChild(circle);*/
			
			remainingLabel = new RTLLabel("", BaseMaterialTheme.ACCENT_COLOR, "center", "ltr", false, null, 60, null, "bold");
			remainingLabel.width = 512;
			remainingLabel.x = -256;
			remainingLabel.y = 320;
			addChild(remainingLabel);
			
			updateTimes();
			intervalID = setInterval(perSecondeCallback, 1000);
			perSecondeCallback();
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, nativeApplication_activateHandler);
		}
		
		
		
		private function perSecondeCallback():void
		{
			now = new Date();
			var s:uint = now.getSeconds();
			var m:uint = now.getMinutes();
			var h:uint = now.getHours();
			/*CLOCK ONE*/
			needleHour.rotation = deg2rad((h * 30) + (m / 2) + 180);	
			needleMinutes.rotation = deg2rad( m * 6 + 180);
			needleSecond.rotation = deg2rad(s * 6+180);
			//trace(rad2deg(rotation), rad2deg(needleSecond.rotation))
			if(nextTime == null)
				return;
			
			if(nextTime.getTime() <= now.getTime())
				updateTimes();
			
			remainingLabel.text = nextTimeString+" "+StrTools.getNumber(GTStringUtils.dateToTime(nextTime,"Second",":") +"\n"+ 
				StrTools.getNumber(GTStringUtils.uintToTime((nextTime.getTime() - now.getTime())/1000, "Second", ":")));
		}
		
		private function createNeedle(width:int, height:int):Quad
		{
			/*var ret:Image = new Image(Assets.getTexture("list-item-selected-skin"));
			//ret.smoothing = TextureSmoothing.BILINEAR;
			//ret.pivotX = ret.width/2;
			ret.width = width;
			ret.height = height;
			//ret.pivotY = width/2;*/
			var ret:Quad = new Quad(width, height, 0xFFFFFF);
			ret.alignPivot("center", "center");
			ret.pivotY = 16;
			addChild(ret);
			return ret;
		}

		protected function nativeApplication_activateHandler(event:Event):void
		{
			updateTimes();
		}

		private function updateTimes():void
		{
			var ret:Vector.<Date> = new Vector.<Date>(2);
			var now:Date = new Date();
			var nowTime:Number = now.getTime();
			var times:Vector.<Date> = AppModel.instance.prayTimes.getTimes(now).toDates();
			times.splice(0, 1);
			for(var t:uint=0; t < times.length; t++)
			{
				if(times[t].getTime() > nowTime)
				{
					if(t==0)
					{
						ret[1] = times[0];
						now.setTime(nowTime - (1000 * 60 * 60 * 24));
						ret[0] = AppModel.instance.prayTimes.getTimes(now).toDates()[8];
						nextTimeString = loc("pray_time_"+t);
					}
					else if(t<=7)
					{
						ret[0] = times[t-1];
						ret[1] = times[t];
						nextTimeString = loc("pray_time_"+t);
					}
					break;
				}
			}
			if(ret[0] == null)
			{
				ret[0] = times[7];
				now.setTime(nowTime + (1000 * 60 * 60 * 24));
				ret[1] = AppModel.instance.prayTimes.getTimes(now).toDates()[0];
				nextTimeString = loc("pray_time_"+0);
			}
			
			//Trace parties -----
			partiesContainer.removeChildren()
			nextTime = ret[1];
			for(t=0; t<ret.length; t++)
			{
				var p:Quad = createPoints();
				p.rotation = deg2rad((ret[0].getHours()*30) + (ret[0].getMinutes()/2));
				if(t==1)
					Starling.juggler.tween(p, 1.5, {delay:2, rotation:deg2rad((ret[t].hours%12)*30 + (ret[t].getMinutes()/2)), transition:Transitions.EASE_IN_OUT})
			}
		}		
		
		
		//  Create times points ---------------------------------------
		private function createPoints():Quad
		{
			var ret:Quad = new Quad(10, 248, BaseMaterialTheme.ACCENT_COLOR);
			//ret.smoothing = TextureSmoothing.BILINEAR;
			ret.pivotX = ret.width/2;
			//ret.alpha = 0.3;
			//	ret.height = ret.width = 12;
			ret.pivotY = 248/ret.scaleY;
			partiesContainer.addChildAt(ret, 0);
			return ret;
		}
		
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}
		protected function num(input:Object):String
		{
			return StrTools.getNumber(input);
		}
		override public function dispose():void
		{
			clearInterval(intervalID);
			super.dispose();
		}
		
		
	}
}