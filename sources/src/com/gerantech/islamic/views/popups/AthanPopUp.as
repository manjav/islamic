package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import feathers.layout.VerticalAlign;

	public class AthanPopUp extends SimplePopUp
	{
		private var _alert:Alert;
		
		private var cityLabel:RTLLabel;
		private var moathenLabel:RTLLabel;
		private var moathenImage:ImageLoader;
		
		public function AthanPopUp()
		{
		}

		override protected function initialize():void
		{
			super.initialize();
			
			addEventListener(Event.CLOSE, closeHandler);
			userModel.timesModel.updateNotfications();
			
			var containerLayout:VerticalLayout = new VerticalLayout();
			containerLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			containerLayout.firstGap = appModel.sizes.DP16;
			container.layout = containerLayout;
			
			cityLabel = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.8, null);
			cityLabel.layoutData = new HorizontalLayoutData(100);
			container.addChild(cityLabel);

			var moathenGroup:LayoutGroup = new LayoutGroup();
			moathenGroup.height = appModel.sizes.DP40;
		//	moathenGroup.width = container.width-containerLayout.padding*2;
			moathenGroup.layoutData = new VerticalLayoutData(100);
			container.addChild(moathenGroup);
			
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.verticalAlign = VerticalAlign.MIDDLE;
			hLayout.gap = appModel.sizes.DP8;
			moathenGroup.layout = hLayout;
			
			moathenLabel = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.88, null, "bold");
			moathenLabel.layoutData = new HorizontalLayoutData(100);
			
			moathenImage = new ImageLoader();
			//moathenImage.width = moathenGroup.height;
			moathenImage.layoutData = new HorizontalLayoutData(NaN, 100);
				
			moathenGroup.addChild(appModel.ltr?moathenImage:moathenLabel)
			moathenGroup.addChild(appModel.ltr?moathenLabel:moathenImage)
			
			var stopButton:Button = new Button();
			stopButton.label = "توقف";
			stopButton.addEventListener(Event.TRIGGERED, stopButton_triggerHandler);
			appModel.theme.setSimpleButtonStyle(stopButton);
			buttonBar.addChild(stopButton);
			addChild(buttonBar);
			show();
			
			var tw:Tween = new Tween(moathenGroup, 2, Transitions.EASE_IN_OUT);
			moathenGroup.alpha = 0;
			tw.delay = 0.5;
			tw.repeatCount = 20;
			tw.fadeTo(1);
			Starling.juggler.add(tw);
		}
		
		private function closeHandler(event:Event):void
		{
			removeEventListener(Event.CLOSE, closeHandler);
			if(_alert != null)
				_alert.moathen.stop();
		}
		
		private function stopButton_triggerHandler(event:Event):void
		{
			close();
		}
		
		public function set alert(value:Alert):void
		{
			_alert = value;
			
			cityLabel.text = userModel.city.name;
			titleDisplay.text = _alert.owner.getAlertTitle(_alert.offset);
			moathenLabel.text = _alert.moathen.name;
			if(_alert.moathen.iconTexture == null)
			{
				_alert.moathen.addEventListener(Person.ICON_LOADED, moathen_iconLoadedHandler);
				_alert.moathen.loadImage();
			}
			else
				moathen_iconLoadedHandler();
			
			_alert.moathen.play();
			_alert.moathen.addEventListener("soundEnded", stopButton_triggerHandler);
		}
			
		private function moathen_iconLoadedHandler():void
		{
			_alert.moathen.removeEventListener(Person.ICON_LOADED, moathen_iconLoadedHandler);
			moathenImage.source = _alert.moathen.iconTexture;
		}
	}
}