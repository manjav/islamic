package com.gerantech.islamic.models
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Moathen;
	import com.gerantech.islamic.models.vo.Reciter;
	import com.gerantech.islamic.models.vo.Time;
	
	import mx.resources.ResourceManager;

	public class TimesModel
	{
		public var loaded:Boolean;
		public var times:Vector.<Time> = new Vector.<Time>(8, true);
		public var moathens:Array;

		private var resourceModel:ResourceModel;
		
		public function TimesModel()
		{
			/*for(var i:uint=0; i<times.length; i++)
				times[i] = new Time(i);

			times[0].alerts[0] = new Alert(0, null, times[0]);
			times[2].alerts[0] = new Alert(0, null, times[2]);
			times[5].alerts[0] = new Alert(0, null, times[5]);*/
			//updateNotfications();
		}
			
		public function load():void
		{
			if(loaded)
				return;
			
			resourceModel = ResourceModel.instance;
			if(resourceModel.persons == null)
				resourceModel.persons = JSON.parse(new ResourceModel.personsClass());
			
			createReciters();
			data = UserModel.instance.user.times;
			
			loaded = true;
		}
		//RECITERS ______________________________________________________________________________________________________
		private function createReciters():void
		{
			moathens = new Array();
			var moathen:Moathen;
			var i:uint=0;
			for each(var p:Object in resourceModel.persons.moathens)
			{
				moathen = new Moathen(p);
				moathen.index = i;
				//recit.free = freeAthanReciters.indexOf(recit.path)>-1;
				moathens.push(moathen);
				i++;
			}
		}
		private function getMoathen(moathen:String):Moathen
		{
			for each(var r:Moathen in moathens)
			if(r.path == moathen)
				return r;
			return null;
		}
		
		public function updateNotfications():void
		{
			trace("updateNotfications");
			var alarmTime:Number = 0;
			NativeAbilities.instance.cancelInvokeApp();
			NativeAbilities.instance.cancelLocalNotifications();
			var d:Date = new Date();
			var n:Number = d.getTime();
			for each(var t:Time in times)
			{
				for (var a:uint=0; a<t.alerts.length; a++)
				{
					alarmTime = t.date.getTime() + t.alerts[a].offset*60000;
					if(n > alarmTime)
						alarmTime += Time.DAY_TIME_LEN;
					
					if(t.alerts[a].type == Alert.TYPE_ALARM)
						NativeAbilities.instance.invokeAppScheme("hidaya://athan?timeIndex="+t.index+"&alertIndex="+a, alarmTime, 0, false);
					else if(t.alerts[a].type == Alert.TYPE_NOTIFICATION)
						NativeAbilities.instance.scheduleLocalNotification(loc("pray_time_"+t.index), loc("pray_time_"+t.index), t.getAlertTitle(t.alerts[a].offset), alarmTime, Time.DAY_TIME_LEN, "", "", "", "", false);

					//var dt:Date = new Date();
					//dt.setTime(alarmTime);
					//trace(t.index, loc("pray_time_"+t.index), dt, "     " , t.date, "     " , a.offset);
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
					times[t].alerts.push(new Alert(value[t][a].offset, getMoathen(value[t][a].moathen), times[t], value[t][a].type));
			}
			//updateNotfications();
		}
		
		public function get data():Array
		{
			var ret:Array = new Array();
			for(var t:uint=0; t<times.length; t++)
			{
				ret[t] = new Array();
				for(var a:uint=0; a<times[t].alerts.length; a++)
					ret[t][a] = {offset:times[t].alerts[a].offset, moathen:times[t].alerts[a].moathen.path, type:times[t].alerts[a].type};
			}
			return ret;
		}
		
		
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}
	}
}