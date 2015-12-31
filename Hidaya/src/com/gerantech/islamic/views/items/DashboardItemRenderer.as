package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Quad;
	
	public class DashboardItemRenderer extends BaseCustomItemRenderer
	{
		private var iconDisplay:ImageLoader;
		private var titleDisplay:RTLLabel;
		public function DashboardItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			width = Math.floor(appModel.sizes.orginalWidth/3);
			height = appModel.sizes.orginalHeight/3;
			
			backgroundSkin = new Quad(1, 1, 0xEEEEEE);
			
			var image:Scale9Image = new Scale9Image(new Scale9Textures(Assets.getTexture("background-popup-skin"), new Rectangle(10,10,1,1)));
			image.x = image.y = 1;
			image.width = width-2;
			image.height = height-2;
			addChild(image);
			
			iconDisplay = new ImageLoader();
			iconDisplay.delayTextureCreation = true;
			iconDisplay.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -(height-width)/2);
			iconDisplay.width = iconDisplay.height = width/2
			addChild(iconDisplay);
			
			titleDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "center", null, true, null, 0, null, "bold");
			titleDisplay.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0, NaN, (height-width));
			//titleDisplay.height = height-width;
			addChild(titleDisplay);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			iconDisplay.source = Assets.getTexture(data.icon);
			titleDisplay.text = loc(data.title);
		}
		
		
	}
}