package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.managers.LocationManager;
	import com.gerantech.islamic.models.vo.Location;

	import feathers.controls.Button;

	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class GeoCityPopup extends GeoPopup
	{
		private var urlLoader:URLLoader;
		private var tryIndex:uint = 1;
		private var latitude:Number;
		private var longitude:Number;		

		override protected function initialize():void
		{
			super.initialize();
		
			buttonBar.removeChildren();
			
			var searchButton:Button = new Button();
			searchButton.label = loc("city_search");
			appModel.theme.setSimpleButtonStyle(searchButton);
			searchButton.addEventListener("triggered", searchButton_triggerHandler);
			buttonBar.addChild(searchButton);
			buttonBar.addChild(enableButton);
		}
		
		override protected function geoLocation_updateHandler(event:GeolocationEvent):void
		{
			clearTimeout(geoTimeoutID);
			geoLocation.removeEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);
			
			geoTimeoutID = setTimeout(geoLocation_errorHandler, 10000);
			this.latitude = event.latitude;
			this.longitude = event.longitude;
			getAddressByLatLong();
		}
		
		private function getAddressByLatLong():void
		{
			urlLoader = new URLLoader(new URLRequest("http://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude));
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_eventsHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_eventsHandler);
		}
		
		protected function urlLoader_eventsHandler(event:Event):void
		{
			resetElements();
			trace(event)
			if(event.type == IOErrorEvent.IO_ERROR)
			{
				LocationManager.instance.getCityByLocation(latitude, longitude, getCityByLocationResponder, tryIndex);
				//manualFindingConfirm();
				return;
			}
			
			var data:Object;
			try { data = JSON.parse(urlLoader.data); } 
			catch(error:Error) { geoLocation_errorHandler(); return; }
			if(data.status != "OK")
			{
				geoLocation_errorHandler();
				return;
			}
			
			var shortNames:Array = new Array();
			for each(var ac:Object in data.results[0].address_components)
			if(shortNames.indexOf(ac.short_name) == -1)
				shortNames.push(ac.short_name);
			
			dispatchEventWith("complete", false, new Location(shortNames.join(","), latitude, longitude));
			close();
		}
		
		private function getCityByLocationResponder(data:Object):void
		{
			if(data.data == null || data.data.length==0)
			{
				if(tryIndex>14)
				{
					geoLocation_errorHandler();
					return;
				}
				
				LocationManager.instance.getCityByLocation(latitude, longitude, getCityByLocationResponder, ++tryIndex);
				return;
			}
			trace(tryIndex)
			var res:Object = data.data[0];
			dispatchEventWith("complete", false, new Location(res.name_latin+","+res.country_name, res.latitude, res.longitude));
			close();
		}
		
		override protected function resetElements():void
		{
			super.resetElements();
			if(urlLoader)
			{
				urlLoader.removeEventListener(Event.COMPLETE, urlLoader_eventsHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoader_eventsHandler);
			}
		}
		
		//  Buttons handlers --------------------------------------------
		override protected function enableButton_triggeredHandler():void
		{
			super.enableButton_triggeredHandler();
			close();
		}
		protected function searchButton_triggerHandler():void
		{
			appModel.navigator.pushScreen(appModel.PAGE_CITY);
			close();
		}
	}
}