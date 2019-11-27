package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.managers.NotificationManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.DownloadPackage;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Reciter;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.PersonAccessory;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;

	import gt.utils.Localizations;

	import starling.display.Quad;
	import starling.events.Event;
	import feathers.layout.VerticalAlign;
	
	public class DownloadHeader extends LayoutGroup
	{
		public var downloadButton:SimpleLayoutButton;
		
		private var appModel:AppModel;
		//private var personImage:ImageLoader;
		private var hlayout:HorizontalLayout;
		private var reciter:Reciter;
		private var checkAll:PersonAccessory;
		private var selectionButton:SimpleLayoutButton;
		private var selectedAll:Boolean;
		private var descriptionLabel:RTLLabel;
		private var downloadManager:DownloadManager;
		private var downloadImage:ImageLoader;
		private var downloadLabel:RTLLabel;
		private var _downloadable:Boolean = false;
		
		
		public function DownloadHeader(reciter:Reciter)
		{
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.SECONDARY_BACKGROUND_COLOR);
			
			appModel = AppModel.instance;
			downloadManager = DownloadManager.instance;
			downloadManager.addEventListener("downloadCompleted", downloadManager_downloadCompletedHalndler); 
			
			this.reciter = reciter;

			hlayout = new HorizontalLayout();
			hlayout.verticalAlign = VerticalAlign.MIDDLE;
			hlayout.gap = appModel.sizes.border;
		//	hlayout.padding = appModel.sizes.border;
			layout = hlayout;
			
			height = appModel.sizes.subtitle;
			
			/*personImage = new ImageLoader();
			personImage.layoutData = new HorizontalLayoutData(NaN, 100);
			//personImage.width = personImage.height//-appModel.sizes.border*2;
			personImage.source = reciter.iconTexture;
			addChild(personImage);*/
			var dLayout:HorizontalLayout = new HorizontalLayout();
			dLayout.padding = appModel.sizes.border*3;
			dLayout.paddingLeft = appModel.sizes.border;
			dLayout.verticalAlign = VerticalAlign.MIDDLE;
			
			downloadButton = new SimpleLayoutButton();
			downloadButton.backgroundSkin = new Quad(1,1,BaseMaterialTheme.ACCENT_COLOR);
			downloadButton.layout = dLayout;
			downloadButton.height = height-appModel.sizes.border*2;
			downloadButton.width = height*2.4;
			downloadButton.layoutData = new HorizontalLayoutData(NaN, 100);
			downloadButton.addEventListener(Event.TRIGGERED, downloadButton_triggeredHandler);
			downloadButton.touchable = false;
			addChild(downloadButton);
			
			downloadImage = new ImageLoader();
			downloadImage.layoutData = new HorizontalLayoutData(NaN, 100);
			downloadImage.source = Assets.getTexture("download_g");
			downloadButton.addChild(downloadImage);
			
			downloadLabel = new RTLLabel(loc("download_link"), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.8, null, "bold");
			downloadLabel.layoutData = new HorizontalLayoutData(100);
			downloadButton.addChild(downloadLabel);
			
			
			descriptionLabel = new RTLLabel(loc("downloader_result_any"), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, true, null, 0.8);
			descriptionLabel.layoutData = new HorizontalLayoutData(100);
			addChild(descriptionLabel);
			
			selectionButton = new SimpleLayoutButton();
			selectionButton.backgroundSkin = new Quad(1,1);
			selectionButton.backgroundSkin.alpha = 0;
			selectionButton.width = height;
			selectionButton.height = height;
			selectionButton.layoutData = new HorizontalLayoutData(NaN, 100);
			selectionButton.layout = new AnchorLayout();
			selectionButton.addEventListener(Event.TRIGGERED, selectionButton_triggeredHandler);
			addChild(selectionButton);
			
			checkAll = new PersonAccessory();
			checkAll.iconScale = 0.5;
			checkAll.layoutData = new AnchorLayoutData(0,0,0,0);
			selectionButton.addChild(checkAll);
		}
		
		private function downloadManager_downloadCompletedHalndler():void
		{
			description = loc("downloader_result_cmp");
			setDownloadButtonMode(downloadManager.downloading);
			NotificationManager.instance.scheduleLocalNotification(1, loc("downloader_result_cmp"));
		}
		
		public function set downloadable(value:Boolean):void
		{
			if(_downloadable==value)
				return;

			_downloadable = value;
			downloadButton.touchable = _downloadable;
		}

		private function downloadButton_triggeredHandler():void
		{
			downloadManager.downloading ? downloadManager.stopDownload() : downloadManager.startDownload();
			setDownloadButtonMode(downloadManager.downloading);
		}
		
		public function setDownloadButtonMode(downloading:Boolean):void
		{
			downloadImage.source = Assets.getTexture(downloading ? "close_g" : "download_g");
			downloadLabel.text = loc(downloading ? "cancel_button" : "download_link");
			selectionButton.touchable = !downloading;
		}
		
		private function selectionButton_triggeredHandler():void
		{
			selectedAll = !selectedAll;
			downloadable = selectedAll;
			checkAll.setState(selectedAll?Person.SELECTED:Person.HAS_FILE, 0.4);
			dispatchEventWith("change", false, selectedAll?DownloadPackage.SELECTED:DownloadPackage.NORMAL);
			description = loc(selectedAll?"downloader_result_all":"downloader_result_any");
		}
		
		private function loc(resourceName:String):String
		{
			return Localizations.instance.get(resourceName);
		}
		
		public function set description(value:String):void
		{
			descriptionLabel.text = StrTools.getNumberFromLocale(value);
		}
		
	}
}