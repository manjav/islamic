package com.gerantech.islamic.models
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Time;
	
	import mx.resources.ResourceManager;

	public class TimesModel
	{
		public var times:Vector.<Time>;
		
		public function TimesModel()
		{
			times = new Vector.<Time>(8, true);
			
			for(var i:uint=0; i<times.length; i++)
				times[i] = new Time(i);

			times[0].alerts[0] = new Alert(0, Alert.TYPE_NOTIFICATION, times[0]);
			times[2].alerts[0] = new Alert(0, Alert.TYPE_NOTIFICATION, times[2]);
			times[5].alerts[0] = new Alert(0, Alert.TYPE_NOTIFICATION, times[5]);
			//updateNotfications();
		}
		
		public function updateNotfications():void
		{
			var alarmTime:Number = 0;
			NativeAbilities.instance.cancelLocalNotifications();
			var d:Date = new Date();
			for each(var t:Time in times)
			{
				for each(var a:int in t.alerts)
				{
					alarmTime = t.date.getTime() + a*60000;
					if(d.getTime() > alarmTime)
						alarmTime += Time.DAY_TIME_LEN;
					NativeAbilities.instance.scheduleLocalNotification(loc("pray_time_"+t.index), loc("pray_time_"+t.index), t.getAlertTitle(a), alarmTime, Time.DAY_TIME_LEN, "", "", false);

					//d.time = alarmTime;
					//trace(t.index, d, t.date, alarmTime, a);
				}
			}
		}
		
		
		public function set data(value:Array):void
		{
			for(var t:uint=0; t<value.length; t++)
			{
				times[t] = new Time(t);
				times[t].alerts = new Vector.<Alert>();
				for (var a:uint=0; a<value[t].length; a++)
					times[t].alerts.push(new Alert(value[t][a].offset, value[t][a].type, times[t]));
			}
			//updateNotfications();
		}
		public function get data():Array
		{
			var ret:Array = new Array();
			for(var t:uint=0; t<times.length; t++)
				ret[t] = times[t].alerts;
			return ret;
		}
		
		
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}
	}
}