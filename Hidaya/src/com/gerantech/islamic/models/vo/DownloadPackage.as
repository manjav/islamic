package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.utils.LoadAndSaver;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.events.IOErrorEvent;
	import flash.utils.setTimeout;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class DownloadPackage extends EventDispatcher
	{
		public var ayas:Vector.<SoundAya>;
		public var tname:String;
		public var name:Object;
		
		public static const NORMAL:String = "normal";
		public static const SELECTED:String = "selected";
		public static const DOWNLOADED:String = "downloaded";
		public static const WAITING:String = "waiting";
		public static const DOWNLOADING:String = "downloading";
		
		private var _state:String = "normal";


		public var percent:Number = 0;
		public var numAyas:uint;
		public var doawnloadedAya:uint;
		
		private var ayaIndex:uint;
		private var downloadIndex:int;
		private var saver:LoadAndSaver;
		private var downloadManager:DownloadManager;
		
		public function DownloadPackage(tname:String, name:String)
		{
			ayas = new Vector.<SoundAya>();
			this.tname = tname;
			this.name = name;
			this.downloadManager = DownloadManager.instance;
		}
		
		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			if(_state == value)
				return;
			
			_state = value;
			dispatchEventWith("stateChanged", false, _state);
		}
		
		
		/**
		 * Get percent of downloaded ayas 
		 */
		public function getPercent():Number
		{
			if(percent==1)
			{
				state = DOWNLOADED;
				return 1;
			}
			
			doawnloadedAya = 0;
			numAyas = ayas.length;
			
			for each(var s:SoundAya in ayas)
				if(s.exists)
					doawnloadedAya ++;
			
			manipulatePercent();
			return percent;
		}

		public function getPercentAsync():void
		{
			doawnloadedAya = 0;
			ayaIndex = 0;
			numAyas = ayas.length;
			checkNextAyaExists();
		}
		private function checkNextAyaExists():void
		{
			if(percent==1 || ayaIndex>=numAyas)
			{
				manipulatePercent();
				return;
			}
			
			if(ayas[ayaIndex].exists)
				doawnloadedAya ++;
			ayaIndex ++;
			setTimeout(checkNextAyaExists, 0);
		}
		
		private function manipulatePercent():void
		{
			percent = doawnloadedAya/numAyas;
			if(percent==1)
				state = DOWNLOADED;			
			dispatchEventWith("getPercentFinished", false, percent);
		}
		
		public function startDownload():void
		{
			downloadIndex = 0;
			downloadAya();
		}		
		
		private function downloadAya():void
		{
			if(downloadIndex>=numAyas || !downloadManager.downloading)
			{
				stopDownload();
				if(downloadIndex>=numAyas)
					dispatchEventWith("downloadCompleted");
				return;
			}
			
			if(ayas[downloadIndex].exists)
			{
				downloadIndex ++;
				downloadAya();
				return;
			}
			var path:String = StrTools.getZeroNum(ayas[downloadIndex].sura.toString())+StrTools.getZeroNum(ayas[downloadIndex].aya.toString());
			var check:Checksum = downloadManager.reciter.getChecksum(path);
			saver = new LoadAndSaver(ayas[downloadIndex].soundPath, ayas[downloadIndex].soundURL, check.md5);
			saver.addEventListener("complete", saver_completeHandler); 
			saver.addEventListener(IOErrorEvent.IO_ERROR, saver_ioErrorHandler); 
			state = DOWNLOADING;
		}		
		
		protected function saver_ioErrorHandler(event:IOErrorEvent):void
		{
			saver.removeEventListener("complete", saver_completeHandler); 
			saver.removeEventListener(IOErrorEvent.IO_ERROR, saver_ioErrorHandler);
			trace(event)
		}
		
		protected function saver_completeHandler(event:Object):void
		{
			saver.removeEventListener("complete", saver_completeHandler); 
			saver.removeEventListener(IOErrorEvent.IO_ERROR, saver_ioErrorHandler);
			doawnloadedAya ++
			manipulatePercent();
			downloadIndex ++;
			downloadAya();
		}	
		
		
		public function stopDownload():void
		{
			if(saver)
			{
				saver.removeEventListener("complete", saver_completeHandler); 
				saver.removeEventListener(IOErrorEvent.IO_ERROR, saver_ioErrorHandler);
				saver.closeLoader();
			}
		}
	}
}