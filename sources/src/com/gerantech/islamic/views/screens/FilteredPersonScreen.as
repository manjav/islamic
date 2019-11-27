package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Moathen;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.SearchInput;
	import com.gerantech.islamic.views.headers.ShopHeader;
	import com.gerantech.islamic.views.items.PersonItemRenderer;
	import com.gerantech.islamic.views.lists.FastList;

	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import starling.core.Starling;
	import starling.events.Event;
	
	public class FilteredPersonScreen extends BaseCustomPanelScreen
	{
		public var mode:Local;
		public var flags:Array;
		public var alert:Alert;
		
		private var list:FastList;
		private var listData:Array;		
		private var changeTID:uint;
		//private var backwardEnabled:Boolean;
		private var searchPattern:String = "";
		private var startScrollBarIndicator:Number = 0;
		private var shopHeader:ShopHeader;

		private var listLayout:VerticalLayout;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout()
			
			list = new FastList();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new PersonItemRenderer();
			}
			list.allowMultipleSelection = true;
			listData = getFilterList();
			list.dataProvider = new ListCollection(listData);
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0); 
			//list.verticalScrollPolicy = ScrollPolicy.ON;
			list.addEventListener(Event.SELECT, list_changedHandler);
			list.addEventListener(Event.RENDER, list_testHandler);
			addChild(list);
			
			if(type==Person.TYPE_TRANSLATOR && !appModel.preventPurchaseWarning && !userModel.premiumMode)
			{
				list.addEventListener(Event.SCROLL, list_scrollHandler);
				shopHeader = new ShopHeader();
				shopHeader.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0);
				shopHeader.addEventListener(Event.TRIGGERED, showPurchaseAlert);
				shopHeader.addEventListener(Event.CLOSE, shopHeader_closeHandler);
				addChild(shopHeader);
				
				listLayout = new VerticalLayout();
				listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
				listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				listLayout.paddingTop = shopHeader._height;
				listLayout.useVirtualLayout = true;
				list.layout = listLayout;
			}
		}
		
		private function list_testHandler(event:Event):void
		{
			for each(var m:Moathen in listData)
			{
				if(m == event.data)
				{
					if(m.playing)
						m.stop();
					else
						m.play();
				}
				else
					m.stop();
			}
		}
		
		private function getFilterList():Array
		{
			var ret:Array = new Array();
			var allPerson:Array ;
			var selectedPersons:Array ;
			if(type==Person.TYPE_TRANSLATOR)
			{
				allPerson = resourceModel.translators;
				selectedPersons = resourceModel.selectedTranslators;
			}
			else if(type==Person.TYPE_RECITER)
			{
				allPerson = resourceModel.reciters;
				selectedPersons = resourceModel.selectedReciters;
			}
			else if(type==Person.TYPE_MOATHEN)
			{
				allPerson = userModel.timesModel.moathens;
				selectedPersons = new Array(alert.moathen);
			}
			
			for each(var p:Person in allPerson)
			if(existLanguage(p) && p.mode==mode.name && searchText(p))
			{//trace(p.name, p.mode, mode.name, existLanguage(p))
				p.state = selectedPersons.indexOf(p)>-1 ? Person.SELECTED : p.checkState(true); 
				ret.push(p);
			}
			return ret;
		}
		
		private function showPurchaseAlert():void
		{
			AppController.instance.alert("purchase_popup_title", "purchase_popup_message", "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
		}

		private function shopHeader_closeHandler():void
		{
			Starling.juggler.tween(listLayout, 0.4, {paddingTop:0});
			//TweenLite.to(listLayout, 0.4, {paddingTop:0});
			shopHeader.removeEventListener(Event.CLOSE, shopHeader_closeHandler);
			shopHeader.removeFromParent(true);
			appModel.preventPurchaseWarning = true;
		}
		
		private function list_scrollHandler():void
		{
			var scrollPos:Number = Math.max(0,list.verticalScrollPosition);
			var changes:Number = startScrollBarIndicator-scrollPos;
			shopHeader.y = Math.max(-shopHeader._height, Math.min(0, shopHeader.y+changes));
			startScrollBarIndicator = scrollPos;
		}
		
		private function list_changedHandler(event:Event):void
		{
			//backwardEnabled = false;
			clearTimeout(changeTID);
			if(type == Person.TYPE_MOATHEN)
			{
				alert.moathen = list.selectedItem as Moathen;
				backButtonFunction();
				return;
			}
			changeTID = setTimeout(waitingForPersonsChanging, 500);
		}
		private function waitingForPersonsChanging():void
		{
			var sampleList:Array ;
			if(type==Person.TYPE_TRANSLATOR)
				sampleList = resourceModel.selectedTranslators;
			else if(type==Person.TYPE_RECITER)
				sampleList = resourceModel.selectedReciters;
		
			for each(var p:Person in listData)
			{
				var ex:int = sampleList.indexOf(p);
				if(p.state==Person.SELECTED && ex==-1)
					sampleList.push(p);
				
				if(ex>-1 && p.state!=Person.SELECTED)
					sampleList.splice(ex,1);
			}
			
			if(type==Person.TYPE_TRANSLATOR)
				resourceModel.selectedTranslators = sampleList;
			else if(type==Person.TYPE_RECITER)
				resourceModel.selectedReciters = sampleList;

			type==Person.TYPE_TRANSLATOR ? resourceModel.selectedTranslators = sampleList : resourceModel.selectedReciters = sampleList;
			///backwardEnabled = true;
			userModel.scheduleSaving();
		}		
		
		override protected function backButtonFunction():void
		{
			//if(!backwardEnabled)
			//	return;
			super.backButtonFunction();
		}

		private function searchText(person:Person):Boolean
		{
			if(searchPattern=="")
				return true;
			if(person.type==Person.TYPE_TRANSLATOR)
				return person.name.toLowerCase().indexOf(searchPattern)>-1;
			else
				return (person.name.toLowerCase().indexOf(searchPattern)>-1 || person.ename.toLowerCase().indexOf(searchPattern)>-1);
		}
		
		private function existLanguage(person:Person):Boolean
		{
			if(flags.length == 0)
				return true;
			
			for each(var f:Local in flags)
				if (f.name == person.flag.name)
					return true; 
				
			return false;
		}
		
		public function startSearch(str:String):void
		{
			searchPattern = StrTools.getSimpleString(str).toLowerCase();
			listData = getFilterList();
			list.dataProvider = new ListCollection(listData);
			list.validate();
		}
		
		
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.centerItem = new SearchInput();
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void
		{
			if(listData && type == Person.TYPE_MOATHEN)
				for each(var m:Moathen in listData)
					m.stop();
			super.feathersControl_removedFromStageHandler(event);
		}
		
		
		
	}
}