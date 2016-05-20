package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Location;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.EiditableButton;
	import com.gerantech.islamic.views.controls.CheckPanel;
	import com.gerantech.islamic.views.controls.Devider;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.controls.SettingPanel;
	import com.gerantech.islamic.views.controls.Spacer;
	import com.gerantech.islamic.views.items.FontItemRenderer;
	import com.gerantech.islamic.views.items.SettingItemRenderer;
	import com.gerantech.islamic.views.popups.GeoCityPopup;
	
	import flash.sensors.Geolocation;
	import flash.utils.setTimeout;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.events.Event;
	
	public class SettingsScreen extends BaseCustomPanelScreen
	{
		public static const MODE_QURAN:String = "modeQuran";
		public static const MODE_CALENDAR:String = "modeCalendar";
		public static const MODE_TIMES:String = "modeTimes";
		public static const MODE_COMPASS:String = "modeCompass";
		
		public var mode:String = "";
		
		private var naviModes:Array;
		private var naviPanel:SettingPanel;
		private var fontPanel:SettingPanel;
		private var remindePanel:SettingPanel;
		private var remindeTimes:Array;

		private var idleModes:Array;
		private var locPanel:SettingPanel;
		private var idlePanel:SettingPanel;
		private var nightModePanel:CheckPanel;
		private var cityButton:EiditableButton;
		private var hijriOffsets:Array;
		private var hijriOffsetsPanel:SettingPanel;
		
		override protected function initialize():void
		{
			super.initialize();
			
			var mLayout:VerticalLayout = new VerticalLayout();
			mLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout = mLayout;
			
			var ld:VerticalLayoutData = new VerticalLayoutData(92);
			
			removeChildren();
			
			switch(mode)
			{
				case MODE_CALENDAR:
					hijriOffsets = [{value:-2},{value:-1},{value:0},{value:1},{value:2}];//
					//[{value:"offset_0", value:-2}, {value:"offset_1", value:-1}, {value:"offset_2", value:0}, {value:"offset_3", value:1}, {name:"offset_4", value:2}];
					function getOffsetsIndex():int
					{
						for (var i:uint=0; i<hijriOffsets.length; i++)
							if(hijriOffsets[i].value == userModel.hijriOffset)
								return i;
						return -1;
					}
					function labelFunction(item:Object):String
					{
						return loc("offset"+item.value);
					}
					
					hijriOffsetsPanel = new SettingPanel("hijri_correction", hijriOffsets, getOffsetsIndex());
					hijriOffsetsPanel.picker.listProperties.itemRendererFactory = function():IListItemRenderer
					{
						var ret:SettingItemRenderer = new SettingItemRenderer();
						ret.labelFunction = labelFunction;
						return ret;
					}
					hijriOffsetsPanel.picker.labelFunction = labelFunction;
					hijriOffsetsPanel.addEventListener(Event.CHANGE, hijriOffsetsPanel_changeHandler);
					hijriOffsetsPanel.layoutData = ld;
					addChild(hijriOffsetsPanel);
					break
				
				case MODE_COMPASS:
				case MODE_TIMES:
					var spacer:Spacer = new Spacer();
					spacer.height = appModel.sizes.DP8;
					spacer.layoutData = ld;
					addChild(spacer);
					
					var ciyLabel:RTLLabel = new RTLLabel(loc("change_city"), BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0.9, null, "bold")
					ciyLabel.layoutData = ld;
					addChild(ciyLabel);
					
					cityButton = new EiditableButton();
					cityButton.label = userModel.city.name;
					cityButton.addEventListener("triggered", cityButton_triggeredHandler);
					cityButton.layoutData = ld;
					addChild(cityButton);

					break

				case MODE_QURAN:
					naviModes = [{value:"page_navi"}, {value:"sura_navi"}, {value:"juze_navi"}]; 
					naviPanel = new SettingPanel("page_mode", naviModes, userModel.navigationMode);
					naviPanel.addEventListener(Event.CHANGE, naviPanel_changeHandler);
					naviPanel.layoutData = ld;
					addChild(naviPanel);
					
					fontPanel = new SettingPanel("select_font", ConfigModel.instance.fonts, userModel.font, FontItemRenderer);
					fontPanel.addEventListener(Event.CHANGE, fontPanel_changeHandler);
					fontPanel.layoutData = ld;
					addChild(fontPanel);
					
					remindeTimes = [{value:"reminder_1"}, {value:"reminder_2"}, {value:"reminder_3"}, {value:"reminder_7"}, {value:"reminder_never"}]; 
					remindePanel = new SettingPanel("reminder_title", remindeTimes, userModel.remniderTime);
					remindePanel.addEventListener(Event.CHANGE, remindePanel_changeHandler);
					remindePanel.layoutData = ld;
					addChild(remindePanel);
					break;
				
				case MODE_TIMES:
					break
			}
			
			if(mode != "")
			{
				var spacer2:Spacer = new Spacer();
				spacer2.height = appModel.sizes.DP8;
				spacer2.layoutData = ld;
				addChild(spacer2);
				
				var  devider:Devider = new Devider(BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, appModel.sizes.DP32);
				devider.height = appModel.sizes.DP40;
				devider.layoutData = new VerticalLayoutData(100);
				devider.layout = new AnchorLayout();
				addChild(devider);
				
				var publicLabel:RTLLabel = new RTLLabel(loc("setting_header"), BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
				publicLabel.layoutData = new AnchorLayoutData(NaN, appModel.sizes.DP16, NaN, appModel.sizes.DP16, NaN, 0);
				devider.addChild(publicLabel);
			}
			
			locPanel = new SettingPanel("select_loc", ConfigModel.instance.languages, userModel.locale);
			locPanel.addEventListener(Event.CHANGE, locPanel_changeHandler);
			locPanel.layoutData = ld;
			addChild(locPanel);
			
			idleModes = [{value:"awake_of"}, {value:"awake_on"}, {value:"while_playing"}]; 
			idlePanel = new SettingPanel("display_timeout", idleModes, userModel.idleMode);
			idlePanel.addEventListener(Event.CHANGE, idlePanel_changeHandler);
			idlePanel.layoutData = ld;
			addChild(idlePanel);
			
			nightModePanel = new CheckPanel("night_mode", userModel.nightMode);
			nightModePanel.addEventListener(Event.CHANGE, nightModePanel_changeHandler);
			nightModePanel.layoutData = ld;
			addChild(nightModePanel);
		}
		
		private function hijriOffsetsPanel_changeHandler():void
		{
			userModel.hijriOffset = hijriOffsetsPanel.picker.selectedItem.value;
			trace(hijriOffsetsPanel.picker.selectedIndex, userModel.hijriOffset);
		}
		
		//Select City -------------------------------------------------------------
		private function cityButton_triggeredHandler():void
		{
			if(!Geolocation.isSupported)
				appModel.navigator.pushScreen(appModel.PAGE_CITY);
			else
				AppController.instance.addPopup(GeoCityPopup).addEventListener("complete", geoPopup_completeHandler);
		}
		private function geoPopup_completeHandler(event:*):void
		{
			event.currentTarget.removeEventListener("complete", geoPopup_completeHandler);
			userModel.city = event.data as Location;
			cityButton.label = userModel.city.name;
		}		
		
		
		
		// quran settings --------------------------------------------------------
		
		private function naviPanel_changeHandler():void
		{
			userModel.navigationMode = naviPanel.picker.selectedItem;
			naviPanel.picker.closeList();
		}		
	
		private function fontPanel_changeHandler(event:Event):void
		{
			userModel.font = fontPanel.picker.selectedItem;
			fontPanel.picker.closeList();
		}
		
		private function remindePanel_changeHandler():void
		{
			userModel.remniderTime = remindePanel.picker.selectedItem;
			remindePanel.picker.closeList();
			
			if(resourceModel.hasTranslator)
				resourceModel.selectedTranslators[0].remindeFirstTranslate();
		}
		
		// base settings --------------------------------------------------------
		private function locPanel_changeHandler(event:Event):void
		{
			userModel.locale = locPanel.picker.selectedItem;
			locPanel.picker.closeList();
			setTimeout(initialize, 100);
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
			userModel.idleMode = idlePanel.picker.selectedItem;
			idlePanel.picker.closeList();
		}
		
		private function nightModePanel_changeHandler(event:Event):void
		{
			userModel.nightMode = nightModePanel.checked;
			setTimeout(initialize, 100);
			userModel.dispatchEventWith(UserEvent.CHANGE_COLOR);
		}		
		
	}
}