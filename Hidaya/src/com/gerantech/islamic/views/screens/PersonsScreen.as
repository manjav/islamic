package com.gerantech.islamic.views.screens
{
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.action.LanguageActionList;
	import com.gerantech.islamic.views.action.ModeActionList;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.gerantech.islamic.views.lists.SortablePersonList;
	
	import flash.geom.Point;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	public class PersonsScreen extends BaseScreen
	{
		private var selectedPersonList:List;
		private var footers:LayoutGroup;
		private var modeSelector:ModeActionList;
		
		private var personList:FilteredPersonScreen;
		private var languageSelector:LanguageActionList;
		private var sortable:SortablePersonList;
		
		public function PersonsScreen()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();

			sortable = new SortablePersonList(type);
			sortable.layoutData = new AnchorLayoutData(0,0,appModel.itemHeight,0);
			addChild(sortable);

			footers = new LayoutGroup();
			footers.layout = new AnchorLayout();
			footers.layoutData = new AnchorLayoutData(NaN,0,0,0);
			footers.height = appModel.itemHeight;
			footers.backgroundSkin = new Quad(1, 1, BaseMaterialTheme.SECONDARY_BACKGROUND_COLOR);
			addChild(footers);
			
			var labelDisplay:RTLLabel = new RTLLabel(loc("person_add"), BaseMaterialTheme.PRIMARY_TEXT_COLOR, "center");
			labelDisplay.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, -appModel.itemHeight/2, 0);
			footers.addChild(labelDisplay);
			
			modeSelector = new ModeActionList(type);
			modeSelector.addEventListener(Event.SELECT, modeSelector_selectHandler);
			modeSelector.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(modeSelector);
		}
		
		private function modeSelector_selectHandler(event:Event):void
		{
			if(type==Person.TYPE_RECITER)
			{
				addPersonScreen(modeSelector.selectedMode, ConfigModel.instance.recitersFlags);
				return;
			}
			if(type==Person.TYPE_TRANSLATOR && modeSelector.selectedMode.name!="trans_t")
			{
				addPersonScreen(modeSelector.selectedMode, ConfigModel.instance.transFlags);
				return;
			}
			
			languageSelector = new LanguageActionList(new Point(modeSelector.actionButton.x, modeSelector.actionButton.y));
			languageSelector.addEventListener(Event.SELECT, languageSelector_selectHandler);
			languageSelector.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(languageSelector);
		}
		
		private function languageSelector_selectHandler(event:Event):void
		{
			if(event.type == Event.CLOSE)
				return;
			addPersonScreen(modeSelector.selectedMode, languageSelector.selectedLanguage.name=="ot_fl"?ConfigModel.instance.singleTransFlags:[languageSelector.selectedLanguage]);
		}
		
		private function addPersonScreen(mode:Local, flags:Array):void
		{
			var screenItem:StackScreenNavigatorItem = appModel.navigator.getScreen(appModel.PAGE_FILTERED);
			screenItem.properties = {type:type, mode:mode, flags:flags};
			appModel.navigator.pushScreen(appModel.PAGE_FILTERED);
		}
		
		override protected function backButtonFunction():void
		{
			if(modeSelector.opened)
				modeSelector.close();
			else if(languageSelector && languageSelector.opened)
				languageSelector.close();
			else
				super.backButtonFunction();
		}
		
		
		
	}
}