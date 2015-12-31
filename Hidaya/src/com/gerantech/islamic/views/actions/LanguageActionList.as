package com.gerantech.islamic.views.actions
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.actions.items.ActionItemRenderer;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class LanguageActionList extends LayoutGroup
	{
		public var selectedLanguage:Local;
		public var opened:Boolean;
		
		private static const HELPER_POINT:Point = new Point();
		
		private var personModes:Vector.<ActionItemRenderer>;
		private var timeoutID:uint;
		private var overlay:Quad;
		private var startPoint:Point;
		
		public function LanguageActionList(startPoint:Point)
		{
			this.startPoint = startPoint;
		}
		
		override protected function draw():void
		{
			super.draw();
			overlay.width = actualWidth;
			overlay.height = actualHeight;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			overlay = new Quad(1,1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			overlay.alpha = 0;
			setTimeout(animateButtons, 0.3, opened = true);
		}		
		
		private function getTypeButton(index:uint):ActionItemRenderer
		{
			var ret:ActionItemRenderer  = new ActionItemRenderer(ConfigModel.instance.multiTransFlags[index], index);
			ret.addEventListener(Event.TRIGGERED, language_triggeredHandler);
			return ret;
		}		
		
		//Buttons Clicked ------------------------------------------------------------
		private function bg_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if(!touch)
				return;
			touch.getLocation(this.stage, HELPER_POINT);
			if(contains(this.stage.hitTest(HELPER_POINT, true)))
				animateButtons(opened=false);
		}
		
		private function language_triggeredHandler(event:Event):void
		{
			animateButtons(opened=false);
			selectedLanguage = ActionItemRenderer(event.currentTarget).mode;
			setTimeout(dispatchEventWith, 500, Event.SELECT, false, selectedLanguage);
		}
	
		
		private function animateButtons(opened:Boolean):void
		{
			clearTimeout(timeoutID);
			if(personModes==null)
			{	
				personModes = new Vector.<ActionItemRenderer>();
				for(var i:uint=0; i<ConfigModel.instance.multiTransFlags.length; i++)
					personModes.push(getTypeButton(i));
				personModes.reverse();
			}
			var bY:Number;
			var gap:Number = Math.min(AppModel.instance.sizes.twoLineItem, actualHeight/(personModes.length+1));
			for(i=0; i<personModes.length; i++)
			{
				personModes[i].touchable = opened;
				if(opened)
				{
					addChildAt(personModes[i], 0);			
					personModes[i].x = startPoint.x-personModes[i].width+personModes[i].height/2;
					personModes[i].y = startPoint.y;
					personModes[i].alpha = 0;
				}					
				bY = opened ? startPoint.y-gap*(i)-personModes[i].height/2 : startPoint.y;
				
				Starling.juggler.tween(personModes[i], 0.2, {delay:i*0.02, alpha:opened?1:0, y:bY, transition:opened?Transitions.EASE_OUT_BACK:Transitions.EASE_IN_BACK});
				//TweenLite.to(personModes[i], 0.2, {delay:i*0.02, alpha:opened?1:0, y:bY, ease:opened?Back.easeOut:Back.easeIn});
			}
			Starling.juggler.tween(overlay, 0.3, {alpha:(opened?0.9:0)});
			//TweenLite.to(overlay, 0.5, {alpha:(opened?0.9:0)});
			
			if(opened)
			{
				addChildAt(overlay, 0);
				setTimeout(addEventListener, 500, TouchEvent.TOUCH, bg_touchHandler);
			}
			else
			{
				removeEventListener(TouchEvent.TOUCH, bg_touchHandler);
				timeoutID = setTimeout(hideTypes, 500);
			}
		}
		
		private function hideTypes():void
		{
			for(var i:uint=0; i<personModes.length; i++)
				if(personModes[i].parent==this)
					removeChild(personModes[i]);
			
			removeChild(overlay);
		}
		
		public function close():void
		{
			animateButtons(opened=false);
		}
	}
}