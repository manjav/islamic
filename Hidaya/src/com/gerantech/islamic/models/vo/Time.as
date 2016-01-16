package com.gerantech.islamic.models.vo
{
	import mx.resources.ResourceManager;

	public class Time
	{
		public static const ALERT_PEAKS:Array = new Array(1000, -120, -90, -60, -45, -30, -20, -15, -10, -5, 0, 5, 10, 15, 20, 30, 45, 60, 90, 120);
		
		public var alerts:Vector.<int>;
		public var date:Date;
		public var index:uint;
		
		public function Time(index:uint)
		{
			this.index = index;
			alerts = new Vector.<int>();
		}
		
		public function get enabled():Boolean
		{
			return alerts.length>0;
		}
		
		public function getAlertTitle(alert:int):String
		{
			if (alert == 1000)
				return loc("alert_none");
			else if (alert == 0)
				return loc("alert_sync");
			else if (alert>0)
				return alert + " " + loc("alert_after") + " " + loc("pray_time_"+index);
			else
				return Math.abs(alert) + " " + loc("alert_before") + " " + loc("pray_time_"+index);
		}
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}

	}
}