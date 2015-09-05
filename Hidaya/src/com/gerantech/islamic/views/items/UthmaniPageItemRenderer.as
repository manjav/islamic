package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.models.vo.media.Breakpoint;
	import com.gerantech.islamic.views.lists.TranslationList;
	
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import feathers.controls.ImageLoader;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	
	public class UthmaniPageItemRenderer extends BaseQPageItemRenderer
	{
		private var uthmaniPage:UthmaniPage;
		private var startScrollBarIndicator:Number = 0;
		private var scrollLayout:VerticalLayout;
		private var shadowImage:ImageLoader;
		private var traslatePage:TranslationList;
		private var purchasePage:PurchasePage;
		
		override protected function initialize():void
		{
			super.initialize();

			layout = new AnchorLayout();
			
			traslatePage = new TranslationList(header._height);
			
			Player.instance.addEventListener(Player.SOUND_PLAY_COMPLETED, player_soundCompleteHandler);
			addChild(headerContainer);
			
			shadowImage = new ImageLoader();
			shadowImage.maintainAspectRatio = false;
			addChild(shadowImage);
			
			purchasePage = new PurchasePage();
			purchasePage.layoutData = new AnchorLayoutData(0,0,0,0);
		}
		
		/*private function scroller_scrollHandler(event:Event):void
		{
			if(ConfigModel.instance.selectedReciters.length>0) 
				event.type==FeathersEventType.SCROLL_START ? SoundPlayer.instance.hide() : SoundPlayer.instance.show();
		}*/
		
		override protected function _owner_resizeHandler(event:Event):void
		{
			super._owner_resizeHandler(event);
			if(_owner==null)
				return;
			setSizes();
			commitData();
		}
		
		override protected function commitData():void
		{
			if(_qdata==null)
			{
				_owner.addEventListener(FeathersEventType.RESIZE, _owner_resizeHandler);
				_owner.addEventListener(FeathersEventType.RENDERER_REMOVE, selfRemovedHandler);
			}
			
			if(_data==null || _owner==null)
				return;			
			
			super.commitData();
			
			if(uthmaniPage)
				uthmaniPage.removeFromParent(true);
			
			if(traslatePage)
				removeChild(traslatePage);
			
			setSizes();
			
			if(!userModel.premiumMode && _qdata.sura>2)
			{
				addChildAt(purchasePage, 0);
				return;
			}
			else
			{
				if(purchasePage)
					removeChild(purchasePage);
			}
			
			setShadows();
			
			clearInterval(intervalId);
			intervalId = setInterval(checkScrolling, 100);
			header.update(_qdata);
		}
		
		private function setSizes():void
		{
			
			height = _owner.height;
			if(!appModel.upside && appModel.isTablet && !ConfigModel.instance.hasTranslator)
				width = appModel.width/2;
			else
				width = appModel.width;
			shadowImage.width = width*0.02;
			//trace("isTablet", appModel.isTablet, appModel.upside, ConfigModel.instance.selectedTranslators.length, width, height)
		}
		
		override protected function commitAfterStopScrolling():void
		{
			super.commitAfterStopScrolling();
			if(!userModel.premiumMode && _qdata.sura>2)
				return;
			
			if(!appModel.upside && appModel.isTablet)
			{
				
				if(!ConfigModel.instance.hasTranslator)
				{
					uthmaniPage = new UthmaniPage(_qdata as Page, width, header._height, 1.3);
					uthmaniPage.layoutData = new AnchorLayoutData(0,0,0,0);
					uthmaniPage.addEventListener(Event.SCROLL, uthmaniPage_scrollChangedHandler);
				}
				else
				{
					var _h:Number = height-header._height;
					var even:Boolean = _qdata.index%2==0;
					uthmaniPage = new UthmaniPage(_qdata as Page, _h/1.3, header._height, 1.3);
					uthmaniPage.layoutData = new AnchorLayoutData(0,even?NaN:appModel.border*4,0, even?appModel.border*4:NaN);
					
					traslatePage.page = _qdata as Page;
					traslatePage.width = width-_h/1.3;
					traslatePage.layoutData = new AnchorLayoutData(0,even?0:NaN,0, even?NaN:0);
					addChildAt(traslatePage, 0);
				}
			}
			else
			{
				uthmaniPage = new UthmaniPage(_qdata as Page, width, header._height);
				uthmaniPage.layoutData = new AnchorLayoutData(0,0,0,0);
				uthmaniPage.addEventListener(Event.SCROLL, uthmaniPage_scrollChangedHandler);
			}
			
			addChildAt(uthmaniPage, 0);
			uthmaniPage.selectByLastItem(userModel.lastItem);
			uthmaniPage.addEventListener(Event.CHANGE, uthmaniPage_changeHandler);
		}
		
		private function uthmaniPage_scrollChangedHandler():void
		{
			var scrollPos:Number = Math.max(0,uthmaniPage.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			if(changes<0)
				changes /=2;
			
			headerContainer.y = Math.max(-header._height, Math.min(0, headerContainer.y+changes));
			startScrollBarIndicator = scrollPos;
			if(!appModel.upside)
				Player.instance.dispatchEventWith(Player.APPEARANCE_CHANGED, false, changes);

			//trace(changes)
			/*if(ConfigModel.instance.hasReciter)
			{
				if(changes>1)
					SoundPlayer.instance.show();
				else if(changes<-1)
					SoundPlayer.instance.hide();
			}*/
		}
		
		private function uthmaniPage_changeHandler(event:Event):void
		{//trace(event)
			if(uthmaniPage==null)
				return;
			
			var breakPoint:Breakpoint = event.data as Breakpoint;
			userModel.setLastItem(breakPoint.sura, breakPoint.aya.aya);
			assignAyaToPlayer(breakPoint.aya);
		}
		
		private function assignAyaToPlayer(aya:Aya):void
		{
			if(ConfigModel.instance.selectedReciters.length==0 || aya==null)
				return;
			Player.instance.resetRepeatation();
			Player.instance.load(aya, Player.instance.playing);
		}
		
		private function player_soundCompleteHandler(event:Event):void
		{
			var aya:Aya = event.data as Aya;
			
			if(!containItem(aya) || uthmaniPage==null)
				return;
			
			uthmaniPage.removeEventListener(Event.CHANGE, uthmaniPage_changeHandler);
			uthmaniPage.selectedIndex = findIndex(aya);
			uthmaniPage.addEventListener(Event.CHANGE, uthmaniPage_changeHandler);
			uthmaniPage.scrollToSelectedItem();
			
			/*			
			if(containAya(aya))
			{
			//trace(aya, uthmaniPage.selectedItem)
				if(aya.order<_qdata.ayas.length)
				{
					uthmaniPage.removeEventListener(Event.CHANGE, uthmaniPage_changeHandler);
					uthmaniPage.selectedIndex = aya.order;//targetIndex = 
					uthmaniPage.addEventListener(Event.CHANGE, uthmaniPage_changeHandler);
					uthmaniPage.scrollToSelectedItem();
				}
			}*/
		}
		
		private function setShadows():void
		{
			var even:Boolean = _qdata.index%2==0;
			
			shadowImage.source = Assets.getTexture("shadow_"+(even?"right":"left"));
			shadowImage.layoutData = new AnchorLayoutData(0,even?NaN:0,0, even?0:NaN);
			//edgeLight.source = Assets.getTexture("shadow_"+(even?"left":"right"));
			//edgeLight.layoutData = new AnchorLayoutData(0,even?0:NaN,0, even?NaN:0);
		}		
		override protected function get isShow():Boolean
		{
			var rect:Rectangle = getBounds(_owner);//trace(index, rect)
			return(rect.x==0 || rect.x==appModel.width/2)
		}
		
	}
}