package com.gerantech.islamic.themes
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.utils.MetricUtils;
	import com.gerantech.islamic.views.lists.QList;
	import com.gerantech.islamic.views.popups.CustomBottomDrawerPopUpContentManager;

	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.ToggleButton;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.skins.ImageSkin;

	import flash.text.TextFormat;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;

	import starling.display.Image;
	import starling.events.Event;
	
	public class CustomTheme extends MaterialTheme
	{
	
		public function get sizes():MetricUtils
		{
			return AppModel.instance.sizes;
		}

		override protected function initializeDimensions():void
		{
			this.borderSize = 1;
			this.gridSize = sizes.DP56;// Math.round(88 * this.scale);
			this.smallGutterSize = sizes.DP4;//Math.round(11 * this.scale);
			this.gutterSize = sizes.DP16;//Math.round(22 * this.scale);
			this.controlSize = sizes.DP48;// Math.round(58 * this.scale);
			this.smallControlSize = sizes.DP16;//Math.round(22 * this.scale);
			this.popUpFillSize = Math.round(552);
			this.calloutBackgroundMinSize = sizes.DP8;//Math.round(11 * this.scale);
			this.calloutArrowOverlapGap = -2;
			this.scrollBarGutterSize = sizes.DP8;
			this.wideControlSize = this.gridSize * 3 + this.gutterSize * 2;
		}
		
		/**
		 * picker list skinning
		 */
		override protected function setPickerListButtonStyles(button:Button):void
		{
			var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			var ef:ElementFormat = new ElementFormat(fd, uint(sizes.orginalFontSize*0.9), BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			button.defaultLabelProperties.elementFormat = ef;			
			
			var skin:ImageSkin = new ImageSkin(backgroundInsetSkinTexture);
			skin.selectedTexture = this.backgroundInsetFocusedSkinTexture;
			///skin.setTextureForState(ButtonState.DOWN, this.backgroundInsetFocusedSkinTexture);
			//skin.setTextureForState(ButtonState.DISABLED, this.backgroundInsetDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
		//	skin.width = this.controlSize;
		//	skin.height = this.controlSize;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.pickerListButtonIconTexture);
			icon.selectedTexture = this.pickerListButtonSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.pickerListButtonIconDisabledTexture);
			button.defaultIcon = icon;
			
			button.gap = Number.POSITIVE_INFINITY;
			button.minGap = this.gutterSize;
			button.minHeight = sizes.DP36;
			//button.padding = sizes.border;
			button.iconPosition = Button.ICON_POSITION_LEFT;
		}
		override protected function setPickerListStyles(list:PickerList):void
		{
			if(sizes.isTablet)
				list.popUpContentManager = new CalloutPopUpContentManager();
			else
			{
				if(list.listFactory == null)
					list.listFactory = function ():List {return new QList();};
				list.popUpContentManager = new CustomBottomDrawerPopUpContentManager();
			}
		}
		override protected function setPickerListPopUpListStyles(list:List):void
		{
			super.setPickerListPopUpListStyles(list);
			if(!sizes.isTablet)
				list.padding = 0;
		}


		/**
		 * scroll bar skinning
		 */
		override protected function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			super.setSimpleScrollBarStyles(scrollBar);
			if(scrollBar.direction == Direction.VERTICAL)
			{
				scrollBar.paddingRight = AppModel.instance.ltr ? this.scrollBarGutterSize : 0;
				scrollBar.paddingLeft = AppModel.instance.ltr ? 0 : this.scrollBarGutterSize;
			}
		}
		override protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			super.setHorizontalSimpleScrollBarThumbStyles(thumb);
			thumb.defaultSkin.height = smallGutterSize;
		}
		override protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			super.setVerticalSimpleScrollBarThumbStyles(thumb);
			thumb.defaultSkin.width = smallGutterSize;
		}
		
		
		/**
		 * buttons skinning
		 */
		override protected function setBaseButtonStyles(button:Button):void
		{
			button.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			button.defaultLabelProperties.bidiLevel = AppModel.instance.ltr ? 0:1;
			button.disabledLabelProperties.bidiLevel = AppModel.instance.ltr ? 0:1;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				ToggleButton(button).selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			}
			
			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = button.minHeight = this.controlSize;
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
		}

		public function setSimpleButtonStyle(button:Button):void
		{
			button.addEventListener(FeathersEventType.CREATION_COMPLETE, button_creationCompleteHandler);
		}
		private function button_creationCompleteHandler(event:Event):void
		{
			var button:Button = event.currentTarget as Button;
			button.removeEventListener(FeathersEventType.CREATION_COMPLETE, button_creationCompleteHandler);
			
			var fd2:FontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			var fe:ElementFormat = new ElementFormat(fd2, sizes.orginalFontSize, BaseMaterialTheme.SELECTED_TEXT_COLOR);
			var fd:ElementFormat = new ElementFormat(fd2, sizes.orginalFontSize, BaseMaterialTheme.DARK_DISABLED_TEXT_COLOR);
			button.disabledLabelProperties.bidiLevel = button.downLabelProperties.bidiLevel = button.defaultLabelProperties.bidiLevel = AppModel.instance.ltr ? 0 : 1;
			button.defaultLabelProperties.elementFormat = fe;
			button.downLabelProperties.elementFormat = fd;
			button.disabledLabelProperties.elementFormat = fe;
			
			button.defaultSkin = null;
		}

		override protected function setHeaderStyles(header:Header):void
		{
			super.setHeaderStyles(header);
			header.padding = 0;
			header.minHeight = sizes.toolbar;
			header.backgroundSkin.height = sizes.toolbar;
		}
		
		
		override protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);
			//var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
			//backgroundSkin.visible = false
			//list.backgroundSkin = backgroundSkin;
		}
		
		override protected function setCalloutStyles(callout:Callout):void
		{
	/*		var backgroundSkin:Image = new Image(Assets.getItemTextures("selected"));
			backgroundSkin.scale9Grid = new Rectangle(Math.floor(backgroundSkin.width/2)-1, Math.floor(backgroundSkin.height/2)-1, 2, 2);
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;
			*/
			var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutArrowOverlapGap;
			
			var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutArrowOverlapGap;
			
			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutArrowOverlapGap;
			
			var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutArrowOverlapGap;
			
		//	callout.padding = this.smallGutterSize*2;
		}
		
		
		/**
		 * Initializes font sizes and formats.
		 */
		override protected function initializeFonts():void
		{
			this.smallFontSize = uint(sizes.orginalFontSize*0.8);//18
			this.regularFontSize = sizes.orginalFontSize;//24
			this.largeFontSize = uint(sizes.orginalFontSize*1.2);//28
			this.extraLargeFontSize = uint(sizes.orginalFontSize*1.4);//36
			
			//these are for components that don't use FTE
			this.scrollTextTextFormat = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_TEXT_COLOR);
			this.scrollTextDisabledTextFormat = new TextFormat(FONT_NAME, this.regularFontSize, DISABLED_TEXT_COLOR);
			
			this.regularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			this.boldFontDescription = new FontDescription(FONT_NAME, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			
			this.headerElementFormat = new ElementFormat(this.boldFontDescription, this.extraLargeFontSize, LIGHT_TEXT_COLOR);
			this.headerDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.extraLargeFontSize, DISABLED_TEXT_COLOR);
			
			this.darkUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
			this.lightUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
			this.selectedUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, SELECTED_TEXT_COLOR);
			this.lightUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);
			this.darkUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);
			
			this.largeUIDarkElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
			this.largeUILightElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
			this.largeUISelectedElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, SELECTED_TEXT_COLOR);
			this.largeUIDarkDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DARK_DISABLED_TEXT_COLOR);
			this.largeUILightDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);
			
			this.darkElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
			this.lightElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
			this.disabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);
			
			this.smallLightElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, LIGHT_TEXT_COLOR);
			this.smallDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, DISABLED_TEXT_COLOR);
			
			this.largeDarkElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
			this.largeLightElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
			this.largeDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);
		}
	}
}