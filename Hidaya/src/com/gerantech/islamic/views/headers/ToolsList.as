package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;

	public class ToolsList extends LayoutGroup
	{
		private var shareButton:FlatButton;
		private var bookmarkButton:FlatButton;
		private var numContainer:LayoutGroup;
		private var numTextField:RTLLabel;
		
		private var aya:Aya;
		private var initialized:Boolean;
		private var _selected:Boolean;

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			var _h:Number = height;
						
			if(UserModel.instance.nightMode)
			{
				var invert:ColorMatrixFilter = new ColorMatrixFilter();
				invert.invert();
				filter = invert;
			}
			
			bookmarkButton = new FlatButton(null, "circle", false, 1);
			bookmarkButton.iconScale = 0.7;
			bookmarkButton.width = _h;
			bookmarkButton.layoutData = new AnchorLayoutData(0, NaN, 0, 0);
			bookmarkButton.addEventListener(Event.TRIGGERED, bookmark_triggerHandler);
			bookmarkButton.visible = false;
			addChild(bookmarkButton);
			
			shareButton = new FlatButton("share_variant", "circle", false, 1);
			shareButton.iconScale = 0.7;
			shareButton.width = _h;
			shareButton.layoutData = new AnchorLayoutData(0, NaN, 0, _h*1.2);
			shareButton.iconHorizontalCenter = -_h/22;
			shareButton.addEventListener(Event.TRIGGERED, share_triggerHandler);
			shareButton.visible = false;
			addChild(shareButton);
			
			numContainer = new LayoutGroup();
			numContainer.width = _h;
			numContainer.layoutData = new AnchorLayoutData(0, 0, 0, NaN);
			numContainer.backgroundSkin = new Image(Assets.getTexture("circle"));
			numContainer.layout = new AnchorLayout();
			addChild(numContainer);
			
			numTextField = new RTLLabel("", 0x6d6d6d, "center", null, false, "center", _h*0.6, "mequran");
			numTextField.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0); 
			numContainer.addChild(numTextField);
			
			initialized = true;
			
			if(aya!=null)
				setData(aya, _selected);
		}
		
		public function setData(aya:Aya, _selected:Boolean=false):void
		{
			if(aya==null)
				return;
			
			this.aya = aya;
			this._selected = _selected;
			
			if(!initialized)
				return;
			
			numContainer.visible = aya.aya!=1
			if(numContainer.visible)
				numTextField.text = aya.aya.toString();
			
			bookmarkButton.texture =aya.bookmarked?"bookmark_on":"bookmark_off";
			
			shareButton.visible = _selected;
			bookmarkButton.visible = _selected || aya.bookmarked;
			
			if(_selected)
			{
				shareButton.alpha = 0;
				bookmarkButton.alpha = 0;
				
				Starling.juggler.tween(shareButton, 0.3, {alpha:1, delay:0.25});
				Starling.juggler.tween(bookmarkButton, 0.3, {alpha:1, delay:0.20});
				//TweenLite.to(shareButton, 0.3, {alpha:1, delay:0.25});
				//TweenLite.to(bookmarkButton, 0.3, {alpha:1, delay:0.20});
			}			
		}
		
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function share_triggerHandler(event:Event):void
		{
			new ShareText(aya);
		}
		
		private function bookmark_triggerHandler(event:Event):void
		{
			//trace(aya.aya, aya.bookmarked)
			if(aya.bookmarked)
			{
				var index:int = UserModel.instance.bookmarks.exist(aya);
				if(index>-1)
					UserModel.instance.bookmarks.removeItemAt(index);
			}
			else
				UserModel.instance.bookmarks.addItem(new Bookmark(aya.sura, aya.aya));
			
			aya.bookmarked = !aya.bookmarked;
			setData(aya, _selected);
		}
		private function playButton_triggerHandler(event:Event):void
		{
			Player.instance.resetRepeatation();
			Player.instance.load(aya);
		}
		/*private function soundPlayer_toggleHandler(event:Event):void
		{
			if(SoundPlayer.instance.ayaSound.equals(aya))
				playButton.texture = event.data ? "pause_circle" : "play_circle";
		}
		
		public function setTint(color:uint=0):void
		{
			if(color>0)
			{
				var filterRed:ColorMatrixFilter = new ColorMatrixFilter();
				filterRed.tint(color, 0.8);
				numCircle.filter = filterRed;
			}
			else
				numCircle.filter = null;

		}*/

		public function setBookmark(_data:Object):void
		{
			// TODO Auto Generated method stub
			
		}
	}
}