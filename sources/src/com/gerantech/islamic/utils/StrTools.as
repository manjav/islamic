﻿package com.gerantech.islamic.utils
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.system.Capabilities;

	public class StrTools
	{
		
		public static function getArabicNumber(input:Object):String
		{
			var _str:String = input.toString();
			_str = _str.split('0').join('٠')
			_str = _str.split('1').join('١')
			_str = _str.split('2').join('٢')
			_str = _str.split('3').join('٣')
			_str = _str.split('4').join('٤')
			_str = _str.split('5').join('٥')
			_str = _str.split('6').join('٦')
			_str = _str.split('7').join('٧')
			_str = _str.split('8').join('٨')
			_str = _str.split('9').join('٩');
			return(_str)
		}
		public static function getPersianNumber(input:Object):String
		{
			var _str:String = input+"";
			_str = _str.split('0').join('۰');
			_str = _str.split('1').join('۱');
			_str = _str.split('2').join('۲');
			_str = _str.split('3').join('۳');
			_str = _str.split('4').join('۴');
			_str = _str.split('5').join('۵');
			_str = _str.split('6').join('۶');
			_str = _str.split('7').join('۷');
			_str = _str.split('8').join('۸');
			_str = _str.split('9').join('۹');
			return(_str)
		}
		public static function getNumber(input:Object):String
		{
			if(UserModel.instance.locale.value=="ar_SA")
				return getArabicNumber(input);
			else if(UserModel.instance.locale.dir=="rtl")
				return getPersianNumber(input);
			else
				return input.toString();
		}
		public static function getNumberFromLocale(str:Object, dir:String=""):String
		{
			if(str==null)
				return '';
			
			var direction:String = dir=="" ? AppModel.instance.direction : dir;
			if(direction=='ltr')
				return str.toString();
			else
				return getArabicNumber(str.toString());
		}
		
		public static function join(_str:String, lines:Array, _patt:String):String
		{
			if(lines==null || lines.length==0)
			{
				return(_str);
			}
			var srtList:Array = new Array ;
			while(lines.length > 14 && _patt == '\n')
			{
				lines.pop();
			}
			for (var i:uint=0; i<lines.length+1; i++)
			{
				srtList[i] = _str.substring(i ? lines[i - 1]:0, i<lines.length?lines[i]:_str.length);
			}
			return(srtList.join(_patt));
		}
		
		public static function getZeroNum(_val:String, _len:uint=3):String
		{
			var zeroStr:String = '';
			_len = _len<_val.length ? _val.length : _len;
			for(var i:uint=0; i<_len-_val.length; i++)
			{
				zeroStr += '0';
			}
			return zeroStr+_val;
		}
		
		public static function getSplitsNum(_str:String, _patt:String):Array
		{
			var ret:Array = new Array;
			var list:Array = _str.split(_patt);
			if(list.length>1)
			{
				list.pop();
				for (var b:uint=0; b<list.length; b++)
				{
					list[b] = list[b].length;
					if (b>0)
					{
						list[b] += list[b - 1];
					}
				}
				ret = list;
			}
			return (ret);
		}
		
		public static function getRepTranslate (str:String, ayaByAya:Boolean=true):String
		{
			if(str=="~")
				str = str.split("~").join(ayaByAya?"تفسیر این آیه، در آیه یا آیات قبلی بصورت یکجا آمده است.":"");
			else
				str = str.split("$").join(ayaByAya?"\n":". ");
			return str;
		}
		
		public static function  getSimpleString (str:String, loc:String="ar"):String
		{
			if(loc=="ar")
			{
				var signs:Array = "َُِّْٰۭٓۢۚۖۗۦًٌٍۙۘۜۥ".split("");
				for(var i:uint=0; i<signs.length; i++)
					str = str.split(signs[i]).join("");
				
				var alefs:Array = "إأٱآ".split("");
				for(i=0; i<alefs.length; i++)
					str = str.split(alefs[i]).join("ا");
				
				str = str.split("ة").join("ه");
				str = str.split("ؤ").join("و");
				str = str.split("ي").join("ی");
				str = str.split("ى").join("ی");
				//str = str.split("ی").join("ي");
				
				str = str.split("ك").join("ک");
			}
			return str.toLowerCase();
		}
		
		public static function  getFullPath (path:String, sura:uint, aya:uint, post:String="dat"):String
		{
			return (path+"/"+getZeroNum(sura.toString())+"/"+getZeroNum(sura.toString())+getZeroNum(aya.toString())+"."+post);
		}
		public static function  getFullURL (path:String, sura:uint, aya:uint, post:String="mp3"):String
		{
			return (path+"/"+getZeroNum(sura.toString())+getZeroNum(aya.toString())+"."+post);
		}
		
		
		public static function getLocal(local:String=null):Object
		{
			var ret:Object = {value:"en_US", dir:"ltr"};
			if(local==null)
				local = Capabilities.languages[0].split("-")[0];
			
			switch(local)
			{
				case "ar":	ret = {value:"ar_SA", dir:"rtl"};	break;
				case "en":	ret = {value:"en_US", dir:"ltr"};	break;
				case "es":	ret = {value:"es_ES", dir:"ltr"};	break;
				case "fa":	ret = {value:"fa_IR", dir:"rtl"};	break;
				case "fr":	ret = {value:"fr_FR", dir:"ltr"};	break;
				case "id":	ret = {value:"id_ID", dir:"ltr"};	break;
				case "ru":	ret = {value:"ru_RU", dir:"ltr"};	break;
				case "tr":	ret = {value:"tr_TR", dir:"ltr"};	break;
				case "ur":	ret = {value:"ur_PK", dir:"rtl"};	break;
			}
			return ret;
		}
	}
}