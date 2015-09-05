package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import flash.text.TextFormat;
	
	import feathers.controls.text.TextFieldTextRenderer;
	
	public class LTRLable extends TextFieldTextRenderer
	{
		private var align:String;
		private var fontFamily:String;
		private var fontSize:uint;
		private var color:uint;
		
		public function LTRLable(text:String, color:uint=0, align:String=null, wordWrap:Boolean=false, fontSize:uint=0, fontFamily:String=null, bold:Boolean=false, italic:Boolean=false)
		{
			embedFonts = true;
			this.align = align==null ? AppModel.instance.align : align;
			this.fontFamily = fontFamily==null ? "SourceSans" : fontFamily;
			this.fontSize = fontSize==0 ? UserModel.instance.fontSize : fontSize;
			this.color = color==0 ? BaseMaterialTheme.PRIMARY_TEXT_COLOR : color;
			this.wordWrap = wordWrap;
			textFormat = new TextFormat(this.fontFamily, this.fontSize, this.color, bold, italic, null, null, null, align, null, null, null);//, -fontSize/1.2
		}
		
		
		public function get isTruncated():Boolean
		{
			if(textField==null)
				return false;
			
			return textField.textWidth>=width;
		}
	}
}