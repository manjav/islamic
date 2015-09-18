package com.gerantech.islamic.views.items
{
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.views.headers.UthmaniHeader;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Image;

	
	public class BaseQPageItemRenderer extends BasePageItemRenderer
	{
		protected var _qdata:BaseQData;

		protected var header:UthmaniHeader;
		protected var headerContainer:LayoutGroup;
		
		override protected function initialize():void
		{
			super.initialize();
			
			layout = new AnchorLayout();
			
			headerContainer = new LayoutGroup();
			headerContainer.layout = new AnchorLayout();
			headerContainer.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0);
			addChild(headerContainer);
			
			header = new UthmaniHeader();
			header.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			headerContainer.addChild(header);
			
			var shadow:LayoutGroup = new LayoutGroup();
			shadow.backgroundSkin = new Image(Assets.getTexture("shadow"));
			shadow.layoutData = new AnchorLayoutData(header.height, 0, NaN, 0);
			//shadow.y = header.height;
			//shadow.width = appModel.sizes.width; 
			shadow.height = appModel.sizes.border;
			headerContainer.addChild(shadow);
		}

		
		override protected function commitData():void
		{
			super.commitData();
			if(_data==null || _owner==null)
				return;

			_qdata = _data as BaseQData;
			header.update(_qdata);
		}
		
			
		override protected function commitAfterStopScrolling():void
		{
			super.commitAfterStopScrolling();
			if(_qdata.ayas==null)
				_qdata.complete();
			//UserModel.instance.lastPage = _qdata;
			//trace("Show", _page.index)
		}
		
		protected function containItem(item:BaseQData):Boolean
		{
			switch(UserModel.instance.navigationMode.value)
			{
				case "page_navi": return _qdata.page == item.page;
				case "sura_navi": return _qdata.sura == item.sura;
				case "juze_navi": return _qdata.juze == item.juze;
			}
			return false;
		}
		
		protected function findIndex(item:BaseQData):uint
		{
			if(!containItem(item))
				return 0;
			if(_qdata.ayas==null)
				_qdata.complete();
			
			for each(var a:Aya in _qdata.ayas)
			{//trace("findIndex", a.sura,item.sura,a.aya,item.aya)
				if(a.sura==item.sura && a.aya==item.aya)
				{
					return a.order;
				}
			}
			return 0;
		}
		
	}
}