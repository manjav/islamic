package gt.mobile.events
{
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class HoldButtonEvent extends MouseEvent
	{
		//public var data;
		public static var BUTTON_HOLD_START:String = "buttonHoldStart";
		public static var BUTTON_HOLD_END:String = "buttonHoldEnd";
		public static var BUTTON_HOLD_CANCEL:String = "buttonHoldCancel";
		public static var BUTTON_CLICK:String = "buttonClick";

		public function HoldButtonEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new HoldButtonEvent(type, bubbles, cancelable);
		}
	}
}