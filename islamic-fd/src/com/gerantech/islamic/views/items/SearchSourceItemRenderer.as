package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;

	public class SearchSourceItemRenderer extends SettingItemRenderer
	{
		private var translator:Translator;
		public function SearchSourceItemRenderer(height:Number=0)
		{
			super(height);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			//addChild(appModel.ltr?iconDisplay:titleDisplay);
			//addChild(appModel.ltr?titleDisplay:iconDisplay);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			if(iconDisplay == null)
				addElements(true);
			translator = _data as Translator;
			
			titleDisplay.text = translator.name;
			if(translator.iconTexture != null)
				translator_iconLoaded();
			else
			{
				translator.addEventListener(Person.ICON_LOADED, translator_iconLoaded);
				translator.loadImage();
			}
		}
		
		private function translator_iconLoaded():void
		{
			translator.removeEventListener(Person.ICON_LOADED, translator_iconLoaded);
			iconDisplay.source = translator.iconTexture;
		}
	}
}