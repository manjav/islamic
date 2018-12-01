package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;

	public class BaseQData
	{
		public var index:uint;
		
		public var sura:uint = 1;
		public var aya:uint = 1;
		public var page:uint = 1;
		public var juze:uint = 1;
		
		public var ayas:Array;
		public var name:String = '';
		public var isLastItem:Boolean;

		public function BaseQData()
		{
		}
	
		public function set xml(value:XML):void
		{
		}
		
		public function complete():void
		{
		}	
		
		public function equals(qdata:BaseQData):Boolean
		{
			return  aya==qdata.aya && sura==qdata.sura;
		}
		

		
		public function get suraObject():Sura
		{
			return ResourceModel.instance.suraList[sura-1];
		}
		
		/*public function setTo(sura:uint, aya:uint, juze:uint, page:uint):void
		{
			this.sura = sura;
			this.aya = aya;
			this.juze = juze;
			this.page = page;
		}*/
		
		public function toString():String
		{
			return("BaseQData[ Sura: "+ sura + "  Aya: "+ aya + "  Juze: "+ juze + "  Page: "+ page + "]"); 
		}

	}
}