package com.gerantech.islamic.models
{	
	import feathers.data.ListCollection;
	
	

	public class BookmarkCollection extends ListCollection
	{		
		
		public function BookmarkCollection(data:Object = null)
		{
			super(data);
		}

		
		public function exist(item:Object):int
		{
			for(var i:uint=0; i<data.length; i++)
			{
				if(data[i].sura==item.sura && data[i].aya==item.aya)
				{
					return i;
				}
			}
			return -1;
		}
		
		override public function addItem(item:Object):void
		{
			super.addItem(item);
			UserModel.instance.scheduleSaving();
		}
		
		override public function addItemAt(item:Object, index:int):void
		{
			UserModel.instance.scheduleSaving();
			super.addItemAt(item, index);
		}
		
		
		override public function removeItem(item:Object):void
		{
			super.removeItem(item);
			UserModel.instance.scheduleSaving();
		}
		
		override public function removeItemAt(index:int):Object
		{
			UserModel.instance.scheduleSaving();
			return super.removeItemAt(index);
		}
		
		
		
		
		/*private var lastSortFields:SortField = new SortField();
		public function sortAt(...sortNames):void
		{
			var sortFields:Array = new Array()
			for each(var s:String in sortNames)
			{
				sortFields.push(new SortField(s, false, true));
			}
			if(sortNames[0] == lastSortFields.name)
			{
				sortFields[0].descending = !lastSortFields.descending;
			}
			else
			{
				sortFields[0].descending = (sortFields[0].name=="sura"||sortFields[0].name=="order") ? false : true;
			}
			
			lastSortFields = sortFields[0];
			
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = sortFields;
			sort = numericDataSort;
			refresh();
			refreshIndex();
		}*/
		
	}
}