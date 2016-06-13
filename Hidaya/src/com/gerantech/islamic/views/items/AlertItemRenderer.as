package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.vo.Alert;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class AlertItemRenderer extends BaseCustomItemRenderer
	{
		public static const EVENT_SELECT:String = "eventSelect";
		public static const EVENT_DELETE:String = "eventDelete";
		public static const EVENT_CHANGE_TYPE:String = "eventChangeType";
		public static const EVENT_CHANGE_RECITER:String = "eventChangeReciter";
		
		private var alert:Alert;

		private var titleDisplay:RTLLabel;
		//private var typeButton:FlatButton;
		private var reciterButton:FlatButton;
	
		override protected function initialize():void
		{
			super.initialize();
			//backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			//backgroundSkin.alpha = 0;
			height = AppModel.instance.sizes.singleLineItem;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			/*if(appModel.ltr)
				myLayout.paddingLeft = appModel.sizes.DP16;
			else
				myLayout.paddingRight = appModel.sizes.DP16;
			myLayout.gap = -appModel.sizes.DP8;*/
			layout = myLayout;
			
			reciterButton = new FlatButton();
			reciterButton.addEventListener(Event.TRIGGERED, reciterImage_triggeredHandler);
			reciterButton.layoutData = new HorizontalLayoutData(NaN, 100);
			
			var titleButton:SimpleLayoutButton = new SimpleLayoutButton();
			//titleButton.backgroundSkin = new Quad(1, 1, BaseMaterialTheme.ACCENT_COLOR);
			titleButton.addEventListener(Event.TRIGGERED, titleButton_triggeredHandler);
			titleButton.layoutData = new HorizontalLayoutData(100, 100);
			titleButton.layout = new AnchorLayout();
			
			titleDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, 0.9, null, "bold");
			titleDisplay.layoutData = new AnchorLayoutData(NaN,0,NaN,0,NaN,0);
			titleButton.addChild(titleDisplay); 
			/*
			typeButton = new FlatButton("comment_alert");
			typeButton.addEventListener(Event.TRIGGERED, typeButton_triggeredHandler);
			typeButton.pivotX = typeButton.width/2;
			//typeButton.pivotY = -typeButton.height/2;
			typeButton.layoutData = new HorizontalLayoutData(NaN, 100);
			typeButton.iconScale = 0.4;*/
			
			var deleteButton:FlatButton = new FlatButton("remove");
			deleteButton.addEventListener(Event.TRIGGERED, deleteButton_triggeredHandler);
			deleteButton.layoutData = new HorizontalLayoutData(NaN, 100);
			deleteButton.iconScale = 0.4;
			
			var itms:Array = [reciterButton, titleButton, deleteButton];
			if(!appModel.ltr)
				itms.reverse();
			
			for each(var itm:DisplayObject in itms)
				addChild(itm);
		}
		
		private function reciterImage_triggeredHandler():void
		{
			_owner.dispatchEventWith(EVENT_CHANGE_RECITER, false, alert); 
		}
		
		private function deleteButton_triggeredHandler():void
		{
			_owner.dispatchEventWith(EVENT_DELETE, false, index); 
		}
		/*private function typeButton_triggeredHandler():void
		{
			alert.type = alert.type == Alert.TYPE_NOTIFICATION ? Alert.TYPE_ALARM : Alert.TYPE_NOTIFICATION;
			typeButton.texture = alert.type == Alert.TYPE_NOTIFICATION ? "comment_alert" : "alarm_grey" ;
			typeButton.scaleX = typeButton.scaleY = 0.6;
			Starling.juggler.tween(typeButton, 0.3, {scaleX:1, scaleY:1, transition:Transitions.EASE_OUT});
			_owner.dispatchEventWith(EVENT_CHANGE_TYPE, false, [index, alert.type]); 
		}*/
		private function titleButton_triggeredHandler():void
		{
			_owner.dispatchEventWith(EVENT_SELECT, false, index); 
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			
			alert = _data as Alert;
			if(alert.moathen.iconTexture == null)
			{
				alert.moathen.addEventListener(Person.ICON_LOADED, moathen_iconLoadedHandler);
				alert.moathen.loadImage();
			}
			else
				reciterButton.icon.source = alert.moathen.iconTexture;
			
			titleDisplay.text = alert.owner.getAlertTitle(alert.offset);
			//typeButton.texture = alert.type == Alert.TYPE_NOTIFICATION ? "comment_alert" : "alarm_grey" 
		}
		
		private function moathen_iconLoadedHandler():void
		{
			alert.moathen.removeEventListener(Person.ICON_LOADED, moathen_iconLoadedHandler);
			reciterButton.icon.source = alert.moathen.iconTexture;
		}
		
		override public function set currentState(value:String):void
		{
		}
	}
}