package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Person;
	
	import feathers.controls.LayoutGroup;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class PersonAccessory extends LayoutGroup
	{
		public var iconScale:Number = 0.7;
		
		private var image:Image;
		private var state:String = Person.HAS_FILE;
		private var _height:Number;
		private var container:Sprite;
		private var slider:CicularProgressBar;
		
		public function PersonAccessory(state:String="hasFile")
		{
			super();
			this.state = state;
			addEventListener(Event.RESIZE, resizeHandler);
		}

		
		override protected function initialize():void
		{
			super.initialize();
			
			slider = new CicularProgressBar();
			addChildAt(slider, 0);
	
			container = new Sprite();
			addChild(container);
			
			image = new Image(getTexture());
			image.pivotX = image.width/2;
			image.pivotY = image.height/2;
			//image.alpha = 0.2;
			container.addChild(image);
			/*setInterval(setPercenta, 100);
			
		}
		
		private function setPercenta():void
		{
			slider.drawPieMask(asad, _height/2, _height/1.8);
			asad += 0.01;*/
		}
		
		public function setPercent(value:Number):void
		{
			//slider.percent = Math.max(Math.min(value, 1), 0);
			slider.drawPieMask(value, _height/2, _height/1.8);
		}
		
		public function setState(value:String, time:Number=0):void
		{
			if(state==value)
				return;
			
			state = value;
			
			if(image==null)
				return;
			
			slider.visible = state==Person.LOADING;
			if(slider.visible)
				setPercent(0);
			
			image.texture = getTexture();
			Starling.juggler.removeTweens(image);
			if(time>0)
			{
				image.width = image.height = _height*iconScale*1.4;
				var tw:Tween = new Tween(image, time, Transitions.EASE_OUT_ELASTIC);
				tw.delay = 0.02;
				tw.animate("width", _height*iconScale);
				tw.animate("height", _height*iconScale);
				//var tw:TweenMax = TweenMax.to(image, time, {delay:0.02, width:_height*iconScale, height:_height*iconScale, ease:Elastic.easeOut});//, onUpdate:resizeHandler, onUpdateParams:[null]
				if(value==Person.PREPARING)
					tw.repeatCount = 10;
					//tw.yoyo = true;
				Starling.juggler.add(tw);
			}
			else
				image.width = image.height = _height*iconScale;
		}
		
		private function getTexture():Texture
		{
			switch(state)
			{
				case Person.NO_FILE:							return Assets.getTexture("download");
				case Person.LOADING:case Person.PREPARING:		return Assets.getTexture("cancel_download");
				case Person.HAS_FILE:							return Assets.getTexture("check_off");
				case Person.SELECTED:							return Assets.getTexture("check_on");
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
			if(slider)
				slider.radius = _height/2.2
			if(container)
				container.y = container.x = _height/2
				
		}
		
		
	}
}