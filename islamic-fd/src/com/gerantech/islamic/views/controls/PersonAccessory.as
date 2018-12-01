package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.Person;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class PersonAccessory extends LayoutGroup
	{
		public var iconScale:Number = 0.7;
		private var state:String = "";
		private var slider:CicularProgressBar2;
		private var icon:ImageLoader;
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			slider = new CicularProgressBar2();
			slider.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(slider);
	
			icon = new ImageLoader();
			icon.layoutData = new AnchorLayoutData(NaN,NaN,NaN,NaN,0,0);
			icon.source = getTexture();
			addChild(icon);

			addEventListener(FeathersEventType.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		private function creationCompleteHandler():void
		{
			icon.width = icon.height = iconScale*height;
		}
		
		public function setPercent(value:Number):void
		{
			slider.value = value;
		}
		
		public function setState(value:String, animationTime:Number=0):void
		{
			if(state==value)
				return;
			
			state = value;
			
			if(icon == null)
				return;
			
			slider.visible = state==Person.LOADING;
			if(slider.visible)
				setPercent(0);
			
			icon.source = getTexture();
			Starling.juggler.removeTweens(icon);
			if(animationTime>0)
			{
				icon.width = icon.height = height*iconScale*1.4;
				var tw:Tween = new Tween(icon, animationTime, Transitions.EASE_OUT_ELASTIC);
				tw.delay = 0.02;
				tw.animate("width", height*iconScale);
				tw.animate("height", height*iconScale);
				if(value==Person.PREPARING)
					tw.repeatCount = 10;
				Starling.juggler.add(tw);
			}
			else
				icon.width = icon.height = height*iconScale;
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
	}
}