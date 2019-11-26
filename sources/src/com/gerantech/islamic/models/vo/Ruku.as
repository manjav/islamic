package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;

	public class Ruku extends BaseQData
	{
		public var ruku:uint;
		
		public function Ruku(xml:XML)
		{
			this.xml = xml;
		}
		
		override public function set xml(value:XML):void
		{
			ruku = uint(value.@index);
			sura = uint(value.@sura);
			aya = uint(value.@aya);
			index = ruku-1;
		}
		
		public static function getBySuraAya(sura:uint, aya:uint):Ruku
		{
			var rs:Vector.<Ruku> = ResourceModel.instance.rukuList;
			for (var i:uint=0; i<rs.length; i++)
			{
				if(rs[i].sura==sura)
				{
					if(rs[i].aya>aya)
						return rs[i-1];
					else if(rs[i].aya==aya)
						return rs[i];
				}
				else if(rs[i].sura>sura)
				{
					return rs[i-1];
				}
			}
			return null;
		}
	}
}