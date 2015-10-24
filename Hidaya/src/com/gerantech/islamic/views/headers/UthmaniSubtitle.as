package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.models.vo.Juze;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	public class UthmaniSubtitle extends BaseSubtitle
	{
		private var juzeImage:ImageLoader;
		private var suraImage:ImageLoader;
		private var numLabel:RTLLabel;
				
		public function UthmaniSubtitle()
		{			
			layout = new AnchorLayout();
			
			if(userModel.navigationMode.value=="page_navi" || userModel.navigationMode.value=="juze_navi")
			{
				juzeImage = new ImageLoader()
				if(userModel.navigationMode.value=="juze_navi")
					juzeImage.layoutData = new AnchorLayoutData(_height/5, NaN, _height/5, NaN, 0, 0);
				else
					juzeImage.layoutData = new AnchorLayoutData(_height/4.5, NaN, _height/4.5, _height/4.5, NaN, 0);
				addChild(juzeImage);
			}
			if(userModel.navigationMode.value=="page_navi")
			{
				numLabel = new RTLLabel("", 0, "center", null, false, null, appModel.sizes.orginalFontSize*1.4, "mequran");
				numLabel.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0, 0, 0);
				addChild(numLabel);
			}
			if(userModel.navigationMode.value=="page_navi" || userModel.navigationMode.value=="sura_navi")
			{
				suraImage = new ImageLoader();
				if(userModel.navigationMode.value=="sura_navi")
					suraImage.layoutData = new AnchorLayoutData(_height/5, NaN, _height/5, NaN, 0, 0);
				else
					suraImage.layoutData = new AnchorLayoutData(_height/5, _height/5, _height/5, NaN, NaN, 0);
				addChild(suraImage);
			}
		}
		
		public function update(data:BaseQData):void
		{
			if(numLabel)
				numLabel.text = (data.index+1).toString();
			if(suraImage)
				suraImage.source = Assets.getTexture(data.sura.toString());//StrTools.getZeroNum((sura-1).toString(), 3)
			if(juzeImage)
				juzeImage.source = Assets.getTexture("j_"+Juze.getByPage(data.page).juze);

		}
	}
}