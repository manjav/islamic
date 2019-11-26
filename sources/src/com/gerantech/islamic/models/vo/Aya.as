package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;
	

	public class Aya extends BaseQData
	{
		public var order:uint;
		
		public var numLines:uint;
		public var start:uint;
		public var end:uint;
		public var text:String;
		public var dir:String="ltr";
		public var bookmarked:Boolean;
		public var hasBism:Boolean;
		
		
		private var _textWithNum:String = '';
		

		public function Aya(sura:uint, aya:uint, order:uint, page:uint=1, juze:uint=1)//, xml:XML=null, person:Person=null
		{
			this.sura = sura;
			this.aya = aya;
			this.page = page;
			this.juze = juze;
			this.index = Math.max(aya-1, 0);
			this.order = order;
			//this.person = person;
			//this.xml = xml;
			this.hasBism = (index==0&&sura!=9);//&&sura>2
		}
		
	/*	override public function set xml(value:XML):void
		{
			if(value!=null)
			{
				this.aya = uint(value.@index);
				this.text = value.@text;
			}
		}*/
		
		public function set textWithNum(value:String):void
		{
			_textWithNum = value;
			numLines = _textWithNum.split("\n").length;
		}
		public function get textWithNum():String
		{
			return(_textWithNum);
		}
		
		
		override public function toString():String
		{
			return("AYA[ Sura: "+ sura + "  Aya: "+ aya + "  Juze: "+ juze + "  Page: "+ page)// + "  Order: "+ order +"  Start: "+ start +"  End:"+ end +"]");
		}
		
		public static function getNext(aya:Aya):Aya
		{
			var ret:Aya = new Aya(aya.sura, aya.aya, 0);
			if(ret.suraObject.numAyas==ret.aya)
			{
				if(ret.sura<114)
				{
					ret.sura ++;
					ret.aya = 1;
					ret.order = 0;
				}
				else
					return null;
			}
			else
				ret.aya ++;
			
			return ret;
		}
		public static function getPrevious(aya:Aya):Aya
		{
			var ret:Aya = new Aya(aya.sura, aya.aya, 0);
			if(ret.aya==1)
			{
				if(ret.sura>1)
				{
					ret.sura --;
					ret.aya = ret.suraObject.numAyas;
					//ret.order = 0;
				}
				else
					return null;
			}
			else
				ret.aya --;
			
			return ret;
		}
	}
}