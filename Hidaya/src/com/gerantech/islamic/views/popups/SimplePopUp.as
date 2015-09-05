package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.events.AppEvent;
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.greensock.TweenLite;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	public class SimplePopUp extends BasePopUp
	{
		protected var titleDisplay:RTLLabel;
		protected var container:ScrollContainer;
		protected var buttonBar:LayoutGroup;
		
		private var vLayout:VerticalLayout;
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
			removeChildren()
			super.initialize();
			autoSizeMode = AUTO_SIZE_MODE_CONTENT; 
			backgroundSkin = new Scale9Image(Assets.getSclaed9Textures("dialog"));
			
			alpha = 0;
			width = Math.round(Math.min(appModel.orginalWidth, appModel.orginalHeightFull)*0.9);
			minHeight = appModel.itemHeight*2;
			maxHeight = appModel.heightFull//;Math.round(Math.min(appModel.orginalWidth, appModel.orginalHeightFull));
			
			vLayout = new VerticalLayout();
			vLayout.padding = appModel.itemHeight*0.8;
			vLayout.paddingTop = appModel.itemHeight*0.6;
			//vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			layout = vLayout;
			
			titleDisplay = new RTLLabel(_title, 0, null, null, false, null, uint(userModel.fontSize*1.1), null, "bold");
			titleDisplay.layoutData = new VerticalLayoutData(100);
			addChild(titleDisplay);
			
			container = new ScrollContainer();
			container.autoSizeMode = AUTO_SIZE_MODE_CONTENT; 
			container.layoutData = new VerticalLayoutData(100);
			container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			container.maxHeight = maxHeight - vLayout.paddingBottom - vLayout.paddingTop - appModel.theme.controlsSize*2 - appModel.border*4;
			addChild(container);
			
			var spacer:LayoutGroup = new LayoutGroup();
			spacer.height = appModel.border*4;
			addChild(spacer);
			
			var buttonLayout:HorizontalLayout = new HorizontalLayout();
			buttonLayout.padding = -appModel.itemHeight*0.2;
			//buttonLayout.paddingTop = -appModel.itemHeight*0.3;
			buttonLayout.horizontalAlign = appModel.ltr ? "right" : "left";
			buttonLayout.gap = appModel.border;
			
			buttonBar = new LayoutGroup();
			buttonBar.layout = buttonLayout;
			buttonBar.layoutData = new VerticalLayoutData(100);
			addChild(buttonBar);

			AppController.instance.addEventListener(AppEvent.ORIENTATION_CHANGED, orientationChangedHandler);
		}
		
		protected function orientationChangedHandler(event:AppEvent):void
		{
			var _h:Number = appModel.heightFull;
			if(height>width)
				height = _h;
			
			maxHeight = _h//;Math.round(Math.min(appModel.orginalWidth, appModel.orginalHeightFull));
			container.maxHeight = _h - vLayout.paddingBottom - vLayout.paddingTop - titleDisplay.height - buttonBar.height - appModel.border*4;
		}		
		
		public function show():void
		{
			TweenLite.to(this, 0.3, {alpha:1, onComplete:initializeCompleted});
		}
		
		override public function close():void
		{
			AppController.instance.removeEventListener(AppEvent.ORIENTATION_CHANGED, orientationChangedHandler);
			TweenLite.to(this, 0.2, {alpha:0, onComplete:super.close});
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