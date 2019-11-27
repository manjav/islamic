package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;

	import feathers.controls.ImageLoader;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;

	import gt.utils.Localizations;
	
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
			aLayout.horizontalAlign = HorizontalAlign.CENTER;
			layout = aLayout;
			
			var aboutIcon:ImageLoader = new ImageLoader();
			aboutIcon.source = "assets/images/icon/icon-192.png";
			aboutIcon.height = aboutIcon.width = AppModel.instance.sizes.twoLineItem;
			addChild(aboutIcon);
			
			/*			appNameLabel = new Label();
			appNameLabel.styleName = Label.ALTERNATE_NAME_HEADING;
			appNameLabel.text = Localizations.instance.get("app_title");
			*/			
			var appNameLabel:RTLLabel = new RTLLabel(Localizations.instance.get(AppModel.instance.PAGE_ABOUT), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.8, null, "bold");
			addChild(appNameLabel);
		}
	}
}