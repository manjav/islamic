package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.Devider;
	import com.gerantech.islamic.views.items.WeekNameItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Quad;

	public class CalendarHeader extends BaseSubtitle
	{
		private var list:List;

		
		public function CalendarHeader()
		{
			height = appModel.sizes.DP36;
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.CHROME_COLOR);
			//backgroundSkin.alpha = 0.3;
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			var startOfWeek:uint = appModel.ltr ? 0 : 6;
			var data:Array = new Array();
			for(var i:uint = startOfWeek; i<startOfWeek+7; i++)
				data.push(i%7);
			
			if(!appModel.ltr)
				data.reverse();

			var listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			
			
			list = new List();
			list.layout = listLayout;
			list.layoutData = new AnchorLayoutData(0,0,0,0);
			list.itemRendererFactory = function ():IListItemRenderer
			{
				return new WeekNameItemRenderer()
			}
			list.dataProvider = new ListCollection(data);
			addChild(list);
			
			/*var devider:Devider = new Devider( BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			devider.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			addChild(devider);*/
		}
		
	}
}