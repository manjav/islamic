package com.gerantech.islamic.managers
{
	import com.gerantech.islamic.models.vo.DownloadPackage;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Reciter;
	
	import flash.utils.setTimeout;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class DownloadManager extends EventDispatcher
	{
		private static var _instance:DownloadManager;
		
		public var reciter:Reciter;
		public var downloading:Boolean;

		
		public static function get instance():DownloadManager
		{
			if(_instance == null)
				_instance = new DownloadManager();
			return (_instance);
		}
		
		public function DownloadManager()
		{
		}
		
		public function setReciter(reciter:Reciter):void
		{
			this.reciter = reciter;
		}
		
		public function changeAll(state:String):void
		{
			for each(var dp:DownloadPackage in reciter.packages)
			if(dp.state!=DownloadPackage.DOWNLOADED) 
				dp.state = state;
		}
		
		public function startDownload():void
		{
			downloading = true;
			for each(var dp:DownloadPackage in reciter.packages)
				if(dp.state==DownloadPackage.SELECTED) 
					dp.state = DownloadPackage.WAITING;
		
			if(reciter.checksums==null)
			{
				reciter.addEventListener(Person.CHECKSUM_LOADED, reciter_checksumLoaded);
				reciter.addEventListener(Person.CHECKSUM_ERROR, reciter_checksumLoaded);
				reciter.loadChecksum();
				return;
			}
				
			dispatchEventWith("toggleDownloading", false, downloading);
			for(var i:uint=0; i<3; i++)
				setTimeout(addFreePackageToQueue, i*10);
		}
		
		private function reciter_checksumLoaded(event:Event):void
		{
			reciter.removeEventListener(Person.CHECKSUM_LOADED, reciter_checksumLoaded);
			reciter.removeEventListener(Person.CHECKSUM_ERROR, reciter_checksumLoaded);
			
			if(event.type==Person.CHECKSUM_LOADED)
				startDownload();
			else
				trace("reciter checksum has error.")
		}

		
		private function addFreePackageToQueue():void
		{
			var hasDownladables:Boolean;
			for each(var dp:DownloadPackage in reciter.packages)
			{
				if(dp.state==DownloadPackage.WAITING) 
				{
					dp.addEventListener("downloadCompleted", dp_downloadCompletedHandler);
					dp.startDownload();
					return;
				}
				else if(dp.state==DownloadPackage.DOWNLOADING) 
					hasDownladables = true;
			}
			if(!hasDownladables)
			{
				stopDownload();
				dispatchEventWith("downloadCompleted");
			}
		}
		
		private function dp_downloadCompletedHandler(event:Event):void
		{
			event.target.removeEventListener("downloadCompleted", dp_downloadCompletedHandler);
			addFreePackageToQueue();
		}
		
		public function stopDownload():void
		{
			downloading = false;
			for each(var dp:DownloadPackage in reciter.packages)
				if(dp.state==DownloadPackage.DOWNLOADING)
				{
					dp.stopDownload();
					dp.removeEventListener("downloadCompleted", dp_downloadCompletedHandler);
					dp.state = DownloadPackage.SELECTED;
				}
				else if(dp.state==DownloadPackage.WAITING) 
					dp.state = DownloadPackage.SELECTED;
				
			dispatchEventWith("toggleDownloading", false, downloading);
		}
	}
}