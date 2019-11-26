package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.SettingPanel;
	
	import feathers.controls.PickerList;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class PlayerPopUp extends SimplePopUp
	{
		private var personPicker:PickerList;
		private var suraPicker:PickerList;
		private var ayaPicker:PickerList;
		
		private var numRepeats:Array;
		
		private var personPanel:SettingPanel;
		private var ayaPanel:SettingPanel;
		private var pagePanel:SettingPanel;

		public function PlayerPopUp()
		{
			super();
			title = loc("player_popup");
		}
		override protected function initialize():void
		{
			super.initialize();
			width = Math.round(Math.min(appModel.sizes.twoLineItem*5, appModel.sizes.orginalWidth));
			
			var cLayout:VerticalLayout = new VerticalLayout();
			cLayout.gap = appModel.sizes.border*3;
			cLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			cLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			container.layout = cLayout;
			
			
			numRepeats = new Array(); 
			for(var i:uint=1; i<=10; i++)
				numRepeats.push({name:StrTools.getNumberFromLocale(i)+" ", value:i});
			
			/*personPanel = new SettingPanel("player_popup_person", numRepeats, {value:userModel.personRepeat});
			personPanel.list.listProperties.width = appModel.actionHeight*2;
			personPanel.addEventListener(Event.CHANGE, personPanel_changeHandler);
			container.addChild(personPanel);*/
			
			ayaPanel = new SettingPanel("player_popup_aya", numRepeats, {value:userModel.ayaRepeat});
			ayaPanel.picker.listProperties.width = appModel.sizes.toolbar*2;
			ayaPanel.addEventListener(Event.CHANGE, ayaPanel_changeHandler);
			container.addChild(ayaPanel);
			
			var pageLabel:String = loc("player_popup_repeat") + " ";
			switch(userModel.navigationMode.value)
			{
				case "page_navi": pageLabel += loc("page_l"); break;
				case "sura_navi": pageLabel += loc("sura_l"); break;
				case "juze_navi": pageLabel += loc("juze_l"); break;
			}
			pagePanel = new SettingPanel(pageLabel , numRepeats, {value:userModel.pageRepeat});
			pagePanel.picker.listProperties.width = appModel.sizes.toolbar*2;
			pagePanel.addEventListener(Event.CHANGE, pagePanel_changeHandler);
			container.addChild(pagePanel);
			
			show();
		}		

		
		private function pagePanel_changeHandler():void
		{
			pagePanel.picker.closeList();
			userModel.pageRepeat = pagePanel.picker.selectedItem.value;
		}
		
		private function ayaPanel_changeHandler():void
		{
			ayaPanel.picker.closeList();
			userModel.ayaRepeat = ayaPanel.picker.selectedItem.value;
		}
		
		/*private function personPanel_changeHandler():void
		{
			personPanel.list.closeList();
			userModel.personRepeat = personPanel.list.selectedItem.value;
		}*/
	}
}