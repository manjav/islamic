package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import gt.utils.GTStringUtils;
	
	import org.praytimes.PrayTime;
	import org.praytimes.constants.CalculationMethod;
	
	public class Dashboard extends LayoutGroup
	{
		private var appModel:AppModel;
		private var padding:Number;
		private var details:LayoutGroup;
		private var resultLabel:RTLLabel;
		private var nextTime:Date;
		private var nextTimeString:String;
		private var intervalID:uint;

		private var clock:Clock;
		private var locationLabel:RTLLabel;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			appModel = AppModel.instance;
			height = appModel.sizes.dashboard;
			
			// Add clock -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			clock = new Clock();
			clock.addEventListener("invokeNewParties", clock_invokeNewPartiesHandler);
			clock.scaleX = clock.scaleY = height/2/512*1.4;
			padding = (height-clock.width)/4;
			clock.y = clock.x = clock.width/2 + padding;
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
					dateText_0.text = loc("week_day_"+date.day)+" "+date.date+" "+dateGergoriStr;
					dateText_1.text = num(date.dateQamari)+" "+dateIslamicStr;
					dateText_2.text = num(date.dateShamsi)+" "+datePersianStr;
					break;
			}	
			details.addChild(dateText_0);
			details.addChild(dateText_1);
			details.addChild(dateText_2);
			
			details.addChild(new Spacer());
			
			// Type times -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			nextTime = getNextTime()[1];
			if(nextTime != null)
			{
				var txt:String = nextTimeString+" "+loc("time_of")+" "+UserModel.instance.city.name+" "+ StrTools.getNumber(GTStringUtils.dateToTime(nextTime,"Second",":"));
				locationLabel = new RTLLabel(txt, 0xFFFFFF, null, "ltr", false, null, 0.9);
				locationLabel.layoutData = new AnchorLayoutData(NaN, padding, padding, padding);
				addChild(locationLabel);  
			}
		}

		protected function nativeApplication_activateHandler(event:Event):void
		{
			nextTime = getNextTime()[1];
			locationLabel.text = nextTimeString+" "+loc("time_of")+" "+UserModel.instance.city.name+" "+ StrTools.getNumber(GTStringUtils.dateToTime(nextTime,"Second",":"));
		}


		
		
		private function clock_invokeNewPartiesHandler():void
		{
			nextTime = getNextTime()[1];
			locationLabel.text = nextTimeString+" "+loc("time_of")+" "+UserModel.instance.city.name+" "+ StrTools.getNumber(GTStringUtils.dateToTime(nextTime,"Second",":"));
		}
		private function getNextTime():Vector.<Date>
		{
			var ret:Vector.<Date> = new Vector.<Date>(2);
			var now:Date = new Date();
			var nowTime:Number = now.getTime();
			var times:Vector.<Date> = AppModel.instance.prayTimes.getTimes(now).toDates();
			for(var t:uint=0; t<times.length; t++)
			{
				if(times[t].getTime()>nowTime)
				{
					if(t==0)
					{
						ret[1] = times[0];
						now.setTime(nowTime - (1000 * 60 * 60 * 24));
						ret[0] = AppModel.instance.prayTimes.getTimes(now).toDates()[8];
					}
					else if(t==8)
					{
						ret[0] = times[8];
						now.setTime(nowTime + (1000 * 60 * 60 * 24));
						ret[1] = AppModel.instance.prayTimes.getTimes(now).toDates()[0];
					}
					else
					{
						ret[0] = times[t-1];
						ret[1] = times[t];
					}
					nextTimeString = loc("pray_time_"+t);
					break;
				}
			}
			clock.createParties(ret);
			return ret;
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