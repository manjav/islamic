package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;

	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.events.FeathersEventType;

	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	import gt.utils.Localizations;

	import starling.events.Event;

	
	public class BasePageItemRenderer extends LayoutGroupListItemRenderer
	{
		protected var firstSetData:Boolean = true;

		protected var appModel:AppModel;
		protected var userModel:UserModel;
		
		protected var intervalId:uint;		
		
		override protected function initialize():void
		{
			super.initialize();
			appModel = AppModel.instance;
			userModel = UserModel.instance;
		}
		
		protected function _owner_resizeHandler(event:Event):void
		{
			if(_owner)
			{
				width = _owner.width
				height = _owner.height;
			}
		}
		
		override protected function commitData():void
		{
			if(_data==null || _owner==null)
				return;

			if(firstSetData)
			{
				_owner.addEventListener(FeathersEventType.RESIZE, _owner_resizeHandler);
				_owner.addEventListener(FeathersEventType.RENDERER_REMOVE, selfRemovedHandler);
			}
			firstSetData = false;
			
			width = _owner.width
			height = _owner.height;
			
			clearInterval(intervalId);
			intervalId = setInterval(checkScrolling, 100);
		}
		
		protected function selfRemovedHandler(event:Event):void
		{
			if(event.data == this)
				clearInterval(intervalId);
		}
		
		protected function checkScrolling():void
		{
			if(!isShow)
				return;
			
			clearInterval(intervalId);
			commitAfterStopScrolling();
		}
		protected function get isShow():Boolean
		{
			var rect:Rectangle = getBounds(_owner);//trace(index, rect)
			return(rect.x==0)
		}
			
		protected function commitAfterStopScrolling():void
		{
		}
		
		
		protected function loc(resourceName:String, parameters:Array=null, locale:String=null):String
		{
			return Localizations.instance.get(resourceName, parameters);//, locale);
		}

	}
}