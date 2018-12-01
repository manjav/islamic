package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.SettingPanel;
	import com.gerantech.islamic.views.items.SearchSourceItemRenderer;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class SearchSettingPopup extends InfoPopUp
	{

		private var sourcePanel:SettingPanel;
		private var scopePanel:SettingPanel;
		private var suraPicker:SettingPanel;
		private var juzePicker:SettingPanel;
		private var searchScopeIndex:uint;

		
		public function SearchSettingPopup()
		{
			title = loc("search_set_title");
			message = loc("search_set_message");
			acceptButtonLabel = loc("ok_button");
			cancelButtonLabel = loc("cancel_button");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var clayout:VerticalLayout = new VerticalLayout();
			clayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			clayout.paddingBottom = appModel.sizes.DP16;
			container.layout = clayout;
			
			sourcePanel = new SettingPanel (loc("search_set_source"), ConfigModel.instance.searchSources, userModel.searchSource, SearchSourceItemRenderer);
			container.addChild(sourcePanel);
			
			searchScopeIndex = userModel.searchScope;
			var scopeData:Array = new Array({name:loc("search_set_scope_0")}, {name:loc("search_set_scope_1")}, {name:loc("search_set_scope_2")});
			scopePanel = new SettingPanel (loc("search_set_scope"), scopeData, userModel.searchScope);
			scopePanel.addEventListener(Event.CHANGE, scopePanel_changeHandler);
			container.addChild(scopePanel);
			show();			
	
			scopePanel_changeHandler(null);
			acceptCallback = acceptCallbackHandler;
		}
				
		
		private function scopePanel_changeHandler(event:Event):void
		{
			container.removeChildren(3);
			if(scopePanel.selectedIndex > -1)
				searchScopeIndex = scopePanel.selectedIndex;

			if(searchScopeIndex == 1)
			{
				createSuraPicker();
				suraPicker.selectedIndex = userModel.searchSura;
				container.addChild(suraPicker);
			}
			else if(searchScopeIndex == 2)
			{
				createJuzePicker();
				juzePicker.selectedIndex = userModel.searchJuze;
				container.addChild(juzePicker);
			}
		}
		
		private function createSuraPicker():void
		{
			if(suraPicker != null)
				return;
			
			suraPicker = new SettingPanel(null, ResourceModel.instance.popupSuraList, userModel.searchSura, null, itemFactory, labelFunction);
			function itemFactory():IListItemRenderer
			{
				var i:SettingItemRenderer = new SettingItemRenderer();
				i.labelFunction = function( item:Object ):String
				{
					return StrTools.getNumberFromLocale(item.index+1) + ". " + (appModel.ltr ? ResourceModel.instance.suraList[item.index].tname : ResourceModel.instance.suraList[item.index].name);
				};
				return i;
			};
			function labelFunction( item:Object ):String
			{
				return loc("sura_l") + " " + (appModel.ltr ? ResourceModel.instance.suraList[item.index].tname : ResourceModel.instance.suraList[item.index].name);
			};
		}
		
		private function createJuzePicker():void
		{
			if(juzePicker != null)
				return;
			
			juzePicker = new SettingPanel(null, ResourceModel.instance.juzeList, userModel.searchJuze, null, itemFactory, labelFunction);
			function itemFactory():IListItemRenderer
			{
				var i:SettingItemRenderer = new SettingItemRenderer();
				i.labelFunction = function( item:Object ):String
				{
					return StrTools.getNumberFromLocale(item.index+1) + ". " + loc("juze_l") + " " + loc("j_"+(item.index+1));
				};
				return i;
			};
			function labelFunction( item:Object ):String
			{
				return loc("juze_l") + " " + loc("j_"+(item.index+1));
			};
		}
		
		private function acceptCallbackHandler():void
		{
			userModel.searchSource = sourcePanel.picker.selectedIndex;
			userModel.searchScope = searchScopeIndex;
			if(suraPicker)
				userModel.searchSura = suraPicker.selectedIndex;
			if(juzePicker)
				userModel.searchJuze = juzePicker.selectedIndex;
		}

	}
}