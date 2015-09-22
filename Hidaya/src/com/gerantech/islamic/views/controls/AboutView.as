package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.VerticalLayout;
	
	public class AboutView extends SimpleLayoutButton
	{
		public function AboutView()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var aLayout:VerticalLayout = new VerticalLayout();
			aLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout = aLayout;
			
			var aboutIcon:ImageLoader = new ImageLoader();
			aboutIcon.source = "com/gerantech/islamic/assets/images/icon/icon-192.png";
			aboutIcon.height = aboutIcon.width = AppModel.instance.sizes.twoLineItem;
			addChild(aboutIcon);
			
			/*			appNameLabel = new Label();
			appNameLabel.styleName = Label.ALTERNATE_NAME_HEADING;
			appNameLabel.text = ResourceManager.getInstance().getString("loc", "app_title");
			*/			
			var appNameLabel:RTLLabel = new RTLLabel(ResourceManager.getInstance().getString("loc", AppModel.instance.PAGE_ABOUT), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.8, null, "bold");
			addChild(appNameLabel);
		}
	}
}