package com.gerantech.islamic.views.popups
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.headers.TranslationHeader;
	import com.gerantech.islamic.views.items.TranslationPageItemRenderer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class TranslationPopUp extends BasePopUp
	{
		public var aya:Aya;
		
		private var startRect:Rectangle;
		private var background:Quad;
		private var list:List;
		private var translatorIndex:uint;

		private var translations:Array;

		private var headerTimeoutID:uint;
		private var header:TranslationHeader;
		private var startTouchPoint:Point;
		private var endTouchPoint:Point;
		private var listLayout:HorizontalLayout;

		private var listData:Array;
		
		
		public function hide():void
		{
		}		
		override protected function draw():void
		{			
			super.draw();
			if(background==null)
			{
				background = new Quad(actualWidth,startRect.height, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
				background.y = startRect.y;
				addChildAt(background, 0);
				
				Starling.juggler.tween(background, 0.3, {y:0, height:actualHeight, onComplete:onEndShowTween, transition:Transitions.EASE_IN});
				//TweenLite.to(background, 0.3, {y:0, height:actualHeight, ease:Sine.easeIn, onComplete:onEndShowTween});
			}
			
			if(header)
			{
				header.alpha = 0;
				Starling.juggler.tween(header, 0.3, {alpha:1, delay:0.3});
				//TweenLite.to(header, 0.3, {alpha:1, delay:0.3});
			}
		}
		private function onEndShowTween():void
		{
			dispatchEventWith("endShowing");
		}
		
		public function TranslationPopUp(rect:Rectangle, aya:Aya)
		{
			startRect = rect;
			setAya(aya);
		}
		
		private function setAya(aya:Aya):void
		{
			if(this.aya!=null)
			{
				if(this.aya.aya==aya.aya && this.aya.sura==aya.sura)
					return;
			}
			this.aya = aya;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = appModel.sizes.width;
			height = appModel.sizes.height;
			layout = new AnchorLayout();
		
			listLayout = new HorizontalLayout();
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TranslationPageItemRenderer ();
			}
			list.snapToPages = true;
			//list.autoHideBackground = true;
			list.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			list.addEventListener("translateChanged", list_translateChangedHandler);
			addChild(list);
			
			//create header 
			header = new TranslationHeader();
			header.layoutData = new AnchorLayoutData(0,0,NaN,0);
			header.addEventListener(Event.CLOSE, close);
			header.alpha = 0;
			addChild(header);
		}
		
		private function list_translateChangedHandler(event:Event):void
		{
			aya = event.data as Aya;
			header.aya = aya;
			
			if(Player.instance.playing || userModel.lastItem.equals(aya))
				return;
			
			userModel.setLastItem(aya.sura, aya.aya);
			userModel.dispatchEventWith(UserEvent.SET_ITEM);
		}

		
		private function translateRenderer_triggeredHandler(event:Event):void
		{
			if(aya.sura>2)
				appModel.navigator.pushScreen(appModel.PAGE_PURCHASE);
		}
		
		public function show():void
		{
			header.aya = aya;
			//trace("show", aya)
			
			Flurry.getInstance().logEvent("TranslatePopUp", {sura:aya.sura, aya:aya.aya});
			
			var baseList:Array;
			listData = new Array;
			switch(userModel.navigationMode.value)
			{
				case "page_navi":
					baseList = ResourceModel.instance.pageList[aya.page-1].ayas
					break;
				case "sura_navi":
					baseList = ResourceModel.instance.suraList[aya.sura-1].ayas
					break;
				case "juze_navi":
					baseList = ResourceModel.instance.juzeList[aya.juze-1].ayas
					break;
			}
			var len:uint = baseList.length-1;
			for (var i:int=len; i>=0; i--)
				listData.push(baseList[i]);
			list.dataProvider = new ListCollection(listData);
			
			var selectedAyaIndex:int = len-aya.order;
			list.scrollToDisplayIndex(selectedAyaIndex, 0.1);
		}
		
		override public function close():void
		{
			dispatchEventWith("startClosing");
			removeChildren(1);
			Starling.juggler.tween(background, 0.3, {y:startRect.y, height:startRect.height, onComplete:backgroundCollapsed, transition:Transitions.EASE_OUT_IN});
			//TweenLite.to(background, 0.3, {y:startRect.y, height:startRect.height, onComplete:backgroundCollapsed, ease:Sine.easeOut});
		}
		private function backgroundCollapsed():void
		{
			Starling.juggler.tween(background, 0.2, {alpha:0, onComplete:super.close});
			//TweenLite.to(background, 0.2, {alpha:0, onComplete:super.close});
		}			
		
		// Fade in-out header
		private function list_scrollHandler(event:Event):void
		{
			if(event.type == FeathersEventType.SCROLL_START)
			{
				header.alpha = 0;
				Starling.juggler.removeTweens(header);
				//TweenLite.killTweensOf(header);
			}
			else
			{
				Starling.juggler.tween(header, 1, {alpha:1});
				//TweenLite.to(header, 1, {alpha:1});
			}
		}
		
		
		/*
		
		
		private function list_touchHandler(event:TouchEvent):void
		{
			var touche:Touch = event.getTouch(list);
			if(touche==null)
				return;
			
			if(touche.phase == TouchPhase.BEGAN)
			{
				startTouchPoint = touche.getLocation(list);
			}
			else if(touche.phase == TouchPhase.ENDED)
			{
				endTouchPoint = touche.getLocation(list);
				if(Math.abs(startTouchPoint.x-endTouchPoint.x)> Math.abs(startTouchPoint.y-endTouchPoint.y) && Math.abs(startTouchPoint.x-endTouchPoint.x)>appModel.sizes.itemHeight)
					swipe(startTouchPoint.x-endTouchPoint.x)
			}
		}
		
		private function swipe(param:Number):void
		{
			var target:Aya = param>0 ? Aya.getPrevious(aya) : Aya.getNext(aya);
			if(target==null)
				return;
			//if(ConfigModel.instance.hasReciter)
			//	SoundPlayer.instance.load(target, SoundPlayer.instance.playing);
			//trace("swipe", target)
			userModel.setLastItem(target.sura, target.aya);
			userModel.dispatchEventWith(UserEvent.SET_ITEM);

		}*/
		
		public function changeAya(aya:Aya):void
		{
			if(list==null || aya.equals(this.aya))
				return;trace("changeAya", aya)
			
			if(!containItem(aya) || listData==null)
			{
				setAya(aya)
				show();
			}
			else
				list.scrollToDisplayIndex(listData.length-aya.order-1, 0.2);
		}
		
		
		protected function containItem(item:BaseQData):Boolean
		{
			switch(UserModel.instance.navigationMode.value)
			{
				case "page_navi": return aya.page == item.page;
				case "sura_navi": return aya.sura == item.sura;
				case "juze_navi": return aya.juze == item.juze;
			}
			return false;
		}

	}
}