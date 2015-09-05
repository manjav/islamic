package com.gerantech.islamic.models.vo
{
	public class Word
	{
		public var text:String;
		public var count:uint = 1;
		
		public function Word(text:String, count:uint=1)
		{
			this.text = text;
			this.count = count;
		}
	}
}