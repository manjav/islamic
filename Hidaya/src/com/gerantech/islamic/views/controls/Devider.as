package com.gerantech.islamic.views.controls
{
	import feathers.controls.LayoutGroup;
	
	import starling.display.Quad;
	
	public class Devider extends LayoutGroup
	{
		public function Devider(color:uint=0, size:uint=1)
		{
			backgroundSkin = new Quad(size,size, color);
		}
	}
}