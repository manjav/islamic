package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.PersonAccessory;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
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
		
		public function PersonItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
		//	backgroundSkin = new Quad(10, 10);
			height = appModel.sizes.listItem;
			
			var myLayout:HorizontalLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.gap = appModel.sizes.border*2;
			myLayout.padding = appModel.sizes.border*2;
			layout = myLayout;
			
			accessory = new PersonAccessory();
			accessory.layoutData = new HorizontalLayoutData(NaN, 100);
			addChild(accessory);
			
			mainContents = new LayoutGroup();
			mainContents.layoutData = new HorizontalLayoutData(100, 100);
			mainContents.layout = new VerticalLayout();
			addChild(mainContents);
			
			var fontSize:uint = appModel.sizes.listItem/4;
			
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, fontSize, null, "bold");
			
			/*nameDisplay = new TextBlockTextRenderer();
			var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			nameDisplay.bidiLevel = appModel.ltr?0:1;
			nameDisplay.textAlign = appModel.align;
			nameDisplay.elementFormat = new ElementFormat(fd, fontSize, 0x000000);*/
			nameDisplay.layoutData = new VerticalLayoutData(100, 50);
			mainContents.addChild(nameDisplay);
			
			messageDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, null, null, false, null, fontSize*0.8);

			/*messageDisplay = new TextBlockTextRenderer();
			var fd2:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			messageDisplay.bidiLevel = appModel.ltr?0:1;
			messageDisplay.textAlign = appModel.align;
			messageDisplay.elementFormat = new ElementFormat(fd2, fontSize*0.8, 0x666666);*/
			messageDisplay.layoutData = new VerticalLayoutData(100, 50);
			mainContents.addChild(messageDisplay);
			
			personImage = new ImageLoader();
			personImage.loadingTexture = Person.getDefaultImage();
			personImage.source = Person.getDefaultImage();
			personImage.layoutData = new HorizontalLayoutData(NaN, 100);
			personImage.delayTextureCreation = true;

			var itms:Array = [accessory, mainContents, personImage];
			if(appModel.ltr)
				itms.reverse();
			
			for each(var itm:DisplayObject in itms)
				addChild(itm);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			if(person==_data)
				return;
			
			person = _data as Person;
			person.addEventListener(Person.STATE_CHANGED, personStatesChanged);
			
			nameDisplay.text = (appModel.ltr&&person.type==Person.TYPE_RECITER) ? person.ename : person.name;
			
			showIcon();
			
			accessory.setState(person.state);
			super.commitData();
		}
		
		// ICON  -------------------------------------------------
		private function showIcon():void
		{
			if(person.hasIcon)
			{
				personImage.source = person.iconTexture;
				showMessage();
			}
			else
			{
				person.addEventListener(Person.ICON_LOADED, person_iconLoadedHandler);
				person.loadImage(person.iconUrl);
			}
		}
		private function person_iconLoadedHandler():void
		{
			person.removeEventListener(Event.COMPLETE, person_iconLoadedHandler);
			if(parent!=null)
				personImage.source = person.iconTexture;
			showMessage();
		}
		
		// MESSAGE  -------------------------------------------------
		private function showMessage():void
		{
			if(intevalId==0)
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
			var rect:Rectangle = getBounds(_owner);
		//	trace(rect.y, tempY)
			if(Math.abs(tempY-rect.y)<appModel.sizes.listItem)
			{
				clearInterval(intevalId);
				messageDisplay.text = person.getCurrentMessage();
			}
			tempY = rect.y;
		}
		
		// CHANGE STATES -------------------------------------------------
		/*override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			trace(value, lastState)//, person.state);
			if(value==lastState)
				return;
			
			if(value==STATE_SELECTED)
			{
				switch(person.state)
				{
					case Person.NO_FILE:
						person.addEventListener(Person.TRANSLATION_PROGRESS_CHANGED, translationProgressChanged);
						person.loadTranslaion();
						break;
					case Person.LOADING:
						person.removeEventListener(Person.TRANSLATION_PROGRESS_CHANGED, translationProgressChanged);
						person.stopDownload();
						break;
					case Person.HAS_FILE:
						person.loadTranslaion();
						break;
					case Person.SELECTED:
						person.state = Person.HAS_FILE;
						break;
				}
				_owner.dispatchEventWith(Event.SELECT, false, person);
			}
		}*/

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
					person.addEventListener(Person.TRANSLATION_PROGRESS_CHANGED, translationProgressChanged);
					Translator(person).loadTransltaion();
					break;
				case Person.LOADING:
				case Person.PREPARING:
					person.removeEventListener(Person.TRANSLATION_PROGRESS_CHANGED, translationProgressChanged);
					Translator(person).stopDownload();
					break;
				case Person.HAS_FILE:
					person.type == Person.TYPE_TRANSLATOR ? Translator(person).loadTransltaion() : person.state = Person.SELECTED;
					break;
				case Person.SELECTED:
					person.state = Person.HAS_FILE;
					break;
			}
		}		
	}
}