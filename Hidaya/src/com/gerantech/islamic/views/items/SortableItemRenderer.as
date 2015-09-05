package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.managers.DownloadManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.Spacer;
	
	import flash.geom.Point;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class SortableItemRenderer extends LayoutGroup
	{
		private var touchID:int = -1;
		private static const HELPER_POINT:Point = new Point();
		private var deleteButton:FlatButton;
		private var mainContents:LayoutGroup;
		private var personImage:ImageLoader;
		private var _person:Person;

		private var appModel:AppModel;

		public var dragButton:FlatButton;

		private var percent:RTLLabel;
		private var nameDisplay:RTLLabel;
		private var messageDisplay:RTLLabel;
		private var downloadButton:FlatButton;
		
		public function SortableItemRenderer()
		{
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			appModel = AppModel.instance;
			height = appModel.itemHeight;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.paddingLeft = myLayout.paddingRight = myLayout.gap = -appModel.border;
			//myLayout.gap = appModel.border*2;
			//myLayout.padding = appModel.border;
			//myLayout.paddingLeft = myLayout.firstGap = appModel.ltr ? 0 : myLayout.gap;
			//myLayout.paddingRight = myLayout.lastGap = appModel.ltr ? myLayout.gap : 0;
			layout = myLayout;
			
			downloadButton = new FlatButton("download_g", null, true);
			downloadButton.layoutData = new HorizontalLayoutData(NaN, 100);
			downloadButton.width = height;
			downloadButton.iconScale = 0.5;
			downloadButton.addEventListener(Event.TRIGGERED, downloadButton_triggeredHandler);
			
			deleteButton = new FlatButton("remove", null, true);
			deleteButton.layoutData = new HorizontalLayoutData(NaN, 100);
			deleteButton.width = height;
			deleteButton.iconScale = 0.46;
			deleteButton.addEventListener(Event.TRIGGERED, deleteButton_triggeredHandler);
			
			mainContents = new LayoutGroup();
			mainContents.layoutData = new HorizontalLayoutData(100, 75);
			mainContents.layout = new VerticalLayout();
			
			var fontSize:uint = appModel.itemHeight/4;
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, fontSize, null, "bold");
			/*var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			nameDisplay.bidiLevel = appModel.ltr?0:1;
			nameDisplay.textAlign = appModel.align;
			nameDisplay.elementFormat = new ElementFormat(fd, fontSize, BaseMaterialTheme.PRIMARY_TEXT_COLOR);*/
			nameDisplay.layoutData = new VerticalLayoutData(100, 55);
			mainContents.addChild(nameDisplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, fontSize*0.8, null);
			/*var fd2:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			messageDisplay.bidiLevel = appModel.ltr?0:1;
			messageDisplay.textAlign = appModel.align;
			messageDisplay.elementFormat = new ElementFormat(fd2, fontSize*0.8, BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);*/
			messageDisplay.layoutData = new VerticalLayoutData(100, 45);
			mainContents.addChild(messageDisplay);
			
			var spacer:Spacer = new Spacer();
			spacer.width = appModel.border*4;
			
			personImage = new ImageLoader();
			personImage.layoutData = new HorizontalLayoutData(NaN, 80);
			personImage.delayTextureCreation = true;
			
			dragButton = new FlatButton("drag", null, true, 0, 0);
			dragButton.width = height;
			dragButton.iconScale = 0.6;
			dragButton.layoutData = new HorizontalLayoutData(NaN, 100);
			/*var sortImage:ImageLoader = new ImageLoader();
			sortImage.layoutData = new HorizontalLayoutData(NaN, 60);
			sortImage.source = Assets.getTexture("sort");
			sortImage.delayTextureCreation = true;*/
			
			var itms:Array = [deleteButton, downloadButton, mainContents, spacer, personImage, dragButton];
			if(appModel.ltr)
				itms.reverse();
			
			for each(var itm:DisplayObject in itms)
				addChild(itm);
		}
		
		private function downloadButton_triggeredHandler(event:Event):void
		{
			var screenItem:StackScreenNavigatorItem = AppModel.instance.navigator.getScreen(appModel.PAGE_DOWNLOAD);
			screenItem.properties = {reciter:_person};
			appModel.navigator.pushScreen(appModel.PAGE_DOWNLOAD);
		}
		
		private function deleteButton_triggeredHandler(event:Event):void
		{
			dispatchEventWith(Event.SELECT);
		}
		
		public function get person():Person
		{
			return _person;
		}
		
		public function set person(value:Person):void
		{
			_person = value;
			downloadButton.visible = _person.type==Person.TYPE_RECITER;
			nameDisplay.text = (appModel.ltr&&_person.type==Person.TYPE_RECITER) ? _person.ename : _person.name;
			showIcon();

			downloadButton.touchable = !DownloadManager.instance.downloading || (DownloadManager.instance.downloading && DownloadManager.instance.reciter==value); 
			deleteButton.touchable = (!DownloadManager.instance.downloading || DownloadManager.instance.reciter!=value);
		}
		
		// ICON  -------------------------------------------------
		private function showIcon():void
		{
			if(_person.hasIcon)
			{
				personImage.source = _person.iconTexture;
				messageDisplay.text = _person.getCurrentMessage();
			}
			else
			{
				_person.addEventListener(Person.ICON_LOADED, person_imageCompleteHandler);
				_person.loadImage(_person.iconUrl);
			}
		}
		private function person_imageCompleteHandler():void
		{
			_person.removeEventListener(Person.ICON_LOADED, person_imageCompleteHandler);
			if(parent!=null)
				personImage.source = _person.iconTexture;
			messageDisplay.text = _person.getCurrentMessage();
		}
	}
}