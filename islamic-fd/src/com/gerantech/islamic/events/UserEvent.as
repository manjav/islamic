package com.gerantech.islamic.events
{
	import starling.events.Event;
	
	public class UserEvent extends Event
	{
		public static const PAGE_CHANGE:String = "pageChange";
		public static const TRANSLATOR_CHANGE:String = "translatorChange";
		public static const LOAD_DATA_COMPLETE:String = "loadDataComplete";
		public static const LOAD_DATA_ERROR:String = "loadDataError";
		
		public static const FONT_SIZE_CHANGE_START:String = "fontSizeChangeStart";
		public static const FONT_SIZE_CHANGING:String = "fontSizeChanging";
		public static const FONT_SIZE_CHANGE_END:String = "fontSizeChangeEnd";
		
		public static const SET_ITEM:String = "setItem";
		public static const CHANGE_COLOR:String = "changeColor";
		
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}