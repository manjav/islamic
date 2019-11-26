package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.UserModel;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class IndexLabel extends Label
	{
		public function IndexLabel()
		{
			super();
			textRendererFactory = function():ITextRenderer
			{
				var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				renderer.embedFonts = true;
				renderer.textFormat = new TextFormat( "SourceSansPro", UserModel.instance.fontSize, 0,
					null, null, null, null, null, TextFormatAlign.CENTER );
				
				return renderer;
			}
		}
		
		
	}
}