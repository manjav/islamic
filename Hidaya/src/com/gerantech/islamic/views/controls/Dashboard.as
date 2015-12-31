package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import org.praytimes.PrayTime;
	import org.praytimes.constants.CalculationMethod;
	
	public class Dashboard extends LayoutGroup
	{
		private var appModel:AppModel;
		private var padding:Number;
		private var details:LayoutGroup;
		private var resultLabel:RTLLabel;
		private var nextTime:Date;
		private var remainingTimeString:String;
		private var intervalID:uint;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			appModel = AppModel.instance;
			appModel.prayTimes = new PrayTime(CalculationMethod.TEHRAN, UserModel.instance.city.latitude, UserModel.instance.city.longitude);
			
			height = appModel.sizes.dashboard;
			
			// Add clock -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			
			var clock:Clock = new Clock();
			clock.scaleX = clock.scaleY = height/2/512*1.7;
			padding = (height-clock.width)/2;
			clock.x = clock.width/2 + padding;
			clock.y = height/2;
			addChild(clock);
			
			var detailsLayout:VerticalLayout = new VerticalLayout();
			detailsLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY; 
			detailsLayout.padding = padding;
			
			details = new LayoutGroup();
			details.layoutData = new AnchorLayoutData(0, 0, 0, clock.width+padding);
			details.layout = detailsLayout;
			addChild(details);
			
			// Type dates -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			
			var dateText_0:RTLLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 1.1);
			var dateText_1:RTLLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 1);
			var dateText_2:RTLLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 0.9);
			
			var date:MultiDate = appModel.date;
			var dateIslamicStr:String = loc("month_i_"+date.monthQamari)	+ " " + num(date.fullYearQamari);
			var datePersianStr:String = loc("month_p_"+date.monthShamsi)	+ " " + num(date.fullYearShamsi);    
			var dateGergoriStr:String = loc("month_g_"+date.month)			+ ", " + num(date.fullYear);  
			
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					dateText_0.text = loc("week_day_"+date.day)+" "+loc("j_"+date.dateShamsi)+" "+datePersianStr;
					dateText_1.text = num(date.dateQamari)+" "+dateIslamicStr;
					dateText_2.text = num(date.date)+" "+dateGergoriStr;
					break;
				case "ar_SA":
					dateText_0.text = loc("week_day_"+date.day)+" "+loc("j_"+date.dateQamari)+" "+dateIslamicStr;
					dateText_1.text = num(date.date)+" "+dateGergoriStr;
					dateText_2.text = num(date.dateShamsi)+" "+datePersianStr;
					break;
				default:
					dateText_0.text = loc("week_day_"+date.day)+", "+date.date+" "+dateGergoriStr;
					dateText_1.text = num(date.dateQamari)+" "+dateIslamicStr;
					dateText_2.text = num(date.dateShamsi)+" "+datePersianStr;
					break;
			}	
			details.addChild(dateText_0);
			details.addChild(dateText_1);
			details.addChild(dateText_2);
			
			details.addChild(new Spacer());
			
			// Type times -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

			nextTime = getNextTime();
			if(nextTime != null)
			{
				var txt:String = "وقت شرعی بعدی به افق " + UserModel.instance.city.name
				var locationLabel:RTLLabel = new RTLLabel(txt, 0xFFFFFF, null, null, false, null, 0.9);
				details.addChild(locationLabel);  
			
				resultLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 0.8);
				details.addChild(resultLabel);  
				intervalID = setInterval(printNextTimeRemainig, 1000);
				printNextTimeRemainig();
			}
		
		}
		
		private function printNextTimeRemainig():void
		{
			var now:Date = new Date();
			var dif:uint = (nextTime.getTime() - now.getTime())/1000;
			var h:Number = Math.floor(dif/3600);
			var m:Number = Math.floor((dif%3600)/ 60);
			var s:Number = dif - h*3600 - m*60;

			resultLabel.text = remainingTimeString+" "+timed(nextTime.hours, true)+":"+timed(nextTime.minutes)+":"+timed(nextTime.seconds)+" , فرصت: "+" "+timed(h, true)+":"+timed(m)+":"+timed(s);
		}
		
		private function timed(time:Number, isHour:Boolean=false):String
		{
			var ret:String = time.toString();
			if(time<10 && !isHour)
				ret = "0"+time;
			return StrTools.getNumber(ret);
		}
		
		private function getNextTime():Date
		{
			var times:Vector.<Date> = appModel.prayTimes.getTimes(new Date()).toDates();
			for(var t:uint=1; t<times.length; t++)
			{
				if(times[t].hours>appModel.date.hours)
				{
					remainingTimeString = loc("pray_time_"+t);
					return times[t];
				}
			}
			return null;
		}		
		
		
		
		
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return ResourceManager.getInstance().getString("loc", str, parameters, locale);
		}
		protected function num(input:Object):String
		{
			return StrTools.getNumber(input);
		}
		override public function dispose():void
		{
			clearInterval(intervalID);
			super.dispose();
		}
	}
}