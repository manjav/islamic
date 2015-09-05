package com.gerantech.islamic.views.controls
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	public class Spacer extends LayoutGroup
	{
		private var vlayout:VerticalLayout;
		public function Spacer(isVertical:Boolean=true)
		{
			super();
			layoutData = isVertical ? new VerticalLayoutData(100,100) : new HorizontalLayoutData(100,100);
		}
	}
}