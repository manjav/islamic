package com.gerantech.islamic.views.popups
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Location;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.events.GeolocationEvent;
	import flash.sensors.Geolocation;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.filters.ColorMatrixFilter;

	public class GeoPopup extends InfoPopUp
	{
		protected var geoTimeoutID:uint;
		protected var geoLocation:Geolocation;
		protected var enableButton:Button;
		protected var retryButton:Button;
		
		private var geoIcon:ImageLoader;
		private var geoTween:Tween;
		private var geoMessage:RTLLabel;

		override protected function initialize():void
		{
			super.initialize();
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.gap = appModel.sizes.DP16; 
			layout.paddingTop = -appModel.sizes.DP16; 
			container.layout = layout;
			
			geoIcon = new ImageLoader();
			geoIcon.width = width/5;
			geoIcon.scaleY = geoIcon.scaleX;
			geoIcon.visible = false;
			geoIcon.source = Assets.getTexture("ic_map_marker_radius");
			geoIcon.layoutData = new VerticalLayoutData();
			container.addChild(geoIcon);
			
			geoMessage = new RTLLabel(loc("geo_error"), BaseMaterialTheme.ACCENT_COLOR, null, null, true, null, 0.9);
			geoMessage.layoutData = new VerticalLayoutData(100);
			geoMessage.visible = false;
			container.addChild(geoMessage);
			
			buttonBar.removeChildren();
			
			enableButton = new Button();
			enableButton.label = loc("geo_enable");
			enableButton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompleteHandler);
			enableButton.addEventListener("triggered", enableButton_triggeredHandler);
			buttonBar.addChild(enableButton);
			
			retryButton = new Button();
			retryButton.label = loc("geo_retry");
			retryButton.addEventListener(FeathersEventType.CREATION_COMPLETE, buttons_creationCompleteHandler);
			retryButton.addEventListener("triggered", startFinding);
			buttonBar.addChild(retryButton);
			
			startFinding();
		}
		
		protected function startFinding():void
		{
			geoMessage.visible = buttonBar.visible = false;
			geoIcon.filter = null;

			geoTween = new Tween(geoIcon, 1.0, Transitions.EASE_IN_OUT);
			geoTween.repeatCount = 20;
			geoTween.fadeTo(0);
			Starling.juggler.add(geoTween);
			
			geoLocation = new Geolocation();
			geoLocation.setRequestedUpdateInterval(1000);
			geoLocation.addEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);
			geoTimeoutID = setTimeout(geoLocation_errorHandler, 5000);
			
			//getAddressByLatLong(35.70741941, 51.34450957);
		}
		
		override protected function initializeCompleted():void
		{
			geoIcon.visible = true;
		}
		
		protected function geoLocation_updateHandler(event:GeolocationEvent):void
		{
			clearTimeout(geoTimeoutID);
			geoLocation.removeEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);
			dispatchEventWith("complete", false, new Location("", event.latitude, event.longitude));
			close();
		}
		protected function geoLocation_errorHandler():void
		{
			resetElements();
			geoMessage.visible = buttonBar.visible = true;
			var ct:ColorMatrixFilter = new ColorMatrixFilter();
			ct.tint(BaseMaterialTheme.ACCENT_COLOR);
			geoIcon.filter = ct;
		}
		
		protected function resetElements():void
		{
			geoLocation.removeEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);
			clearTimeout(geoTimeoutID);
			Starling.juggler.remove(geoTween);
			geoIcon.alpha = 1;
		}		
		
		override public function close():void
		{
			resetElements();
			super.close();
		}
		
		
		protected function enableButton_triggeredHandler():void
		{
			NativeAbilities.instance.runIntent("android.settings.LOCATION_SOURCE_SETTINGS", null);
		}

 
	}
}