package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.deg2rad;
	
	public class CompassCanvas extends Sprite
	{
		public var qibla:Sprite;
		
		private var _angle:Number = 0;
		private var _qiblaAngle:Number = 0;
		
		public function CompassCanvas()
		{
			for(var i:uint=0; i<8; i++)
			{
				var slice:Sprite = new Sprite();
				var image:Image = new Image(Assets.getTexture("radian"));
				image.y = -256;
				image.x = -image.width/2;
				slice.addChild(image);
				slice.rotation = i*22.5*(Math.PI/90);
				addChild(slice);
				
				if(i%2 == 0)
				{
					var arrows:String = "n";
					if(i == 2)
						arrows="e";
					else if(i==4)
						arrows = "s";
					else if(i==6)
						arrows = "w";
					
					var side:Image = new Image(Assets.getTexture("letter_"+arrows));
					//side.height = side.width = 50;
					side.x = -side.width/2;
					side.y = -256-side.height/2;
					slice.addChild(side);
				}
				
			}
			qibla = new Sprite();
			addChild(qibla);
			
			var kaabaImage:Image = new Image(Assets.getTexture("kaaba"));
			kaabaImage.y = -220;
			kaabaImage.x = -kaabaImage.width/2;
			qibla.addChild(kaabaImage);
		}
		
		/**
		 * Angle of compass canvas
		 */
		public function get angle():Number
		{
			return _angle;
		}
		public function set angle(value:Number):void
		{
			if(_angle == value)
				return;
			
			_angle = value;
			rotation = deg2rad(_angle);
		}

		
		/**
		 * Gibla angle second
		 */
		public function get qiblaAngle():Number
		{
			return _qiblaAngle;
		}
		public function set qiblaAngle(value:Number):void
		{
			if(_qiblaAngle == value)
				return;
			
			_qiblaAngle = value;
			qibla.rotation = deg2rad(_qiblaAngle);
		}
	}
}