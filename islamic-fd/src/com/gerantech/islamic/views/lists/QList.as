package com.gerantech.islamic.views.lists
{
	import feathers.controls.renderers.IListItemRenderer;
	
	import starling.display.DisplayObject;
	
	public class QList extends FastList
	{
		private var _layoutItems:Vector.<DisplayObject>;
		
		public function QList()
		{
			_layoutItems = new Vector.<DisplayObject>();
		}
		
		public function get layoutItems():Vector.<DisplayObject>
		{
			var sortingFunction:Function = function(itemA:IListItemRenderer, itemB:IListItemRenderer):Number
			{
				return itemA.index < itemB.index ? -1 : 1;
			}
				
			//_layoutItems.splice(0, _layoutItems.length);
			_layoutItems = new Vector.<DisplayObject>(dataViewPort.numChildren, true);
			for(var i:uint=0; i<dataViewPort.numChildren; i++)
				_layoutItems[i] = dataViewPort.getChildAt(i);
			
			_layoutItems.sort(sortingFunction);
			return _layoutItems;
		}
		
		public function get firstItem():DisplayObject
		{
			for(var i:uint=0; i<layoutItems.length; i++)
				if(_layoutItems[i].visible)
					return _layoutItems[i];
			return null;
		}
		
	}
}