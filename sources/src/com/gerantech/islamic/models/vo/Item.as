package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;

	public dynamic class Item
	{
		public var sura:uint;
		public var aya:uint;
		public var index:uint;
		
		public function Item(sura:uint=1, aya:uint=1, index:uint=0)
		{
			setTo(sura, aya, index);
		}
		
		public function setTo(sura:uint, aya:uint, index:uint=0):void
		{
			this.sura = sura;
			this.aya = aya;
			this.index = index;
		}
		
		public function equals(sura:uint, aya:uint):Boolean
		{
			return (this.sura==sura && this.aya==aya);
		}
		
		public static function getRandom():Item
		{
			var sr:uint = Math.floor(Math.random()*114);
			var ar:uint = Math.floor(Math.random()*ResourceModel.instance.suraList[sr].numAyas);
			return new Item(sr+1, ar+1);
		}
	}
}