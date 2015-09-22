package com.gerantech.islamic.views.popups
{
	import com.greensock.TweenLite;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.display.Scale3Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.textures.Scale3Textures;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Alert extends LayoutGroup
	{
		private var background:Scale3Image;
		private var callback:Function;
		private var params:Array;
		
		override protected function draw():void
		{
			width = AppModel.instance.sizes.width-AppModel.instance.sizes.border*4;
			y = AppModel.instance.sizes.height*0.7;
			x = AppModel.instance.sizes.border*2;
			super.draw();
		}
		
		
		public function Alert(owner:DisplayObjectContainer, label:String, callback:Function=null, params:Array=null, duration:Number=2, delay:Number=1)
		{
			this.callback = callback;
			this.params = params;
			_isEnabled = callback!=null;
			includeInLayout = false;
			
			height = uint(AppModel.instance.sizes.twoLineItem*0.8);
			layout = new AnchorLayout();
		
			backgroundSkin = new Scale3Image(new Scale3Textures(Assets.getTexture("round_alert"), 31,2));
			backgroundSkin.alpha = 0.9;
			
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			hLayout.gap = hLayout.padding = AppModel.instance.sizes.twoLineItem/4;
			
			var hGroup:LayoutGroup = new LayoutGroup();
			hGroup.layout = hLayout;
			hGroup.layoutData = new AnchorLayoutData(0,0,0,0)
			addChild(hGroup);
			
			var textField:TextBlockTextRenderer = new TextBlockTextRenderer();
			textField.text = label;
			var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			textField.bidiLevel = AppModel.instance.ltr?0:1;
			textField.textAlign = AppModel.instance.align;
			textField.elementFormat = new ElementFormat(fd, UserModel.instance.fontSize, 0xFFFFFF);
			textField.layoutData = new HorizontalLayoutData(100);
			hGroup.addChild(textField);
			
		/*	var line:ImageLoader = new ImageLoader();
			//line.layoutData = new HorizontalLayoutData(NaN, 100);
			line.width = AppModel.instance.sizes.border/2;
			line.height = 100;
			line.source = Assets.getTexture("white_rect");
			hGroup.addChild(line);*/
			owner.addChild(this);
			TweenLite.to(this, duration, {delay:delay, alpha:0, onComplete:close});
			
			if(!_isEnabled)
				return;
			
			var sign:ImageLoader = new ImageLoader();
			sign.height = height/2.4
			sign.source = Assets.getTexture("undo_sign");
			hGroup.addChild(sign);
			
			addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function touchHandler(event:TouchEvent):void
		{
			var touch:Touch;
			touch = event.getTouch(this);
			
			if(touch==null || !_isEnabled)
				return;
			if(touch.phase == TouchPhase.BEGAN)
			{
			}
			if(touch.phase == TouchPhase.MOVED)
			{
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				if(callback!=null)
					callback.apply(null, params);
				close();
			}
		}		
		
		public function close():void
		{
			removeFromParent(true);
		}
	}
}