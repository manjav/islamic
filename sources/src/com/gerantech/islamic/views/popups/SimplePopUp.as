package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.views.controls.RTLLabel;

	import feathers.controls.AutoSizeMode;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollPolicy;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.filters.DropShadowFilter;

	public class SimplePopUp extends BasePopUp
	{
		protected var titleDisplay:RTLLabel;
		protected var container:ScrollContainer;
		protected var buttonBar:LayoutGroup;
		
		protected var vLayout:VerticalLayout;
		private var _title:String;
		
		public function SimplePopUp()
		{
			super();
		}
		
		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			if(_title==value)
				return;
			
			_title = value;
			if(titleDisplay)
				titleDisplay.text = _title;
		}

		override protected function initialize():void
		{
			removeChildren();
			super.initialize();
			autoSizeMode = AutoSizeMode.CONTENT; 
			var skin:Image = new Image(Assets.getSclaed9Textures(userModel.nightMode?"i_dialog":"dialog"));
			skin.scale9Grid = new Rectangle(skin.width/2-1, skin.height/2-1, 2, 2);
			backgroundSkin = skin;//new Scale9Image(Assets.getSclaed9Textures(userModel.nightMode?"i_dialog":"dialog"));
			filter = new DropShadowFilter(appModel.sizes.DP4/2, 90*(Math.PI/180), 0, 0.4, appModel.sizes.DP4/2);
			
			alpha = 0;
			width = Math.min(appModel.sizes.orginalWidth, appModel.sizes.orginalHeightFull)-appModel.sizes.DP48;
			minHeight = appModel.sizes.twoLineItem;
			maxHeight = appModel.sizes.height//;Math.round(Math.min(appModel.sizes.orginalWidth, appModel.sizes.orginalHeightFull));
			
			vLayout = new VerticalLayout();
			vLayout.padding = appModel.sizes.getPixelByDP(24);
			vLayout.gap = appModel.sizes.DP4;
			vLayout.paddingTop = appModel.sizes.DP16;
			//vLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			vLayout.verticalAlign = VerticalAlign.TOP;
			layout = vLayout;
			
			titleDisplay = new RTLLabel(_title, 1, null, null, false, null, 0, null, "bold");
			titleDisplay.layoutData = new VerticalLayoutData(100);
			addChild(titleDisplay);
			
			container = new ScrollContainer();
			container.autoSizeMode = AutoSizeMode.CONTENT; 
			container.layoutData = new VerticalLayoutData(100);
			container.horizontalScrollPolicy = ScrollPolicy.OFF;
			container.maxHeight = maxHeight - vLayout.paddingBottom - vLayout.paddingTop -  appModel.sizes.twoLineItem;
			addChild(container);
			
			var spacer:LayoutGroup = new LayoutGroup();
			spacer.height = appModel.sizes.border*4;
			addChild(spacer);
			
			var buttonLayout:HorizontalLayout = new HorizontalLayout();
			buttonLayout.padding = -appModel.sizes.DP16;
			//buttonLayout.paddingTop = -appModel.sizes.itemHeight*0.3;
			buttonLayout.horizontalAlign = appModel.ltr ? "right" : "left";
			buttonLayout.gap = -appModel.sizes.DP8
			
			buttonBar = new LayoutGroup();
			buttonBar.layout = buttonLayout;
			buttonBar.layoutData = new VerticalLayoutData(100);
			addChild(buttonBar);

			AppController.instance.addEventListener(AppEvent.ORIENTATION_CHANGED, orientationChangedHandler);
		}
		
		protected function orientationChangedHandler(event:AppEvent):void
		{
			var _h:Number = appModel.sizes.heightFull;
			if(height>width)
				height = _h;
			
			maxHeight = _h//;Math.round(Math.min(appModel.sizes.orginalWidth, appModel.sizes.orginalHeightFull));
			container.maxHeight = _h - vLayout.paddingBottom - vLayout.paddingTop - titleDisplay.height - buttonBar.height - appModel.sizes.border*4;
		}		
		
		public function show():void
		{
			Starling.juggler.tween(this, 0.3, {alpha:1, onComplete:initializeCompleted});
			/*var tw:Tween = new Tween(this, 0.3);
			tw.fadeTo(1);
			tw.onComplete = initializeCompleted;
			Starling.juggler.add(tw);*/
		}
		
		override public function close():void
		{
			AppController.instance.removeEventListener(AppEvent.ORIENTATION_CHANGED, orientationChangedHandler);
			if(hasEventListener("startClosing"))
				dispatchEventWith("startClosing"); 
			
			Starling.juggler.tween(this, 0.2, {alpha:0, onComplete:super.close});
/*			var tw:Tween = new Tween(this, 0.2);
			tw.fadeTo(0);
			tw.onComplete = super.close;
			Starling.juggler.add(tw);*/
		}		
		
		/*override protected function feathersControl_addedToStageHandler(event:Event):void
		{			
			alpha = 0;
			TweenLite.to(this, 0.3, {alpha:1, onComplete:initializeCompleted});
			super.feathersControl_addedToStageHandler(event);
		}*/
		
		protected function initializeCompleted():void
		{
		}
		
	}
}