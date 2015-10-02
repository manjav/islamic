package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Translator;
	
	import mx.resources.ResourceManager;
	
	import starling.events.Event;

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
			addChild(appModel.ltr?iconDisplay:titleDisplay);
			addChild(appModel.ltr?titleDisplay:iconDisplay);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			
			translator = _data as Translator;
			
			titleDisplay.text = translator.name;
			if(translator.iconTexture != null)
				translator_iconLoaded();
			else
			{
				translator.addEventListener(Person.ICON_LOADED, translator_iconLoaded);
				translator.loadImage();
			}
			trace(translator.iconTexture)
		}
		
		private function translator_iconLoaded():void
		{
			trace(translator.iconTexture)
			translator.removeEventListener(Person.ICON_LOADED, translator_iconLoaded);
			iconDisplay.source = translator.iconTexture;
		}
	}
}