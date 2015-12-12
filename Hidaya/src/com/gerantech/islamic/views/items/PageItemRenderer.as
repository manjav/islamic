package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Aya;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class PageItemRenderer extends BaseQPageItemRenderer
	{

		protected var list:List;
		private var activeAyas:Vector.<Aya>;

		private var currentIndex:uint;
		private var targetIndex:uint;
		private var timeoutID:uint;		
		private var startScrollBarIndicator:Number = 0;
		private var preventSelection:Boolean;
		private var itemHeight:Number = 300;
		private var findingMode:Boolean;
		private var findRatio:Number = 1;
		private var findTime:int;
		private var headerBaseLine:int;
		private var scrollOffset:Number = 0;
		
		override protected function initialize():void
		{
			super.initialize();
			
			var listLayout: VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			listLayout.paddingTop = appModel.sizes.border + appModel.sizes.subtitle + appModel.sizes.toolbar;
			listLayout.paddingBottom = ConfigModel.instance.hasReciter?appModel.sizes.toolbar+appModel.sizes.border:appModel.sizes.border
			listLayout.hasVariableItemDimensions = true;
			//listLayout.gap = appModel.sizes.border;
			
			list = new List();
			list.verticalScrollBarPosition = List.VERTICAL_SCROLL_BAR_POSITION_RIGHT;
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			list.autoHideBackground = true;
			list.horizontalScrollPolicy = List.SCROLL_POLICY_OFF;
			list.snapScrollPositionsToPixels = true
			list.addEventListener(FeathersEventType.RENDERER_ADD, list_rendererHandler);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new AyaItemRenderer();
			}
				
			//list.decelerationRate = 0.9983;
			//list.isQuickHitAreaEnabled = true;
			list.addEventListener(Event.SELECT, list_selectHandler);
			list.addEventListener(Event.CHANGE, list_changedHandler);
			list.addEventListener(Event.SCROLL, list_scrollHandler);
			//list.addEventListener(FeathersEventType.SCROLL_START, list_scrollHandler);
			//list.addEventListener(FeathersEventType.SCROLL_COMPLETE, list_scrollHandler);
			addChild(list);
			addChild(headerContainer);
						
			Player.instance.addEventListener(Player.SOUND_PLAY_COMPLETED, player_soundCompleteHandler);
			userModel.addEventListener(UserEvent.FONT_SIZE_CHANGE_START, user_fontChangeHandler);
			userModel.addEventListener(UserEvent.FONT_SIZE_CHANGE_END, user_fontChangeHandler);
		}
				
		private function user_fontChangeHandler(event:Event):void
		{
			list.verticalScrollPolicy = event.type==UserEvent.FONT_SIZE_CHANGE_START ? List.SCROLL_POLICY_OFF : List.SCROLL_POLICY_AUTO;
		}
		
		private function list_selectHandler(event:Event):void
		{
			if(preventSelection)
				return;
			list.selectedIndex = -1;
			_owner.dispatchEventWith("showTranslation", false, event.data);
			//assignAyaToPlayer(event.data.aya as Aya);
		}
		private function list_changedHandler(event:Event):void
		{
			var aya:Aya = list.selectedItem as Aya;
			if(aya==null || preventSelection)
				return;
			userModel.setLastItem(aya.sura, aya.aya);
			assignAyaToPlayer(aya);
			if(_owner)
				_owner.dispatchEventWith("changeTranslation", false, aya);

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
			if(!containItem(aya))
				return;
			
			preventSelection = true;
			aya.order = list.selectedIndex = targetIndex = findIndex(aya);
			preventSelection = false;
			timeoutID = setTimeout(scrollToSelectedItem, 0);
			if(_owner)
				_owner.dispatchEventWith("changeTranslation", false, aya);
		}
		
		private function list_scrollHandler():void
		{
			if(findingMode || !list.visible || !isShow)
				return;
			var scrollPos:Number = Math.max(0, list.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			startScrollBarIndicator = scrollPos;
			if(changes==0)
				return;
			
			if(changes<0)
			{
				changes /=2;
				headerBaseLine = scrollPos-scrollOffset>appModel.sizes.orginalHeightFull*2 ? 0 : appModel.sizes.toolbar;
			}
			else
			{
				scrollOffset = scrollPos;
				headerBaseLine = appModel.sizes.toolbar;
			}
			var y:Number = Math.max(headerBaseLine-appModel.sizes.subtitle, Math.min(headerBaseLine, headerContainer.y+changes))
			headerContainer.y = y;
			if(headerBaseLine<=0 || changes>0)
				appModel.toolbar.dispatchEventWith("moveToolbar", false, y-appModel.sizes.toolbar);
			//trace(changes, headerBaseLine, y);
			headerContainer.visible = y > -appModel.sizes.subtitle;
			Player.instance.dispatchEventWith(Player.APPEARANCE_CHANGED, false, changes);
		}
		
		/*private function list_scrollHandler(event:Event):void
		{
			//list.isQuickHitAreaEnabled = event.type==FeathersEventType.SCROLL_START;
			trace(event.data)
			//if(ConfigModel.instance.hasReciter) 
				//event.type==FeathersEventType.SCROLL_START ? SoundPlayer.instance.hide() : SoundPlayer.instance.show();
		}*/
		
		override protected function commitData():void
		{
			super.commitData();
			if(_owner)
				_owner.addEventListener("requestChangeItems", _owner_requestChangeItemsHandler);

			list.visible = false;

		}
		
		override protected function commitAfterStopScrolling():void
		{
			super.commitAfterStopScrolling();

			list.dataProvider = new ListCollection(_qdata.ayas);
			gotoLastItem()
		}
		
		private function gotoLastItem():void
		{
			list.visible = false;
			targetIndex = findIndex(userModel.lastItem);
			//trace(currentIndex, targetIndex, itemHeight)
			scrollToSelectedItem();
		}
		
		private function scrollToSelectedItem():void
		{
			findingMode = true;
			findRatio = 1;
			findTime = 0;
			if(targetIndex>0)
			{
				//list.scrollToPosition(0, targetIndex*itemHeight, 0);
				BaseCustomItemRenderer.FAST_COMMIT_TIMEOUT = 1000;
				timeoutID = setTimeout(finding, 0);
				BaseCustomItemRenderer.FAST_COMMIT_TIMEOUT = 0;
			}
			else
				finalizeFinding();			
		}
		
		private function finding():void
		{
			//list.removeEventListener(FeathersEventType.SCROLL_START, list_scrollHandler);
			//list.removeEventListener(FeathersEventType.SCROLL_COMPLETE, list_scrollHandler);
			//trace(currentIndex, targetIndex, itemHeight, findRatio, findTime);
			findRatio *= 0.5;
			findTime ++;
			if(Math.abs(currentIndex-targetIndex)>2 && findTime<20)
			{
				list.scrollToPosition(0, list.verticalScrollPosition+(targetIndex-currentIndex)*itemHeight*findRatio, 0);
				timeoutID = setTimeout(finding, 0);
			}
			else
				finalizeFinding();
		}	
		
		private function finalizeFinding():void
		{
			if(Player.instance.playing)
				list.removeEventListener(Event.CHANGE, list_changedHandler);
			list.selectedIndex = targetIndex;
			list.addEventListener(Event.CHANGE, list_changedHandler);
			list.scrollToDisplayIndex(targetIndex, 0.5);
			list.visible = true;
			setTimeout(function():void{findingMode = false;}, 600); 
		}
		
		private function list_rendererHandler(event:Event):void
		{
			var item:AyaItemRenderer = AyaItemRenderer(event.data);
			currentIndex = item.data.order;
			itemHeight = Math.max(300, item.height);
			findRatio = 1;
		}
		
		private function _owner_requestChangeItemsHandler():void
		{
			if(!containItem(userModel.lastItem))
				return;	
			//preventSelection = true;
			if(list.dataProvider==null)
			{
				setTimeout(_owner_requestChangeItemsHandler, 100);
				return;
			}
				
			preventSelection = false;
			targetIndex = findIndex(userModel.lastItem);
			if(targetIndex == list.selectedIndex)
				list.dispatchEventWith(Event.CHANGE);
			gotoLastItem();
		}
	}
}