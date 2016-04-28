package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class BaseCustomItemRenderer extends LayoutGroupListItemRenderer
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DOWN:String = "down";
		public static const STATE_SELECTED:String = "selected";
		public var stateNames:Vector.<String> = new <String>
			[
				STATE_NORMAL, STATE_DOWN, STATE_SELECTED
			];
		
		public var deleyCommit:Boolean = true;
		public static var FAST_COMMIT_TIMEOUT:uint = 0;
		public static var SLOW_COMMIT_TIMEOUT:uint = 400;
		
		private var _currentState:String = STATE_NORMAL;
		private var intevalId:uint;
		
		private var touchID:int = -1;
		private static const HELPER_POINT:Point = new Point();
		private var tempY:Number;
		
		private var screenRect:Rectangle;
		private var commitPhase:uint;

		protected var touch:Touch;
		
		override protected function initialize():void
		{
			addEventListener( TouchEvent.TOUCH, touchHandler);
			addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler );
		}
		
		override protected function commitData():void
		{
			super.commitData();
			if(deleyCommit)
			{
				clearInterval(intevalId);
				intevalId = setInterval(checkScrolling, SLOW_COMMIT_TIMEOUT);
				commitPhase = 0;
			}
		}		
		protected function get isShow():Boolean
		{
			if(screenRect==null)
				screenRect = appModel.navigator.activeScreen.getBounds(stage);
			try
			{
				var rect:Rectangle = getBounds(appModel.navigator.activeScreen);
				return rect.x<(screenRect.x+screenRect.width) && (rect.x+rect.width)>screenRect.x && rect.y<(screenRect.y+screenRect.height) && (rect.y+rect.height)>screenRect.y;		
			}
			catch(error:Error){}
			return false;
		}
		private function checkScrolling():void
		{
			var rect:Rectangle = getBounds(_owner);
			var speed:Number = Math.abs(tempY-rect.y);
			if(commitPhase==0 && speed<AppModel.instance.sizes.twoLineItem*5)
			{
				commitPhase = 1;
				commitBeforeStopScrolling();
			}
			else if(commitPhase==1 && speed<AppModel.instance.sizes.twoLineItem)
			{
				commitPhase = 2;
				clearInterval(intevalId);
				commitAfterStopScrolling();
			}
			tempY = rect.y;
		}		
		
		protected function commitBeforeStopScrolling():void
		{
		}
		protected function commitAfterStopScrolling():void
		{
		}
		
		
		
		
		private function touchHandler( event:TouchEvent ):void
		{
			if( !this._isEnabled )
			{
				this.touchID = -1;
				return;
			}
			
			if( this.touchID >= 0 )
			{
				touch = event.getTouch( this, null, this.touchID );
				if( !touch )
					return;
			
				if( touch.phase == TouchPhase.ENDED )
				{
					touch.getLocation( this.stage, HELPER_POINT );
					var isInBounds:Boolean = this.contains( this.stage.hitTest( HELPER_POINT, true ) );
					if( isInBounds )
					{
						dispatchEventWith(Event.TRIGGERED);
						if(_owner.allowMultipleSelection)
							this.isSelected = !isSelected;
						else
							this.isSelected = true;
					}
					// the touch has ended, so now we can start watching for a new one.
					this.touchID = -1;
				}
				return;
			}
			else
			{
				// we aren't tracking another touch, so let's look for a new one.
				touch = event.getTouch( this, TouchPhase.BEGAN );
				if(touch)
				{
					currentState = STATE_DOWN;
				}
				else
				{
					// we only care about the began phase. ignore all other phases.
					return;
				}
				// save the touch ID so that we can track this touch's phases.
				this.touchID = touch.id;
			}
		}
		protected function removedFromStageHandler( event:Event ):void
		{
			clearInterval(intevalId);
			this.touchID = -1;
		}
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			currentState = value ? STATE_SELECTED : STATE_NORMAL;
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
		
		protected function loc(resourceName:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", resourceName, parameters, locale);
		}
		protected function get appModel():		AppModel		{	return AppModel.instance;		}
		protected function get userModel():		UserModel		{	return UserModel.instance;		}
		protected function get configModel():	ConfigModel		{	return ConfigModel.instance;	}
		protected function get resourceModel():	ResourceModel	{	return ResourceModel.instance;	}
		
		
	}
}