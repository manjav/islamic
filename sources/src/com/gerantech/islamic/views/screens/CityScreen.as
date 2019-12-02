package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.managers.LocationManager;
	import com.gerantech.islamic.models.vo.Location;
	import com.gerantech.islamic.views.controls.SearchInput;
	import com.gerantech.islamic.views.items.LocationItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	public class CityScreen extends BaseCustomPanelScreen
	{
		private var list:List;

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			LocationManager.instance.connect();
			
			list = new List();
			list.itemRendererFactory = function ():IListItemRenderer
			{
				return new LocationItemRenderer();
			}
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.addEventListener("change", list_changeHandler);
			addChild(list);
		}
		
		
		public function startSearch(cityName:String):void
		{
			if(cityName.length<2)
				return;
			LocationManager.instance.searchCity(cityName, createResult);
		}

		private function createResult(obj:Object):void
		{
			var data:Array = obj.data;
			list.dataProvider = new ListCollection(data);
		}
		

		private function list_changeHandler():void
		{
			userModel.city = new Location(list.selectedItem.name_latin+","+list.selectedItem.country_name, list.selectedItem.latitude, list.selectedItem.longitude);
			appModel.navigator.popScreen();
		}
		
		
		override protected function createToolbarItems():void
		{
			super.createToolbarItems();
			appModel.toolbar.centerItem = new SearchInput();
		}
	}
}