package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	public class Clock extends Sprite
	{
		private var needleHour:Image;
		private var needleMinutes:Image;
		private var needleSecond:Image;

		private var date:Date;
		private var intervalID:uint;
		public function Clock()
		{
			var cmf:ColorMatrixFilter = new ColorMatrixFilter();
			cmf.adjustBrightness(1);
			
			//  Create outline circle ---------------------------------------
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
			needleSecond = createNeedle(6, 240);
			
			//  Create central circle ---------------------------------------
			/*var circle:Image = new Image(Assets.getTexture("page-indicator-selected-skin"));
			circle.smoothing = TextureSmoothing.BILINEAR;
			circle.pivotX = circle.pivotY = circle.width/2;
			circle.width = circle.height = 40;
			circle.filter = cmf;
			addChild(circle);*/
			
			//  Create times points ---------------------------------------
			var now:Date = new Date();
			var times:Vector.<Date> = AppModel.instance.prayTimes.getTimes(now).toDates();
			var pastTime:int = -1;
			for(var t:uint=1; t<times.length; t++)
			{
				if(now.getTime()<=times[t].getTime())
				{
					pastTime = t;
					break;
				}
			}
			for(t=pastTime-1; t<Math.min(pastTime, times.length); t++)
			{
				var point:Image = createPoints();
				var m:uint = times[t].getMinutes();
				var h:uint = times[t].getHours();
				/*CLOCK ONE*/
				point.rotation = deg2rad((h * 30) + (m / 2));	
			}

			intervalID = setInterval(perSecondeCallback, 1000);
			perSecondeCallback();
		}

		private function perSecondeCallback():void
		{
			date = new Date();
			var s:uint = date.getSeconds();
			var m:uint = date.getMinutes();
			var h:uint = date.getHours();
			/*CLOCK ONE*/
			needleHour.rotation = deg2rad((h * 30) + (m / 2));	
			needleMinutes.rotation = deg2rad((m * 6));
			needleSecond.rotation = deg2rad((s * 6));
		}
		
		
		
		private function createPoints():Image
		{
			var ret:Image = new Image(Assets.getTexture("list-item-selected-skin"));
			ret.smoothing = TextureSmoothing.BILINEAR;
			ret.pivotX = ret.width/2;
			ret.height = ret.width = 12;
			ret.pivotY = 248/ret.scaleY;
			addChild(ret);
			return ret;
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
		
		override public function dispose():void
		{
			clearInterval(intervalID);
			super.dispose();
		}
		
		
	}
}