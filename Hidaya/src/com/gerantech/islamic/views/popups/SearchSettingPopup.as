package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.SettingPanel;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class SearchSettingPopup extends InfoPopUp
	{

		private var sourcePanel:SettingPanel;
		private var scopePanel:SettingPanel;
		private var suraPicker:PickerList;
		private var juzePicker:PickerList;

		
		public function SearchSettingPopup()
		{
			super();
		}
		
		override protected function initialize():void
		{
			
			title = loc("search_set_title");
			message = loc("search_set_message");
			acceptButtonLabel = loc("ok_button");
			cancelButtonLabel = loc("cancel_button");
			
			super.initialize();
			
			var clayout:VerticalLayout = new VerticalLayout();
			clayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			clayout.paddingBottom = appModel.sizes.DP16;
			container.layout = clayout;
			
			ConfigModel.instance.searchSources = new Array({name:ResourceManager.getInstance().getString("loc", "quran_t"), icon:"app:/com/gerantech/islamic/assets/images/icon/icon-192.png"});
			for each(var p:Person in ConfigModel.instance.selectedTranslators)
				ConfigModel.instance.searchSources.push({name:p.name, icon:p.iconTexture});

			sourcePanel = new SettingPanel (loc("search_set_source"), ConfigModel.instance.searchSources, SettingItemRenderer);
			sourcePanel.list.selectedIndex = userModel.searchSource;
			sourcePanel.addEventListener(Event.CHANGE, sourcePanel.list.closeList);
			container.addChild(sourcePanel);
			
			
			var scopeData:Array = new Array({name:loc("search_set_scope_0")}, {name:loc("search_set_scope_1")}, {name:loc("search_set_scope_2")});
			scopePanel = new SettingPanel (loc("search_set_scope"), scopeData, SettingItemRenderer);
			scopePanel.list.selectedIndex = userModel.searchScope;
			scopePanel.addEventListener(Event.CHANGE, scopePanel_changeHandler);
			container.addChild(scopePanel);
			
			suraPicker = new PickerList();
			suraPicker.buttonProperties.iconPosition = appModel.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			suraPicker.listProperties.width = appModel.sizes.twoLineItem*3;
			suraPicker.labelFunction = function( item:Object ):String
			{
				return loc("sura_l") + " " + (appModel.ltr ? ResourceModel.instance.suraList[item.index].tname : ResourceModel.instance.suraList[item.index].name);
			};
			suraPicker.dataProvider = new ListCollection(ResourceModel.instance.popupSuraList);
			suraPicker.selectedIndex = userModel.searchSura;
			suraPicker.addEventListener(Event.CHANGE, suraPicker.closeList);
			suraPicker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var i:SettingItemRenderer = new SettingItemRenderer();
				i.labelFunction = function( item:Object ):String
				{
					return StrTools.getNumberFromLocale(item.index+1) + ". " + (appModel.ltr ? ResourceModel.instance.suraList[item.index].tname : ResourceModel.instance.suraList[item.index].name);
				};
				return i;
			}
				
			juzePicker = new PickerList();
			juzePicker.buttonProperties.iconPosition = appModel.ltr ? Button.ICON_POSITION_RIGHT : Button.ICON_POSITION_LEFT;
			juzePicker.listProperties.width = appModel.sizes.twoLineItem*3;
			juzePicker.labelFunction = function( item:Object ):String
			{
				return loc("juze_l") + " " + loc("j_"+(item.index+1));
			};
			juzePicker.dataProvider = new ListCollection(ResourceModel.instance.juzeList);
			juzePicker.selectedIndex = userModel.searchJuze;
			juzePicker.addEventListener(Event.CHANGE, juzePicker.closeList);
			juzePicker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var i:SettingItemRenderer = new SettingItemRenderer();
				i.labelFunction = function( item:Object ):String
				{
					return StrTools.getNumberFromLocale(item.index+1) + ". " + loc("juze_l") + " " + loc("j_"+(item.index+1));
				};
				return i;
			}
			scopePanel_changeHandler(null);
			acceptCallback = acceptCallbackHandler;
		}
		
		private function scopePanel_changeHandler(event:Event):void
		{
			container.removeChildren(3);
			if(scopePanel.list.selectedIndex==1)
				container.addChild(suraPicker);
			else if(scopePanel.list.selectedIndex==2)
				container.addChild(juzePicker);
			
			scopePanel.list.closeList();
		}
		
		private function acceptCallbackHandler():void
		{
			userModel.searchSource = sourcePanel.list.selectedIndex;
			userModel.searchScope = scopePanel.list.selectedIndex;
			userModel.searchSura = suraPicker.selectedIndex;
			userModel.searchJuze = juzePicker.selectedIndex;
		}

	}
}