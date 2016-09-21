package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.utils.StrTools;
	
	import mx.resources.ResourceManager;

	public class Time
	{
		public static const ALERT_PEAKS:Array = new Array(-120, -90, -60, -45, -30, -20, -15, -10, -5, 0, 5, 10, 15, 20, 30, 45, 60, 90, 120);
		public static const DAY_TIME_LEN:int = 86400000;
		
		public var alerts:Vector.<Alert>;
		public var date:Date;
		public var index:uint;
		public var pending:Boolean;
		
		public function Time(index:uint)
		{
			this.index = index;
			alerts = new Vector.<Alert>();
		}
		
		public function get enabled():Boolean
		{
			return alerts.length>0;
		}		
		public function isPending(_date:Date):Boolean
		{
			return date.time >= _date.time;
		}
		
		public function getAlertTitle(alert:int):String
		{
			if (alert == 0)
				return loc("alert_sync") + " " + loc("pray_time_"+index);
			else
				return StrTools.getNumberFromLocale(Math.abs(alert)) + " " + loc(alert>0?"alert_after":"alert_before") + " " + loc("pray_time_"+index);
		}
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}

	}
}