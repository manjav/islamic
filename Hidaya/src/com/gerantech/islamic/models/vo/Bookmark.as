package com.gerantech.islamic.models.vo
{
	public class Bookmark
	{
		
		
		public var index:uint;
		public var sura:uint;
		public var aya:uint;
		public var text:String;
		
		public var used:uint;
		
		public var rate:uint;	
		public var order:uint;	
		
		public var isSearch:Boolean;
		public var colorList:Array;
		
		public function Bookmark(sura:uint, aya:uint, order:uint=0, rate:uint=3, used:uint=0, text:String="")
		{
			this.sura = sura;
			this.aya = aya;
			this.order = order;
			this.rate = rate;
			this.used = used;
			this.text = text;
		}
		
		public static function getFromObject(object:Object):Bookmark
		{
			if(object is Bookmark)
				return object as Bookmark;
			return new Bookmark(object.sura, object.aya, object.order, object.rate, object.used);
		}
		
		public static function getInstance(object:Object):Bookmark
		{
			return (new Bookmark(
				object.sura?object.sura:0,
				object.aya?object.aya:0,
				object.order?object.order:0,
				object.rate?object.rate:0,
				object.used?object.used:0));				
		}
		
		public function getItem():Item
		{
			return  new Item(sura, aya, index);
		}
	}
}