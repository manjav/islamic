package com.gerantech.islamic.models
{
	import com.gerantech.islamic.models.vo.Hizb;
	import com.gerantech.islamic.models.vo.Juze;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.models.vo.Ruku;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.models.vo.Word;
	
	import flash.utils.ByteArray;
		
	public class ResourceModel
	{
		public var quranXML:XML;
		public var metaXML:XML;
		public var simpleQuran:Array;
		/*[Embed("../assets/contents/quran-uthmani.xml", encoding="utf-8")]
		private static const quranClass:Class;
		
		[Embed("../assets/contents/uthmani-metadata.xml", encoding="utf-8")]//, mimeType="application/octet-stream")]
		private static const metaClass:Class;
		
		[Embed("../assets/contents/quran-simple-clean.xml", encoding="utf-8")]
		private static const simpleClass:Class;
		public var simpleXML:XML;
		
		[Embed("../assets/contents/quran-simple.bt", mimeType="application/octet-stream")]
		private static const simpleClass:Class;
		
		[Embed("../assets/contents/words.bt", mimeType="application/octet-stream")]
		private static const wordsClass:Class;*/
		
		public var playerAyaList:Array;
		public var popupSuraList:Array;
		public var suraList:Vector.<Sura>;
		public var juzeList:Vector.<Juze>;
		public var hizbList:Vector.<Hizb>;
		public var pageList:Vector.<Page>;
		public var rukuList:Vector.<Ruku>;
		public var wordList:Vector.<Word>;
		
		private static var _this:ResourceModel;
		public static function get instance():ResourceModel
		{
			if(_this == null)
				_this = new ResourceModel();
			return (_this);
		}
		
		public function load():void
		{
			quranXML = AppModel.instance.assetManager.getXml("quran-uthmani");//new XML(quranClass.data)
			metaXML =  AppModel.instance.assetManager.getXml("uthmani-metadata");//new XML(metaClass.data);
			
			var byte:ByteArray = AppModel.instance.assetManager.getByteArray("quran-simple");//new simpleClass();
			simpleQuran = byte.readObject();
			byte.clear();

			createSuraList();
			createJuzeList();
			createHizbList();
			createPageList();
			createRukuList();
			createWordList();
		}
		
		private function createWordList():void
		{
			var byte:ByteArray = AppModel.instance.assetManager.getByteArray("words")// new wordsClass();
			var obj:Object = byte.readObject();
			byte.clear();
			
			wordList = new Vector.<Word>();
			for each(var w:Object in obj)
				wordList.push(new Word(w.text, w.count));
		}
		
		//SURA__________________________________________________________________________________________________________________________________
		private function createSuraList():void
		{
			suraList = new Vector.<Sura>();
			popupSuraList = new Array();
			var index:uint = 0;
			for each(var sml:XML in metaXML.suras.sura)
			{
				var s:Sura = new Sura(sml);
				suraList.push(s);
				popupSuraList.push({index:index});
				index ++;
			}
			popupSuraList[index-1].isLastItem = suraList[index-1].isLastItem = true;
		}

		//JUZE__________________________________________________________________________________________________________________________________
		private function createJuzeList():void
		{
			juzeList = new Vector.<Juze>();
			for each(var jml:XML in metaXML.juzs.juz)
			{
				juzeList.push(new Juze(jml));
			}
			juzeList[juzeList.length-1].isLastItem = true;
		}
		
		//HIZB__________________________________________________________________________________________________________________________________
		private function createHizbList():void
		{
			hizbList = new Vector.<Hizb>();
			var hizb:Hizb;
			for each(var hml:XML in metaXML.hizbs.quarter)
			{
				hizb = new Hizb(hml);
				hizbList.push(hizb);
			}
			hizbList[hizbList.length-1].isLastItem = true;
		}
		
		//PAGE__________________________________________________________________________________________________________________________________
		private function createPageList():void
		{
			pageList = new Vector.<Page>();
			for each(var pml:XML in metaXML.pages.page)
			{
				pageList.push(new Page(pml));//pageList.push(getPageByIndex(i));
			}
			pageList[pageList.length-1].isLastItem = true;
		}
		

		//RUKU__________________________________________________________________________________________________________________________________
		private function createRukuList():void
		{
			rukuList = new Vector.<Ruku>();
			for each(var kml:XML in metaXML.rukus.ruku)
			{
				//ruku.page = getPageBySuraAya(ruku.sura, ruku.aya).index;
				rukuList.push(new Ruku(kml));
			}
			rukuList[rukuList.length-1].isLastItem = true;
		}
	}
}