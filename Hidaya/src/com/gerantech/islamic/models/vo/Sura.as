package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.utils.StrTools;
	
	import starling.textures.Texture;
	
	public class Sura extends BaseQData
	{
		public var numAyas:uint;
		private var start:uint;
		public var tname:String = '';
		public var ename:String = '';		
		public var type:String;		
		public var order:uint;
		private var goNext:Boolean;
		
		public var person:Person;
		
		//public var sura_texture:Texture;
		
		
		public function Sura(xml:XML)
		{
			this.xml = xml;
		}
		
		public function get localizedName():String
		{
			return AppModel.instance.ltr ? tname : name;
		}
		
		override public function set xml(value:XML):void
		{
			this.sura = uint(value.@index);
			this.index = this.sura-1
			this.numAyas = uint(value.@ayas);
			this.start = uint(value.@start);
			this.name = value.@name; 
			this.tname = value.@tname; 
			this.ename = value.@ename; 
			this.type = String(value.@type).toLowerCase();
			this.order = uint(value.@order);
			this.page = uint(value.@page);
			this.goNext = value.@np=="1";
		}
		
		override public function complete():void//person:Person=null, sml:XML=null
		{
			ayas = new Array();
			var aya:Aya;
			for(var a:uint=0; a<numAyas; a++)
			{
				aya = new Aya(sura, a+1, a);
				aya.name = StrTools.getNumberFromLocale(a+1);
				ayas.push(aya);//, sml, person
			}
			ayas[numAyas-1].isLastItem = true;
		}
		
		public function get actualPage():uint
		{
			return goNext ? page+1 : page;
		}
	}
}