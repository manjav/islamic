package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Sura;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class SuraHeader extends Sprite
	{

		private var suraImage:Image;
		public function SuraHeader(sura:Sura, _width:Number, _height:Number)
		{
			suraImage = new Image(Assets.getTexture(sura.sura.toString()));
			suraImage.height = uint(_height*0.7);
			suraImage.scaleX = suraImage.scaleY;
			suraImage.x = (_width-suraImage.width)/2;
			suraImage.y = (_height-suraImage.height)/2;
			addChild(suraImage);	
		}
	}
}