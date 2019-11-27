package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;

	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;

	import gt.utils.Localizations;

	import starling.events.Event;
	
	public class CheckPanel extends LayoutGroup
	{
		private var titleDisplay:RTLLabel;
		private var label:String;
		private var checkDisplay:PersonAccessory;
		private var hit:FlatButton;

		private var container:LayoutGroup;
		public var checked:Boolean;
		
		public function CheckPanel(label:String, checked:Boolean)
		{
			this.label = label;
			this.checked = checked;
			layout = new AnchorLayout();
			
			height = AppModel.instance.sizes.singleLineItem;
			
			container = new LayoutGroup();
			container.layoutData =  new AnchorLayoutData(0, 0, 0, 0);
			addChild(container);
			
			var mLayout:HorizontalLayout = new HorizontalLayout();
			mLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			mLayout.gap = AppModel.instance.sizes.DP8;
			container.layout = mLayout;
			
			titleDisplay = new RTLLabel(label, BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0.9, null, "bold");
			titleDisplay.layoutData =  new HorizontalLayoutData(100);
			
			checkDisplay = new PersonAccessory();
			checkDisplay.layoutData = new HorizontalLayoutData(NaN, 86);
			checkDisplay.setState(checked ? Person.SELECTED : Person.HAS_FILE, 1);
			checkDisplay.iconScale = 0.6;
			
			hit = new FlatButton(null, null, true, 0, 0);
			hit.layoutData =  new AnchorLayoutData(0, 0, 0, 0);
			hit.addEventListener(Event.TRIGGERED, backgroundSkin_triggeredHandler);
			addChild(hit);

			resetContent();
		}	
		
		private function backgroundSkin_triggeredHandler():void
		{
			checked = !checked;
			checkDisplay.setState(checked?Person.SELECTED:Person.HAS_FILE, 1);
			dispatchEventWith(Event.CHANGE);
		}
		
		public function resetContent():void
		{
			titleDisplay.bidiLevel = AppModel.instance.ltr?0:1;
			titleDisplay.textAlign = AppModel.instance.ltr?"left":"right";
			container.addChild(!AppModel.instance.ltr?checkDisplay:titleDisplay);
			container.addChild(AppModel.instance.ltr?checkDisplay:titleDisplay);
			
			var _label:String = Localizations.instance.get(label);
			if(_label==null)
				_label = label;
			titleDisplay.text = _label;
		}
	}
}