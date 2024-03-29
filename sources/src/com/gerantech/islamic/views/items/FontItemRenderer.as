package com.gerantech.islamic.views.items
{
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;

	public class FontItemRenderer extends SettingItemRenderer
	{

		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			super.commitData();
			
			titleDisplay.fontSize = appModel.sizes.orginalFontSize*_data.scale;
			titleDisplay.fontDescription = new FontDescription(_data.value, "normal", "normal", FontLookup.EMBEDDED_CFF);
			titleDisplay.elementFormat = new ElementFormat(titleDisplay.fontDescription, titleDisplay.fontSize, titleDisplay.color);
		}
	}
}