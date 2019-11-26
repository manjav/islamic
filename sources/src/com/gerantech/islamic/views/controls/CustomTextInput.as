package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	
	public class CustomTextInput extends TextInput
	{
		public function CustomTextInput(softKeyboardType:String, returnKeyLabel:String, textColor:uint=16777215)
		{
			super();
			
			textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontFamily = "SourceSans";
				editor.textAlign = AppModel.instance.align;
				editor.fontSize = UserModel.instance.fontSize ;
				editor.color = textColor;
				editor.softKeyboardType = softKeyboardType;
				editor.returnKeyLabel = returnKeyLabel;
				return editor;
			}
			
			promptProperties.textAlign = AppModel.instance.align;
			promptProperties.bidiLevel = AppModel.instance.ltr?0:1;
			//backgroundFocusedSkin = null
		}
		
	}
}