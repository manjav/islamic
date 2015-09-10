package com.gerantech.islamic.themes
{
	import com.gerantech.islamic.models.AppModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.ToggleButton;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import starling.textures.SubTexture;
	
	public class CustomTheme extends MaterialTheme
	{
		public var controlsSize:int;
		
		public function CustomTheme(scaleToDPI:Boolean=true)
		{
			super(scaleToDPI);
			controlsSize = controlSize;
		}
		
		
		override protected function setPickerListButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);
			
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.pickerListButtonIconTexture;
			//iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
				{
					textureScale: this.scale,
						snapToPixels: true
				}
			button.stateToIconFunction = iconSelector.updateValue;
			
			button.gap = Number.POSITIVE_INFINITY;
			button.minGap = this.gutterSize;
			button.padding = AppModel.instance.border;
			button.iconPosition = Button.ICON_POSITION_LEFT;
			
			
			
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundInsetSkinTextures;
			/*skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
				{
					width: this.controlSize,
						height: this.controlSize,
						textureScale: this.scale
				};*/
			button.stateToSkinFunction = skinSelector.updateValue;
			/*button.hasLabelTextRenderer = false;
			
			button.minWidth = button.minHeight = this.controlSize;
			button.minTouchWidth = button.minTouchHeight = this.gridSize;*/
		}
		
		
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
		
		override protected function setScrollerStyles(scroller:Scroller):void
		{
			super.setScrollerStyles(scroller);
		//	scroller.verticalScrollBarPosition = AppModel.instance.ltr ? Scroller.VERTICAL_SCROLL_BAR_POSITION_RIGHT : Scroller.VERTICAL_SCROLL_BAR_POSITION_LEFT;
		}

		override protected function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			super.setSimpleScrollBarStyles(scrollBar);
			if(scrollBar.direction == SimpleScrollBar.DIRECTION_VERTICAL)
			{
				scrollBar.paddingRight = AppModel.instance.ltr ? this.scrollBarGutterSize : 0;
				scrollBar.paddingLeft = AppModel.instance.ltr ? 0 : this.scrollBarGutterSize;
			}
				
			/*if(scrollBar.direction == SimpleScrollBar.DIRECTION_HORIZONTAL)
			{
				scrollBar.paddingRight = this.scrollBarGutterSize;
				scrollBar.paddingBottom = this.scrollBarGutterSize;
				scrollBar.paddingLeft = this.scrollBarGutterSize;
				scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
			}
			else
			{
				if(AppModel.instance.ltr)
					scrollBar.paddingRight = this.scrollBarGutterSize;
				else
					scrollBar.paddingLeft = this.scrollBarGutterSize;

				scrollBar.paddingTop = this.scrollBarGutterSize;
				scrollBar.paddingBottom = this.scrollBarGutterSize;
				scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
			}*/
		}
		
		
		override protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);
			//var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
			//backgroundSkin.visible = false
			//list.backgroundSkin = backgroundSkin;
		}
	}
}