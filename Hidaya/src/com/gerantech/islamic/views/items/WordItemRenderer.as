package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.vo.Word;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	public class WordItemRenderer extends BaseCustomItemRenderer
	{
		private var wordDisplay:RTLLabel;
		private var word:Word;

		
		override protected function initialize():void
		{
			super.initialize();
			isQuickHitAreaEnabled = true;
			//backgroundSkin = new Scale9Image(Assets.getItemTextures(STATE_NORMAL));
			height = uint(appModel.sizes.twoLineItem*0.7);
			layout = new AnchorLayout();
			
			wordDisplay = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "right", "rtl", false, null, 0, null, "bold");
			wordDisplay.layoutData = new AnchorLayoutData(appModel.sizes.border, appModel.sizes.border*2, appModel.sizes.border*2, appModel.sizes.border);
			addChild(wordDisplay);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			super.commitData();

			word = _data as Word;
			wordDisplay.text = word.text + " ( " + StrTools.getArabicNumber(word.count.toString()) + " )";
		
		}
		
	}
}