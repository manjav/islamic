package com.gerantech.islamic.views.screens
{
	import com.gerantech.extensions.CompassExtension;
	import com.gerantech.extensions.events.CompassEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.LocationManager;
	import com.gerantech.islamic.models.vo.Location;
	import com.gerantech.islamic.views.buttons.EiditableButton;
	import com.gerantech.islamic.views.controls.CompassCanvas;
	import com.gerantech.islamic.views.popups.BasePopUp;
	import com.gerantech.islamic.views.popups.GeoCityPopup;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.sensors.Geolocation;
	import flash.utils.setTimeout;
	
	import feathers.events.FeathersEventType;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	
	public class CompassScreen extends BasePanelScreen
	{
		private var canvas:CompassCanvas;
		private var compass:CompassExtension;
		private var lastAngle:Number = 0;
		private var cityButton:EiditableButton;
		private var minSize:Number;

		override protected function initialize():void
		{
			super.initialize();
			LocationManager.instance;
			
			cityButton = new EiditableButton();
			cityButton.label = userModel.city.name;
			cityButton.addEventListener("triggered", cityButton_triggeredHandler);
			addChild(cityButton);
			
			canvas = new CompassCanvas();
			canvas.alpha = 0;
			addChild(canvas);
			
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
			addEventListener(FeathersEventType.TRANSITION_OUT_START, transitionOutStartHandler);
			addEventListener("resize", resizeHandler);
		}

		//Resize and transition handlers -------------------------------------------------------------
		private function resizeHandler():void
		{
			var h:Number = appModel.sizes.heightFull-appModel.sizes.subtitle;
			minSize = Math.min(appModel.sizes.width, h);
			canvas.x = minSize/2;
			canvas.y = h - minSize/2;
			
			canvas.scaleX = canvas.scaleY = minSize/512 * 0.8
			
			cityButton.width = minSize*0.8;
			if(h > minSize)
			{
				cityButton.x = (width-cityButton.width)/2;
				cityButton.y = (h - width)/2 - cityButton.height/2;
			}
			else
			{
				cityButton.x = width - (width-h)/2-cityButton.width/2;
				cityButton.y = h - minSize/2 - cityButton.height/2;
			}
		}
		private function transitionInCompleteHandler():void
		{
			removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
			resizeHandler();
			
			canvas.scaleX = canvas.scaleY = 0.1;
			canvas.rotation = 1;
			var tw:Tween = new Tween(canvas, 0.8, Transitions.EASE_OUT);
			tw.scaleTo(minSize/512 * 0.8);
			tw.rotateTo(0);
			tw.fadeTo(1);
			tw.onComplete = tweenCompleteHandler;
			Starling.juggler.add(tw);
			function tweenCompleteHandler():void
			{
				compass = new CompassExtension();
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, nativeApplication_activationHandler);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, nativeApplication_activationHandler);
				nativeApplication_activationHandler(new Event(Event.ACTIVATE));
			}
		}
		private function transitionOutStartHandler():void
		{
			if(compass)
				nativeApplication_activationHandler(new Event(Event.DEACTIVATE));
		}
		
		//Compass mothods -------------------------------------------------------------
		protected function nativeApplication_activationHandler(event:Event):void
		{
			if(stage == null)
				return;
			
			if(event.type == Event.ACTIVATE)
			{
				this.compass.addEventListener(CompassEvent.MAGNETIC_FIELD_CHANGED, compass_magneticFieldChangedHandler);
				this.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
				this.compass.register();
				setTimeout(setQiblaAngle, 1500);
			}
			else
			{
				this.compass.removeEventListener(CompassEvent.MAGNETIC_FIELD_CHANGED, compass_magneticFieldChangedHandler);
				this.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
				this.compass.deregister();
			}
		}
		private function setQiblaAngle():void
		{
			var dx:Number = userModel.city.latitude - 21.422604869837578;
			var dy:Number = userModel.city.longitude - 39.826148279762265;

			var tw:Tween = new Tween(canvas.qibla, 0.8, Transitions.EASE_OUT);
			tw.rotateTo(Math.atan2(-dy, -dx));
			Starling.juggler.add(tw);
		}
		protected function compass_magneticFieldChangedHandler(event:CompassEvent):void
		{
			lastAngle = event.angle;
		}
		protected function enterFrameHandler():void
		{
			if (lastAngle == canvas.angle)
				return;
			
			var delta:Number = lastAngle - canvas.angle;
			if (delta > 180) delta -= 360;
			if (delta < -180) delta += 360;
			canvas.angle += (delta / 20);
		}
		
		//Others -------------------------------------------------------------
		private function cityButton_triggeredHandler():void
		{
			if(!Geolocation.isSupported)
				appModel.navigator.pushScreen(appModel.PAGE_CITY);
			else
				AppController.instance.addPopup(GeoCityPopup).addEventListener("complete", geoPopup_completeHandler);
		}
		private function geoPopup_completeHandler(event:*):void
		{
			event.currentTarget.removeEventListener("complete", geoPopup_completeHandler);
			userModel.city = event.data as Location;
			cityButton.label = userModel.city.name;
			setQiblaAngle();
		}		
	}
}