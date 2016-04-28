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
	import com.gerantech.islamic.models.vo.Time;
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
		
		//public var USER_DATA_PATH:String;
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
		public function set idleMode(value:Object):void{appController.setIdleMode(user.idleMode=value); activeSaver()};
		
		public function get remniderTime():Object{return user.remniderTime}
		public function set remniderTime(value:Object):void{user.remniderTime=value, activeSaver()}
		
		public function get fontSize():uint{return user.fontSize};
		public function set fontSize(value:uint):void{if(value==user.fontSize)return; user.fontSize=value, activeSaver(), dispatchEventWith(UserEvent.FONT_SIZE_CHANGING)};
		
		public function get font():Object{return user.font;}
		public function set font(value:Object):void{if(value==user.font)return; user.font=value, activeSaver()}

		public function get storagePath():String{return user.storagePath};
		public function set storagePath(value:String):void{user.storagePath=value, activeSaver()}
		
		public function set premiumMode(value:Boolean):void{user.premiumMode = value, activeSaver()}
		public function get premiumMode():Boolean{return user.premiumMode;}
		
		public function set inbox(value:Array):void{user.inbox = value, activeSaver()}
		public function get inbox():Array{return user.inbox;}

		public function get city():Location{return new Location(user.city.name, user.city.latitude, user.city.longitude)};
		public function set city(value:Location):void { user.city = value; activeSaver();}

		public function get searchPatt():String{return user.searchPatt};
		public function set searchPatt(value:String):void{if(user.searchPatt==value)return; user.searchPatt=value; activeSaver()};
		
		public function get searchSource():uint{return user.searchSource};
		public function set searchSource(value:uint):void{if(user.searchSource==value)return; user.searchSource=value; activeSaver()};
		
		public function get searchScope():uint{return user.searchScope};
		public function set searchScope(value:uint):void{if(user.searchScope==value)return; user.searchScope=value; activeSaver()};
		
		public function get searchSura():uint{return user.searchSura};
		public function set searchSura(value:uint):void{if(user.searchSura==value)return; user.searchSura=value; activeSaver()};
		
		public function get searchJuze():uint{return user.searchJuze};
		public function set searchJuze(value:uint):void{if(user.searchJuze==value)return; user.searchJuze=value; activeSaver()};
		
		public function get locale():Object{return user.local};
		public function set locale(value:Object):void{user.local = value;activeSaver();appController.setLanguage(value);}
		
		public function get ayaRepeat():uint{return user.ayaRepeat}
		public function set ayaRepeat(value:uint):void{user.ayaRepeat=value, activeSaver()}
		
		public function get pageRepeat():uint{return user.pageRepeat}
		public function set pageRepeat(value:uint):void{user.pageRepeat=value, activeSaver()}
		
		public function get personRepeat():uint{return user.personRepeat}
		public function set personRepeat(value:uint):void{user.personRepeat=value, activeSaver()}
		
		/*public function set breakRepeat(value:uint):void{user.breakRepeat=value, activeSaver()}
		public function get breakRepeat():uint{return user.breakRepeat}
		public function set fontFamily(value:String):void{appController.setFontFamily(user.fontFamily=value), activeSaver()}
		public function get fontFamily():String{return user.fontFamily};
		*/		

		public function get lastItem():Aya{return _lastItem};
		public function setLastItem(sura:uint, aya:uint):void
		{
			user.sura = sura;
			user.aya = aya;
			_lastItem = new Aya(sura, aya, 0, Page.getBySuraAya(sura, aya).page, Juze.getBySuraAya(sura, aya).juze);
			activeSaver();
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
			activeSaver();
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
			activeSaver();
		}
		
		
		public function getSelectedByLastItem():uint
		{
			var ret:uint = 0;
			switch(navigationMode.value)
			{
				case "page_navi":
					if(!appModel.upside && appModel.sizes.isTablet&& !configModel.hasTranslator)
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
		
		public function load(appModel:AppModel, appController:AppController, configModel:ConfigModel):void
		{
			//USER_DATA_PATH = File.documentsDirectory.nativePath + "/bayan/texts/user_data.dbqr";
			this.appModel = appModel;
			this.appController = appController;
			this.configModel = configModel;
			//var streamer:GTStreamer = new GTStreamer(USER_DATA_PATH, userdata_loadComplete, userData_errorHandler);
			
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

			//ResourceModel.instance.load();
			appController.setPaths(this, storagePath);
			configModel.setAssets(appModel, this);
			timesModel.data = user.times;
			//setLastItem(user.sura, user.aya);			
			locale	= user.local;
			bookmarks = new BookmarkCollection(user.bookmarks);
			//nightMode = user.nightMode;
			appController.setIdleMode(user.idleMode);
			//navigationMode = user.navigationMode;
			
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
			user.translators = 			configModel.selectedTranslators;
			user.reciters = 			configModel.selectedReciters;
			user.times = 				timesModel.data;

			var so:SharedObject = SharedObject.getLocal("user-data");
			so.data.user = user;
			so.flush(100000);
		}		
		
		public function activeSaver():void
		{
			if(preventSaver)
				return;
			clearTimeout(saveTimeout);
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
			var freeTranslators:Array;
			var freeReciters:Array;
			
			switch(appModel.descriptor.market)
			{
				case "google":
					var translators:Array;
					translators = freeTranslators = ["en.transliteration"];//, "en.sahih"];
					user.reciters = freeReciters = ["mishary_rashid_alafasy"];//,"ibrahim_walk"];
					user.local = StrTools.getLocal();
					break;
				
				case "cafebazaar":
				case "myket":
				case "cando":
				case "sibche":
					user.translators = freeTranslators = ["fa.fooladvand"];//, "en.sahih"];
					user.reciters = freeReciters = ["shahriar_parhizgar","mahdi_fooladvand"];//,"ibrahim_walk"];
					user.local = {value:"fa_IR", dir:"rtl"};
					break;
			}
			configModel.freeTranslators = freeTranslators;
			configModel.freeReciters = freeReciters;
			//if(user.profile.numRun==1)
				
		}
	}
}