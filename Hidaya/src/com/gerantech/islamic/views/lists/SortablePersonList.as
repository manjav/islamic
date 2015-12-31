package com.gerantech.islamic.views.lists
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.views.items.SortableItemRenderer;
	import com.gerantech.islamic.views.popups.UndoAlert;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	
	public class SortablePersonList extends LayoutGroup
	{
		private var itemsList:Array;
		private var touchID:int = -1;
		private static const HELPER_POINT:Point = new Point();
		//private var background:Quad;
		private var itemContainer:ScrollContainer;

		private var tempY:Number;
		private var dragTimeoutID:uint;
		private var personList:Array;
		private var type:String;
		public var itemHeight:uint = 100;

		private var empty:LayoutGroup;

		
		public function SortablePersonList(type:String)
		{
			this.type = type;				
			itemHeight = AppModel.instance.sizes.twoLineItem;
		}
		

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();

			itemContainer = new ScrollContainer();
			itemContainer.layout = new AnchorLayout();
			itemContainer.layoutData = new AnchorLayoutData(0,0,0,0);itemContainer.verticalScrollBarPosition
			addChild(itemContainer);
			
			empty = new LayoutGroup();
			empty.height = itemHeight*0.6;
			
			resetList();
		}
		
		public function resetList():void
		{
			personList = type==Person.TYPE_TRANSLATOR ? ConfigModel.instance.selectedTranslators : ConfigModel.instance.selectedReciters;
			for each(var a:SortableItemRenderer in itemsList)
				a.removeFromParent(true);
			
			itemsList = new Array();
			var s:SortableItemRenderer;
			for(var i:uint; i<personList.length; i++)
			{
				s = new SortableItemRenderer()
				s.person = personList[i];
				s.addEventListener(Event.SELECT, item_selectHandler);
				s.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0);
				itemContainer.addChild(s);
				itemsList.push(s);
			}
			itemContainer.addChild(empty);
			
			srotList();
			if(personList.length>0)
				addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function item_selectHandler(event:Event):void
		{
			var s:SortableItemRenderer = SortableItemRenderer(event.currentTarget);
			var deleteIndex:int = itemsList.indexOf(s);
			var deleted:SortableItemRenderer = itemsList.splice(deleteIndex, 1)[0];
			deleted.filter = null;
			deleted.includeInLayout = deleted.isEnabled = false;
			Starling.juggler.tween(deleted, 0.5, {x:width, transition:Transitions.EASE_IN, onComplete:removeItem, onCompleteArgs:[deleted, deleteIndex]});
			//TweenLite.to(deleted, 0.5, {x:width, onComplete:removeItem, ease:Sine.easeIn, onCompleteParams:[deleted, deleteIndex]})
			setTimeout(srotList, 300);
		}
		
		private function removeItem(item:SortableItemRenderer, index:uint):void
		{
			itemContainer.removeChild(item);
			var undoAlert:UndoAlert = new UndoAlert(ResourceManager.getInstance().getString("loc", "undo_remove"), undoDeleteCaller, 2, 1, [item,index]);
			undoAlert.addEventListener(Event.CLOSE, undoAlert_closeHandler);
			PopUpManager.addPopUp(undoAlert, false);
			//new Alert(parent, ResourceManager.getInstance().getString("loc", "undo_remove"), undoDeleteCaller, [item,index]);
			function undoAlert_closeHandler(event:Event):void
			{
				PopUpManager.removePopUp(event.currentTarget as UndoAlert, true);
			}
		}
		
		
		private function undoDeleteCaller(item:SortableItemRenderer, index:uint):void
		{
			itemsList.splice(index, 0, item);
			itemContainer.addChild(item);
			item.x = width;
			Starling.juggler.tween(item, 0.5, {x:0, transition:Transitions.EASE_IN});
			//TweenLite.to(item, 0.5, {x:0, ease:Sine.easeOut})
			setTimeout(srotList, 300);
		}
		
		private function touchHandler(event:TouchEvent):void
		{
			var obj:SortableItemRenderer;
			var touch:Touch;
			if(!_isEnabled)
				return;
			for each(var s:SortableItemRenderer in itemsList)
			{
				touch = event.getTouch(s.dragButton);
				if(touch!=null)
				{
					obj = s;
					break;
				}
			}
			if(obj==null)
				return;
			if(touch.phase == TouchPhase.BEGAN)
			{
				
				NativeAbilities.instance.vibrate(10);
				itemContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				tempY = touch.globalY-obj.y;
				obj.filter = BlurFilter.createGlow(0, 0.5);
				itemContainer.setChildIndex(obj, itemContainer.numChildren-1);
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				obj.y = (touch.globalY-tempY);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				itemContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
				obj.filter = null;
				srotList()
			}
		}
		
		private function srotList():void
		{
			var sortedPersons:Array = new Array();
			
			itemsList.sortOn("y", Array.NUMERIC);
			var i:uint;
			for each(var a:SortableItemRenderer in itemsList)
			{
				a.includeInLayout = a.isEnabled = true;
				Starling.juggler.tween(a, 0.3, {y:itemHeight*i});
				//TweenLite.to(a, 0.3, {y:itemHeight*i});
				sortedPersons.push(a.person);
				i++;
			}
			
			type==Person.TYPE_TRANSLATOR ? ConfigModel.instance.selectedTranslators=sortedPersons : ConfigModel.instance.selectedReciters=sortedPersons;
			UserModel.instance.activeSaver();
			
			empty.y = itemsList.length*itemHeight;
		}
	
	}
}