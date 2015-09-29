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
			
			title = "تنظیمات جستجو";
			message = "منبع و محدوده جستجوی خود را تعیین و سپس تأیید را فشار دهید";
			acceptButtonLabel = loc("ok_button");
			cancelButtonLabel = loc("cancel_button");
			
			super.initialize();
			
			var clayout:VerticalLayout = new VerticalLayout();
			clayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			container.layout = clayout;
			
			var sourceData:Array = new Array({name:ResourceManager.getInstance().getString("loc", "quran_t"), icon:"app:/com/gerantech/islamic/assets/images/icon/icon-192.png"});
			for each(var p:Person in ConfigModel.instance.selectedTranslators)
			sourceData.push({name:p.name, icon:p.iconTexture});

			sourcePanel = new SettingPanel ("انتخاب منبع", sourceData, SettingItemRenderer);
			sourcePanel.addEventListener(Event.CHANGE, settingPanel_changeHandler);
			container.addChild(sourcePanel);
			
			
			var scopeData:Array = new Array({name:"کل قرآن"}, {name:"یک سوره خاص"}, {name:"یک جزء خاص"});
			
			scopePanel = new SettingPanel ("محدوده جستجو", scopeData, SettingItemRenderer);
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
			suraPicker.addEventListener(Event.CHANGE, suraPicker_changeHandler);
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
			juzePicker.addEventListener(Event.CHANGE, juzePicker_changeHandler);
			juzePicker.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var i:SettingItemRenderer = new SettingItemRenderer();
				i.labelFunction = function( item:Object ):String
				{
					return StrTools.getNumberFromLocale(item.index+1) + ". " + loc("juze_l") + " " + loc("j_"+(item.index+1));
				};
				return i;
			}
	

		}
		
		private function settingPanel_changeHandler(event:Event):void
		{
			sourcePanel.list.closeList();
			userModel.searchSource = sourcePanel.list.selectedIndex;
		}
		
		private function scopePanel_changeHandler(event:Event):void
		{
			scopePanel.list.closeList();
			userModel.searchScope = scopePanel.list.selectedIndex;
			
			container.removeChildren(3);
			if(userModel.searchScope==1)
				container.addChild(suraPicker);
			else if(userModel.searchScope==2)
				container.addChild(juzePicker);
		}
		
		
		private function suraPicker_changeHandler():void
		{
			suraPicker.closeList();
		}
		
		
		private function juzePicker_changeHandler():void
		{
			juzePicker.closeList();
		}		

	}
}