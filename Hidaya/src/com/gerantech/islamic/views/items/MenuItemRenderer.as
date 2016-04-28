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
		
		override protected function initialize():void
		{
			super.initialize();
			var iconFilter:ColorMatrixFilter = new ColorMatrixFilter();
			iconFilter.tint(BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			iconDisplay.filter = iconFilter;
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