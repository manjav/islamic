package com.gerantech.islamic.views.lists
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	
	import feathers.controls.PickerList;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import starling.events.Event;
	
	public class TranslatorPickerList extends PickerList
	{

		override protected function initialize():void
		{
			super.initialize();
			
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
			addEventListener(Event.CHANGE, listchangeHandler);		
			
			var data:Array = new Array({name:"قرآن کریم", icon:"app:/com/gerantech/islamic/assets/images/icon/icon-192.png"});
			for each(var p:Person in ConfigModel.instance.selectedTranslators)
				data.push({name:p.name, icon:p.iconUrl});
			dataProvider = new ListCollection(data);
		}
		
		private function listchangeHandler():void
		{
			closeList();
		}		

	}
}