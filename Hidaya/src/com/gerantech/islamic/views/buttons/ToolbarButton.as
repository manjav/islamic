package com.gerantech.islamic.views.buttons
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.vo.ToolbarButtonData;
	
	import starling.display.Image;

	public class ToolbarButton extends SimpledButton
	{
		
		//private var backgroud:Quad;
		private var backgroundSkin:Image;
		private var icon:Image;
		private var _iconScale:Number = 0.44;
		private var _data:ToolbarButtonData;
		private var _buttonHeight:Number = 48;
		private var _buttonWidth:Number = 48;
		public var screens:Array;
		
		public function ToolbarButton(data:ToolbarButtonData)
		{
			backgroundSkin = new Image(Assets.getTexture("toolbar_button_bg"));
			backgroundSkin.pivotX = backgroundSkin.width/2;
			backgroundSkin.pivotY = backgroundSkin.height/2;
			backgroundSkin.alpha = 0;
			addChild(backgroundSkin);
			
			if(data!=null)
				this.data = data;
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
		
		
		
		public function get data():ToolbarButtonData
		{
			return _data;
		}		
		public function set data(value:ToolbarButtonData):void
		{
			if(_data==value)
				return;
			
			_data = value;
			
			if(_data.icon == null)
				return;
			
			if(icon==null)
			{
				icon = new Image(Assets.getTexture(_data.icon));
				icon.pivotX = icon.width/2
				icon.pivotY = icon.height/2
				addChild(icon);
			}
			else
			{
				icon.texture = Assets.getTexture(_data.icon);
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