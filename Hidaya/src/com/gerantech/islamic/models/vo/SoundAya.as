package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.LoadAndSaver;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class SoundAya extends Aya
	{		
		public var sound:Sound;
		public var reciter:Reciter;
		private var _file:File;
		private var _soundData:ByteArray;

		private var saver:LoadAndSaver;
		public var loaded:Boolean;
		
		public function SoundAya(sura:uint, aya:uint, order:uint, page:uint, juze:uint, reciter:Reciter)
		{
			super(sura, aya, order, page, juze);
			this.reciter = reciter;
		}

		public function get exists():Boolean
		{
			if(_file==null)
				_file = new File(soundPath);
			return _file.exists;
		}
		
		public function get soundURL():String
		{
			return StrTools.getFullURL(reciter.url, sura, aya); 
		}
		
		public function get soundPath():String
		{
			return UserModel.instance.SOUNDS_PATH+StrTools.getFullPath(reciter.path, sura, aya); 
		}
		
		public function load():void
		{
			if(loaded)
			{
				setTimeout(sound.dispatchEvent, 10, new Event(Event.OPEN));
				return;
			}
			sound = new Sound(new URLRequest(exists?soundPath:soundURL));
			sound.addEventListener(Event.COMPLETE, sound_completeHandler);
		}
		
		protected function sound_completeHandler(event:Event):void
		{
			var path:String = StrTools.getZeroNum(sura.toString())+StrTools.getZeroNum(aya.toString());
			var check:Checksum// = reciter.getChecksum(path);
			saver = new LoadAndSaver(soundPath, soundURL, check==null?null:check.md5);
			loaded = true;
		}
		

	}
}