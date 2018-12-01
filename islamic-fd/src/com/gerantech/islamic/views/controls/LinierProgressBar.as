package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.utils.StrTools;
	import com.gerantech.islamic.views.items.ShapeLayout;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	public class LinierProgressBar extends LayoutGroup
	{
		private var appModel:AppModel;
		
		private var background:ShapeLayout;
		private var track:ShapeLayout;
		private var trackText:RTLLabel;

		private var trackGroup:ShapeLayout;
		private var trackPosition:Number;
		private var _progress:Number = -0.001;
		private var _enabled:Boolean;
		
		public var fontSize:uint = 0;
		
		public function LinierProgressBar()
		{
			super();
			appModel = AppModel.instance;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if(_enabled == value)
				return;
			
			_enabled = value;
			if(trackGroup)
				trackGroup.visible = _enabled;
			if(track)
				track.visible = _enabled;
			_progress = -0.001;
		}

		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			background = new ShapeLayout(BaseMaterialTheme.DESCRIPTION_TEXT_COLOR);
			background.height = appModel.sizes.border/4;
			background.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0, NaN, 0);
			addChild(background);
			
			track = new ShapeLayout(BaseMaterialTheme.CHROME_COLOR);
			track.height = appModel.sizes.border/2;
			track.layoutData = new AnchorLayoutData(NaN, appModel.ltr?NaN:0, NaN, appModel.ltr?0:NaN, NaN, 0);
			addChild(track);
			
			trackGroup = new ShapeLayout(BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			trackGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, NaN, 0);
			trackGroup.layout = new AnchorLayout();
			addChild(trackGroup);

			
			fontSize = fontSize==0 ? uint(UserModel.instance.fontSize*0.7) : fontSize;
			trackText = new RTLLabel("", BaseMaterialTheme.CHROME_COLOR, "center", null, true, null, fontSize);
			trackText.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			trackGroup.addChild(trackText);
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		public function set progress(value:Number):void
		{
			if(_progress==value || !enabled)
				return;
			
			_progress = value;
			
			track.visible = trackGroup.visible = _progress>0;
			if(_progress==0)
				return;
			
			track.width = _progress*actualWidth;
			trackText.text = " "+StrTools.getNumberFromLocale( Math.round(_progress*100)) + " % ";
			var pr:Number;
			if(appModel.ltr)
				pr = _progress*actualWidth;
			else
				pr = actualWidth-_progress*actualWidth;
			trackGroup.x = Math.min(actualWidth, Math.max(0, pr-trackText.width));
		}
		
	}
}