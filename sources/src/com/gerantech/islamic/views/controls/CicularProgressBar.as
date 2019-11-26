package com.gerantech.islamic.views.controls
{
	import flash.geom.Matrix;
	
	import starling.display.Shape;
	import starling.textures.Texture;
	
	public class CicularProgressBar extends Shape
	{
		public function CicularProgressBar()
		{
			super();
			//texture = Assets.getTexture("circle_icon");//trace(texture.width)
		}
		
		public var rotationOffset:Number = -1.57;
		public var sides:uint = 3;
		public var radius:Number = 36;

		private var matrix:Matrix;
		private var texture:Texture;

		
		public function drawPieMask(percentage:Number, x:Number = 0, y:Number = 0, rotation:Number = 0, sides:int = 32):void 
		{
			percentage = Math.max(Math.min(percentage, 1), 0);
			//trace(percentage, radius, x,y)
			graphics.clear();
			/*if(matrix==null)
			{
				matrix = new Matrix();
				matrix.translate(6, 6);
				matrix.scale(36/radius*0.8, 36/radius*0.8);
			}
			// graphics should have its beginFill function already called by now
			graphics.beginTextureFill(texture, matrix);*/
			graphics.beginFill(0x009688);
			graphics.moveTo(x, y);
			if (sides < 3) sides = 3; // 3 sides minimum
			// Increase the length of the radius to cover the whole target
			var mRadius:Number = radius;
			mRadius /= Math.cos(1/sides * Math.PI);
			// Shortcut function
			var lineToRadians:Function = function(rads:Number):void 
			{
				graphics.lineTo(Math.cos(rads) * mRadius + x, Math.sin(rads) * mRadius + y);
			};
			// Find how many sides we have to draw
			var sidesToDraw:int = Math.floor(percentage * sides);
			for (var i:int = 0; i <= sidesToDraw; i++)
				lineToRadians((i / sides) * (Math.PI * 2) + rotation);
			// Draw the last fractioned side
			if (percentage * sides != sidesToDraw)
				lineToRadians(percentage * (Math.PI * 2) + rotation);
			
		}
	}
}