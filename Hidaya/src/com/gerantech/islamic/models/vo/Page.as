package com.gerantech.islamic.models.vo
{	
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.utils.StrTools;
	
	import gt.utils.GTStringUtils;
	
	public class Page extends BaseQData
	{
		
		public var lineList:Array;
		public var surasList:Array;
		public var bismsList:Array;
		
		public var text:String;
		
		public var dir:String="rtl";
		
		public function Page(xml:XML)
		{
			this.xml = xml;
		}
		
		override public function set xml(value:XML):void
		{
			this.page = uint(value.@index);
			this.sura = uint(value.@sura);
			this.aya = uint(value.@aya);
			lineList = String(value.@lines)=='' ? new Array() : String(value.@lines).split("-");
			surasList = String(value.@suras)=='' ? new Array() : String(value.@suras).split("-");
			bismsList = String(value.@bisms)=='' ? new Array() : String(value.@bisms).split("-");
			this.index = page-1;
		}
		
		override public function complete():void
		{
			var res:ResourceModel = ResourceModel.instance;
			//var baseXML:XML = ResourceModel.instance.quranXML;
			//_page.dir = dir;
			
			//_page.aya = uint(metaXML.pages.page[pageIndex-1].@aya);
			//var suraIndex:uint = uint(metaXML.pages.page[pageIndex-1].@sura)-1;
			//var ayaIndex:uint = _page.aya-1;
			var nextPage:Page = page<res.pageList.length ? res.pageList[index+1] : new Page(new XML('<page index="605" sura="115" aya="1"/>'));
			

			//var suraNext:uint = page == 604 ? 114 : sura-1;//uint(metaXML.pages.page[pageIndex].@sura)-1;
			//var ayaNext:uint = pageIndex == metaXML.pages.page.length() ? 0 : uint(metaXML.pages.page[pageIndex].@aya)-1;
			
			//var sml:XML = metaXML.suras.sura[suraIndex];
			//suraObject = new Sura(sml);
			ayas = new Array();
			var order:uint;
			if(sura == nextPage.sura)
			{
				for (var i:uint=aya; i<nextPage.aya; i++)
				{
					ayas.push(new Aya(sura, i, order, page, juze));//, baseXML.sura[suraIndex].aya[i])
					order ++;
				}
			}
			else
			{
				for (var s:uint=sura; s<=nextPage.sura; s++)
				{
					if(s == sura)
					{
						for (var a:uint=aya; a<=suraObject.numAyas; a++)
						{
							ayas.push(new Aya(sura, a, order, page, juze));//, baseXML.sura[suraIndex].aya[a]
							order ++
						}
					}
					else if(s < 115)
					{
						for (var b:uint=1; b<=res.suraList[s-1].numAyas; b++)
						{
							if(s == nextPage.sura && b == nextPage.aya)
							{
								break;
							}
							ayas.push(new Aya(s, b, order, page, juze));
							order ++;
						}
						//a += res.suraList[sura-1].numAyas;
					}
				}
			}
			ayas[ayas.length-1].isLastItem = true;
		}




		public function create(uthmani:Boolean=true):void
		{
			text = '';
			for each(var a:Aya in ayas)
			{
				var ayaTxt:String = ResourceModel.instance.quranXML.sura[a.sura-1].aya[a.index].@text
				if(uthmani && a.index==0 && index<2)
					ayaTxt = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" + ayaTxt;
				
				text += ayaTxt + (uthmani?(' ﴿'+StrTools.getArabicNumber(a.aya.toString())+'﴾ '):(' ('+StrTools.getNumberFromLocale(a.aya, dir)+')\n\n'));
				a.dir = dir;
			}
			
			if(uthmani)
			{
				text = StrTools.join(text, lineList, '\n');
			
				var ayaList:Array = GTStringUtils.getSplitsWithPatt(text, "﴾ ");
				text = '';
				for(var i:uint=0; i<ayas.length; i++)
				{
					a = ayas[i];
					a.start = text.length;
					a.textWithNum = ayaList[i];
					text += a.textWithNum
					a.end = text.length-1;
				}
			}
		}
		
		public function getSuras():Vector.<Sura>
		{
			var ret:Vector.<Sura> = new Vector.<Sura>();			
			for each(var s:Sura in ResourceModel.instance.suraList)
				if(s.page == page)
					ret.push(s);
			
			return (ret);
		}
		
		public static function getBySuraAya(sura:uint, aya:uint):Page
		{
			var res:ResourceModel = ResourceModel.instance;
			if(sura==114)
			{
				return res.pageList[res.pageList.length-1]
			}
			
			var thisSura:Sura = res.suraList[sura-1];
			var nextSura:Sura = res.suraList[sura]; 
			if(thisSura.page == nextSura.page)
				return res.pageList[nextSura.page-1];
			
			
			/*for (var p:int=thisSura.actualPage-1; p<nextSura.actualPage-1; p++)
			{
				if(res.pageList[p].aya<=aya)
					return res.pageList[p];
			}*/
			for (var p:int=nextSura.actualPage-1; p>=thisSura.actualPage-1; p--)
			{
				//trace("page", p)
				var pg:Page = res.pageList[p];
				if((pg.sura==sura && pg.aya<=aya) || pg.sura<sura)
					return res.pageList[p];
			}
			return null;//(res.pageList[nextSura.actualPage-1]);
			
		}
		
		
		public function getBySura(sura:uint):Page
		{
			return ResourceModel.instance.pageList[ResourceModel.instance.suraList[sura-1].actualPage-1];
		}		
		/*
		public function getPageByHizb(hizb:Hizb):Page
		{
			return (pageList[hizb.page-1]);
		}
		public function getPageByRuku(ruku:Hizb):Page
		{
			return(getPageBySuraAya(ruku.sura, ruku.aya));
		}
		public function getPageBySura(sura:Sura):Page
		{
			return(pageList[suraList[sura.index-1].page-1]);
		}
			public function getPageByJoze(value:uint):int
			{
			var suraIndex:uint = uint(mataXML.juzs.juz[value-1].@sura);
			var ayaIndex:uint = uint(mataXML.juzs.juz[value-1].@aya);
			return(getPageBySuraAya(suraIndex, ayaIndex));
			}*/
	}
}