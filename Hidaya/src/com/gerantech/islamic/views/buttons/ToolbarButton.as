package com.gerantech.islamic.views.buttons
{
	import com.gerantech.islamic.models.Assets;
	
	import starling.display.Image;

	public class ToolbarButton extends SimpledButton
	{
		
		//private var backgroud:Quad;
		private var backgroundSkin:Image;
		private var icon:Image;
		private var _iconScale:Number = 0.44;
		private var _texture:String;
		private var _buttonHeight:Number = 48;
		private var _buttonWidth:Number = 48;
		public var screens:Array;
		
		public function ToolbarButton(texture:String)
		{
			backgroundSkin = new Image(Assets.getTexture("toolbar_button_bg"));
			backgroundSkin.pivotX = backgroundSkin.width/2;
			backgroundSkin.pivotY = backgroundSkin.height/2;
			backgroundSkin.alpha = 0;
			addChild(backgroundSkin);
			
			if(texture!=null)
				this.texture = texture;
		}
				
		
		public function get buttonWidth():Number
		{
			return _buttonWidth;
		}
		public function set buttonWidth(value:Number):void
		{
			if(_buttonWidth == value)
				return;
			
			_buttonWidth = value;
			draw();
		}

		public function get buttonHeight():Number
		{
			return _buttonHeight;
		}
		public function set buttonHeight(value:Number):void
		{
			if(_buttonHeight == value)
				return;
			
			_buttonHeight = value;
			draw();
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
		
		
		
		public function get texture():String
		{
			return _texture;
		}		
		public function set texture(value:String):void
		{
			if(_texture==value)
				return;
			
			_texture = value;
			
			if(icon==null)
			{
				icon = new Image(Assets.getTexture(value));
				icon.pivotX = icon.width/2
				icon.pivotY = icon.height/2
				addChild(icon);
			}
			else
			{
				icon.texture = Assets.getTexture(value);
			}
			//icon.delayTextureCreation = true;
			draw();
		}
		
		
		protected function draw():void
		{
			backgroundSkin.width = _buttonWidth;
			backgroundSkin.height = _buttonHeight;
			
			var size:Number = Math.min(_buttonWidth, _buttonHeight);
			icon.width = size*iconScale;
			icon.height = size*iconScale;
		}
		
		override public function set currentState(value:String):void
		{
			if(super.currentState == value)
				return;
			
			switch(value)
			{
				case STATE_DOWN:
					backgroundSkin.alpha = 0.2;					
					break;
					
				default:
					backgroundSkin.alpha = 0;
					break;
			}
			super.currentState = value;
		}
	}
}