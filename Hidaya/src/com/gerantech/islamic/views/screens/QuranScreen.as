package com.gerantech.islamic.views.screens
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.views.headers.PlayerView;
	import com.gerantech.islamic.views.items.AyaItemRenderer;
	import com.gerantech.islamic.views.items.PageItemRenderer;
	import com.gerantech.islamic.views.items.UthmaniPageItemRenderer;
	import com.gerantech.islamic.views.popups.TranslationPopUp;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	
	public class QuranScreen extends BaseScreen
	{
	
		private var list:List;
		private var translatorsList:PersonsScreen;
		private var recitersList:PersonsScreen;		
		private var selectedIndex:uint;
		private var player:PlayerView;
		private var translationsPage:TranslationPopUp;
		private var fontScale:Number = 1;
		private var touchEnded:Boolean = true ;
		private var appModel:AppModel;
		private var userModel:UserModel;
		
		override protected function initialize():void
		{
			super.initialize();
			
			layout = new AnchorLayout();
			
			appModel = AppModel.instance;
			userModel = UserModel.instance;
			
			appModel.drawers.isEnabled = true;
			//menuButtonHandler = menuButtonFunction;
			//searchButtonHandler = searchButtonFunction;
			addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
			
			player = new PlayerView();
			player.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			
			AppController.instance.addEventListener(AppEvent.ORIENTATION_CHANGED, app_orientationChangeHandler);
			userModel.addEventListener(UserEvent.SET_ITEM, app_setItemHandler);
		}

		
		private function transitionInCompleteHandler():void
		{
			if(list!=null)
				list.removeFromParent(true);
			
			removeChildren();
			createList();
			if(ConfigModel.instance.selectedReciters.length>0)
			{
				addChild(player);
				//player.reload();
				//setTimeout(player.show, 1000);
			}
			
			Flurry.getInstance().logEvent("page_quran", {sura:userModel.lastItem.sura, aya:userModel.lastItem.aya});
		}
		
		private function createList():void
		{
			var listLayout:HorizontalLayout = new HorizontalLayout();
			var res:ResourceModel = ResourceModel.instance;
			var reverseList:Array = new Array();
			var navi:String = userModel.navigationMode.value;
			
			switch(navi)
			{
				case "page_navi":
					for (var i:int=603; i>=0; i--)
						reverseList.push(res.pageList[i]);
					break;
					
				case "sura_navi":
					for (var j:int=113; j>=0; j--)
						reverseList.push(res.suraList[j]);
					break;
					
				case "juze_navi":
					for (var k:int=29; k>=0; k--)
						reverseList.push(res.juzeList[k]);
					break;
			}
			selectedIndex = userModel.getSelectedByLastItem();
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return (navi=="sura_navi"||navi=="juze_navi") ? (new PageItemRenderer()) : (new UthmaniPageItemRenderer());
			};
			list.dataProvider = new ListCollection(reverseList);
			list.scrollToDisplayIndex(selectedIndex, 0);
			list.snapToPages = true;
			list.autoHideBackground = true;
			list.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			list.addEventListener(Event.SCROLL, list_scrollHandler);
			list.addEventListener("showTranslation", list_showTranslationHandler);
			list.addEventListener("changeTranslation", list_changeTranslationHandler);
			list.addEventListener(TouchEvent.TOUCH, onTouch);
			//list.addEventListener("addAya", list_ayaChangedHandler);
			//list.addEventListener("removeAya", list_ayaChangedHandler);
			addChild(list);
		}
		
		private function list_scrollHandler():void
		{
			appModel.toolbar.dispatchEventWith("moveToolbar", false, 0);
		}
		
		private function list_showTranslationHandler(event:Event):void
		{
			var rect:Rectangle = AyaItemRenderer(event.data).getBounds(list);
			rect.y = Math.max(0, rect.y);
			rect.height = Math.min(actualHeight, rect.height);

			var aya:Aya = event.data.aya as Aya;
			if(aya==null)
				return;
			translationsPage = new TranslationPopUp(rect, aya);
			translationsPage.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			translationsPage.addEventListener(Event.CLOSE, translationsPage_closeHandler);
			translationsPage.addEventListener("endShowing", translationsPage_endShowingHandler);
			translationsPage.addEventListener("startClosing", translationsPage_startClosingHandler);
			addChildAt(translationsPage, numChildren-1);
		}
		
		private function translationsPage_endShowingHandler():void
		{
			translationsPage.show();
			list.visible = false;
		}
		private function translationsPage_startClosingHandler():void
		{
			list.visible = true;
		}
		
		private function list_changeTranslationHandler(event:Event):void
		{
			var aya:Aya = event.data as Aya;
			if(aya==null || translationsPage==null)
				return;
			translationsPage.changeAya(aya);
		}

		private function translationsPage_closeHandler():void
		{
			if(translationsPage==null)
				return;
			removeChildren();
			addChild(list);
			addChild(player);
			translationsPage = null;
		}

		protected function app_setItemHandler(event:Event):void
		{
			var index:int;
			switch(userModel.navigationMode.value)
			{
				case "page_navi":
					index = 604-userModel.lastItem.page;
					break;
				
				case "sura_navi":
					index = 114-userModel.lastItem.sura;
					break;
				
				case "juze_navi":
					index = 30-userModel.lastItem.juze;
					break;
			}
			if(index != selectedIndex)
			{
				selectedIndex = index;
				list.scrollToDisplayIndex(selectedIndex, 0);
			}
			//else
			list.dispatchEventWith("requestChangeItems");
		}
		
		protected function app_orientationChangeHandler(event:AppEvent):void
		{
			selectedIndex = userModel.getSelectedByLastItem();
			var time:Number = event.data==null ? 0 : Number(event.data);
			list.scrollToDisplayIndex(selectedIndex, time);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			if (touches.length == 1 && !touchEnded)
			{
				// one finger touching -> move
				//var delta:Point = touches[0].getMovement(parent);
				//x += delta.x;
				//y += delta.y;
				userModel.dispatchEventWith(UserEvent.FONT_SIZE_CHANGE_END);
				touchEnded = true;
				list.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
			}            
			else if (touches.length == 2)
			{
				if(touchEnded)
				{
					userModel.dispatchEventWith(UserEvent.FONT_SIZE_CHANGE_START);
					list.horizontalScrollPolicy = List.SCROLL_POLICY_OFF;
				}
				touchEnded = false;
				// two fingers touching -> rotate and scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point  = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number = currentAngle - previousAngle;
				
				// update pivot point based on previous center
				var previousLocalA:Point  = touchA.getPreviousLocation(this);
				var previousLocalB:Point  = touchB.getPreviousLocation(this);

				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				fontScale = Math.min(1.8, Math.max(0.6, fontScale*sizeDiff));
				userModel.fontSize = Math.round(appModel.sizes.orginalFontSize*fontScale/2)*2;
			}
		}
	}
}