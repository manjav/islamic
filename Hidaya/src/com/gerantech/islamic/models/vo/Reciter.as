package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.LoadAndSaver;
	
	import flash.events.IOErrorEvent;

	public class Reciter extends Person
	{
	//	public var soundList:Vector.<SoundAya>;
		public var checksums:Vector.<Checksum>;
		public var breaks:String;
		public var packages:Vector.<DownloadPackage>;
	
		private var checksumLoadSaver:LoadAndSaver;
		
		public function Reciter(person:Object=null, type:String="translator", flag:Local=null)
		{
			super(person, type, flag);
			packages = new Vector.<DownloadPackage>();
			for each(var s:Sura in ResourceModel.instance.suraList)
			{
				if(s.ayas==null)
					s.complete();
				packages[s.index] = new DownloadPackage(s.tname, s.name);
				for each(var a:Aya in s.ayas)
					packages[s.index].ayas.push(new SoundAya(a.sura, a.aya, a.order, a.page, a.juze, this));
			}
		}
		
		override public function set person(value:Object):void
		{
			super.person = value;
		}
		
		/*public function addSoundAya(aya:Aya):SoundAya
		{
			for each(var s:SoundAya in soundList)
			{//trace(s.sura, s.aya, aya)
				if(s.equals(aya))
					return s;
			}
			var snd:SoundAya = new SoundAya(aya.sura, aya.aya, aya.order, aya.page, aya.juze, this);
			soundList.push(snd);
			return snd;
		}
		
		 * Load Check sum for all ayas of reciter
		 */
		public function loadChecksum():void
		{
			checksumLoadSaver = new LoadAndSaver(UserModel.instance.SOUNDS_PATH+path+"/000_checksum.md5", url+"/000_checksum.md5");
			checksumLoadSaver.addEventListener("complete", checksum_CompleteHandler);
			checksumLoadSaver.addEventListener(IOErrorEvent.IO_ERROR, checksum_ioErrorHandler);
		}
		protected function checksum_ioErrorHandler(event:IOErrorEvent):void
		{
			checksumLoadSaver.removeEventListener("complete", checksum_CompleteHandler);
			checksumLoadSaver.removeEventListener(IOErrorEvent.IO_ERROR, checksum_ioErrorHandler);
			dispatchEventWith(CHECKSUM_ERROR);
		}		
		protected function checksum_CompleteHandler(event:*):void
		{
			checksumLoadSaver.removeEventListener("complete", checksum_CompleteHandler);
			checksumLoadSaver.removeEventListener(IOErrorEvent.IO_ERROR, checksum_ioErrorHandler);
			var utf:String = checksumLoadSaver.fileUTFData;
			//var hasStar:Boolean = utf.indexOf("*")>-1;
			var cvsLines:Array= utf.split("\n");
			
			checksums = new Vector.<Checksum>();
			for each(var line:String in cvsLines)
			checksums.push(new Checksum(line));
			
			dispatchEventWith(CHECKSUM_LOADED);
		}
		
		public function getChecksum(path:String):Checksum
		{
			for each(var c:Checksum in checksums)
			{
				if(c.path==path)
					return c;
			}
			return null;
		}
		
		public function getSoundAya(aya:Aya):SoundAya
		{
			for each(var dp:DownloadPackage in packages)
				for each(var s:SoundAya in dp.ayas)
				{//trace(s.sura, s.aya, aya)
					if(s.equals(aya))
						return s;
				}
			return null;
		}
	}
}