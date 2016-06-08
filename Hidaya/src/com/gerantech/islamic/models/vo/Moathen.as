package com.gerantech.islamic.models.vo
{
	public class Moathen extends Person
	{
		public function Moathen(person:Object=null, flag:Local=null)
		{
			super(person, TYPE_MOATHEN, flag);
		}
		
		public override function load():void
		{
			//trace("loadTransltaion", loadingState, state)
			if(state==HAS_FILE)
			{
				state = SELECTED;
				return;
			}
			super.load();
		}
		
		override protected function sourceLoadSaver_completeHandler(event:*):void
		{
			super.sourceLoadSaver_completeHandler(event);
			state = SELECTED;
		}
		
		
		
		
	}
}