package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.buttons.ToolbarButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.SearchInput;
	import com.gerantech.islamic.views.lists.MenuList;
	import com.gerantech.islamic.views.popups.GotoPopUp;
	import com.greensock.TweenLite;
	
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Callout;
	import feathers.controls.LayoutGroup;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
		
	public class Toolbar extends LayoutGroup
	{
		private var buttons:Vector.<ToolbarButton>;
		private var activeButtons:Vector.<ToolbarButton>;
		
		private var gap:Number;
		private var padding:Number;

		private var navigateButton:ToolbarButton;
		private var appModel:AppModel;

		private var searchInput:SearchInput;

		private var gotoPopUP:GotoPopUp;

		private var overlay:FlatButton;

		private var callout:Callout;
		private var screenTitle:RTLLabel;
		private var currentPersonType:String;
		
		public function Toolbar()
		{
			autoSizeMode = AUTO_SIZE_MODE_STAGE;
			appModel = AppModel.instance;
			backgroundSkin = new Quad(1,1,BaseMaterialTheme.CHROME_COLOR);
			
			height = appModel.sizes.toolbar;
			gap = Math.min(appModel.sizes.toolbar*1.2, appModel.sizes.orginalWidth/5);
			padding = appModel.sizes.toolbar/3;
			
			layout = new AnchorLayout();
			buttons = new Vector.<ToolbarButton>();
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
			
			var selectedReciterButton:ToolbarButton = new ToolbarButton("dots");
			selectedReciterButton.screens = [appModel.PAGE_SEARCH];
			buttons.push(selectedReciterButton);
			
			/*var gotoButton:ToolbarButton = new ToolbarButton("jump");
			gotoButton.screens = [appModel.PAGE_QURAN];
			buttons.push(gotoButton);
			*/
			searchInput = new SearchInput();
			searchInput.layoutData = new AnchorLayoutData(appModel.sizes.border, NaN, appModel.sizes.border, NaN);
			
			appModel.navigator.addEventListener(Event.CHANGE, navigator_changeHandler);
			appModel.drawers.addEventListener(Event.CLOSE, drawers_changeHandler);
			appModel.drawers.addEventListener(Event.OPEN, drawers_changeHandler);
			UserModel.instance.addEventListener(UserEvent.CHANGE_COLOR, userModel_changeColorHandler);
						
			setLayout();
		}
		
		private function drawers_changeHandler(event:Event):void
		{
			if(event.type==Event.OPEN)
			{
				fadeOut();
			}
			else
			{
				fadeIn();
			}

		}
		
		override protected function stage_resizeHandler(event:Event):void
		{
			setLayout();
			super.stage_resizeHandler(event);
		}
		
		
		public function setLayout():void
		{
			width = appModel.sizes.width;
			searchInput.width = appModel.sizes.width - gap*2;
			searchInput.x =  gap ;
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
			navigateButton.buttonHeight = appModel.sizes.toolbar;
		}
		
		private function navigator_changeHandler(event:Event):void
		{
			fadeOut();
			setTimeout(fadeIn, 500);
		}
		
		public function fadeOut():void
		{
			TweenLite.to(screenTitle, 0.3, {alpha:0, onComplete:function():void{screenTitle.removeFromParent()}});
			
			for(var i:uint; i<activeButtons.length; i++) 
				TweenLite.to(activeButtons[i], 0.3, {alpha:0, x:appModel.ltr?appModel.sizes.width-i*gap:i*gap, delay:i*0.06});
			
			TweenLite.to(navigateButton, 0.3, {alpha:0, scaleX:0, scaleY:0});
			
			if(searchInput.parent)
				TweenLite.to(searchInput, 0.3, {alpha:0});
				
		}
		
		public function fadeIn():void
		{
			for each(var b:ToolbarButton in activeButtons)
				b.removeFromParent();
				
			if(hasTitle)
			{
				var title:String = appModel.navigator.activeScreenID;
				if(title==appModel.PAGE_PERSON)
					title = "page_"+currentPersonType;
				
				addChild(screenTitle);
				screenTitle.text = ResourceManager.getInstance().getString("loc", title);
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
				/*case appModel.PAGE_PERSON:
				case appModel.PAGE_FILTERED:
					naviIcon = "arrow_w_up";
					break;*/
			}
			navigateButton.texture = naviIcon;
			TweenLite.to(navigateButton, 0.3, {alpha:1, scaleX:1, scaleY:1});
			
			if(appModel.navigator.activeScreenID==appModel.PAGE_SEARCH || appModel.navigator.activeScreenID==appModel.PAGE_INDEX || appModel.navigator.activeScreenID==appModel.PAGE_FILTERED)
			{
				searchInput.updateData();
				addChild(searchInput);
				searchInput.alpha = 0;
				TweenLite.to(searchInput, 0.3, {alpha:1});
			}
		}
		
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
		}
		
		private function callout_closeHandler(event:Event):void
		{
			callout.close();
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
		}
		
		/*public function validateSize():void
		{
			skin.width = app.width;
			//skin.height = app.headerHeight;
			
			drawerButton.width = drawerButton.height = app.headerHeight;
		}*/
		
		
		private function userModel_changeColorHandler():void
		{
			backgroundSkin = new Quad(1,1,BaseMaterialTheme.CHROME_COLOR);
		}

	}
}