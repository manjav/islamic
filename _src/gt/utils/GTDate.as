package gt.utils
{
	public class GTDate
	{

		private static var weekDays:Array = new Array("يكشنبه","دوشنبه","سه شنبه","چهارشنبه","پنج شنبه","جمعه","شنبه");;
		private static var months:Array = new Array("فروردين","ارديبهشت","خرداد","تير","مرداد","شهريور","مهر","آبان","آذر","دي","بهمن","اسفند");;
		private static var date:Number = 0;
		private static var month:Number = 0;
		private static var year:Number = 0;
		private static var day:Number = 0;


		public static function gatPersianDate(initDate:Date=null):Date
		{
			var myDate:Date = new Date(); 
			if(initDate!=null)
				myDate.time = initDate.time
			day= myDate.day; 
			date = myDate.date; 
			month = myDate.month+1;
			year = myDate.fullYear;
			
			if (year == 0)
				year = 2000;
			
			if (year < 100)
				year += 1900;
			
			//Define Year type ------
			var y:int = 1; 
			var i:uint;
			for(i=0; i<3000; i+=4)
			{ 
				if (year==i)
					y=2;
			} 
			for(i=1; i<3000; i+=4)
			{ 
				if (year==i)
					y=3;
			}
			
			if (y==1) 
			{ 
				year -= ( (month < 3) || ((month == 3) && (date < 21)) )? 622:621; 
				switch (month)
				{ 
					case 1: (date<21) ? (month=10, date+=10) : (month=11, date-=20); break; 
					case 2: (date<20) ? (month=11, date+=11) : (month=12, date-=19); break; 
					case 3: (date<21) ? (month=12, date+=9) : (month=1, date-=20);   break; 
					case 4: (date<21) ? (month=1, date+=11) : (month=2, date-=20);   break; 
					case 5: 
					case 6: (date<22) ? (month-=3, date+=10) : (month-=2, date-=21); break; 
					case 7:
					case 8:
					case 9: (date<23) ? (month-=3, date+=9) : (month-=2, date-=22);  break; 
					case 10: (date<23) ? (month=7, date+=8) : (month=8, date-=22);   break; 
					case 11: 
					case 12: (date<22) ? (month-=3, date+=9) : (month-=2, date-=21); break; 
				} 
			} 
			if (y == 2)
			{ 
				year -= ( (month < 3) || ((month == 3) && (day < 20)) )? 622:621; 
				switch (month) 
				{ 
					case 1: (day<21) ? (month=10, day+=10) : (month=11, day-=20); break; 
					case 2: (day<20) ? (month=11, day+=11) : (month=12, day-=19); break; 
					case 3: (day<20) ? (month=12, day+=10) : (month=1, day-=19);  break; 
					case 4: (day<20) ? (month=1, day+=12) : (month=2, day-=19);   break; 
					case 5: (day<21) ? (month=2, day+=11) : (month=3, day-=20);   break; 
					case 6: (day<21) ? (month=3, day+=11) : (month=4, day-=20);   break; 
					case 7: (day<22) ? (month=4, day+=10) : (month=5, day-=21);   break; 
					case 8: (day<22) ? (month=5, day+=10) : (month=6, day-=21);   break; 
					case 9: (day<22) ? (month=6, day+=10) : (month=7, day-=21);   break; 
					case 10:(day<22) ? (month=7, day+=9) : (month=8, day-=21);    break; 
					case 11:(day<21) ? (month=8, day+=10) : (month=9, day-=20);   break; 
					case 12:(day<21) ? (month=9, day+=10) : (month=10, day-=20);  break; 
				} 
			} 
			if (y==3)
			{ 
				year -= ( (month < 3) || ((month == 3) && (day < 21)) )? 622:621; 
				switch (month) 
				{ 
					case 1: (day<20) ? (month=10, day+=11) : (month=11, day-=19); break; 
					case 2: (day<19) ? (month=11, day+=12) : (month=12, day-=18); break; 
					case 3: (day<21) ? (month=12, day+=10) : (month=1, day-=20);  break; 
					case 4: (day<21) ? (month=1, day+=11) : (month=2, day-=20);   break; 
					case 5: 
					case 6: (day<22) ? (month-=3, day+=10) : (month-=2, day-=21); break; 
					case 7: 
					case 8: 
					case 9: (day<23) ? (month-=3, day+=9) : (month-=2, day-=22);  break; 
					case 10:(day<23) ? (month=7, day+=8) : (month=8, day-=22);    break; 
					case 11: 
					case 12:(day<22) ? (month-=3, day+=9) : (month-=2, day-=21);  break; 
				} 
			} 
			myDate.month  = month-1;
			myDate.fullYear = year;
			myDate.date = date;
			//trace(1, weekDays[day]+" "+date+" "+months[month-1]+" "+ year + "  " + myDate.hours+":"+myDate.minutes); 
			return myDate;
		}
		
		
		public static function gatPersianDateStr(initDate:Date=null):String
		{ 
			var dt:Date = gatPersianDate(initDate);
			//trace(2, weekDays[day]+" "+date+" "+months[month-1]+" "+ year + "  " + (dt.hours<10?"0":"")+dt.hours+":"+(dt.minutes<10?"0":"")+dt.minutes); 
			return(weekDays[day]+" "+date+" "+months[month-1]+" "+ year + "  " + (dt.hours<10?"0":"")+dt.hours+":"+(dt.minutes<10?"0":"")+dt.minutes); 
		}
	}

/*
	class PersianDate
	{
		public var date:Number = 0;
		public var month:Number = 0;
		public var fullYear:Number = 0;
		public var day:Number = 0;
		public var dayName:String = 0;
	}*/
}