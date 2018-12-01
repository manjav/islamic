package com.gerantech.islamic.views.buttons
{
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	
	import flash.geom.Point;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SeekToucher extends LayoutGroup
	{
		public static const STATE_CHANGED:String = "stateChanged";
		public static const MOVED:String = "moved";

		
		public static const STATE_UP:String = "up";
		public static const STATE_DOWN:String = "down";
		public static const STATE_DISABLED:String = "disabled";
		public var stateNames:Vector.<String> = new <String>
			[
				STATE_UP, STATE_DOWN, STATE_DISABLED
			];
				
		public var touchPoint:Point;
		
		private var touchPointID:int = -1;		
		
		override protected function initialize():void
		{
			touchPoint = new Point();
			
			backgroundSkin = new Quad(1,1,0);
			backgroundSkin.alpha = 0;
			
			this.addEventListener(TouchEvent.TOUCH, button_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, button_removedFromStageHandler);
			super.initialize();
		}
		
		
		
		
		private var _currentState:String = STATE_UP;
		public function get currentState():String
		{
			return _currentState;
		}
		public function set currentState(value:String):void
		{
			if(this._currentState == value)
				return;
			if(this.stateNames.indexOf(value) < 0)
				throw new ArgumentError("Invalid state: " + value + ".");
			
			_currentState = value;
			dispatchEventWith(STATE_CHANGED, false, _currentState);
		}

		/**
		 * @private
		 */
		protected function resetTouchState(touch:Touch = null):void
		{
			this.touchPointID = -1;
			if(this._isEnabled)
				this.currentState = STATE_UP;
			else
				this.currentState = STATE_DISABLED;
		}

		/**
		 * @private
		 */
		protected function button_removedFromStageHandler(event:Event):void
		{
			this.resetTouchState();
		}
		
		/**
		 * @private
		 */
		protected function button_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this.touchPointID = -1;
				return;
			}
			
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this.touchPointID);
				if(!touch)
					return;
				
				if(touch.phase == TouchPhase.MOVED)
				{
					touchPoint.setTo(touch.globalX, touch.globalY);
					dispatchEventWith(MOVED, false, touchPoint);
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					touchPoint.setTo(touch.globalX, touch.globalY);
					this.resetTouchState(touch);
				}
				return;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					touchPoint.setTo(touch.globalX, touch.globalY);
					this.currentState = STATE_DOWN;
					this.touchPointID = touch.id;
					
					return;
				}
				//end of hover
				this.currentState = STATE_UP;
			}
		}
		
	}
}