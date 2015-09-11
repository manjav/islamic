package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.models.vo.Juze;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	
	public class UthmaniHeader extends LayoutGroup
	{
		private var juzeImage:ImageLoader;
		private var suraImage:ImageLoader;
		private var numLabel:TextBlockTextRenderer;
		
		public var _height:Number;
		
		public function UthmaniHeader()
		{
			height = _height = uint(AppModel.instance.subtitleHeight);
			backgroundSkin = new Quad(1, 1, UserModel.instance.nightMode ? BaseMaterialTheme.LIGHT_TEXT_COLOR : BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			
			var myLayout:AnchorLayout = new AnchorLayout()
			/*myLayout.paddingTop = myLayout.paddingBottom = _height/10;
			myLayout.paddingLeft = myLayout.paddingRight = _height/5;
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;*/
			layout = myLayout;
			
			/*var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			colorFilter.invert();*/
			
			juzeImage = new ImageLoader()
			//juzeImage.height = uint(_height*0.5);
			//juzeImage.scaleX = juzeImage.scaleY;
			juzeImage.layoutData = new AnchorLayoutData(_height/4.5, NaN, _height/4.5, _height/4.5, NaN, 0);
			addChild(juzeImage);
			
			/*if(UserModel.instance.nightMode)
				juzeImage.filter = colorFilter;*/
			

			if(UserModel.instance.navigationMode.value=="page_navi")
			{
				numLabel = new TextBlockTextRenderer();
				numLabel.textAlign = "center";
				var fontDescription:FontDescription = new FontDescription( "mequran", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE );
				numLabel.elementFormat = new ElementFormat(fontDescription, UserModel.instance.fontSize*1.6, 0);
				numLabel.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0, 0, 0);
				addChild(numLabel);
			}
			suraImage = new ImageLoader();
			//suraImage.height = uint(_height*0.6);
			//suraImage.scaleX = suraImage.scaleY;
			suraImage.layoutData = new AnchorLayoutData(_height/5, _height/5, _height/5, NaN, NaN, 0);
			addChild(suraImage);
			
			/*if(UserModel.instance.nightMode)
				suraImage.filter = colorFilter;*/
		}
		
		public function update(data:BaseQData):void
		{
			if(numLabel)
				numLabel.text = (data.index+1).toString();
			suraImage.source = Assets.getTexture(data.sura.toString());//StrTools.getZeroNum((sura-1).toString(), 3)
			//suraImage.readjustSize()
			juzeImage.source = Assets.getTexture("j_"+Juze.getByPage(data.page).juze);
			//juzeImage.readjustSize()

		}
	}
}