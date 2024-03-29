package com.gerantech.islamic.views.actions
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.actions.items.ActionItemRenderer;
	import com.gerantech.islamic.views.buttons.FlatButton;
	
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
	import starling.filters.DropShadowFilter;
	
	public class ModeActionList extends LayoutGroup
	{
		public var selectedMode:Local;
		public var type:String;
		public var modes:Array;
		public var opened:Boolean;

		private static const HELPER_POINT:Point = new Point();
		
		private var personModes:Vector.<ActionItemRenderer>;
		private var timeoutID:uint;
		private var overlay:Quad;
		public var actionButton:FlatButton;
		
		public function ModeActionList(type:String)
		{
			this.type = type;
		}
		
		override protected function draw():void
		{
			super.draw();
			actionButton.x = actualWidth-AppModel.instance.sizes.subtitle;
			actionButton.y = actualHeight-AppModel.instance.sizes.subtitle;
			/*if(opened)
				animateButtons(true);*/
			overlay.width = actualWidth;
			overlay.height = actualHeight;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			overlay = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			overlay.alpha = 0;
			//background.layoutData = new AnchorLayoutData(0,0,0,0);
			
			
			
			actionButton = new FlatButton("action_plus", "action_accent", false, 1, 0.8);
			actionButton.iconScale = 0.3;
			actionButton.width = actionButton.height = AppModel.instance.sizes.toolbar;
			actionButton.pivotY = actionButton.pivotX = actionButton.width/2;
			actionButton.filter = new DropShadowFilter(AppModel.instance.sizes.border, 90*(Math.PI/180), 0, 0.4, 3);
			actionButton.addEventListener(Event.TRIGGERED, actionButton_triggerd);
			addChild(actionButton);
			
			modes = type==Person.TYPE_TRANSLATOR?ResourceModel.instance.transModes:ResourceModel.instance.recitersModes;
		}

		
		private function getTypeButton(index:uint):ActionItemRenderer
		{
			var ret:ActionItemRenderer  = new ActionItemRenderer(modes[index], index);
			ret.addEventListener(Event.TRIGGERED, modes_triggerd);
			return ret;
		}		
		
		//Buttons Clicked ------------------------------------------------------------
		private function bg_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if(!touch)
				return;
			touch.getLocation(this.stage, HELPER_POINT);
			if(contains(this.stage.hitTest(HELPER_POINT)))
				close();
		}
		private function modes_triggerd(event:Event):void
		{
			close();
			selectedMode = ActionItemRenderer(event.currentTarget).mode;
			setTimeout(dispatchEventWith, 500, Event.SELECT, false, selectedMode);
		}
		private function actionButton_triggerd(event:Event):void
		{
			opened = !opened;
			animateButtons(opened);
		}	
		
		public function close():void
		{
			animateButtons(opened=false);
		}
		
		private function animateButtons(opened:Boolean):void
		{
			clearTimeout(timeoutID);
			Starling.juggler.tween(actionButton, 1, {rotation:(opened?Math.PI/4:0), transition:Transitions.EASE_OUT_ELASTIC});
			//TweenLite.to(actionButton, 1, {rotation:(opened?135:0)*(Math.PI/180), ease:Elastic.easeOut});
			if(personModes==null)
			{	
				personModes = new Vector.<ActionItemRenderer>();
				for(var i:uint=0; i<modes.length; i++)
					personModes.push(getTypeButton(i));
				personModes.reverse();
			}
			var bY:Number;
			for(i=0; i<personModes.length; i++)
			{
				//personModes[i].touchable = opened;
				if(opened)
				{
					addChildAt(personModes[i], 1);			
					personModes[i].x = actionButton.x-personModes[i].width+personModes[i].height/2;
					personModes[i].y = actionButton.y;
					personModes[i].alpha = 0;
				}
				bY = opened ? actionButton.y-AppModel.instance.sizes.toolbar*(1.8+i) : actionButton.y;
				Starling.juggler.tween(personModes[i], opened?0.3:0.2, {delay:i*0.05, alpha:opened?1:0, y:bY, transition:opened?Transitions.EASE_OUT_BACK:Transitions.EASE_IN_BACK});
//				TweenLite.to(personModes[i], opened?0.3:0.2, {delay:i*0.05, alpha:opened?1:0, y:bY, ease:opened?Back.easeOut:Back.easeIn});
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
		/*
		public function resize(width:Number, height:Number):void
		{
			actionButton.x = width-height;
			actionButton.y = height*0.85;
			if(personModes)
			{
				hideTypes();
				setTimeout(animateButtons, 500, opened);
			}
		}*/
	}
}