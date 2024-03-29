package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.Local;

	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import gt.utils.Localizations;

	import starling.display.Quad;
		
	public class FilterItemRenderer extends BaseCustomItemRenderer
	{
		private var local:Local;
		private var labelDisplay:Label;
		private var checkDisplay:Check;
		
		public function FilterItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			backgroundSkin = new Quad(10, 10);
			
			layout = new AnchorLayout();
			width = AppModel.instance.sizes.twoLineItem*1.6;
			height = AppModel.instance.sizes.twoLineItem*0.8;
			
			checkDisplay = new Check();
			checkDisplay.padding = AppModel.instance.sizes.border
			checkDisplay.horizontalAlign = AppModel.instance.align;
			checkDisplay.iconPosition = AppModel.instance.align;
			checkDisplay.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(checkDisplay);
			
			
			/*labelDisplay = new Label();
			//labelDisplay.height = AppModel.instance.sizes.itemHeight;
			labelDisplay.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(labelDisplay);*/
		}
		
		override protected function commitData():void
		{
			if(_data && _owner)
			{
				if(local==_data)
					return;
				
				local = _data as Local;
				checkDisplay.label = Localizations.instance.get(local.name);
			}
		}
		
		override public function set isSelected(value:Boolean):void
		{
			_data.selected = value;
			super.isSelected = value;
		}
		
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			if(value==lastState)
				return;
			//trace(value)
			//backgroundSkin = new Quad(10, 10, value==STATE_SELECTED?0xAAFFFF:0xFFFFFF);
		}
	}
}