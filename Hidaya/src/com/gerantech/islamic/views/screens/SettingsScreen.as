package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.views.controls.CheckPanel;
	import com.gerantech.islamic.views.controls.SettingPanel;
	
	import flash.utils.setTimeout;
	
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class SettingsScreen extends BaseScreen
	{
		private var locPanel:SettingPanel;
		private var idlePanel:SettingPanel;
		private var fontPanel:SettingPanel;
		private var remindePanel:SettingPanel;
		private var nightModePanel:CheckPanel;

		private var naviModes:Array;

		private var idleModes:Array;
		private var remindeTimes:Array;
		
		override protected function initialize():void
		{
			super.initialize();
			
			var mLayout:VerticalLayout = new VerticalLayout();
			mLayout.gap = mLayout.padding = appModel.border*4;
			mLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout = mLayout;
			
			rejustLayout();
		}	
		
		private function rejustLayout():void
		{
			removeChildren();
			
			locPanel = new SettingPanel("select_loc", ConfigModel.instance.languages, userModel.locale);
			locPanel.addEventListener(Event.CHANGE, locPanel_changeHandler);
			addChild(locPanel);
			
			/*			naviModes = [{value:"page_navi"}, {value:"sura_navi"}, {value:"juze_navi"}]; 
			naviPanel = new SettingPanel("page_mode", naviModes, userModel.navigationMode);
			naviPanel.addEventListener(Event.CHANGE, naviPanel_changeHandler);
			addChild(naviPanel);
			*/			
			idleModes = [{value:"awake_of"}, {value:"awake_on"}, {value:"while_playing"}]; 
			idlePanel = new SettingPanel("display_timeout", idleModes, userModel.idleMode);
			idlePanel.addEventListener(Event.CHANGE, idlePanel_changeHandler);
			addChild(idlePanel);
			
			remindeTimes = [{value:"reminder_1"}, {value:"reminder_2"}, {value:"reminder_3"}, {value:"reminder_7"}, {value:"reminder_never"}]; 
			remindePanel = new SettingPanel("reminder_title", remindeTimes, userModel.remniderTime);
			remindePanel.addEventListener(Event.CHANGE, remindePanel_changeHandler);
			addChild(remindePanel);
			
			nightModePanel = new CheckPanel("night_mode", userModel.nightMode);
			nightModePanel.addEventListener(Event.CHANGE, nightModePanel_changeHandler);
			addChild(nightModePanel);
		}
		
		private function remindePanel_changeHandler():void
		{
			userModel.remniderTime = remindePanel.list.selectedItem;
			remindePanel.list.closeList();
			
			if(ConfigModel.instance.hasTranslator)
				ConfigModel.instance.selectedTranslators[0].remindeFirstTranslate();
		}
		
		private function locPanel_changeHandler(event:Event):void
		{
			userModel.locale = locPanel.list.selectedItem;
			locPanel.list.closeList();
			setTimeout(rejustLayout, 100);
			/*locPanel.resetContent();
			//naviPanel.resetContent();
			idlePanel.resetContent();
			nightModePanel.resetContent();*/
		}
		/*private function naviPanel_changeHandler():void
		{
			userModel.navigationMode = naviPanel.list.selectedItem;
			naviPanel.list.closeList();
		}*/
		private function idlePanel_changeHandler():void
		{
			userModel.idleMode = idlePanel.list.selectedItem;
			idlePanel.list.closeList();
		}
		
		private function nightModePanel_changeHandler(event:Event):void
		{
			userModel.nightMode = nightModePanel.checked;
			setTimeout(rejustLayout, 100);
			userModel.dispatchEventWith(UserEvent.CHANGE_COLOR);
		}		
		
	}
}