package com.gerantech.islamic.models
{
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Reciter;
	import com.gerantech.islamic.models.vo.Translator;

	public class ConfigModel
	{
		public var config:Object;
		
		public var reciters:Array;
		public var selectedReciters:Array;
		public var translators:Array;
		public var selectedTranslators:Array;
		
		public var transFlags:Array;
		public var singleTransFlags:Array;
		public var multiTransFlags:Array;
		public var transModes:Array;
		public var recitersFlags:Array;
		public var recitersModes:Array;
		
		public var locals:Array;
		public var views:Array;
		public var fonts:Array;
		public var languages:Array;
		public var supportEmail:String;
		public var market:String;
		
		
		private static var _this:ConfigModel;
		
		
		public var freeTranslators:Array;
		public var freeReciters:Array;
		public var searchSources:Array;



		public static function get instance():ConfigModel
		{
			if(_this == null)
			{
				_this = new ConfigModel();
			}
			return (_this);
		}
		
		public function ConfigModel()
		{
		}

		public function setAssets(appModel:AppModel, userModel:UserModel):void
		{
			config = appModel.assetManager.getObject("config");
			
			locals = getLocals();
			fonts = config.application.fonts;
			views = config.application.views;
			languages = config.languages;

			setReciters();
			setTranslators(appModel, userModel);
			
			/*if(userModel.locale==null)
			{
				switch(appModel.descriptor.description)
				{
					case "Cafebazaar":
					case "CanDo":
					case "Myket":
						userModel.locale = config.languages.language[9];
						break;
						
					default:
						userModel.locale = config.languages.language[0];
						break;
				}
			}*/
		}
		
		//RECITERS ______________________________________________________________________________________________________
		private function setReciters():void
		{
			reciters = new Array();
			selectedReciters = new Array();
			var recit:Reciter;
			var i:uint=0;
			for each(var p:Object in config.reciters)
			{
				recit = new Reciter(p, getFlagByPath(p.flag));
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
					{
						flag.num ++;
					}
					else if(i==len-1)
					{
						recitersFlags.push(new Local(tr.flag.name, tr.flag.path))
					}
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
		private function setTranslators(appModel:AppModel, userModel:UserModel):void
		{
			translators = new Array();
			selectedTranslators = new Array();
			var trans:Translator;
			
			var i:uint=0;
			for each(var tr:Object in config.translators)
			{
				trans = new Translator(tr, getFlagByPath(tr.flag));
				//trans.compressed = tr.compressed;
				trans.index = i;
				trans.free = freeTranslators.indexOf(trans.path)>-1;
				translators.push(trans);
				i++;
			}
			
			createTransFlags();
			createTransModes();
			for each(var ut:String in userModel.user.translators)
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
					{
						flag.num ++;
					}
					else if(i==len-1)
					{
						transFlags.push(new Local(tr.flag.name, tr.flag.path))
					}
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
		
		//FLAGS ______________________________________________________________________________________________________
		private function getLocals():Array
		{
			var ret:Array = new Array();
			for each(var f:Object in config.flags)
			{
				ret.push(new Local(f.path+"_fl", f.path, f.dir));
			}	
			return ret;
		}
		
		public function getFlagByPath(path:String):Local
		{
			for each(var l:Local in locals)
			{
				if(l.path == path)
					return l;
			}
			return null;
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