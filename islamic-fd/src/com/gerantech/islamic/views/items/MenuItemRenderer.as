package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import starling.filters.ColorMatrixFilter;
	

	public class MenuItemRenderer extends SettingItemRenderer
	{
		
		public function MenuItemRenderer(height:Number=0)
		{
			super(height);
		}
		
		override protected function addElements(hasIcon:Boolean):void
		{
			super.addElements(hasIcon);
			var cmf:ColorMatrixFilter = new ColorMatrixFilter();
			cmf.tint(BaseMaterialTheme.DARK_TEXT_COLOR);
			iconDisplay.filter = cmf;
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			if(_data ==null)
				return;
			
			titleDisplay.text = loc(_data.name);
		}
	}
}