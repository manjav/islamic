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
	import com.gerantech.islamic.views.screens.AlertScreen;
	import com.gerantech.islamic.views.screens.BookmarksScreen;
	import com.gerantech.islamic.views.screens.CalendarScreen;
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
			
			addModal(appModel.PAGE_SETTINGS,			SettingsScreen);
			addModal(appModel.PAGE_ABOUT,				AboutScreen);

			addModal(appModel.PAGE_QURAN,				QuranScreen);
			addModal(appModel.PAGE_INDEX,				IndexScreen);
			addModal(appModel.PAGE_BOOKMARKS,			BookmarksScreen);
			addModal(appModel.PAGE_SEARCH,				SearchScreen);
			addModal(appModel.PAGE_PERSON,				PersonsScreen);
			addModal(appModel.PAGE_FILTERED,			FilteredPersonScreen);
			addModal(appModel.PAGE_OMEN,				OmenScreen);
			
			addModal(appModel.PAGE_PURCHASE,			PurchaseScreen);
			addModal(appModel.PAGE_DOWNLOAD,			DownloadScreen);
			addModal(appModel.PAGE_COMPASS,				CompassScreen);
			addModal(appModel.PAGE_CITY,				CityScreen);
			addModal(appModel.PAGE_TIMES,				TimesScreen);
			addModal(appModel.PAGE_ALERT,				AlertScreen);
			addModal(appModel.PAGE_CALENDAR, 			CalendarScreen);
		}
		
		private function addModal(screenId:String, screenClass:Class, pushTransition:Function=null, popTransition:Function=null):void
		{
			if(pushTransition==null)
				pushTransition = Cover.createCoverUpTransition();
			if(popTransition==null)
				popTransition = Reveal.createRevealDownTransition();
			
			var item:StackScreenNavigatorItem = new StackScreenNavigatorItem(screenClass);
			item.pushTransition = pushTransition;
			item.popTransition = popTransition;
			appModel.navigator.addScreen(screenId, item);
		}		
		
		public function createScreens():void
		{
			appModel.theme = new CustomTheme();
			appModel.drawers = new CustomDrawers();
			addChild(appModel.drawers);
			appModel.drawers.content = appModel.navigator;
			
			appModel.date = new MultiDate(null, UserModel.instance.hijriOffset);
			appModel.prayTimes = new PrayTime(CalculationMethod.TEHRAN, UserModel.instance.city.latitude, UserModel.instance.city.longitude);

			/*if(UserModel.instance.user.profile.numRun==1)
			{
				var tute:TutorialPopUp = new TutorialPopUp();
				tute.addEventListener(Event.CLOSE, tute_closeHandler);
				PopUpManager.addPopUp(tute);
			}
			else*/
				tute_closeHandler(null)
		}

		
		private function tute_closeHandler(event:Event):void
		{
			if(event!=null)
				PopUpManager.removePopUp(event.currentTarget as TutorialPopUp, true);
			Starling.current.nativeStage.autoOrients=true;
			
			appModel.toolbar = new Toolbar();
			addChild(appModel.toolbar);
			
			appModel.navigator.rootScreenID = appModel.PAGE_DASHBOARD;
			appModel.dispatchEventWith(AppEvent.PUSH_FIRST_SCREEN);
		}
	}
}