package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.utils.StrTools;

	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;

	import flash.utils.clearInterval;

	import gt.utils.Localizations;
	import feathers.layout.HorizontalAlign;
	
	public class Dashboard extends LayoutGroup
	{
		private var padding:Number;
		private var details:LayoutGroup;
		private var intervalID:uint;
		private var clock:Clock;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			height = appModel.sizes.dashboard;
			
			// Add clock -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			clock = new Clock();
			clock.scaleX = clock.scaleY = height/1.6/512;
			padding = (height-clock.width)/6;
			clock.y = clock.x = clock.width/2 + padding;
			addChild(clock);
			
			var detailsLayout:VerticalLayout = new VerticalLayout();
			detailsLayout.horizontalAlign = HorizontalAlign.JUSTIFY; 
			detailsLayout.padding = padding;
			
			details = new LayoutGroup();
			details.layoutData = new AnchorLayoutData(0, 0, 0, clock.width+padding);
			details.layout = detailsLayout;
			addChild(details);
			
			// Type dates -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
			var dateText_0:RTLLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 1.1);
			var dateText_1:RTLLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 1);
			var dateText_2:RTLLabel = new RTLLabel("", 0xFFFFFF, null, null, false, null, 0.9);
			
			var date:MultiDate = userModel.timesModel.date;
			var dateIslamicStr:String = loc("month_i_"+date.monthQamari)	+ " " + num(date.fullYearQamari);
			var datePersianStr:String = loc("month_p_"+date.monthShamsi)	+ " " + num(date.fullYearShamsi);    
			var dateGergoriStr:String = loc("month_g_"+date.month)			+ ", " + num(date.fullYear);  
			
			switch(UserModel.instance.locale.value)
			{
				case "fa_IR":
					dateText_0.text = loc("week_day_"+date.day)+" "+num(date.dateShamsi)+" "+datePersianStr;
					dateText_1.text = num(date.dateQamari)+" "+dateIslamicStr;
					dateText_2.text = num(date.date)+" "+dateGergoriStr;
					break;
				case "ar_SA":
					dateText_0.text = loc("week_day_"+date.day)+" "+num(date.dateQamari)+" "+dateIslamicStr;
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
			
			//details.addChild(new Spacer());
		}


		protected function get appModel():		AppModel		{	return AppModel.instance;		}
		protected function get userModel():		UserModel		{	return UserModel.instance;		}
		protected function loc(str:String, parameters:Array=null, locale:String=null):String
		{
			return Localizations.instance.get(str, parameters);//, locale);
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