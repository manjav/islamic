package com.gerantech.islamic.views.items
{
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
			mlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout = mlayout;
			
		//	titleDisplay = new RTLLabel("", 1, 
			
		}
		
		
		override protected function commitData():void
		{
			super.commitData();
		}
		
	}
}