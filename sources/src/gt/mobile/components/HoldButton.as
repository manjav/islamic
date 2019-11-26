package gt.mobile.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gt.mobile.events.HoldButtonEvent;
	
	
	public class HoldButton extends Sprite
	{
		private var btnX:uint;
		private var btnY:uint;
		private var holdTimer:Timer;
		public var data:Object;
		
		public function HoldButton()
		{
			holdTimer = new Timer(50, 10);
			holdTimer.addEventListener(TimerEvent.TIMER, holdTimerHandler);
			holdTimer.addEventListener(TimerEvent.TIMER_COMPLETE, holdTimerCompleted);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function draw(width:Number=480, height:Number=48, color:uint=0xFFFF, alpha:Number=0.5):void
		{
			/*graphics.clear();
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();*/
		}
		private function addedToStageHandler(e:Event):void
		{
			alpha = 0;
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			holdTimer.stop();
			btnX = Math.floor(e.stageX/50);
			btnY = Math.floor(e.stageY/50);
			holdTimer.reset()
			holdTimer.start();
		}
		
		private function mouseOutHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			reset();
			holdTimer.stop();
			dispatchEvent(new HoldButtonEvent(HoldButtonEvent.BUTTON_HOLD_CANCEL));
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			reset();
			holdTimer.stop();
			if(holdTimer.currentCount<holdTimer.repeatCount && getParentMouseChildren())
			{
				dispatchEvent(new HoldButtonEvent(HoldButtonEvent.BUTTON_CLICK));
			}
		}
		private function holdTimerHandler(e:TimerEvent):void
		{//trace(holdTimer.currentCount, holdTimer.repeatCount)
			if(btnX!=Math.floor(stage.mouseX/50) || btnY!=Math.floor(stage.mouseY/50))
			{
				holdTimer.stop();
				dispatchEvent(new HoldButtonEvent(HoldButtonEvent.BUTTON_HOLD_CANCEL));
				reset();
				return;
			}
			if(holdTimer.currentCount==1)
			{
				dispatchEvent(new HoldButtonEvent(HoldButtonEvent.BUTTON_HOLD_START));
				alpha = 1;
			}
			

		}

		private function holdTimerCompleted(e:TimerEvent):void
		{
			reset();//stage.mouseY == btnY && 
			if(getParentMouseChildren())
			{
				dispatchEvent(new HoldButtonEvent(HoldButtonEvent.BUTTON_HOLD_END));
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			}
		}
		
		private function removeFromStageHandler(e:Event):void
		{
			reset();
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			if(holdTimer!=null)holdTimer.stop();
		}
		private function reset():void
		{
			alpha = 0;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		private function getParentMouseChildren(view:DisplayObjectContainer=null):Boolean
		{
			if(view==null)view = this;
			if(view.parent!=null)
			{
				return view.parent.mouseChildren ? getParentMouseChildren(view.parent) : false;
			}
			return true;
		}

	}
}