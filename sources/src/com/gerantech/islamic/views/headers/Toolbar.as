package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.ToolbarButton;
	import com.gerantech.islamic.views.lists.MenuList;

	import feathers.controls.AutoSizeMode;
	import feathers.controls.Callout;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import flash.utils.setTimeout;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.DropShadowFilter;
	import starling.filters.FilterChain;
		
	public class Toolbar extends LayoutGroup
	{
		public var navigationCallback:Function;
		public var accessoriesData:Vector.<ToolbarButtonData>;
		public var centerItem:FeathersControl;
		
		private var gap:Number;
		private var padding:Number;
		private var appModel:AppModel;
		
		private var accessories:Vector.<ToolbarButton>;
		private var navigatorButton:ToolbarButton;
		private var moreButton:ToolbarButton;
		private var moreList:MenuList;
		private var callout:Callout;
		private var moreListData:Array;
		
		public function Toolbar()
		{
			autoSizeMode = AutoSizeMode.STAGE;
			appModel = AppModel.instance;
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR);
						
			height = appModel.sizes.toolbar;
			gap = appModel.sizes.toolbar;
			padding = appModel.sizes.toolbar/2;
			
			layout = new AnchorLayout();
			
			resetItem();
			
			/*buttons = new Vector.<ToolbarButton>();
			activeButtons = new Vector.<ToolbarButton>();
			
			screenTitle = new RTLLabel("", 0xFFFFFF, "center", null, false, null, 0, null, "bold");
			screenTitle.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
	//		screenTitle.screens = [appModel.PAGE_ABOUT, appModel.PAGE_BOOKMARKS, appModel.PAGE_INDEX, appModel.PAGE_PERSON, appModel.PAGE_SETTINGS];
			
			navigateButton = new ToolbarButton("menu");
			navigateButton.screens = [appModel.PAGE_QURAN, appModel.PAGE_INDEX, appModel.PAGE_BOOKMARKS, appModel.PAGE_SETTINGS, appModel.PAGE_SEARCH, appModel.PAGE_PERSON];
			navigateButton.addEventListener(Event.TRIGGERED, navigateButton_triggeredHandler);
			addChild(navigateButton);
			
			var dots:ToolbarButton = new ToolbarButton("dots");
			dots.screens = [appModel.PAGE_QURAN];
			buttons.push(dots);
			
			var translateButton:ToolbarButton = new ToolbarButton("translation");
			translateButton.screens = [appModel.PAGE_QURAN];
			buttons.push(translateButton);
			
			var reciterButton:ToolbarButton = new ToolbarButton("recitation");
			reciterButton.screens = [appModel.PAGE_QURAN];
			buttons.push(reciterButton);
			
			var searchButton:ToolbarButton = new ToolbarButton("search");
			searchButton.screens = [appModel.PAGE_QURAN];
			buttons.push(searchButton);
			
			searchInput = new SearchInput();
			searchInput.layoutData = new AnchorLayoutData(appModel.sizes.border, NaN, appModel.sizes.border, NaN);
			*/
			appModel.navigator.addEventListener(Event.CHANGE, navigator_changeHandler);
			//appModel.drawers.addEventListener(Event.CLOSE, drawers_changeHandler);
			//appModel.drawers.addEventListener(Event.OPEN, drawers_changeHandler);
			UserModel.instance.addEventListener(UserEvent.CHANGE_COLOR, userModel_changeColorHandler);
			addEventListener("moveToolbar", moveToolbarHandler);
						
			setLayout();
		}
		
		
		
		private function moveToolbarHandler(event:Event):void
		{
			y = Math.max(-appModel.sizes.toolbar, Math.min(event.data as Number, 0));
			visible = y>-appModel.sizes.toolbar;
		}
		
		/*private function drawers_changeHandler(event:Event):void
		{
			if(event.type==Event.OPEN)
				fadeOut();
			else
				fadeIn();
		}*/
		
		override protected function stage_resizeHandler(event:Event):void
		{
			setLayout();
			super.stage_resizeHandler(event);
		}
		
		public function setLayout():void
		{
			removeChildren();
			width = appModel.sizes.width;
			
			var len:int = Math.min(accessoriesData.length, Math.floor(appModel.sizes.width/gap)-1);
			var limited:Boolean = len<accessoriesData.length;
			
			//trace(appModel.navigator.activeScreenID, leftItems.length, rightItems.length)
			accessories = new Vector.<ToolbarButton>();
			for(var i:uint=0; i<len; i++) 
			{
				accessories[i] = new ToolbarButton(accessoriesData[i]);
				accessories[i].x = appModel.ltr ? appModel.sizes.width-i*gap-(limited?gap:padding) : i*gap+(limited?gap:padding);
				addItem(accessories[i])
			}
			
			if(limited)
			{
				if(moreButton ==null)
					moreButton = new ToolbarButton(new ToolbarButtonData("more", "dots", null));
				
				moreButton.x = appModel.ltr ? appModel.sizes.width-padding/2 : padding/2;
				moreButton.addEventListener(Event.TRIGGERED, moreButton_triggeredHAndler);
				addItem(moreButton);
				
				//Create more list with remaining buttons
				moreListData = new Array();
				for(i=len; i<accessoriesData.length; i++) 
					moreListData.push(accessoriesData[i]);
			}
			
			if(navigationCallback != null)
			{
				if(navigatorButton==null)
				{
					navigatorButton = new ToolbarButton(new ToolbarButtonData("", "arrow_w_"+appModel.align, null));
					navigatorButton.addEventListener(Event.TRIGGERED, navigationCallback);
				}
				
				navigatorButton.x = appModel.ltr ? padding : appModel.sizes.width-padding;
				addItem(navigatorButton);
			}
			
			if(centerItem != null)
			{
				if(centerItem.layoutData==null)
					centerItem.layoutData = new AnchorLayoutData(appModel.sizes.DP4, appModel.ltr?accessories.length*gap:gap, appModel.sizes.DP4, appModel.ltr?gap:accessories.length*gap);
				addChild(centerItem);
			}
			/*searchInput.x = appModel.ltr ? gap :0;
			searchInput.width = appModel.sizes.width - gap;
			for(var i:uint; i<buttons.length; i++) 
			{
				buttons[i].x = appModel.ltr?appModel.sizes.width-i*gap-padding:i*gap+padding;
				buttons[i].y = appModel.sizes.toolbar/2;
				buttons[i].buttonWidth = gap;
				buttons[i].buttonHeight = appModel.sizes.toolbar;
				buttons[i].addEventListener(Event.TRIGGERED, activeButtons_triggerdHandler);
			}
			navigateButton.x = appModel.ltr ? padding*1.5 : appModel.sizes.width-padding*1.5;
			navigateButton.y = appModel.sizes.toolbar/2;
			navigateButton.buttonWidth = gap;
			navigateButton.buttonHeight = appModel.sizes.toolbar;*/
		}
		
		private function moreButton_triggeredHAndler():void
		{
			moreList = new MenuList();
			moreList.dataProvider = new ListCollection(moreListData);
			moreList.addEventListener(Event.CLOSE, callout_closeHandler);
			
			callout = Callout.show(moreList, moreButton);
			callout.width = Math.min(appModel.sizes.twoLineItem*2, appModel.sizes.orginalWidth*0.8)
			callout.filter = new FilterChain(new DropShadowFilter(appModel.sizes.border, 90*(Math.PI/180), 0, 0.5, 3));
		}
		
		private function navigator_changeHandler(event:Event):void
		{
			setLayout();
			UserModel.instance.scheduleSaving();
			//trace(appModel.navigator.activeScreenID);
			if(appModel.navigator.activeScreenID != appModel.PAGE_DASHBOARD)
				y=0;
			return;
			fadeOut();
			setTimeout(fadeIn, 500);
		}
		
		public function fadeOut():void
		{
/*			TweenLite.to(screenTitle, 0.3, {alpha:0, onComplete:screenTitle.removeFromParent});
			
			for(var i:uint; i<activeButtons.length; i++) 
				TweenLite.to(activeButtons[i], 0.3, {alpha:0, x:appModel.ltr?appModel.sizes.width-i*gap:i*gap, delay:i*0.06});
			
			TweenLite.to(navigateButton, 0.3, {alpha:0, scaleX:0, scaleY:0});
			
			if(searchInput.parent)
				TweenLite.to(searchInput, 0.3, {alpha:0, onComplete:searchInput.removeFromParent});*/
		}
		
		public function fadeIn():void
		{
			/*for each(var b:ToolbarButton in activeButtons)
				b.removeFromParent();
				
			if(hasTitle)
			{
				var title:String = appModel.navigator.activeScreenID;
				if(title==appModel.PAGE_PERSON)
					title = "page_"+currentPersonType;
				
				addChild(screenTitle);
				screenTitle.text = Localizations.instance.get(title);
				screenTitle.alpha = 0;
				TweenLite.to(screenTitle, 0.3, {alpha:1});
			}
				
			activeButtons = new Vector.<ToolbarButton>();
			for each(b in buttons)
				if(b.screens.indexOf(appModel.navigator.activeScreenID)>-1)
					activeButtons.push(b);
				
			for(var i:uint; i<activeButtons.length; i++) 
			{
				activeButtons[i].x = appModel.ltr?appModel.sizes.width-i*gap:i*gap;
				activeButtons[i].alpha = 0;
				addChild(activeButtons[i]);
				TweenLite.to(activeButtons[i], 0.3, {alpha:1, x:appModel.ltr?appModel.sizes.width-i*gap-padding:i*gap+padding, delay:i*0.05});
			}

			var naviIcon:String = "arrow_w_"+appModel.align;
			switch(appModel.navigator.activeScreenID)
			{
				case appModel.PAGE_QURAN:
					naviIcon = "menu";
					break;
			}
			navigateButton.texture = naviIcon;
			TweenLite.to(navigateButton, 0.3, {alpha:1, scaleX:1, scaleY:1});
			
			
			
			
			if(appModel.navigator.activeScreenID==appModel.PAGE_SEARCH || appModel.navigator.activeScreenID==appModel.PAGE_INDEX || appModel.navigator.activeScreenID==appModel.PAGE_FILTERED)
			{
				searchInput.updateData();
				addChild(searchInput);
				searchInput.alpha = 0;
				TweenLite.to(searchInput, 0.3, {alpha:1});
			}*/
		}
		/*
		private function activeButtons_triggerdHandler(event:Event):void
		{
			var btn:ToolbarButton = ToolbarButton(event.currentTarget);
			
			switch(btn.texture)
			{
				case "dots":
					var menu:MenuList = new MenuList();
					menu.addEventListener(Event.CLOSE, callout_closeHandler);
					callout = Callout.show(menu, btn);
					callout.filter = BlurFilter.createDropShadow(appModel.sizes.border, 90*(Math.PI/180), 0, 0.5, 3);
					break;
				case "search":
					AppModel.instance.navigator.pushScreen(appModel.PAGE_SEARCH);
					break;
				case "jump":
					break;
				
				case "recitation":
				case "translation":
					var screenItem:StackScreenNavigatorItem = AppModel.instance.navigator.getScreen(appModel.PAGE_PERSON);
					currentPersonType = btn.texture=="recitation"?Person.TYPE_RECITER:Person.TYPE_TRANSLATOR;
					screenItem.properties = {type:currentPersonType};
					AppModel.instance.navigator.pushScreen(appModel.PAGE_PERSON);
					break;
			}

		
		private function navigateButton_triggeredHandler(event:Event):void
		{
			if(appModel.navigator.activeScreenID==appModel.PAGE_QURAN)
				AppController.instance.toggleDrawer();
			else
				appModel.navigator.popScreen();
		}
		
		
		
		public function get hasTitle():Boolean
		{
			var p:String = appModel.navigator.activeScreenID;
			return(p==appModel.PAGE_ABOUT || p==appModel.PAGE_BOOKMARKS || p==appModel.PAGE_PERSON || p==appModel.PAGE_SETTINGS || p==appModel.PAGE_OMEN || p==appModel.PAGE_DOWNLOAD);
		}*/
		
		/*public function validateSize():void
		{
			skin.width = app.width;
			//skin.height = app.headerHeight;
			
			drawerButton.width = drawerButton.height = app.headerHeight;
		}*/
		
		
		private function callout_closeHandler(event:Event):void
		{
			callout.close();
		}
		
		private function userModel_changeColorHandler():void
		{
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR);
		}
		
		private function addItem(item:ToolbarButton):void
		{
			item.y = appModel.sizes.toolbar/2;
			item.buttonWidth = gap*1.2;
			item.buttonHeight = appModel.sizes.toolbar;
			item.addEventListener(Event.TRIGGERED, accessories_triggerHandler);
			addChild(item);
		}
		
		private function accessories_triggerHandler(event:Event):void
		{
			var item:ToolbarButton = event.currentTarget as ToolbarButton;
			if(item.data.callback)
				item.data.callback(item.data);
		}
		
		public function resetItem():void
		{
			centerItem = null;
			navigationCallback = null;
			accessoriesData = new Vector.<ToolbarButtonData>();
		}
	}
}