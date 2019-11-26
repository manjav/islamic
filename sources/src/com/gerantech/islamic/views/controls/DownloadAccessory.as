package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.DownloadPackage;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.LayoutGroup;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class DownloadAccessory extends LayoutGroup
	{
		public var iconScale:Number = 0.7;
		
		private var image:Image;
		private var state:String = DownloadPackage.NORMAL;
		private var _height:Number;
		private var container:Sprite;
		
		public function DownloadAccessory()
		{
			super();
			this.state = state;
			addEventListener(Event.RESIZE, resizeHandler);
		}

		
		override protected function initialize():void
		{
			super.initialize();
	
			container = new Sprite();
			addChild(container);
			
			image = new Image(getTexture());
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
			//image.alpha = 0.2;
			container.addChild(image);
		}
		
		public function setState(value:String, time:Number=0, index:uint=0):void
		{
			if(state==value)
				return;
			if(image==null)
				return;
			
			state = value;
			
			Starling.juggler.removeTweens(image);
			image.alpha = 1;
			
			image.texture = getTexture();
			
			if(time>0)
			{
				image.width = image.height = _height*iconScale*1.4;
				var tw:Tween = new Tween(image, time, Transitions.EASE_OUT_ELASTIC);//, {delay:0.02, width:_height*iconScale, height:_height*iconScale, ease:Elastic.easeOut});//, onUpdate:resizeHandler, onUpdateParams:[null]
				tw.delay = 0.02;
				tw.animate("width", _height*iconScale);
				tw.animate("height", _height*iconScale);
				Starling.juggler.add(tw);
			}
			else
				image.width = image.height = _height*iconScale;
			
			if(state==DownloadPackage.DOWNLOADING)
			{
				setTimeout(blink, 0.02+time, 0);
			}
			//trace(index, value, state, image.alpha, image.width, _height, iconScale)
		}
		
		private function blink(alpha:Number=0):void
		{
			var tw:Tween = new Tween(image, 0.5);//, {delay:0.02, width:_height*iconScale, height:_height*iconScale, ease:Elastic.easeOut});//, onUpdate:resizeHandler, onUpdateParams:[null]
			tw.fadeTo(alpha);
			tw.onComplete = blink;
			tw.onCompleteArgs = [alpha==0?1:0];
			Starling.juggler.add(tw);
		}
		
		private function getTexture():Texture
		{
			switch(state)
			{
				case DownloadPackage.DOWNLOADED:	return Assets.getTexture("check");
				case DownloadPackage.DOWNLOADING:	return Assets.getTexture("download_g");
				case DownloadPackage.NORMAL:		return Assets.getTexture("check_off");
				case DownloadPackage.SELECTED:		return Assets.getTexture("check_on");
				case DownloadPackage.WAITING:		return Assets.getTexture("timer_grey");
			}
			return null;
		}
		
		protected function resizeHandler(event:Event):void
		{
			if(event==null)
				return;
			
			_height = width = height;
			if(image)
				image.width = image.height = _height*iconScale;
			
			if(container)
				container.y = container.x = _height/2
				
		}
		
	}
}