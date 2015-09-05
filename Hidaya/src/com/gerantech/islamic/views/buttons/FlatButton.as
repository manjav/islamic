package com.gerantech.islamic.views.buttons
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	
	public class FlatButton extends SimpleLayoutButton
	{
		
		public var hitAlphaNormal:Number = 0;
		public var hitAlphaDown:Number = 0.3;
		
		private var _iconHorizontalCenter:Number = 0;
		private var _iconVerticalCenter:Number = 0;

		public var icon:ImageLoader;
		private var _iconScale:Number = 0.8;
		
		public function get iconVerticalCenter():Number
		{
			return _iconVerticalCenter;
		}
		public function set iconVerticalCenter(value:Number):void
		{
			_iconVerticalCenter = value;
			if(icon)
				icon.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, iconHorizontalCenter, iconVerticalCenter);
		}

		public function get iconHorizontalCenter():Number
		{
			return _iconHorizontalCenter;
		}
		public function set iconHorizontalCenter(value:Number):void
		{
			_iconHorizontalCenter = value;
			if(icon)
				icon.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, iconHorizontalCenter, iconVerticalCenter);
		}

		public function get iconScale():Number
		{
			return _iconScale;
		}

		public function set iconScale(value:Number):void
		{
			_iconScale = value;
			draw();
		}

		public function set texture(value:Object):void
		{
			if(value is String)
			{
				if(String(value).indexOf(".")>-1)
				{
					//icon.addEventListener("complete", sss);
					icon.source = value;
				}
				else
					icon.source = Assets.getTexture(value as String);
			}
			else if(value is Texture)
				icon.source = value;

			draw();
		}		
/*		
		private function sss():void
		{
			draw();
			trace(icon.source)
		}*/
		
		
		override protected function draw():void
		{
			icon.width = actualWidth*iconScale;
			icon.height = actualHeight*iconScale;
		//	trace(icon.source, icon.width, icon.height, icon.alpha, icon.visible, icon.parent)
			super.draw();
			
		}
		
				
		public function FlatButton(texture:Object=null, hit:String=null, autoHit:Boolean=false, hitAlphaNormal:Number=0, hitAlphaDown:Number=0.3, hitColor:uint=16777215)
		{
			layout = new AnchorLayout();
			this.hitAlphaNormal = hitAlphaNormal;
			this.hitAlphaDown = hitAlphaDown;
			width = height = AppModel.instance.theme.controlsSize;
			if(hit!=null)
			{
				backgroundSkin = new Image(Assets.getTexture(hit));
			}
			else if(autoHit)
			{
				backgroundSkin = new Quad(1,1, hitColor);
				backgroundSkin.alpha = hitAlphaNormal;
			}
			
			icon = new ImageLoader();
			icon.delayTextureCreation = true;
			icon.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, iconHorizontalCenter, iconVerticalCenter);
			addChild(icon);
			if(texture!=null)
				this.texture = texture;
			
		}

		
		override public function set currentState(value:String):void
		{
			if(super.currentState == value)
				return;
			
			super.currentState = value;
			
			if(backgroundSkin!=null)
				backgroundSkin.alpha = value==STATE_DOWN ? hitAlphaDown:hitAlphaNormal;
		}
		
	}
}