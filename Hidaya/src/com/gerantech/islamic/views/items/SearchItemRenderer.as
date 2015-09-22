package com.gerantech.islamic.views.items
{
	import com.greensock.TweenLite;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import mx.resources.ResourceManager;
	
	import feathers.display.Scale9Image;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	public class SearchItemRenderer extends BaseCustomItemRenderer
	{
		private var bookmark:Bookmark;
		private var openButton:FlatButton;
		
		private var nameDisplay:RTLLabel;
		private var quranTextField:RTLLabel;
		
		public function SearchItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			isQuickHitAreaEnabled = true;
			backgroundSkin = new Scale9Image(Assets.getItemTextures(STATE_NORMAL));
			
			
			deleyCommit = true;
			height = appModel.sizes.twoLineItem*2;
			
			var myLayout:VerticalLayout = new VerticalLayout();
			myLayout.padding = appModel.sizes.border*4;
			myLayout.paddingTop = appModel.sizes.border*2;
			layout = myLayout;
			
			/*var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			hLayout.gap = appModel.sizes.border*4;
			hLayout.padding = appModel.sizes.border*2;
			hLayout.paddingBottom = 0;
			
			var header:LayoutGroup = new LayoutGroup();
			header.height = appModel.actionHeight;
			header.layout = hLayout;
			header.layoutData = new VerticalLayoutData(100);
			addChild(header);
			
			openButton = new FlatButton(appModel.ltr?"arrow_right":"arrow_left");
			openButton.addEventListener(Event.TRIGGERED, openButton_triggeredHandler);*/
			
			nameDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, 0, null, "bold");
			nameDisplay.layoutData = new VerticalLayoutData(100);
			addChild(nameDisplay);

			quranTextField = new RTLLabel("", BaseMaterialTheme.DESCRIPTION_TEXT_COLOR, "justify", "rtl", true, "right", uint(UserModel.instance.fontSize*0.86));
			quranTextField.layoutData = new VerticalLayoutData(100, 100);
			addChild(quranTextField);
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			/*if(bookmark==_data)
				return;*/
			
			bookmark = Bookmark.getFromObject(_data);
			var sura:Sura = ResourceModel.instance.suraList[bookmark.sura-1];
			nameDisplay.text = StrTools.getNumberFromLocale(String(index+1)) + ". " + ResourceManager.getInstance().getString("loc", "sura_l")+" "+ (appModel.ltr?(sura.tname+","):sura.name) + " "+ResourceManager.getInstance().getString("loc", "verse_l")+" "+ StrTools.getNumberFromLocale(bookmark.aya);
			quranTextField.visible = false;
			super.commitData();
		}
		
		override protected function commitAfterStopScrolling():void
		{
			var text:String = ResourceModel.instance.simpleQuran[bookmark.sura-1][bookmark.aya-1];
			quranTextField.text = changeColor(text);
			quranTextField.visible = true;
			quranTextField.alpha = 0;
			TweenLite.to(quranTextField, 0.3, {alpha:1});
			
		//	height = Math.min(appModel.sizes.itemHeight*2, quranTextField.height+appModel.sizes.itemHeight)
		}
		
		override public function set currentState(value:String):void
		{
			if(super.currentState == value)
				return;
			super.currentState = value;
			backgroundSkin = new Scale9Image(Assets.getItemTextures(value));
		}

		private function changeColor(str:String):String
		{
			var ret:String = "";
			if(bookmark.colorList)
			{
				var len:uint = bookmark.colorList.length;
				ret = str.substr(0, bookmark.colorList[1]) ;
				for(var i:uint=1; i<len; i+=2)
				{
					ret += ("  [[ " + str.substring(bookmark.colorList[i], bookmark.colorList[i+1]) + " ]]  ");
					if(i<len-2)
						ret += str.substring(bookmark.colorList[i+1], bookmark.colorList[i+2]);
				}
				ret += str.substr(bookmark.colorList[len-1]);
			}
			return ret;
		}
	}
}