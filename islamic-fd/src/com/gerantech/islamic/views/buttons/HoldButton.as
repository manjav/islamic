package com.gerantech.islamic.views.buttons
{
	import feathers.events.FeathersEventType;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	public class HoldButton extends SimpledButton
	{
		/*private var btnX:uint;
		private var btnY:uint;
		private var intervalID:uint;
		public var data:Object;*/
		
		public var alphaSelected:Number = 0.5;
		public var alphaDown:Number = 1;
		public var alphaNormal:Number = 0;
		
		public function HoldButton()
		{
			isLongPressEnabled = true
			addEventListener(FeathersEventType.LONG_PRESS, longPressHandler);
		}
		
		private function longPressHandler(event:Event):void
		{
			alpha = alphaNormal;
		}
		
		public function draw(x:Number, y:Number, width:Number, height:Number, color:uint=38536, premultipliedAlpha:Boolean=true):void
		{
			var quad:Quad = new Quad(1, 1, color );
			quad.x = x;
			quad.y = y;
			quad.width = width;
			quad.height = height;
			addChild(quad);
			alpha = alphaNormal;
		}
		
		override public function set currentState(value:String):void
		{
			if(value==super.currentState)
				return;
			
			super.currentState = value;
			switch(value)
			{
				case STATE_DOWN:
					alpha = alphaDown;
					break;
				
				case STATE_SELECTED:
					alpha = alphaSelected;
					break;
				
				case STATE_UP:
				default:
					value==STATE_UP
					alpha = alphaNormal;
					break;
			}
			//trace(value)
		}
	}
}