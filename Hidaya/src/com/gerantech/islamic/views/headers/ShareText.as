package com.gerantech.islamic.views.headers
{

	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Translator;
	import com.gerantech.islamic.utils.StrTools;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class ShareText
	{
		private var aya:Aya;
		private var shareTitle:String;
		private var shareText:String;
		private var personIndex:uint;

		private var rm:IResourceManager;
		private var currentPerson:Translator;

		public function ShareText(aya:Aya)
		{
			this.aya = aya;
			rm = ResourceManager.getInstance();
			shareTitle = rm.getString("loc", "sura_l") + " " + aya.suraObject.localizedName + " " + rm.getString("loc", "verse_l") + " " + StrTools.getNumberFromLocale(aya.aya.toString());
			shareText = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n\n" + aya.text;
			personIndex = 0;
			addPersonText();

		}
		
		private function addPersonText():void
		{
			if(personIndex == ResourceModel.instance.selectedTranslators.length)
			{trace(shareTitle, shareText)
				if(AppModel.instance.isAndroid)
					NativeAbilities.instance.shareText(shareTitle, shareText);
				return;
			}
			currentPerson = Translator(ResourceModel.instance.selectedTranslators[personIndex]);
			currentPerson.getAyaText(aya, ayaResponder);
		}
		
		private function ayaResponder(txt:String):void
		{
			shareText += ("\n\n" + txt + "\n" + rm.getString("loc", "trans_t") + " " + currentPerson.name) ;
			shareText += ("\n\n" + rm.getString("loc", "share_sign") + " " + rm.getString("loc", "app_title"));
			personIndex ++;
			addPersonText();
		}
	}
}