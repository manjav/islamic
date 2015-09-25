package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import mx.resources.ResourceManager;
	
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;

	public class BookmarkItemRenderer extends BaseCustomItemRenderer
	{		
		private var bookmark:Bookmark;
		private var nameDisplay:RTLLabel;
		private var deleteButton:FlatButton;
		
		public function BookmarkItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			height = appModel.sizes.singleLineItem;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.gap = appModel.sizes.border*4;
			myLayout.paddingLeft = appModel.ltr ? appModel.sizes.border*4 : 0;
			myLayout.paddingRight = appModel.ltr ? 0 : appModel.sizes.border*4;
			layout = myLayout;
			
			deleteButton = new FlatButton("remove", null, true);
			deleteButton.layoutData = new HorizontalLayoutData(NaN, 100);
			deleteButton.width = height;
			deleteButton.iconScale = 0.4;
			deleteButton.addEventListener(Event.TRIGGERED, deleteButton_triggeredHandler);
			
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR);//TextBlockTextRenderer();
			/*var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			nameDisplay.bidiLevel = appModel.ltr?0:1;
			nameDisplay.textAlign = appModel.align;
			nameDisplay.elementFormat = new ElementFormat(fd, UserModel.instance.fontSize, 0x000000);*/
			nameDisplay.layoutData = new HorizontalLayoutData(100);
			
			addChild(appModel.ltr?nameDisplay:deleteButton);
			addChild(appModel.ltr?deleteButton:nameDisplay);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			/*if(bookmark==_data)
				return;*/
			//trace(ResourceManager.getInstance().localeChain, appModel.ltr)
			bookmark = Bookmark.getFromObject(_data);
			var sura:Sura = ResourceModel.instance.suraList[bookmark.sura-1];
			nameDisplay.text = ResourceManager.getInstance().getString("loc", "sura_l")+" "+ (appModel.ltr?(sura.tname+","):sura.name) + " "+ResourceManager.getInstance().getString("loc", "verse_l")+" "+ StrTools.getNumberFromLocale(bookmark.aya);
			super.commitData();
		}
		
		private function deleteButton_triggeredHandler(event:Event):void
		{
			_owner.dispatchEventWith(Event.SELECT, false, bookmark); 
		}
	
	}
}