package com.gerantech.islamic.models.vo
{
	
	public class User
	{
		public var profile:Profile = new Profile();
				
		public var aya:int = 1;
		public var sura:int = 1;
		
		public var local:Object;
		//public var reciterIndex:int = 37;
		//public var translatorIndex:int = 0;
		public var searchPatt:String = "کتاب";
		public var searchSource:uint = 0;
		public var searchScope:uint = 0;
		public var searchSura:uint = 0;
		public var searchJuze:uint = 0;
		
		//public var breakRepeat:uint = 1;
		public var personRepeat:uint = 1;
		public var ayaRepeat:uint = 1;
		public var pageRepeat:uint = 1;
		
		public var bookmarks:Array = [];
		public var times:Array = [[{offset:0, moathen:"muhammad_taghi_tasviechi"}], [], [{offset:0, moathen:"muhammad_taghi_tasviechi"}], [], [], [{offset:0, moathen:"muhammad_taghi_tasviechi"}], [], []];
		
/*		public var p_uid:String;
		public var p_numRun:uint;
		public var p_lastMonth:uint;
		public var p_registered:Boolean;
		public var p_name:String;
		public var p_email:String;
		public var p_sex:String;
		public var p_birthDateString:String;*/
		
		//public var pageDir:Object = {value:"none"};
		private var _navigationMode:Object = {value:"sura_navi"};
	//	public var fastPaging:Boolean;//////111
		//public var autoScrollDisabled:Boolean;//////111
	//	public var actionbarDown:Boolean;
	//	public var fullScreenDisabled:Boolean;//////111
	//	public var autoOrientsDisabled:Boolean;//////111
		private var _idleMode:Object = {value:"awake_of"};
		public var fontSize:uint = 12;
		//public var fontFamily:String = "Default";
		public var storagePath:String = "";
		//public var overlayAlpha:Number = 0;
		private var _translators:Array = [];
		private var _reciters:Array = [];
		public var premiumMode:Boolean;
		public var rated:Boolean;
		public var nightMode:Boolean;
		public var remniderTime:Object = {value:"reminder_1"};
		public var inbox:Array = [];
		public var font:Object = {value:"mequran", scale:1};
		public var city:Object = new Location();
		public var hijriOffset:int = 0;
		public var quranRead:Boolean;
		
		public function get navigationMode():Object
		{
			return _navigationMode;
		}
		public function set navigationMode(_value:Object):void
		{
			if(_value is String)
				_navigationMode = {value:_value};
			else
				_navigationMode = _value;
		}

		public function get idleMode():Object
		{
			return _idleMode;
		}

		public function set idleMode(_value:Object):void
		{
			if(_value is String)
				_idleMode = {value:_value};
			else
				_idleMode = _value;
		}

		public function get reciters():Array
		{
			return _reciters;
		}
		public function set reciters(value:Array):void
		{
			_reciters = new Array()
			for each(var p:Object in value)
			{
				if(p is String)
					_reciters.push(p);
				else
					_reciters.push(p.path);
			}
		}

		public function get translators():Array
		{
			return _translators;
		}
		public function set translators(value:Array):void
		{
			_translators = new Array()
			for each(var p:Object in value)
			{
				if(p is String)
					_translators.push(p);
				else
					_translators.push(p.path);
			}
		}
	}
}