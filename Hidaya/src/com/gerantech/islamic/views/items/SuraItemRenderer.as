package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;
	import starling.filters.ColorMatrixFilter;

	public class SuraItemRenderer extends BaseCustomItemRenderer
	{
		private var sura:Sura;
		private var _height:Number;
		private var myLayout:HorizontalLayout;
		
		
		private var layoutGroup:LayoutGroup;
		private var suraImage:ImageLoader;
/*		private var indexLabel:Label;
		private var orderLabel:Label;
		private var pageLabel:Label;
		private var ayaLabel:Label;*/
		
		private var meccanImage:ImageLoader;
		private var medinanImage:ImageLoader;
		
		private var first:Boolean;
		private var suraType:String;

		private var textRenderer:RTLLabel;
		private var indexText:RTLLabel;

		private var spacer:LayoutGroup;
		
		
		override protected function initialize():void
		{
			super.initialize();
			_height = AppModel.instance.suraItemHeight;
			if(AppModel.instance.width/_height<6.7)
				_height = AppModel.instance.width/6.7;
			
			var fontSize:uint = uint(_height/2.8);

			deleyCommit = true;
			
			backgroundSkin = new Quad(1, 1, BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			
			myLayout = new HorizontalLayout();
			myLayout.padding = appModel.border;
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
		//	myLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT
			layout = myLayout;
			
			textRenderer = new RTLLabel("32 322 234", BaseMaterialTheme.PRIMARY_TEXT_COLOR, "justify", "rtl", true, "justify", fontSize, "mequran");

		//	textRenderer = new TextBlockTextRenderer();
			textRenderer.width = _height*2.4+appModel.border;
			//textRenderer.text = "32 322 234";
			//var fd:FontDescription = new FontDescription( "mequran", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF );
			//textRenderer.wordWrap = true;
			//textRenderer.leading = 48
			//textRenderer.textJustifier = new SpaceJustifier( "ar", LineJustification.ALL_INCLUDING_LAST );
			//textRenderer.textAlign = TextBlockTextRenderer.TEXT_ALIGN_RIGHT;
			//textRenderer.elementFormat = new ElementFormat(fd, fontSize, 0x000000);
			addChild(textRenderer);
			
			spacer = new LayoutGroup();
			spacer.layoutData = new HorizontalLayoutData(100, NaN);
			addChild(spacer);
			spacer.visible = false;
			
			suraImage = new ImageLoader();
			suraImage.delayTextureCreation = true;
			suraImage.height = _height*0.56;
			suraImage.scaleX = suraImage.scaleY;
			addChild(suraImage);
			
			if(userModel.nightMode)
			{
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
				colorFilter.invert();
				suraImage.filter = colorFilter;
			}
						
			layoutGroup = new LayoutGroup();
			layoutGroup.width = layoutGroup.height = _height;
			layoutGroup.layout = new AnchorLayout();
			addChild(layoutGroup);
			
			meccanImage = new ImageLoader();
			meccanImage.delayTextureCreation = true;
			meccanImage.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			meccanImage.source = Assets.getTexture("meccan_icon");
			meccanImage.width = meccanImage.height = _height*0.6;
			
			medinanImage = new ImageLoader();
			medinanImage.delayTextureCreation = true;
			medinanImage.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			medinanImage.source = Assets.getTexture("medinan_icon");
			medinanImage.width = medinanImage.height = _height*0.6;

			indexText = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, "center", null, false, null, fontSize*0.8, "mequran");
			indexText.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			layoutGroup.addChild(indexText);
			
			/*indexLabel = new Label();
			//indexLabel.backgroundSkin = new Image(Assets.getTexture("circle_icon"));
			indexLabel.width = _height;
			indexLabel.height = _height;
			addChild(indexLabel)*/
		}
		
		override protected function commitData():void
		{
			if(this._data==null || this._owner==null)
				return;
			
			first = (sura==null);
			sura = _data as Sura;
			
			if(sura.sura_texture==null)
				sura.sura_texture = Assets.getTexture(sura.sura.toString());
			
			//backgroundSkin = new Quad(AppModel.instance.width, _height, !isSelected?0xFFFFFF:0xAAFFFF);
			suraImage.source = sura.sura_texture;
			//suraImage.readjustSize();
			indexText.text = sura.sura.toString();//StrTools.getNumberFromLocale(sura.index);
			super.commitData();
			if(first)
				commitBeforeStopScrolling();
		}
		
		override protected function commitBeforeStopScrolling():void
		{
			super.commitBeforeStopScrolling();
			//	var orderStr:String = sura.order.toString()//StrTools.getNumberFromLocale(sura.order);
			//	var numStr:String = sura.numAyas.toString()//StrTools.getNumberFromLocale(sura.numAyas);
			//	var pageStr:String = sura.page.toString()//StrTools.getNumberFromLocale(sura.page);
			//	var sum:uint = pageStr.length+numStr.length+orderStr.length;
			var gap:String = ""//getSpace(sum)
			var padding:String = " ";//getSpace(sum*2)
			textRenderer.text = getThreeChared(sura.order) + gap + getThreeChared(sura.numAyas) + gap + getThreeChared(sura.page) + padding;
			
			if(suraType!=sura.type)
			{
				if(suraType!=null)
					layoutGroup.removeChild(this[suraType+"Image"]);
				suraType = sura.type;
				layoutGroup.addChildAt(this[suraType+"Image"], 0);
				//layoutGroup.addChild(suraType=="meccan" ? meccanImage : medinanImage);
				//orderLabel.backgroundSkin = suraType=="meccan" ? meccanImage : medinanImage;
			}
		}

		
		private function getThreeChared(value:uint):String
		{
			if(value<10)
				return "   "+value+"   ";
			else if(value<100)
				return "  "+value+"  ";
			else
				return " "+value+" ";
		}
		
		private function getSpace(length:int):String
		{
			length /= 3;
			var ret:String = " ";
			for(var i:uint=0; i<3-length; i++)
				ret += " ";
			return ret;
		}
		
		override public function set currentState(value:String):void
		{
			var lastState:String = super.currentState;
			super.currentState = value;
			
			if(value==lastState)
				return;
			//	trace(value)
			backgroundSkin = new Quad(10, 10, value==STATE_SELECTED?BaseMaterialTheme.SELECTED_BACKGROUND_COLOR:BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
		}
	}
		
}