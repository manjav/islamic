package com.gerantech.islamic.views.actions.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Local;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;
	
	public class ActionItemRenderer extends SimpleLayoutButton
	{
		public var mode:Local;
		
		public function ActionItemRenderer(mode:Local, index:uint)
		{
			this.mode = mode;
			var mLayout:HorizontalLayout = new HorizontalLayout();
			mLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			mLayout.gap = AppModel.instance.border*2;
			layout = mLayout;
			
			var _h:uint = height = uint(AppModel.instance.itemHeight*0.7);
			var _w:uint = width = AppModel.instance.orginalWidth/2;
			
			backgroundSkin = new Quad(1, 1);
			backgroundSkin.alpha = 0;
			
		/*	var bg:Image = new Image(Assets.getTexture("white_rect"));
			bg.alpha = 0;
			bg.pivotY = bg.height/2;
			bg.x = -_w+_h;
			bg.height = AppModel.instance.itemHeight;
			bg.width = _w;
			addChild(bg);			
			var textField:TextBlockTextRenderer = new TextBlockTextRenderer();
			var fd:FontDescription = new FontDescription("SourceSansPro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
			textField.textAlign = TextBlockTextRenderer.TEXT_ALIGN_RIGHT;
			textField.elementFormat = new ElementFormat(fd, UserModel.instance.fontSize, 0);
			textField.text = ResourceManager.getInstance().getString("loc", mode.name);
			*/
			var label:RTLLabel = new RTLLabel(ResourceManager.getInstance().getString("loc", mode.name), BaseMaterialTheme.PRIMARY_TEXT_COLOR, "right"); 
			label.layoutData = new HorizontalLayoutData(100);
			addChild(label);
			
			var circle:ImageLoader = new ImageLoader();
			circle.source = Assets.getTexture("action_item_"+index%4);
			circle.height = _h;//*1.123456789;
			circle.width = _h;
			//circle.includeInLayout = false;
			circle.x = _w;
			addChild(circle);
		}
	}
}