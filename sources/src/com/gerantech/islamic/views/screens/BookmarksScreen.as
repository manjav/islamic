package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.managers.BillingManager;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.items.BookmarkItemRenderer;
	import com.gerantech.islamic.views.popups.UndoAlert;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.PopUpManager;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;

	public class BookmarksScreen extends BaseCustomPanelScreen
	{
		private var list:List;

		private var removedBookmark:Bookmark;

		private var removedIndex:int;
		private var undoAlert:UndoAlert;
		
		override protected function initialize():void
		{
			super.initialize();
			title = loc(appModel.PAGE_BOOKMARKS);
			layout = new AnchorLayout();
			
			if(userModel.bookmarks.length>0)
			{
				list = new List();
				list.itemRendererFactory = function():IListItemRenderer
				{
					return new BookmarkItemRenderer();
				};
				list.dataProvider = userModel.bookmarks;
				list.addEventListener(Event.SELECT, list_selectHandler);
				list.addEventListener(Event.CHANGE, list_openHandler);
				//list.autoHideBackground = true;
				list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
				addChild(list);
			}
			else
			{
				var emptyLabel:RTLLabel = new RTLLabel(loc("bookmark_empty"), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", null, true);
				emptyLabel.layoutData = new AnchorLayoutData(NaN, appModel.sizes.twoLineItem, NaN, appModel.sizes.twoLineItem, NaN, 0);
				addChild(emptyLabel);
			}
			
		}
		
		private function list_openHandler(event:Event):void
		{
			if(!UserModel.instance.premiumMode)
			{
				AppController.instance.alert("purchase_popup_title", "purchase_popup_message", "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
				list.removeEventListener(Event.CHANGE, list_openHandler);
				list.selectedIndex = -1;
				list.addEventListener(Event.CHANGE, list_openHandler);
				return;
			}

			var item:Bookmark = Bookmark.getFromObject(list.selectedItem);
			userModel.setLastItem(item.sura, item.aya);
			appModel.navigator.popScreen();
		}
		
		private function list_selectHandler(event:Event):void
		{
			removedBookmark = event.data as Bookmark;
			removedIndex = userModel.bookmarks.exist(removedBookmark);
			userModel.bookmarks.removeItemAt(removedIndex);
			refresh();
			
			undoAlert = new UndoAlert(ResourceManager.getInstance().getString("loc", "undo_remove"), undoRemovedItem);
			undoAlert.addEventListener(Event.CLOSE, undoAlert_closeHandler);
			PopUpManager.addPopUp(undoAlert, false);
		}
		
		private function undoRemovedItem():void
		{
			userModel.bookmarks.addItemAt(removedBookmark, removedIndex);
			refresh();
		}
		
		private function undoAlert_closeHandler():void
		{
			undoAlert.removeEventListener(Event.CLOSE, undoAlert_closeHandler);
			PopUpManager.removePopUp(undoAlert, true);
		}
		
		private function refresh():void
		{
			list.dataProvider = userModel.bookmarks;
			list.validate();
			userModel.scheduleSaving();
		}
		
	}
}