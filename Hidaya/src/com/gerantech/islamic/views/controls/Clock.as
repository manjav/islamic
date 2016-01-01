package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.text.engine.SpaceJustifier;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import gt.utils.GTStringUtils;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	public class Clock extends Sprite
	{
		
		
		private var needleHour:Image;
		private var needleMinutes:Image;
		private var needleSecond:Image;

		private var now:Date;
		private var intervalID:uint;
		private var partiesContainer:Sprite;
		private var remainingLabel:RTLLabel;
		private var nextTime:Date;
		private var nextTimeUTC:Number = -1;
		
		public function Clock()
		{
			partiesContainer = new Sprite();
			addChild(partiesContainer);
			
			//  Create outline circle ---------------------------------------
			var cmf:ColorMatrixFilter = new ColorMatrixFilter();
			cmf.adjustBrightness(1);
			for(var i:uint=0; i<8; i++)
			{
				var slice:Sprite = new Sprite();
				var image:Image = new Image(Assets.getTexture("radian"));
				image.y = -256;
				image.x = -image.width/2;
				slice.addChild(image);
				slice.rotation = i*22.5*(Math.PI/90);
				slice.filter = cmf;
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
			
			remainingLabel = new RTLLabel("", 0xFFFFFF, "center", "ltr", false, null, 64);
			remainingLabel.width = 512;
			remainingLabel.x = -256;
			remainingLabel.y = 300;
			remainingLabel.textJustifier = new SpaceJustifier("ar", "unjustified", true)
			addChild(remainingLabel);
			
			
			intervalID = setInterval(perSecondeCallback, 1000);
			perSecondeCallback();
		}
		
		
		
		private function perSecondeCallback():void
		{
			now = new Date();
			var s:uint = now.getSeconds();
			var m:uint = now.getMinutes();
			var h:uint = now.getHours();
			/*CLOCK ONE*/
			needleHour.rotation = deg2rad((h * 30) + (m / 2));	
			needleMinutes.rotation = deg2rad((m * 6));
			needleSecond.rotation = deg2rad((s * 6));
			
			if(nextTimeUTC==-1)
				return;
			
			if(nextTimeUTC<=now.getTime())
				dispatchEventWith("invokeNewParties");
			
			remainingLabel.text = StrTools.getNumber(GTStringUtils.uintToTime((nextTimeUTC - now.getTime())/1000, "Second", ":"));
		}
		
		private function createNeedle(width:int, height:int):Image
		{
			var ret:Image = new Image(Assets.getTexture("list-item-selected-skin"));
			ret.smoothing = TextureSmoothing.BILINEAR;
			ret.pivotX = ret.width/2;
			ret.pivotY = ret.height-ret.width/2;
			ret.width = width;
			ret.height = height;
			//var ret:Quad = new Quad(width, height, 0xFFFFFF);
			addChild(ret);
			return ret;
		}
		
		public function createParties(times:Vector.<Date>):void
		{
			partiesContainer.removeChildren()
			nextTimeUTC = times[1].getTime();
			for(var t:int=0; t<times.length; t++)
			{
				var p:Quad = createPoints();
				p.rotation = deg2rad((times[0].getHours()*30) + (times[0].getMinutes()/2));
				if(t==1)
					Starling.juggler.tween(p, 1.5, {delay:2, rotation:deg2rad((times[t].getHours()*30) + (times[t].getMinutes()/2)), transition:Transitions.EASE_IN_OUT})
				
			}
		}
		//  Create times points ---------------------------------------
		private function createPoints():Quad
		{
			var ret:Quad = new Quad(10, 248, BaseMaterialTheme.ACCENT_COLOR);
			//ret.smoothing = TextureSmoothing.BILINEAR;
			ret.pivotX = ret.width/2;
			ret.alpha = 0.3;
			//	ret.height = ret.width = 12;
			ret.pivotY = 248/ret.scaleY;
			partiesContainer.addChildAt(ret, 0);
			return ret;
		}
		
		override public function dispose():void
		{
			clearInterval(intervalID);
			super.dispose();
		}
		
		
	}
}