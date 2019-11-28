package com.gerantech.islamic
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.TimesModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.themes.CustomTheme;
	import com.gerantech.islamic.views.controls.CustomDrawers;
	import com.gerantech.islamic.views.headers.Toolbar;
	import com.gerantech.islamic.views.popups.AthanPopUp;
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

	import feathers.controls.AutoSizeMode;
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.core.PopUpManager;
	import feathers.motion.Cover;
	import feathers.motion.Reveal;

	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import flash.utils.getTimer;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import gt.utils.Localizations;

	public class Main extends Sprite
	{		
		private var appModel:AppModel;
		
		public function Main()
		{
			appModel = AppModel.instance;
			appModel.navigator = new StackScreenNavigator();
			appModel.navigator.autoSizeMode = AutoSizeMode.STAGE;
			appModel.navigator.clipContent = true;
			
			var dashItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(DashboardScreen);
			appModel.navigator.addScreen(appModel.PAGE_DASHBOARD, dashItem);
			
			addModal(appModel.PAGE_SETTINGS,			SettingsScreen);
			addModal(appModel.PAGE_ABOUT,					AboutScreen);
			
			addModal(appModel.PAGE_QURAN,					QuranScreen);
			addModal(appModel.PAGE_INDEX,					IndexScreen);
			addModal(appModel.PAGE_BOOKMARKS,			BookmarksScreen);
			addModal(appModel.PAGE_SEARCH,				SearchScreen);
			addModal(appModel.PAGE_PERSON,				PersonsScreen);
			addModal(appModel.PAGE_FILTERED,			FilteredPersonScreen);
			addModal(appModel.PAGE_OMEN,					OmenScreen);
			
			addModal(appModel.PAGE_PURCHASE,			PurchaseScreen);
			addModal(appModel.PAGE_DOWNLOAD,			DownloadScreen);
			addModal(appModel.PAGE_COMPASS,				CompassScreen);
			addModal(appModel.PAGE_CITY,					CityScreen);
			addModal(appModel.PAGE_TIMES,					TimesScreen);
			addModal(appModel.PAGE_ALERT,					AlertScreen);
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
			appModel.drawers.content = appModel.navigator;
			addChild(appModel.drawers);
			
			UserModel.instance.timesModel.load();
			trace(" --  Main createScreens", getTimer()-Hidaya.ft);
			
			Localizations.instance.addEventListener(Event.CHANGE, localizations_changeHandler);
			if( UserModel.instance.locale == null )
				Localizations.instance.changeLocale(Localizations.instance.getLocaleByTimezone("Asia/Tehran"));//NativeAbilities.instance.getTimezone()
			else
				Localizations.instance.changeLocale(UserModel.instance.locale.value);
		}
		
		private function localizations_changeHandler(event:Event):void
		{
			Localizations.instance.removeEventListener(Event.CHANGE, localizations_changeHandler);
			// check invoke event for getting metadata and arguments
			//appModel.invokeData = {type:"athan", timeIndex:0, alertIndex:0};
			appModel.addEventListener(InvokeEvent.INVOKE, showInvokedCommand);
			if(appModel.invokeData != null)
			{
				showInvokedCommand();
			}
			else
			{
				/*if(UserModel.instance.user.profile.numRun==1)
				{
				var tute:TutorialPopUp = new TutorialPopUp();
				tute.addEventListener(Event.CLOSE, tute_closeHandler);
				PopUpManager.addPopUp(tute);
				}
				else*/
				tute_closeHandler(null);

			}
		}

		private function showInvokedCommand():void
		{
			var timeModel:TimesModel = UserModel.instance.timesModel;

			var alert:Alert = timeModel.times[appModel.invokeData.timeIndex].alerts[appModel.invokeData.alertIndex];
			var athanPopUp:AthanPopUp = AppController.instance.addPopup(AthanPopUp, null, true, function():DisplayObject{return new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR)}) as AthanPopUp;
			if(appModel.navigator.rootScreenID == null)
				athanPopUp.addEventListener(Event.CLOSE, athanPopUp_closeHandler);
			athanPopUp.alert = alert;
		}
		
		private function athanPopUp_closeHandler(event:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function tute_closeHandler(event:Event):void
		{
			if(event != null)
				PopUpManager.removePopUp(event.currentTarget as TutorialPopUp, true);
			Starling.current.nativeStage.autoOrients = true;
			
			appModel.toolbar = new Toolbar();
			addChild(appModel.toolbar);
			
			appModel.navigator.rootScreenID = appModel.PAGE_DASHBOARD;
		}
	}
}