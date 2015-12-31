package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.display.Scale3Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.textures.Scale3Textures;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class UndoAlert extends BasePopUp
	{
		private var background:Scale3Image;
		private var callback:Function;
		private var params:Array;
		
		override protected function draw():void
		{
			width = AppModel.instance.sizes.width-AppModel.instance.sizes.border*2;
			y = AppModel.instance.sizes.height-AppModel.instance.sizes.twoLineItem;
			super.draw();
		}
		
		
		
		public function UndoAlert(label:String, callback:Function, duration:Number=2, delay:Number=1, params:Array=null)
		{
			this.params = params;
			this.callback = callback;
			height = uint(AppModel.instance.sizes.twoLineItem*0.8);
			
			layout = new AnchorLayout();
			//hGroup.layoutData = new AnchorLayoutData(0,AppModel.instance.sizes.itemHeight,0,AppModel.instance.sizes.itemHeight)
		
			backgroundSkin = new Scale3Image(new Scale3Textures(Assets.getTexture("round_alert"), 31,2));
			backgroundSkin.alpha = 0.9;
			//addChild(background);
			
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			hLayout.gap = hLayout.padding = AppModel.instance.sizes.twoLineItem/4;
			
			var hGroup:LayoutGroup = new LayoutGroup();
			hGroup.layout = hLayout;
			hGroup.layoutData = new AnchorLayoutData(0,0,0,0)
			addChild(hGroup);
			
			var textField:RTLLabel = new RTLLabel(label, 0xFFFFFF, "right");
			textField.layoutData = new HorizontalLayoutData(100);
			hGroup.addChild(textField);
			
		/*	var line:ImageLoader = new ImageLoader();
			//line.layoutData = new HorizontalLayoutData(NaN, 100);
			line.width = AppModel.instance.sizes.border/2;
			line.height = 100;
			line.source = Assets.getTexture("white_rect");
			hGroup.addChild(line);*/
			
			var sign:ImageLoader = new ImageLoader();
			sign.height = height/2.4
			sign.source = Assets.getTexture("undo_sign");
			hGroup.addChild(sign);
			Starling.juggler.tween(this, duration, {delay:delay, alpha:0, onComplete:close});
			//TweenLite.to(this, duration, {delay:delay, alpha:0, onComplete:close});
			addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		
		private function touchHandler(event:TouchEvent):void
		{
			var touch:Touch;
			touch = event.getTouch(this);
			
			if(touch==null)
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
	}
}