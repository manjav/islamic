package com.gerantech.islamic.views.controls
{
	import feathers.controls.Drawers;
	import feathers.core.IFeathersControl;
	
	public class CustomDrawers extends Drawers
	{
		public function CustomDrawers(content:IFeathersControl=null)
		{
			super(content);
		}
		/*
		override protected function leftDrawerOpenOrCloseTween_onUpdate():void
		{
			//trace("CustomDrawer.leftDrawerOpenOrCloseTween_onUpdate()");
			super.leftDrawerOpenOrCloseTween_onUpdate();
			AppModel.instance.toolbar.x = this._content.x
		}
		
		override protected function rightDrawerOpenOrCloseTween_onUpdate():void
		{
			//trace("CustomDrawer.rightDrawerOpenOrCloseTween_onUpdate()");
			super.rightDrawerOpenOrCloseTween_onUpdate();
			AppModel.instance.toolbar.x = this._content.x
		}
		
		*/
		
	}
}