package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.filters.ColorMatrixFilter;
	
	public class BismHeader extends LayoutGroup
	{
		private var suraImage:ImageLoader;
		private var bismImage:ImageLoader;
		private var mlayout:AnchorLayout;
		//private var _aya:Aya;

		private var colorFilter:ColorMatrixFilter;
		
		public function BismHeader()
		{
			mlayout = new AnchorLayout();
			//mlayout.gap = AppModel.instance.sizes.border/2;
			layout = mlayout;
			
			touchable = false;
			height = AppModel.instance.sizes.DP24;
			
			colorFilter = new ColorMatrixFilter();
			colorFilter.invert();
			
			/*suraImage = new ImageLoader();
			suraImage.delayTextureCreation = true;
			suraImage.height = height*0.8;
			//suraImage.includeInLayout  = false
			suraImage.layoutData = new AnchorLayoutData(-height,0,NaN,0);
			addChild(suraImage)
			
			if(UserModel.instance.nightMode)
				suraImage.filter = colorFilter;*/
			
			bismImage = new ImageLoader();
			bismImage.delayTextureCreation = true;
			bismImage.source = Assets.getTexture("bism_header", "surajuze");
			bismImage.height = height*0.8;
			bismImage.layoutData = new AnchorLayoutData(NaN,0,0,0);
			addChild(bismImage)
			
			if(UserModel.instance.nightMode)
				bismImage.filter = colorFilter;
		}
		/*
		public function set aya(value:Aya):void
		{
			_aya = value;
			suraImage.source = Assets.getTexture(_aya.sura.toString());
		}*/
	}
}