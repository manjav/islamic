package com.gerantech.islamic
{
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.CustomTheme;
	import com.gerantech.islamic.utils.MultiDate;
	import com.gerantech.islamic.views.controls.CustomDrawers;
	import com.gerantech.islamic.views.headers.Toolbar;
	import com.gerantech.islamic.views.popups.TutorialPopUp;
	import com.gerantech.islamic.views.screens.AboutScreen;
	import com.gerantech.islamic.views.screens.BookmarksScreen;
	import com.gerantech.islamic.views.screens.CityScreen;
	import com.gerantech.islamic.views.screens.CompassScreen;
	import com.gerantech.islamic.views.screens.DashboardScreen;
	import com.gerantech.islamic.views.screens.DownloadScreen;
	import com.gerantech.islamic.views.screens.FilteredPersonScreen;
	import com.gerantech.islamic.views.screens.IndexScreen;
	import com.gerantech.islamic.views.screens.OmenScreen;
	import com.gerantech.islamic.views.screens.PersonsScreen;
	import com.gerantech.islamic.views.screens.PurchaseScreen;
	import com.gerantech.islamic.views.screens.QuranScreen;
	import com.gerantech.islamic.views.screens.SearchScreen;
	import com.gerantech.islamic.views.screens.SettingsScreen;
	import com.gerantech.islamic.views.screens.TimesScreen;
	
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.core.PopUpManager;
	import feathers.motion.Cover;
	import feathers.motion.Reveal;
	
	import org.praytimes.PrayTime;
	import org.praytimes.constants.CalculationMethod;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{		
		private var appModel:AppModel;
		
		public function Main()
		{
			appModel = AppModel.instance;
			
			appModel.navigator = new StackScreenNavigator();
			appModel.navigator.autoSizeMode = StackScreenNavigator.AUTO_SIZE_MODE_STAGE;
			appModel.navigator.clipContent = true;
			
			var dashItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(DashboardScreen);
			appModel.navigator.addScreen(appModel.PAGE_DASHBOARD, dashItem);
			
			
			var settingItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SettingsScreen);
			settingItem.pushTransition = appModel.pushTransition;
			settingItem.popTransition = appModel.popTransition;
			appModel.navigator.addScreen(appModel.PAGE_SETTINGS, settingItem);		
			
			var aboutItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AboutScreen);
			aboutItem.pushTransition = appModel.pushTransition;
			aboutItem.popTransition = appModel.popTransition;
			appModel.navigator.addScreen(appModel.PAGE_ABOUT, aboutItem);		
			
			// Quran --------------------------------------------------
			var quranItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(QuranScreen);
			quranItem.pushTransition = Cover.createCoverUpTransition();
			quranItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_QURAN, quranItem);
			
			var indexItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(IndexScreen);
			indexItem.pushTransition = appModel.pushTransition;
			indexItem.popTransition = appModel.popTransition;
			appModel.navigator.addScreen(appModel.PAGE_INDEX, indexItem);		
			
			var bookmarkItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(BookmarksScreen);
			bookmarkItem.pushTransition = appModel.pushTransition;
			bookmarkItem.popTransition = appModel.popTransition;
			appModel.navigator.addScreen(appModel.PAGE_BOOKMARKS, bookmarkItem);		
			
			var searchItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SearchScreen);
			searchItem.pushTransition = appModel.pushTransition;
			searchItem.popTransition = appModel.popTransition;
			appModel.navigator.addScreen(appModel.PAGE_SEARCH, searchItem);		
			
			var personItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(PersonsScreen);
			personItem.pushTransition = Cover.createCoverUpTransition();
			personItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_PERSON, personItem);
			
			var filterItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FilteredPersonScreen);
			filterItem.pushTransition = Cover.createCoverUpTransition();
			filterItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_FILTERED, filterItem);	
			
			var omenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(OmenScreen);
			omenItem.pushTransition = appModel.pushTransition;
			omenItem.popTransition = appModel.popTransition;
			appModel.navigator.addScreen(appModel.PAGE_OMEN, omenItem);
			
			var purchaseItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(PurchaseScreen);
			purchaseItem.pushTransition = Cover.createCoverUpTransition();
			purchaseItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_PURCHASE, purchaseItem);
			
			var downloadItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(DownloadScreen);
			downloadItem.pushTransition = Cover.createCoverUpTransition();
			downloadItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_DOWNLOAD, downloadItem);
				
		
			var compassItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(CompassScreen);
			compassItem.pushTransition = Cover.createCoverUpTransition();
			compassItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_COMPASS, compassItem);
			
			var cityItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(CityScreen);
			cityItem.pushTransition = Cover.createCoverUpTransition();
			cityItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_CITY, cityItem);
			
			var timesItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TimesScreen);
			timesItem.pushTransition = Cover.createCoverUpTransition();
			timesItem.popTransition = Reveal.createRevealDownTransition();
			appModel.navigator.addScreen(appModel.PAGE_TIMES, timesItem);
		}
		
		public function createScreens():void
		{
			appModel.theme = new CustomTheme();
			appModel.drawers = new CustomDrawers();
			/*appModel.myDrawer = new DrawerList(appModel.ltr);
			
			if(appModel.ltr)
				appModel.drawers.leftDrawer = appModel.myDrawer;
			else
				appModel.drawers.rightDrawer = appModel.myDrawer;*/
			
			addChild(appModel.drawers);
			appModel.drawers.content = appModel.navigator;
			
			appModel.date = new MultiDate();
			appModel.prayTimes = new PrayTime(CalculationMethod.TEHRAN, UserModel.instance.city.latitude, UserModel.instance.city.longitude);

			trace(UserModel.instance.city.name)
			
			if(UserModel.instance.user.profile.numRun==1)
			{
				var tute:TutorialPopUp = new TutorialPopUp();
				tute.addEventListener(Event.CLOSE, tute_closeHandler);
				PopUpManager.addPopUp(tute);
			}
			else
				tute_closeHandler(null)
			
		}

		
		private function tute_closeHandler(event:Event):void
		{
			if(event!=null)
				PopUpManager.removePopUp(event.currentTarget as TutorialPopUp, true);
			Starling.current.nativeStage.autoOrients=true;
			
			appModel.toolbar = new Toolbar();
			//appModel.toolbar.layoutData = new AnchorLayoutData(0,0,NaN,0);
			addChild(appModel.toolbar);
			
			appModel.navigator.rootScreenID = appModel.PAGE_DASHBOARD;
			appModel.dispatchEventWith(AppEvent.PUSH_FIRST_SCREEN);
		}
	}
}