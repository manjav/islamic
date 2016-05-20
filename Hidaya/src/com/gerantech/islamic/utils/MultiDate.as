package com.gerantech.islamic.utils
{
	
	public class MultiDate
	{
		public function get fullYear():Number { return dateClass.fullYear; }
		//public function set fullYear(value:Number):void { dateClass.fullYear = value; calculate(); }
		
		public function get month():Number { return dateClass.month; }
		//public function set month(value:Number):void { dateClass.month = value; calculate(); }
		
		public function get date():Number { return dateClass.date; }
		//public function set date(value:Number):void { dateClass.date = value; calculate(); }
		
		public function get hours():Number { return dateClass.hours; }
		//public function set hours(value:Number):void { dateClass.hours = value; calculate(); }
		
		public function get minutes():Number { return dateClass.minutes; }
		//public function set minutes(value:Number):void { dateClass.minutes = value; calculate(); }
		
		public function get seconds():Number { return dateClass.seconds; }
		//public function set seconds(value:Number):void { dateClass.seconds = value; calculate(); }
		
		public function get milliseconds():Number { return dateClass.milliseconds; }
		//public function set milliseconds(value:Number):void { dateClass.milliseconds = value; calculate(); }
		
		public function get day():Number { return dateClass.day; }

		public var dateClass:Date;
		
		public var fullYearQamari:Number;
		public var monthQamari:Number;
		public var dateQamari:Number;
		
		public var fullYearShamsi:Number;
		public var monthShamsi:Number;
		public var dateShamsi:Number;
		
		public var firstTime:Number;
		public var middleTime:Number;
		
		public var julianDays:Number;
		public var hijriOffset:Number = 0;

		public function MultiDate(dateInput:Date = null, hijriOffset:Number=0)
		{
			if(dateInput==null)
				dateClass = new Date();
			else
				dateClass = dateInput;
			
			this.hijriOffset = hijriOffset;
			calculate();
		}
		
		public function setTime(time:*):void
		{
			dateClass.setTime(time);
			calculate();
		}
		
		/**
		 * Calculate shamsi and qamari date according to gregorian date
		 */
		public function calculate():void
		{
			julianDays = gregorianToJD(dateClass.fullYear, dateClass.month+1, dateClass.date);

			var qamari:Array = jdToIslamic(julianDays + hijriOffset);
			var shamsi:Array = jdToPersian(julianDays);
			
			fullYearQamari	= qamari[0];
			monthQamari		= qamari[1] - 1;
			dateQamari		= qamari[2];
			
			fullYearShamsi	= shamsi[0];
			monthShamsi		= shamsi[1] - 1;
			dateShamsi 		= shamsi[2];
			firstTime = new Date(fullYear, month, date).getTime();
			middleTime = firstTime + 43200000;
		}

		public  function toString():String
		{ 
			return(day+" "+date+" "+(month+1)+" "+fullYear+"  "+dateShamsi+" "+(monthShamsi+1)+" "+fullYearShamsi+"  "+dateQamari+" "+(monthQamari+1)+" "+fullYearQamari+"  "+(hours<10?"0":"")+hours+":"+(minutes<10?"0":"")+minutes); 
		}
		
		
		
		
		
		
		//  GREGORIAN_TO_JD  --  Determine Julian day number from Gregorian calendar date ____________________________________________________________________________________
		private static function gregorianToJD (year:Number, month:Number, date:Number):Number
		{
			if (month <= 2)
			{
				year -= 1;
				month += 12;
			}
			var A:Number = Math.floor(year/ 100);
			var B:Number = 2- A+ Math.floor(A/ 4);
			return Math.floor(365.25* (year + 4716)) + Math.floor(30.6001* (month+ 1)) + date + B - 1524.5;
		}

		//  LEAP_ISLAMIC  --  Is a given year a leap year in the Islamic calendar ? ____________________________________________________________________________________
		private static var ISLAMIC_EPOCH:Number = 1948439.5;
		//private static var ISLAMIC_WEEKDAYS:Array = new Array("al-'ahad", "al-'ithnayn", "ath-thalatha'", "al-'arb`a'", "al-khamis", "al-jum`a", "as-sabt");
		private static function isLeapIslamic(year):Boolean
		{
			return (((year * 11) + 14) % 30) < 11;
		}
		
		//  ISLAMIC_TO_JD  --  Determine Julian day from Islamic date
		private static function islamicToJD(year, month, date):Number
		{
			return (date +
				Math.ceil(29.5 * (month - 1)) +
				(year - 1) * 354 +
				Math.floor((3 + (11 * year)) / 30) +
				ISLAMIC_EPOCH) - 1;
		}
		
		//  JD_TO_ISLAMIC  --  Calculate Islamic date from Julian day
		private static function jdToIslamic(jd:Number):Array
		{
			var year:Number, month:Number, date:Number;
			
			jd = Math.floor(jd) + 0.5;
			year = Math.floor(((30 * (jd - ISLAMIC_EPOCH)) + 10646) / 10631);
			month = Math.min(12, Math.ceil((jd - (29 + islamicToJD(year, 1, 1))) / 29.5) + 1);
			date = (jd - islamicToJD(year, month, 1)) + 1;
			return new Array(year, month, date);
		}
		
		//  LEAP_PERSIAN  --  Is a given year a leap year in the Persian calendar ? ____________________________________________________________________________________--
		private static var PERSIAN_EPOCH:Number = 1948320.5;
		//private static var PERSIAN_WEEKDAYS:Array = new Array("Yekshanbeh", "Doshanbeh", "Seshhanbeh", "Chaharshanbeh", "Panjshanbeh", "Jomeh", "Shanbeh");
		private static function isLeapPersian(year:Number):Boolean
		{
			return ((((((year - ((year > 0) ? 474 : 473)) % 2820) + 474) + 38) * 682) % 2816) < 682;
		}
		
		//  PERSIAN_TO_JD  --  Determine Julian day from Persian date
		private static function persianToJD(year:Number, month:Number, day:Number):Number
		{
			var epbase:Number, epyear:Number;
			
			epbase = year - ((year >= 0) ? 474 : 473);
			epyear = 474 + (epbase% 2820);
			
			return day +
				((month <= 7) ?
					((month - 1) * 31) :
					(((month - 1) * 30) + 6)
				) +
				Math.floor(((epyear * 682) - 110) / 2816) +
				(epyear - 1) * 365 +
				Math.floor(epbase / 2820) * 1029983 +
				(PERSIAN_EPOCH - 1);
		}
		
		//  JD_TO_PERSIAN  --  Calculate Persian date from Julian day
		private static function jdToPersian(jd:Number):Array
		{
			var year:Number, month:Number, day:Number, depoch:Number, cycle:Number, 
			cyear:Number, ycycle:Number, aux1:Number, aux2:Number, yday:Number;
			
			jd = Math.floor(jd) + 0.5;
			
			depoch = jd - persianToJD(475, 1, 1);
			cycle = Math.floor(depoch / 1029983);
			cyear = (depoch% 1029983);
			if (cyear == 1029982)
				ycycle = 2820;
			else 
			{
				aux1 = Math.floor(cyear / 366);
				aux2 = (cyear % 366);
				ycycle = Math.floor(((2134 * aux1) + (2816 * aux2) + 2815) / 1028522) +
					aux1 + 1;
			}
			year = ycycle + (2820 * cycle) + 474;
			if (year <= 0)
				year--;
			yday = (jd - persianToJD(year, 1, 1)) + 1;
			month = (yday <= 186) ? Math.ceil(yday / 31) : Math.ceil((yday - 6) / 30);
			day = (jd - persianToJD(year, month, 1)) + 1;
			return new Array(year, month, day);
		}

		public function equalDay(i_date:Date):Boolean
		{
			// TODO Auto Generated method stub
			return i_date.date == date && i_date.month==month && i_date.fullYear==fullYear;
		}
	}
}