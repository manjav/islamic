package com.gerantech.islamic.models
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.managers.ProfileManager;
	import com.gerantech.islamic.managers.UserDataUpdater;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Juze;
	import com.gerantech.islamic.models.vo.Location;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.models.vo.User;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.net.SharedObject;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	public class UserModel extends EventDispatcher
	{
		public var appModel:AppModel;
		public var appController:AppController;
		public var configModel:ConfigModel;
		public var user:User;
		
		public var TRANSLATOR_PATH:String;
		public var SOUNDS_PATH:String;
		
		private static var _this:UserModel;

		private var saveTimeout:uint;
		private var preventSaver:Boolean;
		public var profileManager:ProfileManager;
		public var userUpdater:UserDataUpdater;
		private var backupTimeout:uint;
		public var pagesList:Array;
		public var bookmarks:BookmarkCollection;
		private var _lastItem:Aya;
		public var loaded:Boolean;
		public var timesModel:TimesModel;
		private var resourceInited:Boolean;

		public static function get instance():UserModel
		{
			if(_this == null)
				_this = new UserModel();
			return (_this);
		}
		
		public function UserModel()
		{			
			user = new User();
			bookmarks = new BookmarkCollection(user.bookmarks);
			userUpdater = new UserDataUpdater();
			profileManager = new ProfileManager();
			timesModel = new TimesModel();
		}
				
		public function get idleMode():Object{return user.idleMode};
		public function set idleMode(value:Object):void{appController.setIdleMode(user.idleMode=value); scheduleSaving()};
		
		public function get remniderTime():Object{return user.remniderTime}
		public function set remniderTime(value:Object):void{user.remniderTime=value, scheduleSaving()}
		
		public function get fontSize():uint{return user.fontSize};
		public function set fontSize(value:uint):void{if(value==user.fontSize)return; user.fontSize=value, scheduleSaving(), dispatchEventWith(UserEvent.FONT_SIZE_CHANGING)};
		
		public function get font():Object{return user.font;}
		public function set font(value:Object):void{if(value==user.font)return; user.font=value, scheduleSaving()}

		public function get storagePath():String{return user.storagePath};
		public function set storagePath(value:String):void{user.storagePath=value, scheduleSaving()}
		
		public function set premiumMode(value:Boolean):void{user.premiumMode = value, scheduleSaving()}
		public function get premiumMode():Boolean{return user.premiumMode;}
		
		public function set inbox(value:Array):void{user.inbox = value, scheduleSaving()}
		public function get inbox():Array{return user.inbox;}

		public function get city():Location{return new Location(user.city.name, user.city.latitude, user.city.longitude)};
		public function set city(value:Location):void { user.city = value; scheduleSaving();}

		public function get searchPatt():String{return user.searchPatt};
		public function set searchPatt(value:String):void{if(user.searchPatt==value)return; user.searchPatt=value; scheduleSaving()};
		
		public function get searchSource():uint{return user.searchSource};
		public function set searchSource(value:uint):void{if(user.searchSource==value)return; user.searchSource=value; scheduleSaving()};
		
		public function get searchScope():uint{return user.searchScope};
		public function set searchScope(value:uint):void{if(user.searchScope==value)return; user.searchScope=value; scheduleSaving()};
		
		public function get searchSura():uint{return user.searchSura};
		public function set searchSura(value:uint):void{if(user.searchSura==value)return; user.searchSura=value; scheduleSaving()};
		
		public function get searchJuze():uint{return user.searchJuze};
		public function set searchJuze(value:uint):void{if(user.searchJuze==value)return; user.searchJuze=value; scheduleSaving()};
		
		public function get locale():Object{return user.local};
		public function set locale(value:Object):void{user.local = value;scheduleSaving();appController.setLanguage(value);}
		
		public function get ayaRepeat():uint{return user.ayaRepeat}
		public function set ayaRepeat(value:uint):void{user.ayaRepeat=value, scheduleSaving()}
		
		public function get pageRepeat():uint{return user.pageRepeat}
		public function set pageRepeat(value:uint):void{user.pageRepeat=value, scheduleSaving()}
		
		public function get personRepeat():uint{return user.personRepeat}
		public function set personRepeat(value:uint):void{user.personRepeat=value, scheduleSaving()}
		
		public function get hijriOffset():int{return user.hijriOffset}
		public function set hijriOffset(value:int):void{user.hijriOffset=value, appModel.date.hijriOffset=value, appModel.date.calculate(), scheduleSaving()}
		
		public function get lastItem():Aya{return _lastItem};
		public function setLastItem(sura:uint, aya:uint):void
		{
			user.sura = sura;
			user.aya = aya;
			_lastItem = new Aya(sura, aya, 0, Page.getBySuraAya(sura, aya).page, Juze.getBySuraAya(sura, aya).juze);
			scheduleSaving();
		}
		
		public function get nightMode():Boolean{return user.nightMode}
		public function set nightMode(value:Boolean):void
		{
			user.nightMode = value;
			
			BaseMaterialTheme.CHROME_COLOR = value ? 0x004D40 : 0x009688;
			BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR = value ? 0x001616 : 0xFAFFFF;
			BaseMaterialTheme.PRIMARY_TEXT_COLOR = value ? 0xC2C8C4 : 0x101010;
			BaseMaterialTheme.DESCRIPTION_TEXT_COLOR = value ? 0x7d8d88 : 0x757575;
			BaseMaterialTheme.SECONDARY_BACKGROUND_COLOR = value ? 0x00695C : 0xE0F2F1;
			Starling.current.stage.color = BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR;
			Starling.current.nativeStage.color = BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR;
			scheduleSaving();
		}
		
		public function get navigationMode():Object{return user.navigationMode};
		public function set navigationMode(value:Object):void
		{
			user.navigationMode = value;
			pagesList = new Array();
			switch(value.value)
			{
				case "page_navi":
					for (var i:int=603; i>=0; i--)
						pagesList.push(ResourceModel.instance.pageList[603-i]);
					break;
				
				case "sura_navi":
					for (var j:int=113; j>=0; j--)
						pagesList.push(ResourceModel.instance.suraList[113-j]);
					break;
				
				case "juze_navi":
					for (var k:int=29; k>=0; k--)
						pagesList.push(ResourceModel.instance.juzeList[29-k]);
					break;
			}
			scheduleSaving();
		}
		
		
		public function getSelectedByLastItem():uint
		{
			var ret:uint = 0;
			switch(navigationMode.value)
			{
				case "page_navi":
					if(!appModel.upside && appModel.sizes.isTablet&& !ResourceModel.instance.hasTranslator)
						ret = (604-lastItem.page)/2;
					else
						ret = 604-lastItem.page;
					break;
				
				case "sura_navi":
					ret = 114-lastItem.sura;
					break;
				
				case "juze_navi":
					ret = 30-lastItem.juze;
					break;
			}
			return ret;
		}		
		
		/**
		 *Controlers ___________________________________ 
		 */		
		public function initResources():void
		{
			if(resourceInited)
				return;
			
			resourceInited = preventSaver = true;
			ResourceModel.instance.load();
			setLastItem(user.sura, user.aya);			
			navigationMode = user.navigationMode;
			preventSaver = false;
		}
		
		public function load(appModel:AppModel, appController:AppController, configModel:ConfigModel):void
		{
			this.appModel = appModel;
			this.appController = appController;
			this.configModel = configModel;
			
			var so:SharedObject = SharedObject.getLocal("user-data");
			setMarketData();
			loadByObject(so.data.user);
			userUpdater.restore(user);
			//premiumMode = true;
			loaded = true;
		}
		
		public function loadByObject(loadData:Object):void
		{
			preventSaver = true;
			if(loadData!=null)
			{
				for(var n:String in loadData)
				{
					if(n=='profile')
					{
						for(var p:String in loadData[n])
							if(user.profile.hasOwnProperty(p))
								user.profile[p] = loadData[n][p];
						//user.profile[n.substr(2)] = loadData[n];
					}
					else if(user.hasOwnProperty(n))
						user[n] = loadData[n];
				}
			}
			appController.setPaths(this, storagePath);
			configModel.setAssets(appModel, this);
			locale	= user.local;
			bookmarks = new BookmarkCollection(user.bookmarks);
			nightMode = user.nightMode;
			appController.setIdleMode(user.idleMode);
			
			user.profile.numRun ++;
			if(!user.rated)
			{
				if(user.profile.numRun==3 || user.profile.numRun==10 || user.profile.numRun==20 || user.profile.numRun==30)
				{
					if(user.profile.numRun>10)
						setTimeout(BillingManager.instance.rate, 10000);
					else
						setTimeout(appController.alert, 10000, "rate_popup_title", "rate_popup_message", "cancel_button", "rate_popup_ok", BillingManager.instance.rate) 
				}
			}
			preventSaver = false;			
			dispatchEventWith(UserEvent.LOAD_DATA_COMPLETE);
		}
		
		public function save():void
		{
			trace('final saving');
			
			user.bookmarks = 			bookmarks.data as Array;
			if(ResourceModel.instance.selectedTranslators && ResourceModel.instance.selectedTranslators.length>0)
				user.translators = 		ResourceModel.instance.selectedTranslators;
			if(ResourceModel.instance.selectedReciters && ResourceModel.instance.selectedReciters.length>0)
				user.reciters = 		ResourceModel.instance.selectedReciters;
			if(timesModel.loaded)
				user.times = 			timesModel.data;

			var so:SharedObject = SharedObject.getLocal("user-data");
			so.data.user = user;
			so.flush(100000);
		}		
		
		public function scheduleSaving():void
		{
			clearTimeout(saveTimeout);
			if(preventSaver)
				return;
			saveTimeout = setTimeout(save, 3000);
			
		}		
		
		public function deactiveBackup():void
		{
			clearTimeout(backupTimeout);
		}		
		
		public function activeBackup():void
		{
			clearTimeout(backupTimeout);
			backupTimeout = setTimeout(userUpdater.backup, 10000, user);
		}
		
		
		private function setMarketData():void
		{
			switch(appModel.descriptor.market)
			{
				case "google":
					user.local = StrTools.getLocal();
					break;
				
				case "cafebazaar":
				case "myket":
				case "cando":
				case "sibche":
					user.local = {value:"fa_IR", dir:"rtl"};
					break;
			}
		}
	}
}