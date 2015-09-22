package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.DownloadPackage;
	import com.gerantech.islamic.models.vo.Reciter;
	import com.gerantech.islamic.views.headers.DownloadHeader;
	import com.gerantech.islamic.views.items.DownloadItemRenderer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class DownloadScreen extends BaseScreen
	{
		public var reciter:Reciter;
		
		private var list:List;
		private var downloadHeader:DownloadHeader;
		private var listLayout:VerticalLayout;
		private var downloadManager:DownloadManager;
		
		public function DownloadScreen()
		{
			downloadManager = DownloadManager.instance;
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();

			downloadManager.setReciter(reciter);
		
			downloadHeader = new DownloadHeader(reciter);
			downloadHeader.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			downloadHeader.addEventListener(Event.CHANGE, downloadHeader_changeHandler);
			addChild(downloadHeader);
			
			listLayout = new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.paddingTop = appModel.sizes.twoLineItem/4;
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(downloadHeader.height,0,0,0);
			list.allowMultipleSelection = true;
			list.itemRendererFactory = function ():IListItemRenderer
			{
				return new DownloadItemRenderer();
			}
			list.addEventListener(Event.CHANGE, list_changedHandler);
			addChild(list);
			
			var shadow:ImageLoader = new ImageLoader();
			shadow.maintainAspectRatio = false;  
			shadow.layoutData = new AnchorLayoutData(downloadHeader.height,0,NaN,0);
			shadow.height = appModel.sizes.border*2;
			shadow.source = Assets.getTexture("shadow");
			addChild(shadow);
		//	setTimeout(list_changedHandler, 1);
			
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}
		
		private function transitionInCompleteHandler():void
		{
			list.dataProvider = new ListCollection(reciter.packages);
		}
		
		private function list_changedHandler():void
		{
			var numSelecteds:uint = 0;
			var numWaitings:uint = 0;
			var numDownloadings:uint = 0;
			
			for each(var dp:DownloadPackage in reciter.packages)
				if(dp.state==DownloadPackage.SELECTED)
					numSelecteds ++;
				else if(dp.state==DownloadPackage.DOWNLOADING)
					numDownloadings ++;
				else if(dp.state==DownloadPackage.WAITING)
					numWaitings ++;
				
			if(numSelecteds==0)
				downloadHeader.description = loc("downloader_result_any");
			else
				downloadHeader.description = (numSelecteds) + " " + loc("downloader_result_num");
			
			downloadHeader.downloadable = numSelecteds>0 || numWaitings>0 || numDownloadings>0;
			downloadHeader.setDownloadButtonMode(numWaitings>0 || numDownloadings>0);
			
		//	trace(numSelecteds, numWaitings, numDownloadings)
		}
		
		private function downloadHeader_changeHandler(event:Event):void
		{
			downloadManager.changeAll(event.data as String);
		}	
	}
}