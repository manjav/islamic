package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import starling.events.Event;
	import gt.utils.Localizations;
	
	public class TranslatorPickerList extends PickerList
	{

		override protected function initialize():void
		{
			super.initialize();
			
			buttonProperties.visible = false;
			
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = Assets.getTexture("remove");//this.pickerListButtonIconTexture;
			buttonProperties.stateToIconFunction = iconSelector.updateValue;
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			buttonProperties.stateToSkinFunction = skinSelector.updateValue;
			
			labelField = "name";
			listProperties.itemRendererFactory = function():IListItemRenderer
			{
				return new SettingItemRenderer();
			}
			
			
				
			var data:Array = new Array({name:Localizations.instance.get("quran_t"), icon:"app:/com/gerantech/islamic/assets/images/icon/icon-192.png"});
			for each(var p:Person in ConfigModel.instance.selectedTranslators)
				data.push({name:p.name, icon:p.iconTexture});
			dataProvider = new ListCollection(data);
			
			trace(UserModel.instance.searchSource, ConfigModel.instance.selectedTranslators.length)
			
			if(UserModel.instance.searchSource<ConfigModel.instance.selectedTranslators.length-1)
				UserModel.instance.searchSource = 0;
			
			selectedIndex = UserModel.instance.searchSource;
		}
		
		override protected function list_changeHandler(event:Event):void
		{
			closeList();
			super.list_changeHandler(event);
			UserModel.instance.searchSource = selectedIndex;
		}

	}
}