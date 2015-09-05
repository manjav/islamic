package com.gerantech.islamic.skins
{
	import feathers.controls.Button;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.textures.Scale9Textures;
	import feathers.themes.MetalWorksMobileTheme;
	
	import flash.geom.Rectangle;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;
	
	public class CustomMetalWorksTheme extends MetalWorksMobileTheme
	{
		public static const CUSTOM_BUTTON:String = "my-custom-button";
		
		[Embed(source="assets/murguz/ChangaOne-Regular.ttf", embedAsCFF="true", fontFamily="Changa One", fontName="Changa One")]
		public static const CHANGE_ONE:Class;
		
		[Embed(source="assets/murguz/button_up.png")]
		private static var buttonUp:Class;
		public static var buttonUpTexture:Texture;
		
		[Embed(source="assets/murguz/button_down.png")]
		private static var buttonDown:Class;
		public static var buttonDownTexture:Texture;
		
		public function CustomMetalWorksTheme(container:DisplayObjectContainer=null, scaleToDPI:Boolean=true)
		{
			super(container, scaleToDPI);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// set new initializers here
			this.setInitializerForClass( Button, mySimpleButtonInitializer, CUSTOM_BUTTON );
		}
		
		protected function mySimpleButtonInitializer(button:Button):void
		{
			// Setting Background Texture
			buttonUpTexture = Texture.fromBitmap(new buttonUp());
			buttonDownTexture = Texture.fromBitmap(new buttonDown());
			var rect:Rectangle = new Rectangle(5, 5, 50, 50);
			var default_texture:Scale9Textures = new Scale9Textures( buttonUpTexture, rect );
			var down_texture:Scale9Textures = new Scale9Textures( buttonDownTexture, rect );
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = default_texture;
			skinSelector.setValueForState(down_texture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
				{
					width: 60 * this.scale,
					height: 60 * this.scale,
					textureScale: this.scale
				};
			button.stateToSkinFunction = skinSelector.updateValue;
			button.minWidth = button.minHeight = 60 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
			
			// Setting Font Details
			this.regularFontDescription = new FontDescription("Changa One", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.NORMAL, CFFHinting.HORIZONTAL_STEM);
			
			button.defaultLabelProperties.elementFormat  = new ElementFormat(this.regularFontDescription, 25 * this.scale, 0xffffff);
			button.defaultLabelProperties.embedFonts = true;
			
			button.downLabelProperties.elementFormat  = new ElementFormat(this.regularFontDescription, 25 * this.scale, 0xffffff);
			button.downLabelProperties.embedFonts = true;
			button.defaultSelectedLabelProperties.elementFormat  = new ElementFormat(this.regularFontDescription, 25 * this.scale, 0xffffff);
			button.defaultSelectedLabelProperties.embedFonts = true;
		}
	}
}