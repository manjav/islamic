package com.gerantech.islamic.views.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Item;
	
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.math.roundToNearest;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class AbstractDrawer extends FeathersControl
	{
		
		public var containerWidth:uint;
		public var hitAlpha:Number;
		public var edgeWidth:uint;
		
		private var hit:Button;
		private var edge:Button;
		private var isDrawerOpen:Boolean;
		private var _startX:Number;
		//private var _startY:Number;
		private var showEdgeTimeoutID:uint;
		
		protected var container:LayoutGroup;
		
		
		public function AbstractDrawer()
		{
			containerWidth = AppModel.instance.sizes.twoLineItem*4;
			edgeWidth =  AppModel.instance.sizes.twoLineItem/3;
			hitAlpha = 0.1;
			
			hit = new Button(Assets.getTexture("toolbar_background_skin"));
			hit.width = AppModel.instance.sizes.width;
			//hit.addEventListener( Event.TRIGGERED, hit_triggeredHandler );
			hit.alpha = hitAlpha;
			addChild(hit);
			
			edge = new Button(Assets.getTexture("toolbar_background_skin"));
			edge.width = edgeWidth;
			edge.alpha = 0;
			addChild(edge);
			
			container = new LayoutGroup();
			addChild(container);
			
			addEventListener(TouchEvent.TOUCH, drawers_touchHandler);
			hide();
		}
		public function show(easeing:Function=null):void
		{
			if(easeing == null)
				easeing = Expo.easeOut;
			setTimeout(function():void{addEventListener(Event.ENTER_FRAME, enterFrameHandler)}, 20);
			
			isDrawerOpen = true;
			addChildAt(hit, 0);
			container.visible = true;
			TweenLite.to(container, 0.3, {x:0, ease:easeing});
		}
		public function hide(easeing:Function=null):void
		{
			if(easeing == null)
				easeing = Expo.easeIn;
			setTimeout(function():void{addEventListener(Event.ENTER_FRAME, enterFrameHandler)}, 20);
			isDrawerOpen = false;
			TweenLite.to(container, 0.3, {x:-containerWidth, ease:easeing, onComplete:hideCompleted});
		}
		private function hideCompleted():void
		{
			removeChild(hit)
			container.visible = false;

		}

		
		private function enterFrameHandler(event:Event):void
		{
			var ha:Number = (containerWidth+container.x)*hitAlpha/containerWidth;
			hit.alpha = ha
			if(ha>=(hitAlpha-0.1) || ha<0.01)
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//trace("enterFrameHandler")
		}
		
		
		public function validateSize():void
		{
			hit.width = AppModel.instance.sizes.width;
			edge.height = hit.height = AppModel.instance.sizes.heightFull;
		}
		
		
		
		
		//TOUCH HANDLER _______________________________________________________________________________________________________________
		

		/**
		 * @private
		 */
		protected function drawers_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
				return;
		
			var touch:Touch = event.getTouch(this, null, -1);
			if(!touch)
				return;
			
			if(container.x>-containerWidth && container.x<0)
			{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				if(!container.visible)
					container.visible = true;
				_startX = touch.globalX;
				if(_startX<edgeWidth)
					showEdgeTimeoutID = setTimeout(showEdge, 100)
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				clearTimeout(showEdgeTimeoutID);
				changeDrawerPosition(touch);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				clearTimeout(showEdgeTimeoutID);
				endDrawerPosition(touch);
			}
		//	trace(touch.toString())
		}
		
		private function showEdge():void
		{
			_startX = edgeWidth-1;
			TweenLite.to(container, 0.2, {x:-containerWidth+edgeWidth});
		}
		
		private function changeDrawerPosition(touch:Touch):void
		{
			if(touch.globalX>containerWidth && isDrawerOpen)
			{
				_startX = containerWidth;
				return;
			}
			if(_startX>edgeWidth && !isDrawerOpen)
				return;
			
			var newX:Number = touch.globalX-containerWidth;
			container.x = Math.max(-containerWidth,Math.min(0, newX));
			//trace("Drag", newX, touch.globalX, isDrawerOpen);
		}
		
		private function endDrawerPosition(touch:Touch):void
		{
			if(isDrawerOpen)
			{
				if(touch.globalX>containerWidth/2 && !(_startX>containerWidth && touch.globalX>containerWidth))
					show(Expo.easeOut)
				else 
					hide(Expo.easeOut);
			}
			else
			{
				if(touch.globalX>containerWidth/2 && _startX<edgeWidth)
					show(Expo.easeOut)
				else 
					hide(Expo.easeOut);
			}
			//trace("Drop", _startX, touch.globalX, containerWidth/2, edgeWidth, isDrawerOpen)
		}
		

	}
}