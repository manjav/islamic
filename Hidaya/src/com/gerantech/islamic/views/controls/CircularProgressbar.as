package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.Assets;
	
	import feathers.core.FeathersControl;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.MaskedTextInput;
	
	import starling.display.Image;
	
	
	public class CircularProgressbar extends FeathersControl
	{
		override protected function initialize():void
		{
			super.initialize();
			/*var image:Image = new Image(Assets.getTexture("semi_circle"));
			addChild(image);
			
			var _clipMask:Rectangle = new Rectangle(0,0,64, 128);

            var ratioX:Number = 1 / image.width;
            var ratioY:Number = 1 / image.height;

             
            var scrollLeft:Number =     (0 + _clipMask.left) * ratioX;
            var scrollTop:Number =      (0 + _clipMask.top) * ratioY;
            var scrollRight:Number =    (0 + _clipMask.right) * ratioX;
            var scrollBottom:Number =   (0 + _clipMask.bottom) * ratioY;
             
            image.setTexCoords(0, new Point(scrollLeft, scrollTop));
            image.setTexCoords(1, new Point(scrollRight, scrollTop));
            image.setTexCoords(2, new Point(scrollLeft, scrollBottom));
            image.setTexCoords(3, new Point(scrollRight, scrollBottom));

			image.x =_clipMask.x;
			image.y =_clipMask.y;
			image.width =_clipMask.width;
			image.height =_clipMask.height*/;
		}
	}
}