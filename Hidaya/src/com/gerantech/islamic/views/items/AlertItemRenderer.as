package com.gerantech.islamic.views.items
{
	public class AlertItemRenderer extends SettingItemRenderer
	{
	
		override protected function initialize():void
		{
			super.initialize();
			height = appModel.sizes.DP48;
			backgroundSkin.alpha = 0;
		}
		
		/*override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;

			super.commitData();
			if(labelFunction!=null)
				titleDisplay.text = StrTools.getNumberFromLocale((index+1) + ". " + labelFunction(_data));
		}*/
		
		override public function set currentState(value:String):void
		{
		}
	}
}