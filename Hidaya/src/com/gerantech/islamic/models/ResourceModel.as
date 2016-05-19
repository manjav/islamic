package com.gerantech.islamic.models
{
	import com.gerantech.islamic.models.vo.Hizb;
	import com.gerantech.islamic.models.vo.Juze;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.models.vo.Reciter;
	import com.gerantech.islamic.models.vo.Ruku;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.models.vo.Word;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.utils.ByteArray;
		
	public class ResourceModel
	{
		[Embed("../assets/contents/quran-uthmani.xml", encoding="utf-8")]
		private static const quranClass:Class;
		[Embed("../assets/contents/uthmani-metadata.xml", encoding="utf-8")]//, mimeType="application/octet-stream")]
		private static const metaClass:Class;
		[Embed("../assets/contents/quran-simple.bt", mimeType="application/octet-stream")]
		private static const simpleClass:Class;
		[Embed("../assets/contents/words.bt", mimeType="application/octet-stream")]
		private static const wordsClass:Class;
		[Embed(source = "../assets/contents/persons-embeded.json", mimeType="application/octet-stream")]
		private static const personsClass:Class;
		
		public var quranXML:XML;
		public var metaXML:XML;
		public var simpleQuran:Array;
		private var persons:Object;
		
		public var playerAyaList:Array;
		public var popupSuraList:Array;
		public var suraList:Vector.<Sura>;
		public var juzeList:Vector.<Juze>;
		public var hizbList:Vector.<Hizb>;
		public var pageList:Vector.<Page>;
		public var rukuList:Vector.<Ruku>;
		public var wordList:Vector.<Word>;

		public var reciters:Array;
		public var selectedReciters:Array;
		public var translators:Array;
		public var selectedTranslators:Array;
		public var freeTranslators:Array;
		public var freeReciters:Array;
		
		public var transFlags:Array;
		public var singleTransFlags:Array;
		public var multiTransFlags:Array;
		public var transModes:Array;
		public var recitersFlags:Array;
		public var recitersModes:Array;

		private static var _this:ResourceModel;
		public static function get instance():ResourceModel
		{
			if(_this == null)
				_this = new ResourceModel();
			return (_this);
		}
		
		public function load():void
		{
			quranXML = new XML(quranClass.data);//AppModel.instance.assetManager.getXml("quran-uthmani");
			metaXML =  new XML(metaClass.data);//AppModel.instance.assetManager.getXml("uthmani-metadata");
			
			var byte:ByteArray = new simpleClass();//AppModel.instance.assetManager.getByteArray("quran-simple");
			simpleQuran = byte.readObject();
			byte.clear();

			persons = JSON.parse(new personsClass());
			switch(AppModel.instance.descriptor.market)
			{
				case "google":
					freeTranslators = ["en.transliteration"];//, "en.sahih"];
					freeReciters = ["mishary_rashid_alafasy"];//,"ibrahim_walk"];
					break;
				
				case "cafebazaar":
				case "myket":
				case "cando":
				case "sibche":
					freeTranslators = ["fa.fooladvand"];//, "en.sahih"];
					freeReciters = ["shahriar_parhizgar","mahdi_fooladvand"];//,"ibrahim_walk"];
					break;
			}
			if(UserModel.instance.user.profile.numRun==1)
			{
				UserModel.instance.user.translators = freeTranslators;
				UserModel.instance.user.reciters = freeReciters;
			}
			trace("ssssss", UserModel.instance.user.translators)
			createSuraList();
			createJuzeList();
			createHizbList();
			createPageList();
			createRukuList();
			createWordList();
			createReciters();
			createTranslators();
			
		}
		
		private function createWordList():void
		{
			var byte:ByteArray = new wordsClass(); //AppModel.instance.assetManager.getByteArray("words");
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
				juzeList.push(new Juze(jml));
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
				pageList.push(new Page(pml));//pageList.push(getPageByIndex(i));
			pageList[pageList.length-1].isLastItem = true;
		}
		

		//RUKU__________________________________________________________________________________________________________________________________
		private function createRukuList():void
		{
			rukuList = new Vector.<Ruku>();
			for each(var kml:XML in metaXML.rukus.ruku)
				rukuList.push(new Ruku(kml));
			rukuList[rukuList.length-1].isLastItem = true;
		}
		
		
		
		//RECITERS ______________________________________________________________________________________________________
		private function createReciters():void
		{
			reciters = new Array();
			selectedReciters = new Array();
			var recit:Reciter;
			var i:uint=0;
			for each(var p:Object in persons.reciters)
			{
				recit = new Reciter(p, ConfigModel.instance.getFlagByPath(p.flag));
				recit.index = i;
				recit.free = freeReciters.indexOf(recit.path)>-1;
				reciters.push(recit);
				i++;
			}
			createRecitersFlags();
			createRecitersModes();
			for each(var ur:String in UserModel.instance.user.reciters)
			for each(var r:Reciter in reciters)
			if(r.path==ur)
				selectedReciters.push(r);
			
		}
		
		private function createRecitersFlags():void
		{
			recitersFlags = new Array();
			var flag:Local;
			for each(var tr:Reciter in reciters)
			{
				var len:int = recitersFlags.length;
				for (var i:uint=0; i<len; i++)
				{
					flag = recitersFlags[i] as Local;
					if(flag.name == tr.flag.name)
						flag.num ++;
					else if(i==len-1)
						recitersFlags.push(new Local(tr.flag.name, tr.flag.path))
				}
				if(len==0)
					recitersFlags.push(new Local(tr.flag.name, tr.flag.path));
			}
			recitersFlags.sortOn('num', Array.NUMERIC)
			recitersFlags.reverse();
		}
		/*public function getSelectedReciterFlags():Array
		{
		var ret:Array = new Array();
		for each(var fg:Local in recitersFlags)
		{
		if(fg.selected)
		ret.push(fg);
		}
		return ret;
		}*/
		private function createRecitersModes():void
		{
			recitersModes = new Array();
			recitersModes.push(new Local("murat_t", '', ''));
			recitersModes.push(new Local("mujaw_t", '', ''));
			recitersModes.push(new Local("treci_t", '', ''));			
			recitersModes.push(new Local("muall_t", '', ''));			
		}
		/*public function getSelectedReciterModes():Array
		{
		var ret:Array = new Array();
		for each(var fg:Local in recitersModes)
		{
		if(fg.selected)
		ret.push(fg);
		}
		return ret;
		}*/
		public function getSelectedReciters():Array
		{
			var ret:Array = new Array;
			for each(var r:Reciter in reciters)
			if(r.selected)
				ret.push(r);
			return ret;
		}
		
		public function get hasReciter():Boolean
		{
			return (selectedReciters.length>0);
		}
		
		//TRANSLATORS ______________________________________________________________________________________________________
		private function createTranslators():void
		{
			translators = new Array();
			selectedTranslators = new Array();
			var trans:Translator;
			
			var i:uint=0;
			for each(var tr:Object in persons.translators)
			{
				trans = new Translator(tr, ConfigModel.instance.getFlagByPath(tr.flag));
				//trans.compressed = tr.compressed;
				trans.index = i;
				trans.free = freeTranslators.indexOf(trans.path)>-1;
				translators.push(trans);
				i++;
			}
			
			createTransFlags();
			createTransModes();
			for each(var ut:String in UserModel.instance.user.translators)
			for each(var t:Translator in translators)
			if(t.path==ut)
				selectedTranslators.push(t);
		}
		private function createTransFlags():void
		{
			transFlags = new Array();
			var flag:Local;
			for each(var tr:Translator in translators)
			{
				var len:int = transFlags.length;
				for (var i:uint=0; i<len; i++)
				{
					flag = transFlags[i] as Local;
					if(flag.name == tr.flag.name)
						flag.num ++;
					else if(i==len-1)
						transFlags.push(new Local(tr.flag.name, tr.flag.path))
				}
				if(len==0)
					transFlags.push(new Local(tr.flag.name, tr.flag.path));
			}
			transFlags.sortOn('num', Array.NUMERIC)
			transFlags.reverse();
			
			singleTransFlags = new Array();
			multiTransFlags = new Array();
			for each(var loc:Local in transFlags)
			if(loc.num<4)
				singleTransFlags.push(loc);
			else
				multiTransFlags.push(loc);
			multiTransFlags.push(new Local("ot_fl", ""));
		}
		/*public function getSelectedTransFlags():Array
		{
		var ret:Array = new Array();
		for each(var fg:Local in transFlags)
		{
		if(fg.selected)
		ret.push(fg);
		}
		return ret;
		}*/
		private function createTransModes():void
		{
			transModes = new Array();
			transModes.push(new Local("trans_t", '', ""));
			transModes.push(new Local("tafsi_t", '', ""));			
			transModes.push(new Local("quran_t", '', ""));
		}
		/*public function getSelectedTransModes():Array
		{
		var ret:Array = new Array();
		for each(var fg:Local in transModes)
		{
		if(fg.selected)
		ret.push(fg);
		}
		return ret;
		}*/
		public function getSelectedTranslators():Array
		{
			var ret:Array = new Array;
			for each(var t:Translator in translators)
			if(t.selected)
				ret.push(t);
			return ret;
		}
		
		
		public function get hasTranslator():Boolean
		{
			return (selectedTranslators.length>0);
		}
		
		public function getTranslatorByPath(path:String):Translator
		{
			for each(var p:Translator in translators)
			if(p.path == path)
				return p;
			
			return null;
		}
		
		public function getReciterByPath(path:String):Reciter
		{
			for each(var p:Reciter in reciters)
			if(p.path == path)
				return p;
			
			return null;
		}
		
	}
}