package com.gerantech.islamic.views.screens
{
	import com.greensock.TweenLite;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.items.PersonItemRenderer;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	import com.gerantech.islamic.views.headers.ShopHeader;
	
	public class FilteredPersonScreen extends BasePanelScreen
	{
		public var mode:Local;
		public var flags:Array;
		
		private var list:List;
		private var listData:Array;		
		private var changeTID:uint;
		private var backwardEnabled:Boolean;
		private var searchPattern:String = "";
		private var startScrollBarIndicator:Number = 0;
		private var shopHeader:ShopHeader;

		private var listLayout:VerticalLayout;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout()
			
			list = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new PersonItemRenderer();
			}
			list.allowMultipleSelection = true;
			listData = getFilterList();
			list.dataProvider = new ListCollection(listData);
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0); 
			//list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			list.addEventListener(Event.SELECT, list_changedHandler);
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
		
		private function showPurchaseAlert():void
		{
			AppController.instance.alert("purchase_popup_title", "purchase_popup_message", "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
		}
		

		private function shopHeader_closeHandler():void
		{
			TweenLite.to(listLayout, 0.4, {paddingTop:0});
			//listLayout.paddingTop = 0;
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
			backwardEnabled = false;
			clearTimeout(changeTID);
			changeTID = setTimeout(waitingForPersonsChanging, 500);
		}
		private function waitingForPersonsChanging():void
		{

			var sampleList:Array = type==Person.TYPE_TRANSLATOR ? ConfigModel.instance.selectedTranslators : ConfigModel.instance.selectedReciters;
			
			for each(var p:Person in listData)
			{
				var ex:int = sampleList.indexOf(p);
				if(p.state==Person.SELECTED && ex==-1)
				{
					sampleList.push(p);
				}
				
				if(ex>-1 && p.state!=Person.SELECTED)
					sampleList.splice(ex,1);
			}
			
			/*var ret:Array = new Array();
			for each(var ps:Person in sampleList)
				if(ps.state == Person.SELECTED)
					ret.push(ps);*/
			
			type==Person.TYPE_TRANSLATOR ? ConfigModel.instance.selectedTranslators = sampleList : ConfigModel.instance.selectedReciters = sampleList;
			backwardEnabled = true;
		}		
		
		override protected function backButtonFunction():void
		{
			if(!backwardEnabled)
				return;
			super.backButtonFunction();
		}
		
		private function getFilterList():Array
		{
			var ret:Array = new Array();
			var allPerson:Array = type==Person.TYPE_TRANSLATOR?ConfigModel.instance.translators : ConfigModel.instance.reciters
			var selectedPerson:Array = type==Person.TYPE_TRANSLATOR?ConfigModel.instance.selectedTranslators : ConfigModel.instance.selectedReciters
			
			for each(var p:Person in allPerson)
				if(existLanguage(p) && p.mode==mode.name && searchText(p))
				{//trace(p.name, p.mode, mode.name, existLanguage(p))
					p.state = selectedPerson.indexOf(p)>-1 ? Person.SELECTED : p.checkState(); 
					ret.push(p);
				}			
			return ret;
		}
		
		private function searchText(person:Person):Boolean
		{
			if(searchPattern=="")
				return true;
			if(person.type==Person.TYPE_RECITER)
				return (person.name.toLowerCase().indexOf(searchPattern)>-1 || person.ename.toLowerCase().indexOf(searchPattern)>-1);
			else
				return person.name.toLowerCase().indexOf(searchPattern)>-1;
				
		}
		
		private function existLanguage(person:Person):Boolean
		{
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
		
		
		
	}
}