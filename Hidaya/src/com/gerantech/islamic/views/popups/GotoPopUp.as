package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.CustomTextInput;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.SettingPanel;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.utils.setTimeout;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class GotoPopUp extends InfoPopUp
	{
		private var pageLabel:RTLLabel;
		private var pageInput:CustomTextInput;

		private var suraPicker:SettingPanel;
		private var ayaPicker:SettingPanel;
		private var isPage:Boolean = true;

		private var pageGroup:LayoutGroup;
		private var suraGroup:LayoutGroup;
		private var firstButton:Button;
		private var secondButton:Button;
		
		private var pageMode:Boolean;
		private var resModel:ResourceModel;

		public function GotoPopUp()
		{
			title = loc("goto_popup");
			acceptButtonLabel = loc("goto_button");
			cancelButtonLabel = loc("cancel_button");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			resModel = ResourceModel.instance;

			var cLayout:VerticalLayout = new VerticalLayout();
			cLayout.gap = appModel.sizes.border*3;
			cLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			cLayout.paddingBottom = appModel.sizes.DP16;
			container.layout = cLayout;
			
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_BOTTOM;
			hLayout.gap = appModel.sizes.border*3;
			
			// add page text when navigation mode set to page by page  ------------------------------
			pageMode = userModel.navigationMode.value=="page_navi";
			if(pageMode)
			{
				pageGroup = new LayoutGroup();
				pageGroup.layout = hLayout;
				pageGroup.layoutData = new VerticalLayoutData(100);
				container.addChild(pageGroup);
				
				pageLabel = new RTLLabel(loc("page_l"), BaseMaterialTheme.DARK_TEXT_COLOR, null, null, false, null, 0, null, FontWeight.BOLD, FontPosture.NORMAL);
				pageLabel.layoutData = new VerticalLayoutData(100);
								
				pageInput = new CustomTextInput(SoftKeyboardType.NUMBER, ReturnKeyLabel.DONE, BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
				pageInput.maxChars = 3;
				pageInput.width = width*0.5;
				pageGroup.addChild(appModel.ltr?pageLabel:pageInput);
				pageGroup.addChild(appModel.ltr?pageInput:pageLabel);
			}
			
			var suraLayout:HorizontalLayout = new HorizontalLayout();
			suraLayout.gap = appModel.sizes.border*2;
			
			suraGroup = new LayoutGroup();
			suraGroup.layout = suraLayout;
			suraGroup.layoutData = new VerticalLayoutData(100);
			container.addChild(suraGroup);
			
			// set sura pannel --------------------------------
			suraPicker = new SettingPanel(null, resModel.popupSuraList, userModel.lastItem.sura-1, null, suraItemFactory, suraLabelFunction);
			suraPicker.layoutData = new HorizontalLayoutData(70);
			suraPicker.addEventListener(Event.CHANGE, suraPicker_changeHandler);
			function suraLabelFunction( item:Object ):String
			{
				return (appModel.ltr ? resModel.suraList[item.index].tname : resModel.suraList[item.index].name);
			};
			function suraItemFactory():IListItemRenderer
			{
				var i:SettingItemRenderer = new SettingItemRenderer();
				i.labelFunction = function( item:Object ):String
				{
					return StrTools.getNumberFromLocale(item.index+1) + ". " + (appModel.ltr ? resModel.suraList[item.index].tname : resModel.suraList[item.index].name);
				};
				return i;
			};
			
			// set aya pannel --------------------------------
			ayaPicker = new SettingPanel(null, resModel.suraList[userModel.lastItem.sura-1].ayas, userModel.lastItem.aya-1, null, ayaItemFactory, ayaLabelFunction);
			ayaPicker.layoutData = new HorizontalLayoutData(30);
			function ayaLabelFunction( item:Object ):String
			{
				if(item==null)
					return "";
				return StrTools.getNumberFromLocale(item.name);
			};
			function ayaItemFactory():IListItemRenderer
			{
				return new SettingItemRenderer();
			};

			suraGroup.addChild(appModel.ltr?suraPicker:ayaPicker);
			suraGroup.addChild(appModel.ltr?ayaPicker:suraPicker);
			
			acceptCallback = buttons_triggerHandler;
			hideAssets();
			setTimeout(assetsFadeIn, 1);
		}
		
		private function pageInput_focusHandler():void
		{
			isPage = true;
		}

		private function suraPicker_changeHandler():void
		{
			setTimeout(initAyaPicker, 1, suraPicker.selectedIndex);
		}
		
		private function initAyaPicker(suraIndex:int):void
		{
			if(resModel.suraList[suraIndex].ayas==null || resModel.suraList[suraIndex].ayas.length==0)
				resModel.suraList[suraIndex].complete();
			ayaPicker.pickerList.dataProvider = new ListCollection(resModel.suraList[suraIndex].ayas);
			ayaPicker.selectedIndex = Math.min(resModel.suraList[suraIndex].numAyas, Math.max(0, userModel.lastItem.aya-1));
			ayaPicker.addEventListener(Event.CHANGE, ayaPicker_changeHandler);			
		}
		
		public function hideAssets():void
		{
			if(pageMode)
				pageGroup.alpha = 0;
			suraGroup.alpha = 0;
			buttonBar.alpha = 0;
		}
		
		private function assetsFadeIn():void
		{
			if(pageMode)
				Starling.juggler.tween(pageGroup, 0.5, {alpha:1});
				//TweenLite.to(pageGroup, 0.5, {alpha:1});
			
			Starling.juggler.tween(suraGroup, 0.5, {delay:(pageMode?0.1:0), alpha:1});
			Starling.juggler.tween(buttonBar, 0.5, {delay:(pageMode?0.3:0.1), alpha:1});
			
			//TweenLite.to(suraGroup, 0.5, {delay:(pageMode?0.1:0), alpha:1});
			//TweenLite.to(buttonBar, 0.5, {delay:(pageMode?0.3:0.1), alpha:1});
		}
		
		private function ayaPicker_changeHandler():void
		{
			isPage = false;
			if(!pageMode)
				return;
			var p:Page = Page.getBySuraAya(suraPicker.selectedIndex+1, ayaPicker.selectedIndex+1);
			if(p != null && pageInput!=null)
				pageInput.text = p.page.toString();
		}
		
		private function buttons_triggerHandler():void
		{
			if(pageMode && isPage)
			{
				var p:uint = Math.min(603, Math.max(0, uint(pageInput.text)-1))
				var page:Page = resModel.pageList[p];
				userModel.setLastItem(page.sura, page.aya);
			}
			else
			{
				var s:uint = Math.min(114, Math.max(1, suraPicker.selectedIndex+1));
				var a:uint = Math.min(resModel.suraList[s-1].numAyas, Math.max(1, ayaPicker.selectedIndex+1));
				userModel.setLastItem(s, a);
			}
			userModel.dispatchEventWith(UserEvent.SET_ITEM);
			close();
		}
	}
}