package com.gerantech.islamic.models.vo.media
{
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.views.buttons.HoldButton;
	
	import starling.display.BlendMode;
	

	public class Breakpoint extends HoldButton
	{
		public var juze:uint;
		public var page:uint;
		public var sura:uint;
		public var aya:Aya;
		/*public var verse:uint;
		public var order:uint;
		public var start:uint;
		public var end:uint;*/
		public var time:uint;
		public var length:uint;
		
		
		public function Breakpoint()
		{
			blendMode = UserModel.instance.nightMode ? BlendMode.MULTIPLY : BlendMode.SCREEN ;	
		}

		public function sync(_br:Breakpoint):void
		{
			/*start = _br.start;
			end = _br.end;
			order = _br.order;
			verse = _br.verse;
			sura = _br.sura;*/
			aya = _br.aya;
			time = _br.time;
			length = _br.length;
		}
		
		/*public function draw(x:Number, y:Number, width:Number, height:Number, color:uint=16777215, premultipliedAlpha:Boolean=true):void
		{
			var quad:Button = new Button(Assets.getTexture("toolbar_background_skin"), "", Assets.getTexture("toolbar_background_skin"));
			quad.x = x;
			quad.y = y;
			quad.width = width;
			quad.height = height;
			addChild(quad);
			alpha = 0.3
		}*/
		
		public function toString():String
		{
			return("Start: "+ aya.start +"  End:"+ aya.end +"  Order: "+ aya.order +"  Sura: "+ aya.sura +"  Aya: "+ aya.aya +"  Time: "+ time +"  Length: "+ length);
		}
	}
}