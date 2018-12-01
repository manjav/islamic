package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.buttons.SeekToucher;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.popups.PlayerPopUp;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import gt.utils.GTStringUtils;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.DropShadowFilter;
	
	public class PlayerView extends LayoutGroup
	{
		private var appModel:AppModel;
		private var toucher:SeekToucher;
		private var settingIcon:ImageLoader;
		private var reciterLabel:RTLLabel;
		private var dataProgress:Quad;
		private var playProgress:Quad;
		private var isShow:Boolean = true;
		private var isShowElements:Boolean = true;
		private var player:Player;
		private var configModel:ConfigModel;
		private var oldPlayingState:Boolean;

		private var isTouchDown:Boolean;
		private var downPoint:Point;
		private var reciterImage:ImageLoader;
		private var playerButton:FlatButton;
		private var timeLabel:RTLLabel;
		private var _height:Number;
		private var background:LayoutGroup;
		private var backgroundLayoutData:AnchorLayoutData;
		private var buttonSize:Number = 1;
		private var reciterLayoutdata:AnchorLayoutData;
		private var reciterLabelLayoutData:AnchorLayoutData;
		private var appearTimeout:uint;
		private var shadow:DropShadowFilter;
		
		public function PlayerView()
		{
			super();
		}
		
		override protected function stage_resizeHandler(event:Event):void
		{
			playerButton.x = appModel.sizes.width - _height/(isShow?1:2) 
			super.stage_resizeHandler(event);
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			autoSizeMode = AUTO_SIZE_MODE_STAGE;
			appModel = AppModel.instance;
			configModel = ConfigModel.instance;
			_height = height = appModel.sizes.toolbar;
			
			player = Player.instance;
			player.addEventListener(Player.RECITER_CHANGED,		player_reciterChanged);
			player.addEventListener(Player.PROGRESS_CHANGED,	player_progressChanged);
			player.addEventListener(Player.POSITION_CHANGED,	player_positionChanged);
			player.addEventListener(Player.APPEARANCE_CHANGED,	player_appearanceChanged);
			player.addEventListener(Player.STATE_CHANGED,		player_stateChangedHandler);
			
			backgroundLayoutData = new AnchorLayoutData(0,0,0,0);
			
			background = new LayoutGroup();
			background.backgroundSkin = new Quad(1, 1, UserModel.instance.nightMode ? BaseMaterialTheme.DESCRIPTION_TEXT_COLOR : BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			//background.filter = new FilterChain(new DropShadowFilter(0, 0, 0, 1, appModel.sizes.border/2));
			background.layoutData = backgroundLayoutData;
			addChild(background);
			
			layout = new AnchorLayout();
			
			dataProgress = new Quad(1, appModel.sizes.border/1.4, BaseMaterialTheme.PRIMARY_TEXT_COLOR);
			dataProgress.width = player.progressPercent*actualWidth;
			addChild(dataProgress);
			
			playProgress = new Quad(1, appModel.sizes.border/1.4, 0xFFFF);
			playProgress.width = player.positionPercent*actualWidth;
			addChild(playProgress);
						
			settingIcon = new ImageLoader()
			settingIcon.height = settingIcon.width = _height/2;
			settingIcon.source = Assets.getTexture("repeat_black");
			settingIcon.layoutData = new AnchorLayoutData(NaN, NaN, NaN, _height/4, NaN, 0);
			addChild(settingIcon);
			
			reciterLayoutdata = new AnchorLayoutData(appModel.sizes.border, NaN, appModel.sizes.border, _height, NaN, 0);
			
			reciterImage = new ImageLoader();
			reciterImage.width = reciterImage.height = _height*0.8;
			reciterImage.source = ResourceModel.instance.hasReciter?ResourceModel.instance.selectedReciters[0].iconTexture : null;
			reciterImage.layoutData = reciterLayoutdata;
			addChild(reciterImage);
			
			reciterLabel = new RTLLabel(ResourceModel.instance.hasReciter?ResourceModel.instance.selectedReciters[0].name:"", 0, "left", "rtl", false, null, 0.9)
			reciterLabelLayoutData = new AnchorLayoutData(NaN, NaN, NaN, _height*2, NaN, 0);
			reciterLabel.layoutData = reciterLabelLayoutData;
			addChild(reciterLabel);
						
			toucher = new SeekToucher();
			toucher.addEventListener(SeekToucher.MOVED, toucher_movedHandler);
			toucher.addEventListener(SeekToucher.STATE_CHANGED, toucher_stateChangedHandler);
			toucher.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			addChild(toucher);
						
			timeLabel = new RTLLabel("", 0);
			timeLabel.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0) ;
			timeLabel.visible = false;
			addChild(timeLabel);
			
			playerButton = new FlatButton("action_play", "action", false, 1, 0.8);
			playerButton.iconScale = 0.4;
			playerButton.x = appModel.sizes.width-_height;
			playerButton.width = playerButton.height = appModel.sizes.toolbar;
			playerButton.pivotY = playerButton.pivotX = playerButton.width/2;
			playerButton.addEventListener("triggered", playerButton_triggeredHandler);
			playerButton.includeInLayout = false;
			shadow = new DropShadowFilter(appModel.sizes.DP4/2, 90*(Math.PI/180), 0, 0.4, appModel.sizes.DP4/4);
			playerButton.filter = shadow;
			addChild(playerButton);
			
			setState(player.state);
		}
		
		private function player_appearanceChanged(event:Event):void
		{
			var change:Number = event.data as Number;
			if(change>2)
				show();
			else if(change<-2)
				hide();
				
		}
		
		private function player_progressChanged(event:Event):void
		{
			dataProgress.width = player.progressPercent*actualWidth;
		}
		
		private function player_positionChanged(event:Event):void
		{
			//if(!isTouchDown)
				playProgress.width = player.positionPercent*actualWidth;
		}
		
		private function toucher_movedHandler(event:Event):void
		{
			playProgress.width = toucher.touchPoint.x;
			if(player.ayaSound!=null && player.ayaSound.sound!=null)
			{
				var pos:Number = toucher.touchPoint.x/appModel.sizes.width*player.ayaSound.sound.length
				player.lastPosition = pos;
				timeLabel.text = GTStringUtils.uintToTime(pos/1000);
			}
		}
		
		private function toucher_stateChangedHandler():void
		{
			isTouchDown = toucher.currentState==SeekToucher.STATE_DOWN;
			playProgress.width = toucher.touchPoint.x;
			if(isTouchDown)
			{
				oldPlayingState = player.playing;
				downPoint = toucher.touchPoint.clone();
				player.pause();
				hideElements();
			}
			else
			{
				//trace(downPoint, toucher.touchPoint)
				if(isShow && toucher.touchPoint.x<_height && Point.distance(downPoint, toucher.touchPoint)<10)
				{
					showSetting();
					showElements();
					return;
				}
				else if(isShow && toucher.touchPoint.x<_height*2 && toucher.touchPoint.x>_height && Point.distance(downPoint, toucher.touchPoint)<10)
				{
					showPersonPage();
					return;
				}
				if(oldPlayingState)
					player.play();
				
				showElements();
			}
		}
		
		private function playerButton_triggeredHandler():void
		{
			player.playing ? player.pause() : player.play();
			setTimeout(show, 500);
		}
		
		private function player_stateChangedHandler(event:Event):void
		{
			setState(event.data as String);
		}
		
		private function setState(data:String):void
		{
			var texture:String;
			switch(data)
			{
				case Player.STATE_WAITING:
					texture = "action_timer";
					break;
				case Player.STATE_ERROR:
					texture = "action_danger";
					break;
				case Player.STATE_PAUSE:
					texture = "action_play";
					break;
				case Player.STATE_PLAY:
					texture = "action_pause";
					break;
			}
			if(texture)
				playerButton.texture = texture;
			playerButton.rotation = 0;
			playerButton.scaleX = playerButton.scaleY = buttonSize * 0.7;
			Starling.juggler.tween(playerButton, 0.5, {scaleX:buttonSize*1, scaleY:buttonSize*1, transition:Transitions.EASE_OUT_BACK});			
		}
		
		private function player_reciterChanged(event:Event):void
		{
			var reciter:Person = event.data as Person;
			if(reciter.iconTexture==null)
			{
				reciter.loadImage();
				reciter.addEventListener(Person.ICON_LOADED, reciter_iconLoadHandler);
				return;
			}
			reciterImage.source = reciter.iconTexture;
			reciterImage.alpha = 0;
			Starling.juggler.tween(reciterImage, 0.2, {alpha:1});
			
			reciterLabel.text = reciter.name;
			reciterLabel.alpha = 0;
			Starling.juggler.tween(reciterLabel, 0.3, {delay:0.2, alpha:1});
		}
		private function reciter_iconLoadHandler(event:Event):void
		{
			event.target.removeEventListener(Person.ICON_LOADED, reciter_iconLoadHandler);
			player.dispatchEventWith(Player.RECITER_CHANGED, false, event.target);
		}		

		private function showPersonPage():void
		{
			var screenItem:StackScreenNavigatorItem = AppModel.instance.navigator.getScreen(appModel.PAGE_PERSON);
			screenItem.properties = {type:Person.TYPE_RECITER};
			AppModel.instance.navigator.pushScreen(appModel.PAGE_PERSON);
		}
		
		/**
		 * Setting button ------------------------------------------------
		 */
		private function showSetting():void
		{
			if(!UserModel.instance.premiumMode)
			{
				var purchaseMessage:String = ResourceManager.getInstance().getString("loc", "purchase_repeat")+"\n"+ResourceManager.getInstance().getString("loc", "purchase_popup_message");
				AppController.instance.alert("purchase_popup_title", purchaseMessage, "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
				return;
			}
			
			AppController.instance.addPopup(PlayerPopUp);
		}
		
		// Appearance --------------------------------------------
		
		public function show(duration:Number=0.5):void
		{
			if(isShow)
				return;
			isShow = true;
			buttonSize = 1//appModel.sizes.itemHeight*1.3;
			
			animate(duration)

			clearTimeout(appearTimeout);
			appearTimeout = setTimeout(changeAppear, duration*1000, isShow);
		}
		
		public function hide(duration:Number=0.5):void
		{
			if(!isShow)
				return;
			isShow = false;
			changeAppear(isShow);
			
			clearTimeout(appearTimeout);
			animate(duration)
		}
		
		private function animate(duration:Number):void
		{
			var s:Number = 0.5;
			var _h:Number = isShow?0:_height*s;
			var border:Number = _height / (isShow?8:18);
			buttonSize = 1-(isShow?0:s*0.8)//appModel.sizes.itemHeight*1.3*0.65;
			
			var tween:Tween = new Tween(playerButton, duration, Transitions.EASE_IN_OUT);
			tween.moveTo(actualWidth-_height+_h, _h);
			tween.scaleTo(buttonSize);
			Starling.juggler.add(tween);
			
			var tween2:Tween = new Tween(backgroundLayoutData, duration, Transitions.EASE_IN_OUT);
			tween2.animate("top", _h);
			Starling.juggler.add(tween2);
			
			var tween3:Tween = new Tween(dataProgress, duration, Transitions.EASE_IN_OUT);
			tween3.animate("y", _h);
			Starling.juggler.add(tween3);
			
			var tween4:Tween = new Tween(playProgress, duration, Transitions.EASE_IN_OUT);
			tween4.animate("y", _h);
			Starling.juggler.add(tween4);
			
			var tween5:Tween = new Tween(reciterLayoutdata, duration, Transitions.EASE_IN_OUT);
			tween5.animate("top", (isShow?0:_h) + border);
			tween5.animate("bottom", border);
			tween5.animate("left", isShow?_height:border);
			Starling.juggler.add(tween5);
			
			var tween6:Tween = new Tween(reciterImage, duration, Transitions.EASE_IN_OUT);
			tween6.animate("width", (isShow?_height:_h)-border*2);
			Starling.juggler.add(tween6);
			
			var tween7:Tween = new Tween(reciterLabelLayoutData, duration, Transitions.EASE_IN_OUT);
			tween7.animate("left", isShow?_height*2:_h);
			tween7.animate("verticalCenter", isShow?0:_h/2);
			Starling.juggler.add(tween7);
			
/*			var tween8:Tween = new Tween(background, duration, Transitions.EASE_IN_OUT);
			tween8.fadeTo(isShow?1:0.8);
			Starling.juggler.add(tween8);*/
			
		}
		
		private function changeAppear(isShow:Boolean):void
		{
			//reciterLabel.visible = reciterImage.visible = 
			settingIcon.visible = isShow;
			//playerButton.filter = isShow ? shadow : null;
			timeLabel.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, isShow?0:_height/4);
		}
		
		private function hideElements(duration:Number=0.2):void
		{
			if(isShowElements)
				return;
			timeLabel.visible = isShowElements = true;
			playerButton.visible = reciterLabel.visible = reciterImage.visible = settingIcon.visible = !isShowElements;
			/*TweenLite.to(settingIcon, duration, {alpha:0});
			TweenLite.to(reciterImage, duration, {alpha:0, delay: 0.1});
			TweenLite.to(reciterLabel, duration, {alpha:0, delay: 0.2});
			TweenLite.to(playerButton, duration, {alpha:0, delay: 0.3});*/
		}
		private function showElements(duration:Number=0.2):void
		{
			if(!isShowElements)
				return;
			timeLabel.visible = isShowElements = false;
			playerButton.visible = reciterLabel.visible = reciterImage.visible = !isShowElements;
			settingIcon.visible =!isShowElements && isShow;
			/*TweenLite.to(playerButton, duration, {alpha:1});
			TweenLite.to(reciterLabel, duration, {alpha:1, delay: 0.1});
			TweenLite.to(reciterImage, duration, {alpha:1, delay: 0.2});
			TweenLite.to(settingIcon, duration, {alpha:1, delay: 0.3});*/
		}

	}
}