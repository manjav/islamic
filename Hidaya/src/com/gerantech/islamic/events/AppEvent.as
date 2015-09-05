package com.gerantech.islamic.events
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		public static const ORIENTATION_CHANGED:String = "orientationChanged";
		public static const PUSH_FIRST_SCREEN:String = "pushFirstScreen";
		//public static const INVALIDATE_CONTROLS:String = "invalidateControls";
		/*public static const APP_FULL_SCREEN:String = "appFullScreen";
		public static const APP_AUTO_ORIENTS:String = "appautoOrientsDisabled";
		public static const APP_ORIENTATION_CHANGED:String = "appOrientationChanged";
		public static const APP_DIRECTION_CHANGED:String = "appDirectionChanged";
		public static const APP_IDLE_MODE_CHANGED:String = "appIdleModeChanged";
		public static const APP_CHANGE_FONT:String = "appChangeFont";
		
		public static const SELECT_AYA:String = "appSelectAya";
		public static const SELECT_PAGE:String = "appSelectPage";
		public static const SELECT_SURA:String = "appSelectSura";
		public static const SELECT_JUZE:String = "appSelectJuze";*/
		
		
		public var data:Object;
		
		public function AppEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}