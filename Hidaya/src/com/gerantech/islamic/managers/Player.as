package com.gerantech.islamic.managers
{
	import com.gerantech.extensions.AndroidExtension;
	import com.gerantech.extensions.events.AndroidEvent;
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Reciter;
	import com.gerantech.islamic.models.vo.SoundAya;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundChannel;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import starling.events.EventDispatcher;

	
	public class Player extends EventDispatcher
	{
		public static const SOUND_PLAY_COMPLETED:String = "soundPlayCompleted";
		public static const STATE_CHANGED:String = "playerStateChanged";
		public static const POSITION_CHANGED:String = "playerPositionChanged";
		public static const PROGRESS_CHANGED:String = "playerProgressChanged";
		public static const RECITER_CHANGED:String = "playerReciterChanged";
		public static const APPEARANCE_CHANGED:String = "playerAppearanceChanged";
		
		public static const STATE_WAITING:String = "stateWaiting";
		public static const STATE_ERROR:String = "stateError";
		public static const STATE_PLAY:String = "statePlay";
		public static const STATE_PAUSE:String = "statePause";
		public static const STATE_DISABLED:String = "stateDisabled";

		public var currentReciter:Reciter;
		public var ayaSound:SoundAya;
		public var reciterIndex:uint = 1;
		public var isShow:Boolean = true;
		
		private static var _this:Player;
		private var channel:SoundChannel = new SoundChannel();
		private var app:AppModel;
		private var conf:ConfigModel;
		private var userModel:UserModel;
		private var intervalID:uint;
		private var _state:String;
		private var _playEnabled:Boolean = true;
		private var autoPlay:Boolean;
		private var pauseForCall:Boolean;
		
		//private var reciterRepeat:uint = 1;
		private var ayaRepeat:uint = 1;
		private var pageRepeat:uint = 1;
		public var lastPosition:Number;
		public var positionPercent:Number = 0;
		public var progressPercent:Number = 0;
		
		public function Player()
		{
			app = AppModel.instance;
			conf = ConfigModel.instance;
			userModel = UserModel.instance;
	
			AndroidExtension.instance.init();
			AndroidExtension.instance.addEventListener(AndroidEvent.CALL_STATE_CHANGED, phone_callStateChanged);
		}

		public function get playing():Boolean
		{
			return state==STATE_PLAY;
		}

		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			_state = value;
			
			if(userModel.idleMode.value == "while_playing")
				NativeApplication.nativeApplication.systemIdleMode = _state==STATE_PLAY ? SystemIdleMode.KEEP_AWAKE : SystemIdleMode.NORMAL;
			
			dispatchEventWith(STATE_CHANGED, false, _state);
		}
		
		public static function get instance():Player
		{
			if(_this == null)
				_this = new Player();
			return (_this);
		}


		protected function phone_callStateChanged(event:AndroidEvent):void
		{
			if(_state==STATE_PLAY && event.state!=AndroidExtension.CALL_STATE_IDLE)
			{
				pauseForCall = true;
				pause();
			}
			if(pauseForCall && event.state==AndroidExtension.CALL_STATE_IDLE)
			{
				pauseForCall = false;
				play();
			}
		}
		

		
		public function load(aya:Aya, autoPlay:Boolean=true):void
		{
			this.autoPlay = autoPlay;
			var reciterChanged:Boolean = true;
			if(ayaSound)
			{
				reciterChanged = ayaSound.reciter!=conf.selectedReciters[reciterIndex];
				if(!reciterChanged && ayaRepeat==userModel.ayaRepeat && ayaSound.equals(aya))
					return;
			}
			stop();
			
			if(reciterChanged)
			{
				if(currentReciter)
				{
					currentReciter.addEventListener(Person.CHECKSUM_LOADED, reciter_checksumLoaded);
					currentReciter.addEventListener(Person.CHECKSUM_ERROR, reciter_checksumLoaded);
				}
				currentReciter = conf.selectedReciters[reciterIndex];
				dispatchEventWith(RECITER_CHANGED, false, currentReciter);
			}
			ayaSound = currentReciter.getSoundAya(aya);
			
/*			if(!userModel.premiumMode && aya.sura>2 && !currentReciter.free)
			{
				var purchaseMessage:String;
				var persons:Array = new Array();
				var bullet:String = AppModel.instance.ltr ? "▸" : "◂";
				
				for each(var p:String in conf.freeReciters)
					persons.push(ConfigModel.instance.getReciterByPath(p).name);
				
				purchaseMessage = ResourceManager.getInstance().getString("loc", "purchase_player_1")+"\n"+bullet+" ";
				purchaseMessage+= (persons.join("\n"+bullet+" "));
				purchaseMessage += ("\n"+ResourceManager.getInstance().getString("loc", "purchase_player_2"));
				purchaseMessage += ("\n\n"+ResourceManager.getInstance().getString("loc", "purchase_popup_message"));
				AppController.instance.alert("purchase_popup_title", purchaseMessage, "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
				return;
			}*/
			
			if(autoPlay)
				loadSoundFile();
		}
		
		private function loadSoundFile():void
		{
			state = STATE_WAITING;
			if(currentReciter.checksums==null)
			{
				currentReciter.addEventListener(Person.CHECKSUM_LOADED, reciter_checksumLoaded);
				currentReciter.addEventListener(Person.CHECKSUM_ERROR, reciter_checksumLoaded);
				currentReciter.loadChecksum();
				return;
			}
			
			ayaSound.load();
			ayaSound.sound.addEventListener(Event.OPEN, sound_openHandler);
			ayaSound.sound.addEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
		}
		
		private function reciter_checksumLoaded(event:*):void
		{
			currentReciter.removeEventListener(Person.CHECKSUM_LOADED, reciter_checksumLoaded);
			currentReciter.removeEventListener(Person.CHECKSUM_ERROR, reciter_checksumLoaded);
			
			if(event.type==Person.CHECKSUM_LOADED)
				loadSoundFile();
		}
		
		
		protected function sound_errorHandler(event:IOErrorEvent):void
		{
			ayaSound.sound.removeEventListener(Event.OPEN, sound_openHandler);
			ayaSound.sound.removeEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
			state = STATE_ERROR;
		}
		
		protected function sound_openHandler(event:Event):void
		{
			if(ayaSound.loaded)
				sound_progressHandler(null);
			else
				ayaSound.sound.addEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
			ayaSound.sound.removeEventListener(Event.OPEN, sound_openHandler);
			ayaSound.sound.removeEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
			if(autoPlay)
				play();
			else
			{
				positionPercent = 0;
				dispatchEventWith(POSITION_CHANGED, false, positionPercent);
			//	playProgress.width = 0;
				state = STATE_PAUSE;
			}
		}
		
		public function play():void
		{
			if(ayaSound==null)
			{
				dispatchEventWith("ayaNotFound");
				return;
			}
			
			channel.stop();
			if(ayaSound.sound==null)
			{
				autoPlay = true;
				loadSoundFile();
				return;
			}
			
			//show(0);
			state = STATE_PLAY;
			channel = ayaSound.sound.play(lastPosition);
			channel.addEventListener(Event.SOUND_COMPLETE, channel_soundCompleteHandler);
			intervalID = setInterval(changePlayProgress, 50);
			dispatchEventWith("toggle", false, playing);
		}
		public function pause():void
		{
			lastPosition = channel.position;
			stopSound();
		}
		public function stop():void
		{
			lastPosition = 0;
			stopSound();
		}		
		private function stopSound():void
		{
			state = STATE_PAUSE;
			channel.stop()
			clearInterval(intervalID);
			channel.removeEventListener(Event.SOUND_COMPLETE, channel_soundCompleteHandler);
			dispatchEventWith("toggle", false, playing);
		}
		
		private function changePlayProgress():void
		{
			if(ayaSound.sound)
			{
				positionPercent = channel.position/ayaSound.sound.length;
				dispatchEventWith(POSITION_CHANGED, false, positionPercent);
			}
			//playProgress.width = app.width*(channel.position/ayaSound.sound.length);
			//timeLabel.text = GTStringUtils.uintToTime(uint(channel.position/1000))
		}
		
		protected function sound_progressHandler(event:ProgressEvent):void
		{
			progressPercent = ayaSound.sound.bytesLoaded/ayaSound.sound.bytesTotal;
			dispatchEventWith(PROGRESS_CHANGED, false, progressPercent);
			//dataProgress.width = app.width*(ayaSound.sound.bytesLoaded/ayaSound.sound.bytesTotal);
		}
		
		protected function channel_soundCompleteHandler(event:Event):void
		{
			progressPercent = 1;
			dispatchEventWith(PROGRESS_CHANGED, false, progressPercent);
			//playProgress.width = dataProgress.width = app.width;
			stop();
			
			if(reciterIndex<conf.selectedReciters.length-1)
			{
				reciterIndex ++;
				load(ayaSound);
			}
			else
			{
				reciterIndex = 0;
				if(ayaRepeat<userModel.ayaRepeat)
				{
					load(ayaSound);
					ayaRepeat ++;
				}
				else
				{
					ayaRepeat = 1;
					var order:int = getAyaOrder(ayaSound);
					if(order<currentAyas.length-1)
					{
						gotoNextAya();
					}
					else
					{
						if(pageRepeat<userModel.pageRepeat)
						{
							pageRepeat ++;
							load(currentAyas[0]);
						}
						else
						{
							pageRepeat = 1;
							gotoNextPage();
							AppController.instance.dispatchEvent(new AppEvent(AppEvent.ORIENTATION_CHANGED, 0.5));
						}
					}
				}
			}
			dispatchEventWith(Player.SOUND_PLAY_COMPLETED, false, ayaSound);
		}		
		
		
		private function gotoNextAya():void
		{
			var ret:Aya = Aya.getNext(ayaSound);
			if(ret==null)
				return;
			
			userModel.setLastItem(ret.sura, ret.aya);
			ret = new SoundAya(userModel.lastItem.sura, userModel.lastItem.aya, userModel.lastItem.order, userModel.lastItem.page, userModel.lastItem.juze, ayaSound.reciter)
			load(ret);
		}		
		
		private function gotoNextPage():void
		{
			var ret:Aya = new Aya(ayaSound.sura, ayaSound.aya, ayaSound.order, ayaSound.page, ayaSound.juze);
			switch(userModel.navigationMode.value)
			{
				case "page_navi":
					if(ayaSound.page<userModel.pagesList.length)
					{
						if(ret.suraObject.numAyas==ret.aya)
						{
							if(ret.sura<114)
							{
								ret.sura ++;
								ret.aya = 1;
							}
						}
						else
							ret.aya ++;
					}
					else
						return;
					break;
				case "sura_navi":
					if(ayaSound.sura<114)
					{
						ret.sura ++;
						ret.aya = 1;
					}
					else
						return;
					break;
				case "juze_navi": 
					if(ayaSound.juze<userModel.pagesList.length)
					{
						if(ret.suraObject.numAyas==ret.aya)
						{
							if(ret.sura<114)
							{
								ret.sura ++;
								ret.aya = 1;
							}
						}
						else
							ret.aya ++;
					}
					else
						return;
					break;
			}
			userModel.setLastItem(ret.sura, ret.aya);
			ret = new SoundAya(userModel.lastItem.sura, userModel.lastItem.aya, 0, userModel.lastItem.page, userModel.lastItem.juze, ayaSound.reciter)
			setTimeout(load, 0, ret);
		}
		
		
		private function getAyaOrder(item:Aya):int
		{
			var ret:int = -1;
			var ayas:Array = currentAyas;
			for (var i:uint=0; i<ayas.length; i++)
				if(ayas[i].sura== item.sura && ayas[i].aya==item.aya)
					return i;
					
			return ret;
		}
		
		private function get currentAyas():Array
		{
			var ret:BaseQData;
			switch(userModel.navigationMode.value)
			{
				case "page_navi": ret = userModel.pagesList[ayaSound.page-1]; break;
				case "sura_navi": ret = userModel.pagesList[ayaSound.sura-1]; break;
				case "juze_navi": ret = userModel.pagesList[ayaSound.juze-1]; break;
			}
			if(ret.ayas==null)
				ret.complete();
			return ret.ayas;
		}
		
		public function resetRepeatation():void
		{
			ayaRepeat = 1;
			pageRepeat = 1
			reciterIndex = 0;
		}

	}
}