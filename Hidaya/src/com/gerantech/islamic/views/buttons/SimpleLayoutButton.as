package com.gerantech.islamic.views.buttons
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	[Event(name="triggered",type="starling.events.Event")]
	[Event(name="longPress",type="starling.events.Event")]
	
	public class SimpleLayoutButton extends LayoutGroup
	{
		public static const STATE_UP:String = "up";
		public static const STATE_DOWN:String = "down";
		public static const STATE_HOVER:String = "hover";
		public static const STATE_DISABLED:String = "disabled";
		public var stateNames:Vector.<String> = new <String>
			[
				STATE_UP, STATE_DOWN, STATE_HOVER, STATE_DISABLED
			];
		
		private static const HELPER_POINT:Point = new Point();
		
		private var touchPointID:int;
		//protected var _isEnabled:Boolean = true;
		protected var _touchBeginTime:int;
		public var isLongPressEnabled:Boolean = false;
		protected var _hasLongPressed:Boolean = false;
		public var longPressDuration:Number = 0.5;
		public var keepDownStateOnRollOut:Boolean = false;
		private var _currentState:String = STATE_UP;
		private var _touchable:Boolean = true;

		
		public function SimpleLayoutButton()
		{
			super();
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(TouchEvent.TOUCH, button_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, button_removedFromStageHandler);
		}
		
		override public function set touchable(value:Boolean):void
		{
			if(_touchable==value)
				return;
			
			_touchable = value; 
			alpha = value ? 1 : 0.6;
			super.touchable = value;
		}
		
		
		
		public function get currentState():String
		{
			return _currentState;
		}
		public function set currentState(value:String):void
		{
			if(this._currentState == value)
			{
				return;
			}
			if(this.stateNames.indexOf(value) < 0)
			{
				throw new ArgumentError("Invalid state: " + value + ".");
			}
			_currentState = value;
		}

		/**
		 * @private
		 */
		protected function resetTouchState(touch:Touch = null):void
		{
			this.touchPointID = -1;
			this.removeEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
			if(this._isEnabled)
			{
				this.currentState = STATE_UP;
			}
			else
			{
				this.currentState = STATE_DISABLED;
			}
		}
		
		/**
		 * Triggers the button.
		 */
		protected function trigger():void
		{
			if(hasEventListener(Event.TRIGGERED))
			this.dispatchEventWith(Event.TRIGGERED);
		}
		
		/**
		 * @private
		 
		protected function childProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}*/
		

	
		
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
				{
					//this should never happen
					return;
				}
				
				touch.getLocation(this.stage, HELPER_POINT);
				var isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
				if(touch.phase == TouchPhase.MOVED)
				{
					if(isInBounds || this.keepDownStateOnRollOut)
					{
						this.currentState = STATE_DOWN;
					}
					else
					{
						this.currentState = STATE_UP;
					}
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this.resetTouchState(touch);
					//we we dispatched a long press, then triggered and change
					//won't be able to happen until the next touch begins
					if(!this._hasLongPressed && isInBounds)
					{
						this.trigger();
					}
				}
				return;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					this.currentState = STATE_DOWN;
					this.touchPointID = touch.id;
					if(this.isLongPressEnabled)
					{
						this._touchBeginTime = getTimer();
						this._hasLongPressed = false;
						this.addEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
					}
					return;
				}
				touch = event.getTouch(this, TouchPhase.HOVER);
				if(touch)
				{
					this.currentState = STATE_HOVER;
					return;
				}
				
				//end of hover
				this.currentState = STATE_UP;
			}
		}
		
		/**
		 * @private
		 */
		protected function longPress_enterFrameHandler(event:Event):void
		{
			var accumulatedTime:Number = (getTimer() - this._touchBeginTime) / 1000;
			if(accumulatedTime >= this.longPressDuration)
			{
				this.removeEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
				this._hasLongPressed = true;
				this.dispatchEventWith(FeathersEventType.LONG_PRESS);
			}
		}
		
		/**
		 * @private
		 
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
			{
				this.touchPointID = -1;
				this.currentState = STATE_UP;
			}
			if(this.touchPointID >= 0 || event.keyCode != Keyboard.SPACE)
			{
				return;
			}
			this.touchPointID = int.MAX_VALUE;
			this.currentState = STATE_DOWN;
		}
		
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(this.touchPointID != int.MAX_VALUE || event.keyCode != Keyboard.SPACE)
			{
				return;
			}
			this.resetTouchState();
			this.trigger();
		}*/
	}
}