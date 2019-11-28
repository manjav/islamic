package com.gerantech.islamic.views.items
{
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;

	public class InboxItemRenderer extends BaseCustomItemRenderer
	{
		public function InboxItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			height = userModel.fontSize*4;
			
			var mlayout:VerticalLayout = new VerticalLayout();
			mlayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout = mlayout;
		}
		
		override protected function commitData():void
		{
			super.commitData();
		}
		
	}
}