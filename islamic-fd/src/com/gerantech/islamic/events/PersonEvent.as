package com.gerantech.bayan.events
{
	import flash.events.Event;
	
	import com.gerantech.bayan.models.vo.Sura;
	
	public class PersonEvent extends Event
	{
		
		public static const SURA_DOWNLOAD_COMPLETE:String = "suraDownloadComplete";
		
		public var sura:Sura;
		
		public function PersonEvent(type:String, sura:Sura=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.sura = sura;
			
			super(type, bubbles, cancelable);
		}
	}
}