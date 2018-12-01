package com.gerantech.islamic.models.vo
{
	import starling.display.DisplayObject;

	public class TutorialStep
	{
		public var key:String;
		public var target:DisplayObject;
		
		public function TutorialStep(key:String, target:DisplayObject)
		{
			this.key = key;
			this.target = target;
		}
	}
}