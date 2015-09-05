package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.text.engine.ElementFormat;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.display.Quad;

	public class DrawerItemRenderer extends BaseCustomItemRenderer
	{		
		private var titleDisplay:RTLLabel;
		private var iconDisplay:ImageLoader;
		private var isLeft:Boolean;

		private var myLayout:HorizontalLayout;

		
		public function DrawerItemRenderer(isLeft:Boolean)
		{
			super();
			this.isLeft = isLeft;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			height = AppModel.instance.itemHeight;
			backgroundSkin = new Quad(1, 1);
			backgroundSkin.alpha = 0;
			
			myLayout = new HorizontalLayout();
			myLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			myLayout.gap = AppModel.instance.border*5;
			myLayout.padding = AppModel.instance.border*2;
			layout = myLayout;
			height = AppModel.instance.itemHeight;
			
			iconDisplay = new ImageLoader();
			iconDisplay.layoutData = new HorizontalLayoutData(NaN, 60);
			iconDisplay.delayTextureCreation = true;
			
			titleDisplay = new RTLLabel("", BaseMaterialTheme.PRIMARY_TEXT_COLOR, null, null, false, null, UserModel.instance.fontSize*0.94, null, "bold") 
			titleDisplay.layoutData = new HorizontalLayoutData(100);
						
			addChild(isLeft?iconDisplay:titleDisplay);
			addChild(!isLeft?iconDisplay:titleDisplay);
			
			userModel.addEventListener(UserEvent.CHANGE_COLOR, userModel_changeColorHandler);
		}
		
		private function userModel_changeColorHandler():void
		{
			titleDisplay.elementFormat = new ElementFormat(titleDisplay.fontDescription, titleDisplay.fontSize, BaseMaterialTheme.PRIMARY_TEXT_COLOR);			
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;
			
			super.commitData();

			
			if(_data.title=="null")
			{
				visible = false;
				return;
			}
			iconDisplay.source = Assets.getTexture(String(_data.icon));
			titleDisplay.text = ResourceManager.getInstance().getString("loc", String(_data.title));
		}

	}
}