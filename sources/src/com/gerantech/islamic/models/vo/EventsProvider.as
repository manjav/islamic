package com.gerantech.islamic.models.vo
{
	import com.gerantech.extensions.CalendarEvent;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;

	import gt.utils.Localizations;

	import starling.events.EventDispatcher;

	public class EventsProvider extends EventDispatcher
	{
		public var date:MultiDate;
		public var holiday:Boolean;
		public var mainDateString:String = "";
		public var secondaryDatesString:String = "";
		public var eventsString:String = "";
		public var googleEventsString:String = "";
		
		private var time:Object;
		private var persians:Array;
		private var gregorians:Array;
		private var islamics:Array;
		private var googleEvents:Vector.<CalendarEvent>;

		[Embed(source = "../../assets/contents/events-persian.csv", mimeType="application/octet-stream")]
		private static const PersianEvents:Class;
		[Embed(source = "../../assets/contents/events-gregorian.csv", mimeType="application/octet-stream")]
		private static const GaregorianEvents:Class;
		[Embed(source = "../../assets/contents/events-islamic.csv", mimeType="application/octet-stream")]
		private static const IslamicEvents:Class;
	
		public function EventsProvider()
		{
			this.date = new MultiDate(null, UserModel.instance.hijriOffset);
			this.persians = createEvents(new PersianEvents());
			this.islamics = createEvents(new IslamicEvents());
			this.gregorians = createEvents(new GaregorianEvents());
			this.googleEvents = new Vector.<CalendarEvent>;// NativeAbilities.instance.getCalendarEvents();
		}
				
		public function setTime(time:Object):void
		{
			this.holiday = false;
			this.time = time as Number;
			this.date.setTime(time);

			this.mainDateString = isToday ? "امروز " : "";
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
			// var ge:Array = getGoogleEvents();
			// googleEventsString = ge.length>0 ? ge.join(" - ") : "";
			
			// get persian, gregorian and islamic calendars events
			eventsString = "";
			for each(var e:Array in persians)
				if( int(e[0]) == date.monthShamsi && int(e[1]) == date.dateShamsi )
					addEvent(e);
			for each(e in gregorians)
				if( int(e[0]) == date.month && int(e[1]) == date.date )
					addEvent(e);
			for each(e in islamics)
				if( int(e[0]) == date.monthQamari && int(e[1]) == date.dateQamari )
					addEvent(e);

			function addEvent(e:Object):void {
				eventsString += "\n• " + e[2];
				if( !holiday )
					holiday = e[3] == "1\r";
			}
		}		
		
		private function getGoogleEvents():Array
		{
			var ret:Array = new Array();
			if(googleEvents == null)
				return ret;
			for each(var ev:CalendarEvent in googleEvents)
				if(ev.startTime >=time && ev.startTime<time+Time.DAY_TIME_LEN)
					ret.push(ev.name);
			return ret;
		}
		
		public function get isHoliday():Boolean
		{
			if( holiday )
				return true;
			return date.day == 5;
		}

		public function get isToday():Boolean
		{
			return UserModel.instance.timesModel.date.equalDay(date.dateClass);
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
			return Localizations.instance.get(resourceName, parameters);//, locale);
		}

		private function createEvents(csv:*):Array
		{
			var ret:Array = new Array();
			var lines:Array = csv.toString().split("\n");

			for(var i:int=1; i<lines.length; i++)
				ret.push(String(lines[i]).split(","));
			return ret;
		}
	}
}