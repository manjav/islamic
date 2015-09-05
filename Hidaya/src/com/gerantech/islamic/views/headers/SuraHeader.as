package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Sura;
	
	import feathers.display.Scale3Image;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class SuraHeader extends Sprite
	{

		private var scale3Image:Scale3Image;
		private var suraImage:Image;
		public function SuraHeader(sura:Sura, _width:Number, _height:Number)
		{
			/*scale3Image = new Scale3Image(Assets.getScale3Textures("sura_header", 254,4));
			scale3Image.width = _width;
			scale3Image.height = _height
			addChild(scale3Image);*/
			
			suraImage = new Image(Assets.getTexture(sura.sura.toString()));
			suraImage.height = uint(_height*0.7);
			suraImage.scaleX = suraImage.scaleY;
			suraImage.x = (_width-suraImage.width)/2;
			suraImage.y = (_height-suraImage.height)/2;
			addChild(suraImage);	
		}
	}
}