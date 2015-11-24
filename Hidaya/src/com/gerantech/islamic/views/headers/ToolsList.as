package com.gerantech.islamic.views.headers
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.managers.Player;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.Bookmark;
	import com.gerantech.islamic.views.buttons.FlatButton;
	import com.greensock.TweenLite;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class ToolsList extends LayoutGroup
	{
		private var shareButton:FlatButton;
		private var bookmarkButton:FlatButton;
		
		private var aya:Aya;

		private var numContainer:LayoutGroup;
		private var numTextField:TextField;
		//private var playButton:FlatButton;

		private var scaleFactor:Number = 1;
		private var _selected:Boolean;
		private var lastHeight:uint;
		private var initialized:Boolean;
		public function ToolsList()
		{
			super();
		}
		

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
						
			if(UserModel.instance.nightMode)
			{
				var invert:ColorMatrixFilter = new ColorMatrixFilter();
				invert.invert();
				filter = invert;
			}
			
			bookmarkButton = new FlatButton(null, "circle", false, 1);
			bookmarkButton.iconScale = 0.7;
			bookmarkButton.addEventListener(Event.TRIGGERED, bookmark_triggerHandler);
			bookmarkButton.visible = false;
			addChild(bookmarkButton);
			
			shareButton = new FlatButton("share_variant", "circle", false, 1);
			shareButton.iconScale = 0.7;
			shareButton.addEventListener(Event.TRIGGERED, share_triggerHandler);
			shareButton.visible = false;
			addChild(shareButton);
			
			numContainer = new LayoutGroup();
			numContainer.backgroundSkin = new Image(Assets.getTexture("circle"));
			addChild(numContainer);
			
			numTextField = new TextField(height, height, "", "mequrandev", uint(UserModel.instance.fontSize*1.5), 0x6d6d6d);
			numTextField.hAlign = HAlign.CENTER;
			numTextField.vAlign = VAlign.CENTER;
			numContainer.addChild(numTextField);
			
		//	UserModel.instance.addEventListener(UserEvent.FONT_SIZE_CHANGE_END, user_fontChangedHandler);
			initialized = true;
			
			if(aya!=null)
				setData(aya, _selected);

		//	var ih:Number = AppModel.instance.sizes.twoLineItem;
			var _h:uint = height = AppModel.instance.sizes.DP36;//uint(Math.min(Math.max(ih/1.6, UserModel.instance.fontSize*2.6),ih/1.2));
			if(lastHeight==_h)
				return;
			
			lastHeight = _h;
			numContainer.width = numContainer.height = _h*scaleFactor;
			numContainer.layoutData = new AnchorLayoutData(NaN, 0, NaN, NaN, NaN, 0);
		//	numCircle.width = numCircle.height = _h*scaleFactor;
			numTextField.width = numTextField.height = _h*scaleFactor;
			numTextField.fontSize = uint(_h*0.6);
			//numContainer.x = width-_h*scaleFactor;
			
			bookmarkButton.width = bookmarkButton.height = _h;
			bookmarkButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, 0, NaN, 0);
			
			shareButton.width = shareButton.height = _h;
			shareButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, _h*1.2, NaN, 0);
			shareButton.iconHorizontalCenter = -_h/22;
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
				TweenLite.to(shareButton, 0.3, {alpha:1, delay:0.25});
				bookmarkButton.alpha = 0;
				TweenLite.to(bookmarkButton, 0.3, {alpha:1, delay:0.20});
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