package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;
	
	public class Juze extends BaseQData
	{

		public function Juze(xml:XML)
		{
			this.xml = xml;
		}
		
		override public function set xml(value:XML):void
		{
			this.juze = uint(value.@index);
			this.index = juze-1;
			this.sura = uint(value.@sura);
			this.aya = uint(value.@aya);
			this.name = value.@name; 
			this.page = uint(value.@page);
		}
		
		
		override public function complete():void
		{
			var res:ResourceModel = ResourceModel.instance;
			ayas = new Array();
			var nextJuze:Juze = juze<30 ? res.juzeList[index+1] : new Juze(new XML('<juz index="31" sura="115" aya="1" name="" page="605"/>'));
			var order:uint;
			if(sura == nextJuze.sura)
			{
				for (var i:uint=aya; i<nextJuze.aya; i++)
				{
					ayas.push(new Aya(sura, i, order, page, juze));//, baseXML.sura[suraIndex].aya[i])
					order ++;
				}
			}
			else
			{
				i = 0;
				for (var s:uint=sura-1; s<nextJuze.sura; s++)
				{
					if(s == sura-1)
					{
						for (var a:uint=aya-1; a<suraObject.numAyas; a++)
						{
							ayas.push(new Aya(sura, a+1, order, page, juze));
							i++;
							order ++
						}
					}
					else if(s != 114)
					{
						for (var b:uint=0; b<res.suraList[s].numAyas; b++)
						{
							if(s == nextJuze.sura-1 && b == nextJuze.aya-1)
							{
								break;
							}
							ayas.push(new Aya(s+1, b+1, order, page, juze));
							i++;
							order ++;
						}
						//a += res.suraList[s].numAyas;
					}
				}
			}
			ayas[ayas.length-1].isLastItem = true;
		}
		
		public static function getBySuraAya(sura:uint, aya:uint):Juze
		{
			var js:Vector.<Juze> = ResourceModel.instance.juzeList;
			var len:uint = js.length;
			for (var i:int=len-1; i>=0; i--)
				if(js[i].sura==sura)
				{
					if(js[i].aya<=aya)
						return js[i];
				}
				else if(js[i].sura<sura)
					return js[i];
			
			return (js[0]);
		}
		
		public static function getByPage(page:uint):Juze
		{
			var js:Vector.<Juze> = ResourceModel.instance.juzeList;
			for (var i:int=js.length-1; i>=0; i--)
				if(js[i].page<=page)
					return js[i];
			
			return (js[0]);
		}
	}
}