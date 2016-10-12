package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Moathen;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.Devider;
	import com.gerantech.islamic.views.controls.PersonAccessory;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class PersonItemRenderer extends BaseCustomItemRenderer
	{
		private var mainContents:LayoutGroup;
		private var personImage:ImageLoader;
		
		private var person:Person;
		private var intevalId:uint;
		private var tempY:Number;
		private var accessory:PersonAccessory;
		private var nameDisplay:RTLLabel;
		private var messageDisplay:RTLLabel;

		private var testButton:FlatButton;
		
		override protected function initialize():void
		{
			super.initialize();
			height = appModel.sizes.twoLineItem;
			layout = new AnchorLayout();
			
			var bgTouchable:Devider = new Devider();
			bgTouchable.alpha = 0;
			bgTouchable.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			touchTarget = bgTouchable;
			addChild(bgTouchable);
			
			var container:LayoutGroup = new LayoutGroup();
			container.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			addChild(container);
			
			var containerLayout:HorizontalLayout = new HorizontalLayout();
			containerLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			containerLayout.gap = containerLayout.padding = appModel.sizes.DP16;
			//myLayout.paddingRight = appModel.sizes.DP8;
			container.layout = containerLayout;
			
			accessory = new PersonAccessory();
			accessory.width = appModel.sizes.DP40;
			accessory.layoutData = new HorizontalLayoutData(NaN, 100);
			accessory.touchable = accessory.touchGroup = false;
			
			testButton = new FlatButton(Assets.getTexture("action_play"), "circle", false, 1, 0.5);
			testButton.iconScale = 0.6;
			testButton.height = testButton.width = appModel.sizes.DP32;
			testButton.addEventListener(Event.TRIGGERED, test_triggeredHandler); 
			testButton.layoutData = new HorizontalLayoutData(NaN, NaN);
			
			mainContents = new LayoutGroup();
			mainContents.layoutData = new HorizontalLayoutData(100, 100);
			mainContents.layout = new VerticalLayout();
			mainContents.touchable = mainContents.touchGroup = false;
			
			var fontSize:uint = height/5.4;
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, fontSize, null, "bold");
			nameDisplay.layoutData = new VerticalLayoutData(100, 55);
			mainContents.addChild(nameDisplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, fontSize*0.8);
			messageDisplay.layoutData = new VerticalLayoutData(100, 45);
			mainContents.addChild(messageDisplay);
			
			personImage = new ImageLoader();
			personImage.width = appModel.sizes.DP40;
			personImage.loadingTexture = Person.getDefaultImage();
			personImage.source = Person.getDefaultImage();
			personImage.layoutData = new HorizontalLayoutData(NaN, 100);
			personImage.delayTextureCreation = true;
			personImage.touchable = personImage.touchGroup = false;

			var itms:Array = [accessory, testButton, mainContents, personImage];
			if(appModel.ltr)
				itms.reverse();
			
			for each(var itm:DisplayObject in itms)
				container.addChild(itm);
		}
		
		private function test_triggeredHandler():void
		{
			_owner.dispatchEventWith(Event.RENDER, false, person);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			if(person==_data)
				return;
			if(person != null)
			{
				person.removeEventListener(Person.STATE_CHANGED, personStatesChanged);
				if(person.type == Person.TYPE_MOATHEN)
					Moathen(person).removeEventListener(Moathen.SOUND_TOGGLED, moathen_soundToggledHandler);
			}
			
			person = _data as Person;
			person.addEventListener(Person.STATE_CHANGED, personStatesChanged);
			
			
			testButton.visible = person.type == Person.TYPE_MOATHEN;
			if(person.type == Person.TYPE_MOATHEN)
			{
				Moathen(person).addEventListener(Moathen.SOUND_TOGGLED, moathen_soundToggledHandler);
			}
			
			nameDisplay.text = (appModel.ltr&&person.type==Person.TYPE_RECITER) ? person.ename : person.name;
			
			showMessage();
			if(!person.hasIcon)
			{
				person.addEventListener(Person.ICON_LOADED, person_iconLoadedHandler);
				person.loadImage();
			}
			else
				personImage.source = person.iconTexture;
			
			accessory.setState(person.state);
			super.commitData();
		}
		
		private function moathen_soundToggledHandler(event:Event):void
		{
			testButton.icon.source = Assets.getTexture("action_"+(event.data ? "pause" : "play"));
		}
		
		private function person_iconLoadedHandler():void
		{
			person.removeEventListener(Event.COMPLETE, person_iconLoadedHandler);
			if(parent!=null)
				personImage.source = person.iconTexture;
		}
		
		// MESSAGE  -------------------------------------------------
		private function showMessage():void
		{
			if(intevalId == 0)
			{
				messageDisplay.text = person.getCurrentMessage();
				intevalId = 10000;
			}
			else
			{
				clearInterval(intevalId);
				intevalId = setInterval(internalCaller, 400);
			}
		}

		private function internalCaller():void
		{
			var rect:Rectangle = getBounds(_owner);//trace(rect.y, tempY)
			if(Math.abs(tempY-rect.y)<appModel.sizes.twoLineItem)
			{
				clearInterval(intevalId);
				messageDisplay.text = person.getCurrentMessage();
			}
			tempY = rect.y;
		}
		
		private function personStatesChanged(event:Event):void
		{
			accessory.setState(person.state, person.hasIcon?0.8:0);
			if((person.state==Person.SELECTED||person.state==Person.HAS_FILE) && _owner!=null)
				_owner.dispatchEventWith(Event.SELECT, false, person);
		}
		
		private function translationProgressChanged(event:Event):void
		{
			accessory.setPercent(person.percent)
		}
		
		
		override public function set isSelected(value:Boolean):void
		{
			if(super.isSelected == value)
				return;
			//trace(person.type, UserModel.instance.premiumMode)
			/*if(person.type==Person.TYPE_TRANSLATOR && !UserModel.instance.premiumMode && UserModel.instance.firstTranslators.indexOf(person.path)==-1)
			{
				AppController.instance.alert("purchase_popup_title", "purchase_popup_message", "cancel_button", "purchase_popup_accept_label", BillingManager.instance.purchase);
				return;
			}*/
			super.isSelected = value;
			//trace(index, value,person.state);
			switch(person.state)
			{
				case Person.NO_FILE:
					person.addEventListener(Person.LOADING_PROGRESS_CHANGED, translationProgressChanged);
					person.load();
					break;
				case Person.LOADING:
				case Person.PREPARING:
					person.removeEventListener(Person.LOADING_PROGRESS_CHANGED, translationProgressChanged);
					person.unload();
					break;
				case Person.HAS_FILE:
					person.type == Person.TYPE_RECITER ? person.state = Person.SELECTED : person.load();
					break;
				case Person.SELECTED:
					person.state = Person.HAS_FILE;
					break;
			}
		}	
	}
}