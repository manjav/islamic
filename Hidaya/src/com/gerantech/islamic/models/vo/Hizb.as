package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;

	public class Hizb extends BaseQData
	{
		public var hizb:uint;
		
		public function Hizb(xml:XML)
		{
			this.xml = xml;
		}
		
		override public function set xml(value:XML):void
		{
			hizb = uint(value.@index);
			sura = uint(value.@sura);
			aya = uint(value.@aya);
			index = hizb-1;
			juze = Math.floor(index/8)+1;
		}
		
		public static function getBySuraAya(sura:uint, aya:uint):Hizb
		{
			var hs:Vector.<Hizb> = ResourceModel.instance.hizbList;
			for (var i:uint=0; i<hs.length; i++)
			{
				if(sura>99)
					return hs[hs.length-1];
				if(hs[i].sura==sura)
				{
					if(hs[i].aya>aya)
						return hs[i-1];
					else if(hs[i].aya==aya)
						return hs[i];
				}
				else if(hs[i].sura>sura)
				{
					return hs[i-1];
				}
			}
			return null;
		}
	}
}