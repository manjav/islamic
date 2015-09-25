package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.DownloadPackage;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.DownloadAccessory;
	import com.gerantech.islamic.views.controls.LinierProgressBar;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class DownloadItemRenderer extends BaseCustomItemRenderer
	{
		private var mainContents:LayoutGroup;
		private var nameDisplay:RTLLabel;
		private var messageDisplay:RTLLabel;
		private var download:DownloadPackage;
		private var progressBar:LinierProgressBar;
		private var _height:Number;
		private var checkImage:DownloadAccessory;
		private var checkButton:SimpleLayoutButton;
		private var nameAlpha:Number = 1;
		private var downloadManager:DownloadManager;

		
		public function DownloadItemRenderer()
		{
			downloadManager = DownloadManager.instance;
			downloadManager.addEventListener("toggleDownloading", toggleDownloadingHandler);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			appModel = AppModel.instance;
			height = _height = appModel.sizes.singleLineItem;
			
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			//hLayout.paddingRight = hLayout.gap = appModel.sizes.border/3;
			hLayout.paddingLeft = appModel.sizes.border*2;
			layout = hLayout;
			
			mainContents = new LayoutGroup();
			mainContents.layoutData = new HorizontalLayoutData(100, 80);
			var mLayout:VerticalLayout = new VerticalLayout();
			//mLayout.firstGap = 0;
			mLayout.lastGap = -_height/10;
			mLayout.paddingBottom = _height/20;
			mainContents.layout = mLayout;
			addChild(mainContents);

			var fontSize:uint = uint(_height/4.6);
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, fontSize, null, "bold");
			nameDisplay.layoutData = new VerticalLayoutData(100, 55);
			mainContents.addChild(nameDisplay);
			
			progressBar = new LinierProgressBar();
			progressBar.fontSize = uint(fontSize*0.9);
			progressBar.layoutData = new VerticalLayoutData(100);
			mainContents.addChild(progressBar);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, fontSize*0.8, null);
			messageDisplay.layoutData = new VerticalLayoutData(100, 40);
			mainContents.addChild(messageDisplay);
			
			checkButton = new SimpleLayoutButton();
			checkButton.backgroundSkin = new Quad(1,1);
			checkButton.backgroundSkin.alpha = 0;
			checkButton.layout = new AnchorLayout();
			checkButton.width = checkButton.height = _height;
			checkButton.addEventListener(Event.TRIGGERED, checkButton_triggered);
			addChild(checkButton);
			
			checkImage = new DownloadAccessory();
			checkImage.iconScale = 0.45;
			checkImage.layoutData = new AnchorLayoutData(0,0,0,0);
			checkButton.addChild(checkImage);
		}
		
		private function checkButton_triggered():void
		{
			if(download.state==DownloadPackage.DOWNLOADED || DownloadManager.instance.downloading)
				return;
			download.state = download.state==DownloadPackage.NORMAL ? DownloadPackage.SELECTED : DownloadPackage.NORMAL;
		}
		
		override protected function commitData():void
		{
			super.commitData();
			if(_data==null || _owner==null)
				return;
			
			
			if(download!=null)
			{
				download.removeEventListener("stateChanged", download_stateChangedHandler);
				download.removeEventListener("getPercentFinished", download_getPercentFinishedHandler);
			}
			download = _data as DownloadPackage;
			download.addEventListener("stateChanged", download_stateChangedHandler);
			download.addEventListener("getPercentFinished", download_getPercentFinishedHandler);
			
			checkButton.touchable = !downloadManager.downloading;
			
			progressBar.enabled = false;
			TweenLite.killTweensOf(progressBar);
			nameDisplay.text = StrTools.getNumberFromLocale(String(index+1)) + ". " + ResourceManager.getInstance().getString("loc", "sura_l")+" "+ (appModel.ltr?(download.tname+","):download.name);
			
			messageDisplay.visible = false;
			messageDisplay.alpha = 0;
		}	
		
		private function download_getPercentFinishedHandler(event:Event):void
		{
			var percent:Number = event.data as Number;
			updatePercent(percent);
		}
		
		override protected function commitAfterStopScrolling():void
		{			
			setState(download.state);
			var percent:Number = download.getPercent();
			updatePercent(percent);
		}
		
		
		private function updatePercent(percent:Number):void
		{
			progressBar.enabled = true;
			if(percent>0)
				TweenLite.to(progressBar, 0.8, {delay:0.1, progress:percent, ease:Expo.easeOut});
			else
				progressBar.progress = 0;
			
			showTexts();
		}

		private function showTexts():void
		{
			var txt:String;
			switch(download.percent)
			{
				case 0:
					txt = loc("downloader_message_any");
					break;
				
				case 1:
					txt = loc("downloader_message_all");
					break;
					
				default:
					txt = StrTools.getNumberFromLocale(download.doawnloadedAya)+" "+getAyaLabel()+" "+loc("downloader_message_item")+" " + StrTools.getNumberFromLocale(download.numAyas) + " " + getAyaLabel();
					break;
			}

			var alfa:Number = download.percent>=1?0.6:1;
			if(alfa!=nameAlpha)
			{
				nameAlpha = alfa;
				var t1:Tween = new Tween(nameDisplay, 0.4);
				t1.fadeTo(alfa);
				Starling.juggler.add(t1); 
			}
			
			messageDisplay.visible = true;
			messageDisplay.text = txt.toLowerCase();
			var t:Tween = new Tween(messageDisplay, 0.6);
			t.fadeTo(1);
			Starling.juggler.add(t); 
		}
		
		private function getAyaLabel():String
		{
			return loc(appModel.ltr?"verses_in":"verse_l");
		}
		
		/*override public function set isSelected(value:Boolean):void
		{
			if(super.isSelected == value)
				return;

			super.isSelected = value;trace(value)
			download.state = value ? DownloadPackage.SELECTED : DownloadPackage.NORMAL;
		}*/
		
		private function download_stateChangedHandler(event:Event):void
		{
			setState(event.data as String);
		}
		
		private function setState(state:String):void
		{
			checkImage.setState(state, 0.5, index);
		}
		
		private function toggleDownloadingHandler(event:Event):void
		{
			checkButton.touchable = !downloadManager.downloading;
		}
		
	}
}