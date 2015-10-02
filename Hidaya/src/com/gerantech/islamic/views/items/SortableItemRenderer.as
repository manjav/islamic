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
			height = appModel.sizes.twoLineItem;
			
			var grid:uint = appModel.sizes.DP32;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.paddingLeft = myLayout.paddingRight = appModel.sizes.DP8;
			layout = myLayout;
			
			deleteButton = new FlatButton("remove", null, true);
			deleteButton.layoutData = new HorizontalLayoutData(NaN, 100);
			deleteButton.width = grid;
			deleteButton.iconScale = 0.7;
			deleteButton.addEventListener(Event.TRIGGERED, deleteButton_triggeredHandler);
			
			downloadButton = new FlatButton("download_g", null, true);
			downloadButton.layoutData = new HorizontalLayoutData(NaN, 100);
			downloadButton.width = grid;
			downloadButton.iconScale = 0.7;
			downloadButton.addEventListener(Event.TRIGGERED, downloadButton_triggeredHandler);
			
			mainContents = new LayoutGroup();
			mainContents.layoutData = new HorizontalLayoutData(100, 60);
			mainContents.layout = new VerticalLayout();
			
			var fontSize:uint = height/5.4;
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, fontSize, null, "bold");
			nameDisplay.layoutData = new VerticalLayoutData(100, 55);
			mainContents.addChild(nameDisplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, fontSize*0.8, null);
			messageDisplay.layoutData = new VerticalLayoutData(100, 45);
			mainContents.addChild(messageDisplay);
			
			var spacer:Spacer = new Spacer();
			spacer.width = appModel.sizes.DP4;
			
			personImage = new ImageLoader();
			personImage.layoutData = new HorizontalLayoutData(NaN, 60);
			personImage.delayTextureCreation = true;
			
			dragButton = new FlatButton("drag", null, true, 0, 0);
			dragButton.width = grid;
			dragButton.layoutData = new HorizontalLayoutData(NaN, 100);
			
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
				_person.loadImage();
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