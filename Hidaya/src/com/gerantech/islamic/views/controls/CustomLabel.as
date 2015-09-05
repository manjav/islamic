package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.UserModel;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.LineJustification;
	import flash.text.engine.SpaceJustifier;
	
	import feathers.controls.text.TextBlockTextRenderer;
	
	public class CustomLabel extends TextBlockTextRenderer
	{

		private var fontDescription:FontDescription;
		
		public function CustomLabel()
		{
			//validateFormat();
		}
		
		private function validateFormat():void
		{
			fontDescription = new FontDescription(_fontName, _fontWeight, _fontPosture, FontLookup.EMBEDDED_CFF );
			elementFormat = new ElementFormat(fontDescription, _fontSize, _color);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			text = "";
			textJustifier = new SpaceJustifier( "ar", LineJustification.UNJUSTIFIED );
		}
		
		private var _fontWeight:String = FontWeight.NORMAL;
		private var _fontPosture:String = FontPosture.NORMAL;
		private var _fontName:String = "SourceSansPro"
		private var _textAlignLast:String = "left"
		private var _fontSize:Number = UserModel.instance.fontSize;
		private var _color:uint;
		
		
		/**
		 * FONTWEIGHT _____________________________
		 **/
		public function set fontWeight(value:String):void
		{
			if(_fontWeight==value)
				return;
			
			_fontWeight = value;
			validateFormat();
		}
		public function get fontWeight():String
		{
			return _fontWeight;
		}
		
		/**
		 * FONTPOSTURE _____________________________
		 **/
		public function set fontPosture(value:String):void
		{
			if(_fontPosture==value)
				return;
			
			_fontPosture = value;
			validateFormat();
		}
		public function get fontPosture():String
		{
			return _fontPosture;
		}
		
		/**
		 * FONTNAME _____________________________
		 **/
		public function set fontName(value:String):void
		{
			if(_fontName==value)
				return;
			
			_fontName = value;
			validateFormat();
		}
		public function get fontName():String
		{
			return _fontName;
		}
		
		/**
		 * FONTSIZE _____________________________
		 **/
		public function set fontSize(value:uint):void
		{
			if(_fontSize==value)
				return;
			
			_fontSize = value;
			validateFormat();
		}
		public function get fontSize():uint
		{
			return _fontSize;
		}
		
		/**
		 * COLOR _____________________________
		 **/
		public function set color(value:uint):void
		{
			if(_color==value)
				return;
			
			_color = value;
			validateFormat();
		}
		public function get color():uint
		{
			return _color;
		}
		
		override public function set textAlign(value:String):void
		{
			//textJustifier = new SpaceJustifier("en", value==TextAlign.JUSTIFY?LineJustification.ALL_BUT_LAST : LineJustification.UNJUSTIFIED)
			super.textAlign = value;
			//validateFormat();
		}
		override public function get textAlign():String
		{
			return super.textAlign;
		}	
		
		public function set textAlignLast(value:String):void
		{
			if(super.textAlign!="justify" || _textAlignLast==value)
				return;
			_textAlignLast = value;
		//	textJustifier = new SpaceJustifier("en", value==TextAlign.JUSTIFY?LineJustification.ALL_INCLUDING_LAST : LineJustification.UNJUSTIFIED)
		}
		public function get textAlignLast():String
		{
			return _textAlignLast;
		}	
		
		public function set direction(value:String):void
		{
			bidiLevel = value=="ltr" ? 0 : 1;
		}
		public function get direction():String
		{
			return bidiLevel==0 ? "ltr" : "rtl";
		}
		
		
	}
	
	
}