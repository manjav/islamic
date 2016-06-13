package com.gerantech.islamic.models.vo
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	public class Moathen extends Person
	{
		private var channel:SoundChannel;
		public var playing:Boolean;
		
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
		
		public function play():void
		{
			var sound:Sound = new Sound(new URLRequest(existsFile?localPath:url));
			channel = sound.play();
			playing = true;
		}
		
		public function stop():void
		{
			if(channel)
				channel.stop();
			playing = false;
		}
		
		
	}
}