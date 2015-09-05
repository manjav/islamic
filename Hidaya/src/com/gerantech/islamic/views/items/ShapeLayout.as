package com.gerantech.islamic.views.items
{
	import feathers.controls.LayoutGroup;
	
	import starling.display.Quad;
	
	public class ShapeLayout extends LayoutGroup
	{
		public function ShapeLayout(color:uint)
		{
			super();
			backgroundSkin = new Quad(1,1,color);
		}
	}
}