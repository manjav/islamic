package com.gerantech.islamic.models.vo
{
	import com.gerantech.extensions.CalendarEvent;
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import starling.events.EventDispatcher;

	public class DayDataProvider extends EventDispatcher
	{
		public var mainDateString:String = "";
		public var secondaryDatesString:String = "";
		public var eventsString:String = "";
		public var googleEventsString:String = "";
		
		private var sqlConnection:SQLConnection;
		private var date:MultiDate;
		private var googleEvents:Vector.<CalendarEvent>;
		private var _time:Object;

		public function DayDataProvider()
		{
			date = new MultiDate();
			sqlConnection = new SQLConnection();
			//sqlConnection.addEventListener(SQLEvent.OPEN, sqlConnection_openHandler); 
			//sqlConnection.addEventListener(SQLErrorEvent.ERROR, sqlConnection_errorHandler); 
			sqlConnection.open(File.applicationDirectory.resolvePath("com/gerantech/islamic/assets/contents/events.db"), SQLMode.READ);//, null, false, 1024, AppModel.instance.byteArraySec); 
			googleEvents = NativeAbilities.instance.getCalendarEvents();
		}
		
		
		public function setTime(time:Object):void
		{
			_time = time as Number;
			date.setTime(time);

			mainDateString = isToday ? "امروز " : "";
			//setTitleStyle(date.date==appModel.date.date && date.month==appModel.date.month ? BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR : BaseMaterialTheme.PRIMARY_TEXT_COLOR); 
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					mainDateString +=  loc("week_day_"+date.day)+" "+StrTools.getNumber(date.dateShamsi)+" "+loc("month_p_"+date.monthShamsi)	+ " " + StrTools.getNumber(date.fullYearShamsi);
					secondaryDatesString = StrTools.getNumber(date.dateQamari)+" "+loc("month_i_"+date.monthQamari)+" "+StrTools.getNumber(date.fullYearQamari)+" - "+StrTools.getNumber(date.date)+" "+loc("month_g_"+date.month) + ", " + StrTools.getNumber(date.fullYear);
					break;
				case "ar_SA":
					mainDateString +=  loc("week_day_"+date.day)+" "+StrTools.getNumber(date.dateQamari)+" "+loc("month_i_"+date.monthQamari)	+ " " + StrTools.getNumber(date.fullYearQamari);
					secondaryDatesString = StrTools.getNumber(date.date)+" "+loc("month_g_"+date.month) + ", " + StrTools.getNumber(date.fullYear);
					break;
				default:
					mainDateString +=  loc("week_day_"+date.day)+" "+StrTools.getNumber(date.date)+" "+loc("month_g_"+date.month) + ", " + StrTools.getNumber(date.fullYear);
					secondaryDatesString = StrTools.getNumber(date.dateQamari)+" "+loc("month_i_"+date.monthQamari) + ", " + StrTools.getNumber(date.fullYearQamari);
					break;
			}
			
			// get google calendar events
			var ge:Array = getGoogleEvents();
			googleEventsString = ge.length>0 ? ge.join(" - ") : "";
			
			// get persian, gregorian and islamic calendars events
			eventsString = "";
			query("select text, holiday from hijri where date="+date.dateQamari+" AND month="+date.monthQamari
				+ " union all select text, holiday from persian where date="+date.dateShamsi+" AND month="+date.monthShamsi
				+ " union all select text, holiday from gregorian where date="+date.date+" AND month="+date.month
				, persianQueryCallback);
			
			function persianQueryCallback(result:Object):void
			{
				if(result is SQLErrorEvent || result.data==null)
				{
					if(result is SQLErrorEvent)
						trace(SQLErrorEvent(result).text);
					dispatchEventWith("update");
					return;
				}
				for(var s:int=0; s<result.data.length; s++)
					eventsString += result.data[s].text + (s<result.data.length-1?" - ":"");
				dispatchEventWith("update");
			}
		}		
		
		private function query(query:String, response:Function):void
		{
			var createStmt:SQLStatement = new SQLStatement(); 
			createStmt.sqlConnection = sqlConnection; 
			createStmt.text = query ;
			createStmt.addEventListener(SQLEvent.RESULT, createResult); 
			createStmt.addEventListener(SQLErrorEvent.ERROR, createError); 
			if(sqlConnection==null || sqlConnection.connected)
				createStmt.execute(); 
			else
			{
				setTimeout(response, 1, new SQLErrorEvent(SQLErrorEvent.ERROR, false, false, new SQLError("execute", "SQL Connection not found.")));
				return;
			}
			//trace(query);
			function createError(event:SQLErrorEvent):void
			{
				response(event);
			}
			function createResult(event:SQLEvent):void
			{
				response(createStmt.getResult());
			}			
		}

		
		private function getGoogleEvents():Array
		{
			var ret:Array = new Array();
			if(googleEvents != null)
				for each(var ev:CalendarEvent in googleEvents)
				{
					//trace(ev.startTime, ev.name);
					if(ev.startTime >=_time && ev.startTime<_time+Time.DAY_TIME_LEN)
						ret.push(ev.name);
				}
			return ret;
		}
		
		
		
		public function get isToday():Boolean
		{
			return date.date==AppModel.instance.date.date && date.month==AppModel.instance.date.month;
		}
		
		public function get isFirstDay():Boolean
		{
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					return (date.dateShamsi == 1);
				case "ar_SA":
					return (date.dateQamari == 1);
				default:
					return (date.date == 1);
			}	
			return false;
		}
		
		public function get currentDate():Number
		{
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					return date.dateShamsi;
				case "ar_SA":
					return date.dateQamari;
				default:
					return date.date;
			}	
			return 1;
		}
		
		public function get currentMonth():Number
		{
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					return date.monthShamsi;
				case "ar_SA":
					return date.monthQamari;
				default:
					return date.month;
			}	
			return 0;
		}
	
		protected function loc(resourceName:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", resourceName, parameters, locale);
		}
	}
}