package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	import com.greensock.TweenLite;
	
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.display.Quad;

	public class SearchItemRenderer extends BaseCustomItemRenderer
	{
		private var bookmark:Bookmark;
		private var openButton:FlatButton;
		
		private var nameDisplay:RTLLabel;
		private var quranTextField:RTLLabel;

		private var myLayout:VerticalLayout;
		private var title:String;
		private var numItems:uint;
		
		public function SearchItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			isQuickHitAreaEnabled = true;
		//	backgroundSkin = new Scale9Image(Assets.getItemTextures(STATE_NORMAL));
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			
			deleyCommit = true;
			
			myLayout = new VerticalLayout();
			myLayout.padding = appModel.sizes.border*4;
			myLayout.paddingTop = appModel.sizes.border*2;
			layout = myLayout;
			
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0, null, "bold");
			nameDisplay.layoutData = new VerticalLayoutData(100);
			addChild(nameDisplay);

			quranTextField = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "justify", "rtl", true, "right", 0.9);
			quranTextField.layoutData = new VerticalLayoutData(100);
			addChild(quranTextField);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			
			bookmark = Bookmark.getFromObject(_data);
			numItems = (bookmark.colorList.length-1)/2;

			if(bookmark.index==0)
				myLayout.paddingTop = appModel.sizes.border*2+appModel.sizes.DP24;
			
			var sura:Sura = ResourceModel.instance.suraList[bookmark.sura-1];
			title = StrTools.getNumberFromLocale(index+1)+". "+loc("sura_l")+" "+(appModel.ltr?(sura.tname+","):sura.name)+" "+loc("verse_l")+" "+ StrTools.getNumberFromLocale(bookmark.aya);
			if(numItems>1)
				title += ("  -  " + StrTools.getNumberFromLocale(numItems) + " " + loc("search_one"));
			nameDisplay.text = title;
			
			quranTextField.visible = false;
			quranTextField.height = numItems*appModel.sizes.orginalFontSize*1.3;
			
			super.commitData();
		}
		
		override protected function commitAfterStopScrolling():void
		{
	//		var text:String = ResourceModel.instance.simpleQuran[bookmark.sura-1][bookmark.aya-1];
			if(bookmark.processedText==null)
				bookmark.processedText = changeColor(bookmark.text);
			
			quranTextField.text = bookmark.processedText;
			quranTextField.visible = true;
			quranTextField.alpha = 0;
			TweenLite.to(quranTextField, 0.3, {alpha:1});
		}
		
		/*override public function set currentState(value:String):void
		{
			if(super.currentState == value)
				return;
			super.currentState = value;
			backgroundSkin = new Scale9Image(Assets.getItemTextures(value));
		}
*/
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			if(value==lastState)
				return;
			//	trace(value)
			backgroundSkin = new Quad(10, 10, value==STATE_SELECTED?BaseMaterialTheme.SELECTED_BACKGROUND_COLOR:BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
		}
		
		
		private function changeColor(str:String):String
		{
			var ret:String = "";
			if(bookmark.colorList)
			{//trace(bookmark.colorList)
				var len:uint = bookmark.colorList.length;
				//ret = "... " + str.substring(bookmark.colorList[1]-20, bookmark.colorList[1]) ;
				for(var i:uint=1; i<len; i+=2)
				{
					ret += ("... " + str.substring(bookmark.colorList[i]-20, bookmark.colorList[i])+ " \"" + str.substring(bookmark.colorList[i], bookmark.colorList[i+1]) + "\" " + str.substr(bookmark.colorList[i+1], 20) + " ...\n");
					//if(i<len-2)
					//	ret += str.substr(bookmark.colorList[i+1], 20) + " ...\n";
				}
				//ret += str.substr(bookmark.colorList[len-1], 20) + " ...";
			}//trace(ret)
			return ret;
		}
	}
}