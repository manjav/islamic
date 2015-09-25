package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.models.vo.Juze;
	
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	public class UthmaniSubtitle extends BaseSubtitle
	{
		private var juzeImage:ImageLoader;
		private var suraImage:ImageLoader;
		private var numLabel:TextBlockTextRenderer;
				
		public function UthmaniSubtitle()
		{			
			layout = new AnchorLayout();
			
			juzeImage = new ImageLoader()
			juzeImage.layoutData = new AnchorLayoutData(_height/4.5, NaN, _height/4.5, _height/4.5, NaN, 0);
			addChild(juzeImage);

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
			suraImage.layoutData = new AnchorLayoutData(_height/5, _height/5, _height/5, NaN, NaN, 0);
			addChild(suraImage);
		}
		
		public function update(data:BaseQData):void
		{
			if(numLabel)
				numLabel.text = (data.index+1).toString();
			suraImage.source = Assets.getTexture(data.sura.toString());//StrTools.getZeroNum((sura-1).toString(), 3)
			juzeImage.source = Assets.getTexture("j_"+Juze.getByPage(data.page).juze);

		}
	}
}